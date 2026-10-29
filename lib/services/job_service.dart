import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/errors/exceptions.dart';
import '../core/utils/app_utils.dart';
import '../core/utils/logger.dart';
import '../data/models/job_model.dart';

class JobService {
  final FirebaseFirestore? _firestore;

  static final List<JobModel> _mockJobs = [
    JobModel(
      id: 'job-1',
      title: 'Senior Flutter Developer',
      company: 'TechFlow Innovations',
      companyLogo: 'https://images.unsplash.com/photo-1549923746-c502d488b3ea?w=100&h=100&fit=crop',
      companyWebsite: 'https://techflow.io',
      description: 'We are seeking an experienced Flutter Engineer to lead mobile client development for our flagship AI platform. You will build cutting-edge user interfaces and optimize cross-platform performance.',
      shortDescription: 'Lead Flutter development for flagship AI platform',
      requirements: const [
        '5+ years mobile development experience',
        '3+ years Flutter & Dart expertise',
        'Experience with Riverpod, Clean Architecture',
        'Strong knowledge of state management and CI/CD pipelines',
      ],
      responsibilities: const [
        'Architect and implement scalable Flutter apps',
        'Collaborate with backend and design teams',
        'Mentor junior developers and lead code reviews',
      ],
      skills: const ['Flutter', 'Dart', 'Riverpod', 'Firebase', 'REST APIs'],
      experienceLevel: 'Senior (5+ yrs)',
      jobType: 'Full-time',
      location: 'San Francisco, CA',
      isRemote: true,
      minSalary: 140000,
      maxSalary: 180000,
      currency: 'USD',
      industry: 'Technology',
      department: 'Engineering',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      isActive: true,
      viewCount: 142,
      applyCount: 18,
      tags: const ['Flutter', 'Mobile', 'Remote', 'Senior'],
    ),
    JobModel(
      id: 'job-2',
      title: 'AI / Machine Learning Engineer',
      company: 'NeuralPulse AI',
      companyLogo: 'https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=100&h=100&fit=crop',
      companyWebsite: 'https://neuralpulse.ai',
      description: 'Join our research and deployment team to build production LLM pipelines, fine-tune models, and deploy real-time inference systems.',
      shortDescription: 'Build production LLM pipelines & AI inference systems',
      requirements: const [
        '3+ years experience with PyTorch or TensorFlow',
        'Hands-on experience with LLMs and prompt engineering',
        'Solid background in Python, Docker, and Kubernetes',
      ],
      responsibilities: const [
        'Develop and fine-tune generative AI models',
        'Build scalable API endpoints for model serving',
        'Evaluate model safety, latency, and throughput',
      ],
      skills: const ['Python', 'PyTorch', 'LLMs', 'Transformers', 'Docker'],
      experienceLevel: 'Mid-Level (2-5 yrs)',
      jobType: 'Full-time',
      location: 'New York, NY',
      isRemote: true,
      minSalary: 150000,
      maxSalary: 195000,
      currency: 'USD',
      industry: 'Artificial Intelligence',
      department: 'AI Research',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      isActive: true,
      viewCount: 220,
      applyCount: 34,
      tags: const ['AI', 'Machine Learning', 'Python', 'Remote'],
    ),
    JobModel(
      id: 'job-3',
      title: 'Senior Product Designer',
      company: 'Vibrant Labs',
      companyLogo: 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=100&h=100&fit=crop',
      companyWebsite: 'https://vibrantlabs.design',
      description: 'We are looking for a visual & interaction design specialist to craft delightful user journeys, design systems, and mobile prototypes.',
      shortDescription: 'Craft delightful user journeys and modern design systems',
      requirements: const [
        '4+ years UX/UI design experience in fast-paced teams',
        'Mastery of Figma, design tokens, and interactive prototyping',
        'Demonstrated portfolio of shipped consumer or SaaS products',
      ],
      responsibilities: const [
        'Design responsive interfaces for mobile and web',
        'Maintain and expand our core design system',
        'Conduct usability testing with real users',
      ],
      skills: const ['Figma', 'UI/UX', 'Design Systems', 'Prototyping', 'User Research'],
      experienceLevel: 'Senior (5+ yrs)',
      jobType: 'Full-time',
      location: 'Austin, TX',
      isRemote: true,
      minSalary: 125000,
      maxSalary: 160000,
      currency: 'USD',
      industry: 'Design',
      department: 'Product',
      postedAt: DateTime.now().subtract(const Duration(days: 3)),
      isActive: true,
      viewCount: 180,
      applyCount: 22,
      tags: const ['Design', 'Figma', 'UI/UX', 'Remote'],
    ),
    JobModel(
      id: 'job-4',
      title: 'Full Stack Cloud Architect',
      company: 'Apex Cloud Solutions',
      companyLogo: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=100&h=100&fit=crop',
      companyWebsite: 'https://apexcloud.dev',
      description: 'Design and implement resilient serverless architectures, microservices, and GraphQL APIs supporting millions of daily active users.',
      shortDescription: 'Architect resilient serverless systems & microservices',
      requirements: const [
        '5+ years experience building cloud-native infrastructure',
        'Strong expertise with AWS/GCP, TypeScript, and Go',
        'Deep understanding of distributed data stores and caching',
      ],
      responsibilities: const [
        'Design multi-region cloud infrastructure',
        'Optimize database queries and cache layers',
        'Ensure security and compliance standards',
      ],
      skills: const ['TypeScript', 'Node.js', 'AWS', 'Docker', 'GraphQL'],
      experienceLevel: 'Senior (5+ yrs)',
      jobType: 'Full-time',
      location: 'Seattle, WA',
      isRemote: false,
      minSalary: 165000,
      maxSalary: 210000,
      currency: 'USD',
      industry: 'Cloud Infrastructure',
      department: 'Architecture',
      postedAt: DateTime.now().subtract(const Duration(days: 4)),
      isActive: true,
      viewCount: 95,
      applyCount: 12,
      tags: const ['Cloud', 'AWS', 'Architecture', 'TypeScript'],
    ),
  ];

  static final Set<String> _demoSavedJobIds = {'job-1', 'job-3'};
  static final List<JobApplicationModel> _demoApplications = [];

  JobService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? (Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null);

  Future<List<JobModel>> getJobs({
    int limit = 20,
    String? lastJobId,
    String? industry,
    String? experienceLevel,
    String? jobType,
    String? location,
    bool? isRemote,
    String? searchQuery,
    List<String>? skills,
  }) async {
    final firestore = _firestore;
    if (firestore == null) {
      var filtered = List<JobModel>.from(_mockJobs);
      if (industry != null) {
        filtered = filtered.where((j) => j.industry == industry).toList();
      }
      if (experienceLevel != null) {
        filtered = filtered.where((j) => j.experienceLevel == experienceLevel).toList();
      }
      if (jobType != null) {
        filtered = filtered.where((j) => j.jobType == jobType).toList();
      }
      if (isRemote != null) {
        filtered = filtered.where((j) => j.isRemote == isRemote).toList();
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        filtered = filtered.where((j) =>
          j.title.toLowerCase().contains(query) ||
          j.company.toLowerCase().contains(query) ||
          j.skills.any((s) => s.toLowerCase().contains(query))
        ).toList();
      }
      return filtered.take(limit).toList();
    }
    try {
      Query query = firestore.collection('jobs')
          .where('isActive', isEqualTo: true)
          .orderBy('postedAt', descending: true);

      if (industry != null) query = query.where('industry', isEqualTo: industry);
      if (experienceLevel != null) query = query.where('experienceLevel', isEqualTo: experienceLevel);
      if (jobType != null) query = query.where('jobType', isEqualTo: jobType);
      if (isRemote != null) query = query.where('isRemote', isEqualTo: isRemote);

      if (lastJobId != null) {
        final lastDoc = await firestore.collection('jobs').doc(lastJobId).get();
        if (lastDoc.exists) query = query.startAfterDocument(lastDoc);
      }

      query = query.limit(limit);
      final snapshot = await query.get();

      AppLogger.info('Fetched ${snapshot.docs.length} jobs', tag: 'JobService');

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return JobModel.fromMap({...data, 'id': doc.id});
      }).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching jobs', tag: 'JobService', error: e, stackTrace: e.stackTrace);
      throw ServerException(message: 'Failed to fetch jobs: ${e.message}');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching jobs', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch jobs.');
    }
  }

  Future<JobModel?> getJobById(String jobId) async {
    final firestore = _firestore;
    if (firestore == null) {
      try {
        return _mockJobs.firstWhere((j) => j.id == jobId);
      } catch (_) {
        return null;
      }
    }
    try {
      final doc = await firestore.collection('jobs').doc(jobId).get();
      if (!doc.exists) return null;

      // Increment view count (fire-and-forget, do not block)
      firestore.collection('jobs').doc(jobId).update({
        'viewCount': FieldValue.increment(1),
      }).catchError((e) {
        AppLogger.warning('Failed to increment view count', tag: 'JobService', error: e);
      });

      return JobModel.fromMap({...doc.data()!, 'id': doc.id});
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching job $jobId', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to fetch job details.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching job $jobId', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch job details.');
    }
  }

  Future<void> recordSwipe(String userId, String jobId, String action, {double? matchScore}) async {
    final firestore = _firestore;
    if (firestore == null) {
      if (action == 'like' || action == 'save') {
        _demoSavedJobIds.add(jobId);
      }
      AppLogger.info('Recorded swipe: $action on $jobId (demo)', tag: 'JobService');
      return;
    }
    try {
      final swipeId = AppUtils.generateId();
      final swipeData = {
        'id': swipeId,
        'userId': userId,
        'jobId': jobId,
        'action': action,
        'swipedAt': Timestamp.fromDate(DateTime.now()),
        'matchScore': matchScore,
      };

      final batch = firestore.batch();
      batch.set(firestore.collection('swipes').doc(swipeId), swipeData);
      batch.update(firestore.collection('users').doc(userId), {
        'dailySwipeCount': FieldValue.increment(1),
      });

      if (action == 'like' || action == 'save') {
        batch.update(firestore.collection('users').doc(userId), {
          'savedJobIds': FieldValue.arrayUnion([jobId]),
        });
      }

      await batch.commit();
      AppLogger.info('Recorded swipe: $action on $jobId', tag: 'JobService');
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error recording swipe', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to record swipe.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error recording swipe', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to record swipe.');
    }
  }

  Future<void> applyForJob(String userId, String jobId, {String? coverLetter, String? resumeUrl}) async {
    final firestore = _firestore;
    if (firestore == null) {
      if (_demoApplications.any((a) => a.jobId == jobId)) {
        throw ServerException(message: 'You have already applied to this job.');
      }
      final application = JobApplicationModel(
        id: 'app-${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        jobId: jobId,
        status: 'pending',
        appliedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        coverLetter: coverLetter,
        resumeUrl: resumeUrl,
      );
      _demoApplications.insert(0, application);
      AppLogger.info('Applied to demo job $jobId', tag: 'JobService');
      return;
    }
    try {
      // Check if already applied
      final existingApp = await firestore
          .collection('applications')
          .where('userId', isEqualTo: userId)
          .where('jobId', isEqualTo: jobId)
          .limit(1)
          .get();

      if (existingApp.docs.isNotEmpty) {
        throw ServerException(message: 'You have already applied to this job.');
      }

      final applicationId = AppUtils.generateId();
      final now = Timestamp.fromDate(DateTime.now());
      final applicationData = {
        'id': applicationId,
        'userId': userId,
        'jobId': jobId,
        'status': 'pending',
        'coverLetter': coverLetter,
        'resumeUrl': resumeUrl,
        'appliedAt': now,
        'updatedAt': now,
        'timeline': {
          'applied': now,
        },
      };

      final batch = firestore.batch();
      batch.set(firestore.collection('applications').doc(applicationId), applicationData);
      batch.update(firestore.collection('jobs').doc(jobId), {
        'applyCount': FieldValue.increment(1),
      });
      batch.update(firestore.collection('users').doc(userId), {
        'appliedJobIds': FieldValue.arrayUnion([jobId]),
      });
      await batch.commit();

      AppLogger.info('Applied to job $jobId', tag: 'JobService');
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error applying for job', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to apply for job.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error applying for job', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to apply for job.');
    }
  }

  Future<void> saveJob(String userId, String jobId) async {
    final firestore = _firestore;
    if (firestore == null) {
      _demoSavedJobIds.add(jobId);
      AppLogger.info('Saved demo job $jobId', tag: 'JobService');
      return;
    }
    try {
      await firestore.collection('users').doc(userId).update({
        'savedJobIds': FieldValue.arrayUnion([jobId]),
      });
      AppLogger.info('Saved job $jobId for user $userId', tag: 'JobService');
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error saving job', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to save job.');
    }
  }

  Future<void> unsaveJob(String userId, String jobId) async {
    final firestore = _firestore;
    if (firestore == null) {
      _demoSavedJobIds.remove(jobId);
      AppLogger.info('Unsaved demo job $jobId', tag: 'JobService');
      return;
    }
    try {
      await firestore.collection('users').doc(userId).update({
        'savedJobIds': FieldValue.arrayRemove([jobId]),
      });
      AppLogger.info('Unsaved job $jobId for user $userId', tag: 'JobService');
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error unsaving job', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to unsave job.');
    }
  }

  Future<List<JobModel>> getSavedJobs(String userId) async {
    final firestore = _firestore;
    if (firestore == null) {
      return _mockJobs.where((j) => _demoSavedJobIds.contains(j.id)).toList();
    }
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return [];

      final savedIds = List<String>.from(userDoc.data()?['savedJobIds'] ?? []);
      if (savedIds.isEmpty) return [];

      final jobs = <JobModel>[];
      // Firestore 'whereIn' is limited to 30 items, batch by 10 for safety
      for (var i = 0; i < savedIds.length; i += 10) {
        final end = (i + 10 > savedIds.length) ? savedIds.length : i + 10;
        final batch = savedIds.sublist(i, end);
        final snapshot = await firestore
            .collection('jobs')
            .where(FieldPath.documentId, whereIn: batch)
            .get();
        jobs.addAll(snapshot.docs.map((doc) => JobModel.fromMap({...doc.data(), 'id': doc.id})));
      }

      AppLogger.info('Fetched ${jobs.length} saved jobs', tag: 'JobService');
      return jobs;
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching saved jobs', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to fetch saved jobs.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching saved jobs', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch saved jobs.');
    }
  }

  Future<List<JobApplicationModel>> getAppliedJobs(String userId) async {
    final firestore = _firestore;
    if (firestore == null) {
      return List<JobApplicationModel>.from(_demoApplications);
    }
    try {
      final snapshot = await firestore
          .collection('applications')
          .where('userId', isEqualTo: userId)
          .orderBy('appliedAt', descending: true)
          .get();

      AppLogger.info('Fetched ${snapshot.docs.length} applications', tag: 'JobService');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return JobApplicationModel.fromMap({...data, 'id': doc.id});
      }).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching applications', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to fetch applied jobs.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching applications', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch applied jobs.');
    }
  }

  Future<List<JobModel>> getRecommendedJobs(String userId) async {
    final firestore = _firestore;
    if (firestore == null) {
      return _mockJobs;
    }
    try {
      // In a real app, this would call an AI recommendation endpoint
      return await getJobs(limit: 10);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching recommendations', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch recommendations.');
    }
  }

  /// Full-text search using Firestore array-contains on a pre-computed
  /// `searchTokens` field. Falls back to a title prefix scan if tokens missing.
  Future<List<JobModel>> searchJobs(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];

    final firestore = _firestore;
    if (firestore == null) {
      final term = query.trim().toLowerCase();
      return _mockJobs.where((j) =>
        j.title.toLowerCase().contains(term) ||
        j.company.toLowerCase().contains(term) ||
        j.description.toLowerCase().contains(term) ||
        j.skills.any((s) => s.toLowerCase().contains(term))
      ).take(limit).toList();
    }

    try {
      final term = query.trim().toLowerCase();

      // Try array-contains on searchTokens first (requires indexing on write)
      final tokenSnapshot = await firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where('searchTokens', arrayContains: term)
          .limit(limit)
          .get();

      if (tokenSnapshot.docs.isNotEmpty) {
        AppLogger.info('Search "$term" returned ${tokenSnapshot.docs.length} results (token)', tag: 'JobService');
        return tokenSnapshot.docs.map((doc) {
          return JobModel.fromMap({...doc.data(), 'id': doc.id});
        }).toList();
      }

      // Fallback: prefix scan on titleLowercase field
      final prefixSnapshot = await firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where('titleLowercase', isGreaterThanOrEqualTo: term)
          .where('titleLowercase', isLessThan: '${term}z')
          .limit(limit)
          .get();

      AppLogger.info('Search "$term" returned ${prefixSnapshot.docs.length} results (prefix)', tag: 'JobService');
      return prefixSnapshot.docs.map((doc) {
        return JobModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error searching jobs', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to search jobs.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error searching jobs', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to search jobs.');
    }
  }

  // ---------------------------------------------------------------------------
  // RECRUITER METHODS
  // ---------------------------------------------------------------------------

  /// Post a new job or internship
  Future<JobModel> createJob(JobModel job) async {
    final firestore = _firestore;
    if (firestore == null) {
      _mockJobs.insert(0, job);
      AppLogger.info('Job created in local state: ${job.id}', tag: 'JobService');
      return job;
    }

    try {
      final docRef = firestore.collection('jobs').doc(job.id);
      await docRef.set({
        ...job.toMap(),
        'postedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.info('Job posted to Firestore: ${job.id}', tag: 'JobService');
      return job;
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error creating job', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to create job: ${e.message}');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error creating job', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to create job.');
    }
  }

  /// Get all jobs posted by a specific recruiter
  Future<List<JobModel>> getRecruiterJobs(String recruiterId) async {
    final firestore = _firestore;
    if (firestore == null) {
      // In demo mode return jobs owned by recruiter or all active mock jobs
      final owned = _mockJobs.where((j) => j.recruiterId == recruiterId).toList();
      return owned.isNotEmpty ? owned : _mockJobs;
    }

    try {
      final snapshot = await firestore
          .collection('jobs')
          .where('recruiterId', isEqualTo: recruiterId)
          .orderBy('postedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return JobModel.fromMap({...data, 'id': doc.id});
      }).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching recruiter jobs', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to fetch your job listings.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching recruiter jobs', tag: 'JobService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch your job listings.');
    }
  }

  /// Update active status or edit job
  Future<void> updateJobStatus(String jobId, bool isActive) async {
    final firestore = _firestore;
    if (firestore == null) {
      final idx = _mockJobs.indexWhere((j) => j.id == jobId);
      if (idx != -1) {
        _mockJobs[idx] = _mockJobs[idx].copyWith(isActive: isActive);
      }
      return;
    }

    try {
      await firestore.collection('jobs').doc(jobId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to update job status: ${e.message}');
    }
  }

  /// Get applicants for a specific job listing
  Future<List<JobApplicationModel>> getJobApplicants(String jobId) async {
    final firestore = _firestore;
    if (firestore == null) {
      // Seed demo applicants if empty for realistic evaluation
      if (_demoApplications.isEmpty) {
        _demoApplications.addAll([
          JobApplicationModel(
            id: 'app-1',
            userId: 'usr_rahul_sharma',
            jobId: jobId,
            status: 'shortlisted',
            appliedAt: DateTime.now().subtract(const Duration(days: 2)),
            updatedAt: DateTime.now().subtract(const Duration(days: 1)),
            coverLetter: 'Passionate Flutter & Dart Engineer with 3+ years experience.',
          ),
          JobApplicationModel(
            id: 'app-2',
            userId: 'usr_priya_singh',
            jobId: jobId,
            status: 'pending',
            appliedAt: DateTime.now().subtract(const Duration(days: 3)),
            updatedAt: DateTime.now().subtract(const Duration(days: 3)),
            coverLetter: 'Frontend & mobile developer experienced with Riverpod and Firebase.',
          ),
          JobApplicationModel(
            id: 'app-3',
            userId: 'usr_arjun_verma',
            jobId: jobId,
            status: 'interview',
            appliedAt: DateTime.now().subtract(const Duration(days: 5)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
            coverLetter: 'Senior cross-platform developer specializing in clean architecture.',
          ),
          JobApplicationModel(
            id: 'app-4',
            userId: 'usr_neha_patel',
            jobId: jobId,
            status: 'pending',
            appliedAt: DateTime.now().subtract(const Duration(days: 6)),
            updatedAt: DateTime.now().subtract(const Duration(days: 6)),
            coverLetter: 'Mobile developer eager to contribute to AI-driven products.',
          ),
        ]);
      }
      return _demoApplications.where((a) => a.jobId == jobId || jobId.isEmpty).toList();
    }

    try {
      Query query = firestore.collection('applications');
      if (jobId.isNotEmpty) {
        query = query.where('jobId', isEqualTo: jobId);
      }
      final snapshot = await query.orderBy('appliedAt', descending: true).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return JobApplicationModel.fromMap({...data, 'id': doc.id});
      }).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching applicants', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to fetch applicants.');
    }
  }

  /// Update application status (e.g. 'shortlisted', 'rejected', 'interview', 'offered')
  Future<void> updateApplicationStatus(String applicationId, String newStatus) async {
    final firestore = _firestore;
    if (firestore == null) {
      final idx = _demoApplications.indexWhere((a) => a.id == applicationId);
      if (idx != -1) {
        final old = _demoApplications[idx];
        _demoApplications[idx] = JobApplicationModel(
          id: old.id,
          userId: old.userId,
          jobId: old.jobId,
          status: newStatus,
          coverLetter: old.coverLetter,
          resumeUrl: old.resumeUrl,
          appliedAt: old.appliedAt,
          updatedAt: DateTime.now(),
          timeline: {...old.timeline, newStatus: DateTime.now().toIso8601String()},
        );
      }
      return;
    }

    try {
      await firestore.collection('applications').doc(applicationId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
        'timeline.$newStatus': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error updating status', tag: 'JobService', error: e);
      throw ServerException(message: 'Failed to update application status.');
    }
  }
}
