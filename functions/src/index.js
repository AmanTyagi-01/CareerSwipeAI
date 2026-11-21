const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { OpenAI } = require('openai');

admin.initializeApp();
const db = admin.firestore();
const storage = admin.storage();

const openai = new OpenAI({
  apiKey: functions.config().openai.key,
});

// Resume Analysis Cloud Function
exports.analyzeResume = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const authUserId = context.auth.uid;
  const { resumeId, extractedText } = data;
  const userId = authUserId; // Authoritative identity from auth context

  if (resumeId) {
    const resumeDoc = await db.collection('resumes').doc(resumeId).get();
    if (resumeDoc.exists && resumeDoc.data().userId !== authUserId) {
      throw new functions.https.HttpsError('permission-denied', 'Unauthorized: resume does not belong to caller');
    }
  }

  try {
    // Call OpenAI for resume analysis
    const completion = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: 'You are an expert resume analyzer. Analyze the following resume and provide scores and recommendations in JSON format.'
        },
        {
          role: 'user',
          content: `Analyze this resume and provide: 1) ATS Score (0-100), 2) Keyword Match Score (0-100), 3) Formatting Score (0-100), 4) Content Score (0-100), 5) Detected Skills (array), 6) Missing Skills (array), 7) Strengths (array), 8) Improvements (array), 9) Keywords (array), 10) Summary (string), 11) Section Scores (object). Resume text: ${extractedText}`
        }
      ],
      temperature: 0.3,
    });

    const analysis = JSON.parse(completion.choices[0].message.content);

    // Save analysis to Firestore
    const analysisId = db.collection('resume_analyses').doc().id;
    await db.collection('resume_analyses').doc(analysisId).set({
      id: analysisId,
      userId,
      resumeId,
      ...analysis,
      analyzedAt: admin.firestore.FieldValue.serverTimestamp(),
      isComplete: true,
    });

    // Update user's resume score
    await db.collection('users').doc(userId).update({
      lastResumeAnalysis: analysisId,
      resumeScore: analysis.atsScore,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, analysisId, analysis };
  } catch (error) {
    console.error('Resume analysis error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to analyze resume');
  }
});

// Job Matching Cloud Function
exports.matchJobs = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid; // Enforce authoritative UID
  const { skills, experienceLevel } = data;

  try {
    // Get active jobs
    const jobsSnapshot = await db.collection('jobs')
      .where('isActive', '==', true)
      .limit(50)
      .get();

    const matches = [];

    for (const doc of jobsSnapshot.docs) {
      const job = doc.data();
      const jobSkills = job.skills || [];

      // Calculate match score
      const matchedSkills = skills.filter(skill => 
        jobSkills.some(jobSkill => 
          jobSkill.toLowerCase().includes(skill.toLowerCase()) ||
          skill.toLowerCase().includes(jobSkill.toLowerCase())
        )
      );

      const matchScore = jobSkills.length > 0 
        ? (matchedSkills.length / jobSkills.length) * 100 
        : 0;

      if (matchScore > 30) {
        matches.push({
          jobId: doc.id,
          matchScore: Math.round(matchScore),
          matchedSkills,
          reason: `Matches ${matchedSkills.length} of ${jobSkills.length} required skills`,
        });
      }
    }

    // Sort by match score
    matches.sort((a, b) => b.matchScore - a.matchScore);

    return { success: true, matches: matches.slice(0, 20) };
  } catch (error) {
    console.error('Job matching error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to match jobs');
  }
});

// Send Push Notification
exports.sendNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const callerUid = context.auth.uid;
  const { userId, title, body, data: payload } = data;

  if (!userId || !title || !body) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required notification fields');
  }

  // Authorization check: User can only notify themselves unless they have a recruiter or admin role
  const isSelf = callerUid === userId;
  const isTokenRecruiter = context.auth.token && (context.auth.token.role === 'recruiter' || context.auth.token.admin === true);

  if (!isSelf && !isTokenRecruiter) {
    const callerDoc = await db.collection('users').doc(callerUid).get();
    if (!callerDoc.exists || callerDoc.data()?.userType !== 'recruiter') {
      throw new functions.https.HttpsError('permission-denied', 'Unauthorized: only recruiters or admins may send notifications to other users');
    }
  }

  try {
    // Get user's FCM token
    const userDoc = await db.collection('users').doc(userId).get();
    const fcmToken = userDoc.data()?.fcmToken;

    if (!fcmToken) {
      throw new functions.https.HttpsError('not-found', 'User FCM token not found');
    }

    const message = {
      token: fcmToken,
      notification: { title, body },
      data: payload || {},
      android: {
        notification: {
          channelId: 'high_importance_channel',
          priority: 'high',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    await admin.messaging().send(message);

    // Save notification to Firestore
    await db.collection('notifications').add({
      userId,
      title,
      body,
      data: payload || {},
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true };
  } catch (error) {
    console.error('Notification error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
});

// On new job posted - notify matching users
exports.onJobCreated = functions.firestore
  .document('jobs/{jobId}')
  .onCreate(async (snap, context) => {
    const job = snap.data();
    const jobSkills = job.skills || [];

    try {
      // Find users with matching skills
      const usersSnapshot = await db.collection('users')
        .where('jobAlerts', '==', true)
        .get();

      for (const userDoc of usersSnapshot.docs) {
        const user = userDoc.data();
        const userSkills = user.skills || [];

        const hasMatchingSkills = jobSkills.some(jobSkill =>
          userSkills.some(userSkill =>
            userSkill.toLowerCase().includes(jobSkill.toLowerCase()) ||
            jobSkill.toLowerCase().includes(userSkill.toLowerCase())
          )
        );

        if (hasMatchingSkills && user.fcmToken) {
          await admin.messaging().send({
            token: user.fcmToken,
            notification: {
              title: 'New Job Match!',
              body: `${job.title} at ${job.company} matches your skills`,
            },
            data: {
              type: 'job_match',
              jobId: context.params.jobId,
            },
          });

          // Save notification
          await db.collection('notifications').add({
            userId: userDoc.id,
            type: 'job_match',
            title: 'New Job Match!',
            body: `${job.title} at ${job.company} matches your skills`,
            data: { jobId: context.params.jobId },
            isRead: false,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (error) {
      console.error('Job notification error:', error);
    }
  });

// Clean up old notifications
exports.cleanupOldNotifications = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('UTC')
  .onRun(async (context) => {
    const thirtyDaysAgo = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
    );

    const oldNotifications = await db.collection('notifications')
      .where('createdAt', '<', thirtyDaysAgo)
      .where('isRead', '==', true)
      .limit(500)
      .get();

    const batch = db.batch();
    oldNotifications.docs.forEach(doc => {
      batch.delete(doc.ref);
    });

    await batch.commit();
    console.log(`Deleted ${oldNotifications.size} old notifications`);
  });
