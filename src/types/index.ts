// Data models ported from Flutter CareerSwipe AI

export type UserType = 'talent' | 'recruiter' | 'organizer';
export type WorkMode = 'remote' | 'hybrid' | 'onsite' | 'any';
export type ExperienceLevel = 'student' | 'fresher' | 'intern' | 'junior' | 'midLevel' | 'senior' | 'lead' | 'executive';

export interface EducationEntry {
  institution: string;
  degree: string;
  field: string;
  grade?: string;
  startYear?: number;
  endYear?: number;
  isCurrent?: boolean;
}

export interface ExperienceEntry {
  company: string;
  role: string;
  description?: string;
  location?: string;
  isRemote?: boolean;
  startMonth?: number;
  startYear?: number;
  endMonth?: number;
  endYear?: number;
  isCurrent?: boolean;
  skills: string[];
}

export interface CertificationEntry {
  name: string;
  issuer: string;
  credentialId?: string;
  issuedYear?: number;
  expiryYear?: number;
  url?: string;
}

export interface ProjectEntry {
  name: string;
  description: string;
  skills: string[];
  url?: string;
  githubUrl?: string;
  year?: number;
}

export interface UserModel {
  id: string;
  email: string;
  displayName: string;
  photoUrl?: string;
  phoneNumber?: string;
  bio?: string;
  userType: UserType;
  skills: string[];
  experienceLevel?: string;
  industry?: string;
  location?: string;
  targetRole?: string;
  preferredIndustry?: string;
  workMode: WorkMode;
  careerGoal?: string;
  education: EducationEntry[];
  experience: ExperienceEntry[];
  certifications: CertificationEntry[];
  projects: ProjectEntry[];
  achievements: string[];
  hackathonHistory: string[];
  githubUrl?: string;
  linkedinUrl?: string;
  portfolioUrl?: string;
  resumeUrl?: string;
  resumeId?: string;
  lastAtsScore?: number;
  isEmailVerified: boolean;
  isProfileComplete: boolean;
  isAdmin: boolean;
  createdAt: string;
  updatedAt?: string;
  lastLoginAt?: string;
  preferences: Record<string, any>;
  savedJobIds: string[];
  appliedJobIds: string[];
  dailySwipeCount: number;
}

export interface JobModel {
  id: string;
  title: string;
  company: string;
  companyLogo?: string;
  companyWebsite?: string;
  description: string;
  shortDescription?: string;
  requirements: string[];
  responsibilities: string[];
  skills: string[];
  experienceLevel?: string;
  jobType?: string;
  location?: string;
  isRemote: boolean;
  minSalary?: number;
  maxSalary?: number;
  currency: string;
  industry?: string;
  department?: string;
  postedAt: string;
  expiresAt?: string;
  isActive: boolean;
  viewCount: number;
  applyCount: number;
  recruiterId?: string;
  tags: string[];
}

export interface JobSwipeModel {
  id: string;
  userId: string;
  jobId: string;
  action: 'like' | 'dislike' | 'save' | 'superlike';
  swipedAt: string;
  matchScore?: number;
}

export type ApplicationStatus = 'pending' | 'reviewing' | 'interview' | 'offered' | 'rejected' | 'withdrawn';

export interface JobApplicationModel {
  id: string;
  userId: string;
  applicantName?: string;
  applicantEmail?: string;
  jobId: string;
  jobTitle?: string;
  companyName?: string;
  location?: string;
  status: ApplicationStatus;
  atsScore?: number;
  skills?: string[];
  coverLetter?: string;
  resumeUrl?: string;
  resumeFileName?: string;
  appliedAt: string;
  updatedAt?: string;
  timeline: {
    status: ApplicationStatus;
    date: string;
    note?: string;
  }[];
}

export interface LearningResource {
  title: string;
  platform: string; // Coursera, YouTube, Udemy, etc.
  type: 'course' | 'book' | 'project' | 'certification';
  url?: string;
  duration?: string;
}

export interface RoadmapMonth {
  month: number;
  theme: string;
  goals: string[];
  resources: LearningResource[];
  projects: string[];
  certifications: string[];
}

export interface ResumeAnalysisContext {
  targetRole: string;
  experienceLevel: string;
  preferredIndustry?: string;
  preferredLocation?: string;
  workMode: string;
  customRole?: string;
}

export interface ResumeModel {
  id: string;
  userId: string;
  fileName: string;
  fileUrl: string;
  fileSize: number;
  fileType: string;
  extractedText?: string;
  uploadedAt: string;
  isActive: boolean;
  version: number;
  atsScore: number;
  skills: string[];
  atsBreakdown: {
    Keywords: number;
    Formatting: number;
    Readability: number;
    Impact: number;
    Experience: number;
  };
}

export interface ResumeAnalysisModel {
  id: string;
  userId: string;
  resumeId: string;
  atsScore: number;
  keywordMatch: number;
  formattingScore: number;
  contentScore: number;
  jobReadinessScore: number;
  careerCompetitivenessScore: number;
  interviewReadinessScore: number;
  marketDemandScore: number;
  resumeStrengthScore: number;
  detectedSkills: string[];
  missingSkills: string[];
  recommendedSkills: string[];
  keywords: string[];
  missingKeywords: string[];
  strengths: string[];
  improvements: string[];
  summary: string;
  rewriteSuggestions: string[];
  careerAdvice: string[];
  interviewTips: string[];
  sectionScores: {
    contact_info: number;
    summary: number;
    experience: number;
    education: number;
    skills: number;
    projects: number;
  };
  projectAnalysis: {
    name: string;
    rating: string;
    feedback: string;
  }[];
  roadmap: RoadmapMonth[];
  context?: ResumeAnalysisContext;
  analyzedAt: string;
  isComplete: boolean;
}

export interface NotificationModel {
  id: string;
  userId: string;
  title: string;
  message: string;
  type: 'job_match' | 'application_update' | 'resume_tip' | 'system';
  isRead: boolean;
  createdAt: string;
  actionUrl?: string;
}
