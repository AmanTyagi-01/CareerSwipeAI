import React, { createContext, useContext, useState, useEffect } from 'react';
import { 
  UserModel, 
  JobModel, 
  ResumeModel, 
  ResumeAnalysisModel, 
  JobApplicationModel, 
  NotificationModel,
  UserType,
  ApplicationStatus
} from '../types';
import { 
  freshCandidateUser, 
  demoCandidateUser, 
  recruiterUser, 
  initialJobs 
} from '../data/mockData';
import { extractTextFromFile, parseResumeText, ParsedResumeData } from '../services/resumeParser';
import { calculateAtsCompatibility, generateFullResumeAnalysisModel, ATSCompatibilityResult } from '../services/atsAnalyzer';

interface AppContextType {
  currentUser: UserModel;
  isAuthenticated: boolean;
  jobs: JobModel[];
  activeResume: ResumeModel | null;
  resumes: ResumeModel[];
  currentAnalysis: ResumeAnalysisModel | null;
  applications: JobApplicationModel[];
  notifications: NotificationModel[];
  themeMode: 'dark' | 'light';
  currentRoute: string;
  routeParams: Record<string, string>;
  swipeHistory: { jobId: string; action: string }[];
  toast: { message: string; type: 'success' | 'error' | 'info' } | null;
  
  // Auth Modal State
  isAuthModalOpen: boolean;
  authModalTab: 'signin' | 'register';
  openAuthModal: (tab?: 'signin' | 'register') => void;
  closeAuthModal: () => void;

  // Actions
  toggleTheme: () => void;
  navigate: (path: string, params?: Record<string, string>) => void;
  login: (email: string, password?: string) => Promise<{ success: boolean; error?: string }>;
  register: (data: { email: string; password: string; name: string; userType: UserType }) => Promise<{ success: boolean; error?: string }>;
  loginWithGoogle: () => Promise<{ success: boolean; error?: string }>;
  logout: () => void;
  switchPersona: (persona: 'fresh' | 'demo' | 'recruiter' | 'admin') => void;
  
  // Job Swiping & Applications
  recordSwipe: (jobId: string, action: 'like' | 'dislike' | 'save' | 'superlike') => void;
  undoSwipe: () => void;
  toggleSaveJob: (jobId: string) => void;
  applyForJob: (jobId: string, coverLetter?: string) => { success: boolean; message: string };
  
  // Recruiter actions
  postJob: (jobData: {
    title: string;
    company: string;
    description: string;
    requirements: string[];
    skills: string[];
    experienceLevel: string;
    jobType: string;
    location: string;
    isRemote: boolean;
    minSalary?: number;
    maxSalary?: number;
  }) => JobModel;
  updateApplicationStatus: (applicationId: string, newStatus: ApplicationStatus, recruiterNote?: string) => void;
  
  // Resume & ATS Parsing
  uploadResumeFile: (file: File) => Promise<{ success: boolean; error?: string; analysis?: ResumeAnalysisModel }>;
  deleteResume: (resumeId: string) => void;
  setActiveResumeById: (resumeId: string) => void;
  runJobSpecificAtsCheck: (job: JobModel) => ATSCompatibilityResult | null;
  
  // User Profile & Notifications
  updateUserProfile: (updates: Partial<UserModel>) => void;
  markNotificationRead: (id: string) => void;
  markAllNotificationsRead: () => void;
  switchUserRole: (role: UserType) => void;
  showToast: (message: string, type?: 'success' | 'error' | 'info') => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  // Current user state (Default to Fresh Candidate for clean zero-fake-data experience)
  const [currentUser, setCurrentUser] = useState<UserModel>(() => {
    const saved = localStorage.getItem('careerswipe_user');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return freshCandidateUser;
  });

  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(() => {
    return localStorage.getItem('careerswipe_is_auth') !== 'false';
  });

  const [jobs, setJobs] = useState<JobModel[]>(() => {
    const saved = localStorage.getItem('careerswipe_jobs');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return initialJobs;
  });

  const [resumes, setResumes] = useState<ResumeModel[]>(() => {
    const saved = localStorage.getItem('careerswipe_resumes');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return [];
  });

  const [activeResume, setActiveResume] = useState<ResumeModel | null>(() => {
    const saved = localStorage.getItem('careerswipe_active_resume');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return resumes.find(r => r.isActive) || resumes[0] || null;
  });

  const [currentAnalysis, setCurrentAnalysis] = useState<ResumeAnalysisModel | null>(() => {
    const saved = localStorage.getItem('careerswipe_analysis');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return null;
  });

  const [applications, setApplications] = useState<JobApplicationModel[]>(() => {
    const saved = localStorage.getItem('careerswipe_applications');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return [];
  });

  const [notifications, setNotifications] = useState<NotificationModel[]>(() => {
    const saved = localStorage.getItem('careerswipe_notifications');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return [];
  });

  const [themeMode, setThemeMode] = useState<'dark' | 'light'>('dark');
  const [currentRoute, setCurrentRoute] = useState<string>('/home');
  const [routeParams, setRouteParams] = useState<Record<string, string>>({});
  const [swipeHistory, setSwipeHistory] = useState<{ jobId: string; action: string }[]>([]);
  const [toast, setToast] = useState<{ message: string; type: 'success' | 'error' | 'info' } | null>(null);

  // Auth modal controls
  const [isAuthModalOpen, setIsAuthModalOpen] = useState(false);
  const [authModalTab, setAuthModalTab] = useState<'signin' | 'register'>('signin');

  // Sync state to localStorage
  useEffect(() => {
    localStorage.setItem('careerswipe_user', JSON.stringify(currentUser));
  }, [currentUser]);

  useEffect(() => {
    localStorage.setItem('careerswipe_is_auth', isAuthenticated ? 'true' : 'false');
  }, [isAuthenticated]);

  useEffect(() => {
    localStorage.setItem('careerswipe_jobs', JSON.stringify(jobs));
  }, [jobs]);

  useEffect(() => {
    localStorage.setItem('careerswipe_resumes', JSON.stringify(resumes));
  }, [resumes]);

  useEffect(() => {
    if (activeResume) {
      localStorage.setItem('careerswipe_active_resume', JSON.stringify(activeResume));
    } else {
      localStorage.removeItem('careerswipe_active_resume');
    }
  }, [activeResume]);

  useEffect(() => {
    if (currentAnalysis) {
      localStorage.setItem('careerswipe_analysis', JSON.stringify(currentAnalysis));
    } else {
      localStorage.removeItem('careerswipe_analysis');
    }
  }, [currentAnalysis]);

  useEffect(() => {
    localStorage.setItem('careerswipe_applications', JSON.stringify(applications));
  }, [applications]);

  useEffect(() => {
    localStorage.setItem('careerswipe_notifications', JSON.stringify(notifications));
  }, [notifications]);

  const showToast = (message: string, type: 'success' | 'error' | 'info' = 'info') => {
    setToast({ message, type });
    setTimeout(() => {
      setToast(null);
    }, 3500);
  };

  const toggleTheme = () => {
    const next = themeMode === 'dark' ? 'light' : 'dark';
    setThemeMode(next);
    if (next === 'dark') {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  };

  const navigate = (path: string, params: Record<string, string> = {}) => {
    setCurrentRoute(path);
    setRouteParams(params);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const openAuthModal = (tab: 'signin' | 'register' = 'signin') => {
    setAuthModalTab(tab);
    setIsAuthModalOpen(true);
  };

  const closeAuthModal = () => {
    setIsAuthModalOpen(false);
  };

  // Authentication Flows
  const login = async (email: string, password?: string): Promise<{ success: boolean; error?: string }> => {
    if (!email || !email.includes('@')) {
      return { success: false, error: 'Please provide a valid email address.' };
    }
    if (password && password.length < 6) {
      return { success: false, error: 'Password must contain at least 6 characters.' };
    }

    // Match demo accounts or existing profile
    let loggedUser: UserModel;
    if (email.toLowerCase().includes('recruiter') || email.toLowerCase().includes('sarah')) {
      loggedUser = recruiterUser;
    } else if (email.toLowerCase().includes('aman')) {
      loggedUser = demoCandidateUser;
    } else {
      loggedUser = {
        ...freshCandidateUser,
        email,
        displayName: email.split('@')[0].replace(/[._-]/g, ' ').replace(/\b\w/g, l => l.toUpperCase()),
        lastLoginAt: new Date().toISOString()
      };
    }

    setCurrentUser(loggedUser);
    setIsAuthenticated(true);
    closeAuthModal();
    showToast(`Signed in successfully as ${loggedUser.displayName}! 👋`, 'success');
    return { success: true };
  };

  const register = async (data: { email: string; password: string; name: string; userType: UserType }): Promise<{ success: boolean; error?: string }> => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(data.email)) {
      return { success: false, error: 'Please enter a valid email format (e.g. name@domain.com).' };
    }
    if (!data.password || data.password.length < 6) {
      return { success: false, error: 'Password must be at least 6 characters long.' };
    }
    if (!data.name.trim()) {
      return { success: false, error: 'Please provide your full name.' };
    }

    // Check duplicate email
    const registeredUsers = JSON.parse(localStorage.getItem('careerswipe_registered_emails') || '[]');
    if (registeredUsers.includes(data.email.toLowerCase())) {
      return { success: false, error: 'An account with this email already exists. Please sign in.' };
    }

    registeredUsers.push(data.email.toLowerCase());
    localStorage.setItem('careerswipe_registered_emails', JSON.stringify(registeredUsers));

    // Fresh new account with ZERO fake activity
    const newUser: UserModel = {
      id: `usr_${Date.now()}`,
      email: data.email,
      displayName: data.name,
      photoUrl: '',
      phoneNumber: '',
      bio: '',
      userType: data.userType,
      skills: [],
      experienceLevel: data.userType === 'recruiter' ? 'midLevel' : 'Fresher / Junior',
      industry: 'Technology',
      location: 'Remote',
      targetRole: data.userType === 'recruiter' ? 'Technical Recruiter' : 'Software Engineer',
      preferredIndustry: 'Technology',
      workMode: 'remote',
      education: [],
      experience: [],
      certifications: [],
      projects: [],
      achievements: [],
      hackathonHistory: [],
      isEmailVerified: true,
      isProfileComplete: false,
      isAdmin: data.userType === 'recruiter',
      createdAt: new Date().toISOString(),
      preferences: { emailAlerts: true },
      savedJobIds: [],
      appliedJobIds: [],
      dailySwipeCount: 0
    };

    setCurrentUser(newUser);
    setIsAuthenticated(true);
    setResumes([]);
    setActiveResume(null);
    setCurrentAnalysis(null);
    setApplications([]);
    setNotifications([]);
    closeAuthModal();

    showToast(`Welcome to CareerSwipe AI, ${newUser.displayName}! 🚀`, 'success');
    navigate(newUser.userType === 'recruiter' ? '/admin' : '/jobs/swipe');
    return { success: true };
  };

  const loginWithGoogle = async (): Promise<{ success: boolean; error?: string }> => {
    try {
      const createOrGetUser = (email: string, name?: string, photo?: string, googleSub?: string) => {
        const cleanEmail = email.trim().toLowerCase();
        const googleUid = googleSub ? `usr_google_${googleSub}` : `usr_google_${cleanEmail.replace(/[^a-zA-Z0-9]/g, '_')}`;

        // Retrieve existing database of users to prevent overwriting
        const usersDb: Record<string, UserModel> = JSON.parse(localStorage.getItem('careerswipe_users_db') || '{}');
        let userModel: UserModel;

        if (usersDb[googleUid]) {
          userModel = usersDb[googleUid];
          userModel.lastLoginAt = new Date().toISOString();
        } else {
          // Initialize fresh user account specifically for this Google profile
          userModel = {
            id: googleUid,
            email: cleanEmail,
            displayName: name || cleanEmail.split('@')[0].replace(/[._-]/g, ' ').replace(/\b\w/g, l => l.toUpperCase()),
            photoUrl: photo || '',
            phoneNumber: '',
            bio: '',
            userType: 'talent',
            skills: [],
            experienceLevel: 'Entry / Junior',
            industry: 'Software Development',
            location: 'Remote',
            targetRole: 'Software Developer',
            preferredIndustry: 'Technology',
            workMode: 'remote',
            education: [],
            experience: [],
            certifications: [],
            projects: [],
            achievements: [],
            hackathonHistory: [],
            isEmailVerified: true,
            isProfileComplete: false,
            isAdmin: false,
            createdAt: new Date().toISOString(),
            lastLoginAt: new Date().toISOString(),
            preferences: { notifications: true },
            savedJobIds: [],
            appliedJobIds: [],
            dailySwipeCount: 0
          };
          usersDb[googleUid] = userModel;
        }

        localStorage.setItem('careerswipe_users_db', JSON.stringify(usersDb));

        // Load isolated per-user data
        const savedResumes = JSON.parse(localStorage.getItem(`careerswipe_resumes_${googleUid}`) || '[]');
        const savedApps = JSON.parse(localStorage.getItem(`careerswipe_apps_${googleUid}`) || '[]');

        setCurrentUser(userModel);
        setResumes(savedResumes);
        setActiveResume(savedResumes.length > 0 ? savedResumes[0] : null);
        setApplications(savedApps);
        setIsAuthenticated(true);
        closeAuthModal();
        showToast(`Signed in with Google Account (${userModel.email})`, 'success');
      };

      const chosenEmail = window.prompt('Google Account Chooser: Enter Google account email to sign in with:');
      if (!chosenEmail || !chosenEmail.trim()) {
        return { success: false, error: 'Google sign-in was cancelled.' };
      }
      createOrGetUser(chosenEmail.trim());
      return { success: true };
    } catch (e: any) {
      return { success: false, error: e?.message || 'Google sign-in failed.' };
    }
  };

  const logout = () => {
    setIsAuthenticated(false);
    setCurrentUser(freshCandidateUser);
    setResumes([]);
    setActiveResume(null);
    setCurrentAnalysis(null);
    setApplications([]);
    setNotifications([]);
    showToast('Signed out of session. You can now sign in with another account.', 'info');
  };

  const switchPersona = (persona: 'fresh' | 'demo' | 'recruiter' | 'admin') => {
    if (persona === 'fresh') {
      setCurrentUser(freshCandidateUser);
      setResumes([]);
      setActiveResume(null);
      setCurrentAnalysis(null);
      setApplications([]);
      setNotifications([]);
      showToast('Switched to Fresh Candidate (Clean empty state)', 'info');
      navigate('/home');
    } else if (persona === 'demo') {
      setCurrentUser(demoCandidateUser);
      // Create a sample resume
      const demoRes: ResumeModel = {
        id: 'res_aman_01',
        userId: demoCandidateUser.id,
        fileName: 'Aman_Tyagi_Mobile_FullStack_Resume.pdf',
        fileUrl: '/resumes/aman_resume.pdf',
        fileSize: 420000,
        fileType: 'pdf',
        uploadedAt: new Date().toISOString(),
        isActive: true,
        version: 1,
        atsScore: 88,
        skills: demoCandidateUser.skills,
        atsBreakdown: {
          Keywords: 86,
          Formatting: 94,
          Readability: 90,
          Impact: 84,
          Experience: 88
        }
      };
      setResumes([demoRes]);
      setActiveResume(demoRes);
      
      const parsed = parseResumeText(
        `Aman Tyagi\nSenior Mobile & Full-Stack Engineer\nEmail: aman.tyagi@careerswipe.ai\nPhone: +1 555 489 2041\nSkills: Flutter, Dart, React, TypeScript, Firebase, REST APIs, Git\nExperience: Senior Mobile Developer at TechCorp. Architected cross-platform apps reducing memory by 35%.\nEducation: B.S. in Computer Science, UC Berkeley.`
      );
      const analysis = generateFullResumeAnalysisModel(parsed, demoRes.id, demoCandidateUser.id, jobs[0]);
      setCurrentAnalysis(analysis);
      
      // Sample application
      const demoApp: JobApplicationModel = {
        id: 'app_demo_01',
        userId: demoCandidateUser.id,
        applicantName: demoCandidateUser.displayName,
        applicantEmail: demoCandidateUser.email,
        jobId: 'job_stripe_01',
        jobTitle: 'Senior Mobile & Flutter Engineer',
        companyName: 'Stripe',
        location: 'San Francisco, CA (Remote)',
        status: 'interview',
        atsScore: 88,
        skills: ['Flutter', 'Dart', 'TypeScript', 'REST APIs'],
        coverLetter: 'Hi Stripe Engineering Team, thrilled to submit my mobile engineering background...',
        appliedAt: new Date(Date.now() - 3600000 * 48).toISOString(),
        updatedAt: new Date().toISOString(),
        timeline: [
          { status: 'pending', date: '2 days ago', note: 'Application submitted' },
          { status: 'reviewing', date: 'Yesterday', note: 'Reviewed by Technical Hiring Team' },
          { status: 'interview', date: 'Today', note: 'Technical Screen Scheduled' }
        ]
      };
      setApplications([demoApp]);
      showToast('Loaded Demo Candidate Profile (Aman Tyagi)', 'info');
      navigate('/home');
    } else if (persona === 'recruiter') {
      setCurrentUser(recruiterUser);
      showToast('Switched to Recruiter Mode (Sarah Jenkins, Apex AI)', 'info');
      navigate('/admin');
    } else if (persona === 'admin') {
      setCurrentUser({ ...recruiterUser, isAdmin: true, displayName: 'Platform Administrator' });
      showToast('Admin Mode Active', 'info');
      navigate('/admin');
    }
  };

  // Job Actions
  const recordSwipe = (jobId: string, action: 'like' | 'dislike' | 'save' | 'superlike') => {
    setSwipeHistory(prev => [...prev, { jobId, action }]);
    const targetJob = jobs.find(j => j.id === jobId);

    if (action === 'like' || action === 'superlike' || action === 'save') {
      if (!currentUser.savedJobIds.includes(jobId)) {
        setCurrentUser(prev => ({
          ...prev,
          savedJobIds: [...prev.savedJobIds, jobId],
          dailySwipeCount: prev.dailySwipeCount + 1,
        }));
      }
      if (action === 'superlike') {
        applyForJob(jobId, 'Fast-tracked priority candidate submission via Superlike ⭐');
      } else {
        showToast(`Saved: ${targetJob?.title || 'Job'} at ${targetJob?.company || ''}`, 'success');
      }
    } else {
      setCurrentUser(prev => ({
        ...prev,
        dailySwipeCount: prev.dailySwipeCount + 1,
      }));
    }
  };

  const undoSwipe = () => {
    if (swipeHistory.length === 0) {
      showToast('No swipes left to undo', 'info');
      return;
    }
    const last = swipeHistory[swipeHistory.length - 1];
    setSwipeHistory(prev => prev.slice(0, -1));

    if (last.action === 'like' || last.action === 'save' || last.action === 'superlike') {
      setCurrentUser(prev => ({
        ...prev,
        savedJobIds: prev.savedJobIds.filter(id => id !== last.jobId),
      }));
    }
    showToast('Undid previous swipe', 'info');
  };

  const toggleSaveJob = (jobId: string) => {
    const job = jobs.find(j => j.id === jobId);
    const isSaved = currentUser.savedJobIds.includes(jobId);

    if (isSaved) {
      setCurrentUser(prev => ({
        ...prev,
        savedJobIds: prev.savedJobIds.filter(id => id !== jobId)
      }));
      showToast(`Removed from saved: ${job?.title || 'Job'}`, 'info');
    } else {
      setCurrentUser(prev => ({
        ...prev,
        savedJobIds: [...prev.savedJobIds, jobId]
      }));
      showToast(`Saved: ${job?.title || 'Job'} at ${job?.company || ''}`, 'success');
    }
  };

  const applyForJob = (jobId: string, coverLetter?: string): { success: boolean; message: string } => {
    const job = jobs.find(j => j.id === jobId);
    if (!job) return { success: false, message: 'Job not found' };

    if (currentUser.appliedJobIds.includes(jobId)) {
      showToast(`You have already applied for ${job.title}`, 'info');
      return { success: false, message: 'Already applied' };
    }

    const calculatedMatch = activeResume ? activeResume.atsScore : 80;

    const newApplication: JobApplicationModel = {
      id: `app_${Date.now()}`,
      userId: currentUser.id,
      applicantName: currentUser.displayName || 'Candidate',
      applicantEmail: currentUser.email,
      jobId: job.id,
      jobTitle: job.title,
      companyName: job.company,
      location: job.location || (job.isRemote ? 'Remote' : 'Onsite'),
      status: 'pending',
      atsScore: calculatedMatch,
      skills: activeResume ? activeResume.skills : currentUser.skills,
      coverLetter: coverLetter || `Hi ${job.company} Team, I am eager to apply for the ${job.title} position...`,
      resumeUrl: activeResume?.fileUrl || '',
      resumeFileName: activeResume?.fileName || 'Candidate_Profile.pdf',
      appliedAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      timeline: [
        { status: 'pending', date: 'Just now', note: 'Application sent directly to Hiring Manager' }
      ]
    };

    setApplications(prev => [newApplication, ...prev]);
    setCurrentUser(prev => ({
      ...prev,
      appliedJobIds: [...prev.appliedJobIds, jobId]
    }));

    // Increment applyCount on the job
    setJobs(prev => prev.map(j => j.id === jobId ? { ...j, applyCount: j.applyCount + 1 } : j));

    // Notification
    const newNotif: NotificationModel = {
      id: `notif_${Date.now()}`,
      userId: currentUser.id,
      title: 'Application Submitted!',
      message: `Your application for ${job.title} at ${job.company} has been received.`,
      type: 'application_update',
      isRead: false,
      createdAt: new Date().toISOString(),
      actionUrl: '/jobs/applied'
    };
    setNotifications(prev => [newNotif, ...prev]);

    showToast(`Successfully applied to ${job.title} at ${job.company}! 🚀`, 'success');
    return { success: true, message: 'Applied successfully' };
  };

  // Recruiter actions
  const postJob = (jobData: {
    title: string;
    company: string;
    description: string;
    requirements: string[];
    skills: string[];
    experienceLevel: string;
    jobType: string;
    location: string;
    isRemote: boolean;
    minSalary?: number;
    maxSalary?: number;
  }): JobModel => {
    const newJob: JobModel = {
      id: `job_${Date.now()}`,
      title: jobData.title,
      company: jobData.company,
      description: jobData.description,
      shortDescription: jobData.description.slice(0, 140) + '...',
      requirements: jobData.requirements,
      responsibilities: [
        'Collaborate with product and engineering leaders on feature implementation',
        'Maintain high testing standards, automated deployments, and documentation',
        'Contribute to sprint retrospectives and iterative improvement'
      ],
      skills: jobData.skills,
      experienceLevel: jobData.experienceLevel,
      jobType: jobData.jobType,
      location: jobData.location,
      isRemote: jobData.isRemote,
      minSalary: jobData.minSalary || 120000,
      maxSalary: jobData.maxSalary || 180000,
      currency: 'USD',
      industry: 'Technology',
      department: 'Engineering',
      postedAt: new Date().toISOString(),
      isActive: true,
      viewCount: 1,
      applyCount: 0,
      recruiterId: currentUser.id,
      tags: [jobData.jobType, jobData.isRemote ? 'Remote' : 'Onsite', jobData.experienceLevel]
    };

    setJobs(prev => [newJob, ...prev]);
    showToast(`Job "${newJob.title}" posted successfully and live in candidate feed! 🎉`, 'success');
    return newJob;
  };

  const updateApplicationStatus = (applicationId: string, newStatus: ApplicationStatus, recruiterNote?: string) => {
    setApplications(prev => prev.map(app => {
      if (app.id !== applicationId) return app;
      const statusLabels: Record<ApplicationStatus, string> = {
        pending: 'Pending Review',
        reviewing: 'Under Review',
        interview: 'Interview Scheduled',
        offered: 'Offer Extended',
        rejected: 'Declined',
        withdrawn: 'Withdrawn'
      };

      const newTimelineItem = {
        status: newStatus,
        date: 'Just now',
        note: recruiterNote || `Status updated to ${statusLabels[newStatus]}`
      };

      return {
        ...app,
        status: newStatus,
        updatedAt: new Date().toISOString(),
        timeline: [newTimelineItem, ...app.timeline]
      };
    }));

    // Trigger notification
    const app = applications.find(a => a.id === applicationId);
    if (app) {
      const notif: NotificationModel = {
        id: `notif_${Date.now()}`,
        userId: app.userId,
        title: `Application Status Updated: ${app.companyName}`,
        message: `Your application for ${app.jobTitle} is now marked as "${newStatus.toUpperCase()}".`,
        type: 'application_update',
        isRead: false,
        createdAt: new Date().toISOString(),
        actionUrl: '/jobs/applied'
      };
      setNotifications(prev => [notif, ...prev]);
    }

    showToast(`Application updated to ${newStatus.toUpperCase()}`, 'success');
  };

  // Resume Upload & ATS Parsing
  const uploadResumeFile = async (file: File): Promise<{ success: boolean; error?: string; analysis?: ResumeAnalysisModel }> => {
    try {
      // Validate file format
      const extension = file.name.split('.').pop()?.toLowerCase();
      if (!extension || !['pdf', 'docx', 'doc', 'txt'].includes(extension)) {
        return { success: false, error: 'Unsupported file format. Please upload a PDF, DOCX, or TXT file.' };
      }

      // Validate size (max 10MB)
      if (file.size > 10 * 1024 * 1024) {
        return { success: false, error: 'File size exceeds 10MB limit. Please upload a smaller file.' };
      }

      // Extract real text from file
      const extractedText = await extractTextFromFile(file);
      if (!extractedText || extractedText.trim().length < 20) {
        return { 
          success: false, 
          error: 'Could not extract readable text from document. Ensure the document contains selectable text and is not an image scan.' 
        };
      }

      // Parse text into structured resume fields
      const parsedData = parseResumeText(extractedText);

      // Algorithmic ATS Compatibility Evaluation against standard benchmark or current target role
      const atsResult = calculateAtsCompatibility(parsedData, jobs[0] || null);

      const newVersion = resumes.length + 1;
      const newResume: ResumeModel = {
        id: `res_${Date.now()}`,
        userId: currentUser.id,
        fileName: file.name,
        fileUrl: URL.createObjectURL(file),
        fileSize: file.size,
        fileType: extension,
        extractedText,
        uploadedAt: new Date().toISOString(),
        isActive: true,
        version: newVersion,
        atsScore: atsResult.overallScore,
        skills: parsedData.skills,
        atsBreakdown: {
          Keywords: atsResult.requiredSkillsMatch.percentage,
          Formatting: atsResult.formattingAndImpact.score,
          Readability: 90,
          Impact: atsResult.formattingAndImpact.metricsScore,
          Experience: atsResult.experienceMatch.score
        }
      };

      // Set old resumes to inactive
      const updatedResumes = [newResume, ...resumes.map(r => ({ ...r, isActive: false }))];
      setResumes(updatedResumes);
      setActiveResume(newResume);

      // Generate complete analysis model
      const analysisModel = generateFullResumeAnalysisModel(parsedData, newResume.id, currentUser.id, jobs[0] || null);
      setCurrentAnalysis(analysisModel);

      // Update current user skills and resume info
      setCurrentUser(prev => ({
        ...prev,
        resumeUrl: newResume.fileUrl,
        resumeId: newResume.id,
        lastAtsScore: atsResult.overallScore,
        skills: Array.from(new Set([...prev.skills, ...parsedData.skills])),
        displayName: parsedData.contact.name || prev.displayName,
        phoneNumber: parsedData.contact.phone || prev.phoneNumber,
        isProfileComplete: true
      }));

      showToast(`Resume uploaded & parsed successfully! ATS compatibility: ${atsResult.overallScore}/100`, 'success');
      return { success: true, analysis: analysisModel };
    } catch (err: any) {
      console.error('Resume processing error:', err);
      return { success: false, error: err?.message || 'Failed to process and analyze resume.' };
    }
  };

  const deleteResume = (resumeId: string) => {
    const updated = resumes.filter(r => r.id !== resumeId);
    setResumes(updated);

    if (activeResume?.id === resumeId) {
      const next = updated[0] || null;
      setActiveResume(next);
      if (!next) {
        setCurrentAnalysis(null);
        setCurrentUser(prev => ({ ...prev, resumeId: undefined, resumeUrl: undefined, lastAtsScore: undefined }));
      }
    }
    showToast('Resume deleted successfully', 'info');
  };

  const setActiveResumeById = (resumeId: string) => {
    const selected = resumes.find(r => r.id === resumeId);
    if (!selected) return;

    setResumes(prev => prev.map(r => ({ ...r, isActive: r.id === resumeId })));
    setActiveResume({ ...selected, isActive: true });

    // Update analysis
    if (selected.extractedText) {
      const parsed = parseResumeText(selected.extractedText);
      const analysis = generateFullResumeAnalysisModel(parsed, selected.id, currentUser.id, jobs[0] || null);
      setCurrentAnalysis(analysis);
    }
    showToast(`Active resume set to: ${selected.fileName}`, 'info');
  };

  const runJobSpecificAtsCheck = (job: JobModel): ATSCompatibilityResult | null => {
    if (!activeResume || !activeResume.extractedText) {
      // Create fallback from active resume skills if text is missing
      const parsed: ParsedResumeData = {
        rawText: `Skills: ${activeResume?.skills.join(', ')}`,
        contact: { email: currentUser.email, name: currentUser.displayName },
        skills: activeResume ? activeResume.skills : currentUser.skills,
        experienceYears: 2,
        experienceItems: [],
        educationItems: [],
        projects: [],
        certifications: [],
        metricsCount: 2,
        sectionsFound: ['Skills', 'Experience']
      };
      return calculateAtsCompatibility(parsed, job);
    }
    const parsed = parseResumeText(activeResume.extractedText);
    return calculateAtsCompatibility(parsed, job);
  };

  const updateUserProfile = (updates: Partial<UserModel>) => {
    setCurrentUser(prev => ({ ...prev, ...updates, updatedAt: new Date().toISOString() }));
    showToast('Profile updated successfully', 'success');
  };

  const markNotificationRead = (id: string) => {
    setNotifications(prev => prev.map(n => n.id === id ? { ...n, isRead: true } : n));
  };

  const markAllNotificationsRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
    showToast('All notifications marked as read', 'info');
  };

  const switchUserRole = (role: UserType) => {
    setCurrentUser(prev => ({
      ...prev,
      userType: role,
      isAdmin: role === 'recruiter' || role === 'organizer' || prev.isAdmin
    }));
    showToast(`Switched active view mode to ${role.toUpperCase()}`, 'info');
  };

  return (
    <AppContext.Provider
      value={{
        currentUser,
        isAuthenticated,
        jobs,
        activeResume,
        resumes,
        currentAnalysis,
        applications,
        notifications,
        themeMode,
        currentRoute,
        routeParams,
        swipeHistory,
        toast,
        isAuthModalOpen,
        authModalTab,
        openAuthModal,
        closeAuthModal,
        toggleTheme,
        navigate,
        login,
        register,
        loginWithGoogle,
        logout,
        switchPersona,
        recordSwipe,
        undoSwipe,
        toggleSaveJob,
        applyForJob,
        postJob,
        updateApplicationStatus,
        uploadResumeFile,
        deleteResume,
        setActiveResumeById,
        runJobSpecificAtsCheck,
        updateUserProfile,
        markNotificationRead,
        markAllNotificationsRead,
        switchUserRole,
        showToast
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
