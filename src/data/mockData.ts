import { 
  UserModel, 
  JobModel, 
  ResumeModel, 
  ResumeAnalysisModel, 
  JobApplicationModel,
  NotificationModel 
} from '../types';

// Fresh Candidate Account (Genuinely Clean with 0 fake history)
export const freshCandidateUser: UserModel = {
  id: 'usr_fresh_01',
  email: 'hlotushar7@gmail.com',
  displayName: 'Tushar',
  photoUrl: '',
  phoneNumber: '',
  bio: '',
  userType: 'talent',
  skills: [],
  experienceLevel: 'Fresher / Junior',
  industry: 'Software Engineering',
  location: 'Bangalore, India',
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
  preferences: { emailAlerts: true, remoteOnly: false },
  savedJobIds: [],
  appliedJobIds: [],
  dailySwipeCount: 0
};

// Demo Populated Candidate Profile (Aman Tyagi) for showcase
export const demoCandidateUser: UserModel = {
  id: 'usr_aman_01',
  email: 'aman.tyagi@careerswipe.ai',
  displayName: 'Aman Tyagi',
  photoUrl: '',
  phoneNumber: '+1 (555) 489-2041',
  bio: 'Senior Mobile & Full-Stack Engineer specializing in high-performance cross-platform mobile apps with Flutter, React, and scalable cloud architectures.',
  userType: 'talent',
  skills: [
    'Flutter', 'Dart', 'React', 'TypeScript', 'Firebase', 'State Management',
    'REST APIs', 'GraphQL', 'Git', 'Agile & Scrum', 'Tailwind CSS'
  ],
  experienceLevel: 'Senior',
  industry: 'Technology',
  location: 'San Francisco, CA',
  targetRole: 'Senior Mobile Engineer',
  preferredIndustry: 'Technology',
  workMode: 'remote',
  careerGoal: 'Become a Principal Staff Engineer / Mobile Tech Lead architecting large-scale cross-platform ecosystems.',
  education: [
    {
      institution: 'University of California, Berkeley',
      degree: 'B.S. in Computer Science',
      field: 'Software Engineering & Distributed Systems',
      grade: '3.85 GPA',
      startYear: 2018,
      endYear: 2022,
      isCurrent: false,
    }
  ],
  experience: [
    {
      company: 'TechCorp Inc.',
      role: 'Senior Mobile Developer',
      description: 'Architected and deployed cross-platform mobile applications using Flutter & Riverpod. Reduced memory consumption by 35% with lazy rendering.',
      location: 'San Francisco, CA',
      isRemote: true,
      startMonth: 3,
      startYear: 2023,
      isCurrent: true,
      skills: ['Flutter', 'Dart', 'Firebase', 'CI/CD Pipelines']
    }
  ],
  certifications: [
    {
      name: 'Google Associate Cloud Engineer',
      issuer: 'Google Cloud',
      credentialId: 'GCP-892401',
      issuedYear: 2023,
      expiryYear: 2026,
    }
  ],
  projects: [
    {
      name: 'CareerSwipe AI Mobile',
      description: 'AI-assisted swipe discovery marketplace with real-time ATS compatibility scoring.',
      skills: ['Flutter', 'Dart', 'Firebase', 'TypeScript'],
      year: 2024
    }
  ],
  achievements: [
    'Won 1st place in DevPost Global Flutter Hackathon 2023'
  ],
  hackathonHistory: ['DevPost Global 2023'],
  isEmailVerified: true,
  isProfileComplete: true,
  isAdmin: false,
  createdAt: '2024-01-15T08:00:00.000Z',
  preferences: { notifications: true, remoteOnly: true },
  savedJobIds: ['job_stripe_01'],
  appliedJobIds: [],
  dailySwipeCount: 0
};

// Recruiter Profile (Apex AI Hiring Lead)
export const recruiterUser: UserModel = {
  id: 'usr_recruiter_sarah',
  email: 'sarah.jenkins@apexai.co',
  displayName: 'Sarah Jenkins',
  photoUrl: '',
  phoneNumber: '+1 (415) 890-3321',
  bio: 'Head of Technical Talent Acquisition at Apex AI. Passionate about connecting exceptional engineers with groundbreaking AI opportunities.',
  userType: 'recruiter',
  skills: ['Technical Recruiting', 'Talent Strategy', 'Sourcing', 'Engineering Hiring'],
  experienceLevel: 'lead',
  industry: 'Artificial Intelligence',
  location: 'San Francisco, CA',
  targetRole: 'Head of Talent',
  preferredIndustry: 'Artificial Intelligence',
  workMode: 'hybrid',
  education: [
    {
      institution: 'Stanford University',
      degree: 'B.A. in Psychology & Organizational Design',
      field: 'Organizational Behavior',
      startYear: 2014,
      endYear: 2018,
      isCurrent: false
    }
  ],
  experience: [
    {
      company: 'Apex AI',
      role: 'Head of Technical Recruiting',
      description: 'Leading technical hiring for distributed systems, mobile, and AI research teams.',
      startMonth: 1,
      startYear: 2022,
      isCurrent: true,
      skills: ['Technical Recruiting', 'Executive Search']
    }
  ],
  certifications: [],
  projects: [],
  achievements: ['Scaled engineering organization from 20 to 180+ engineers'],
  hackathonHistory: [],
  isEmailVerified: true,
  isProfileComplete: true,
  isAdmin: true,
  createdAt: '2023-06-01T08:00:00.000Z',
  preferences: { dailyDigest: true },
  savedJobIds: [],
  appliedJobIds: [],
  dailySwipeCount: 0
};

// Real, production-quality job & internship listings
export const initialJobs: JobModel[] = [
  {
    id: 'job_stripe_01',
    title: 'Senior Mobile & Flutter Engineer',
    company: 'Stripe',
    companyLogo: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=120&auto=format&fit=crop&q=80',
    companyWebsite: 'https://stripe.com',
    description: 'We are looking for an experienced Senior Mobile Engineer to build seamless, ultra-reliable payment and financial merchant experiences across iOS and Android. You will collaborate with product designers, backend architects, and financial infra specialists to ship high-throughput checkout workflows.',
    shortDescription: 'Build next-generation merchant checkout experiences with Flutter and modern mobile architecture.',
    requirements: [
      '5+ years of mobile engineering experience with Flutter or native iOS/Android',
      'Deep mastery of Dart, state management (Bloc, Riverpod, or Redux)',
      'Experience optimizing app performance, memory footprint, and network latency',
      'Solid understanding of REST APIs, gRPC, and secure local storage',
      'Strong automated unit, integration, and UI testing discipline'
    ],
    responsibilities: [
      'Architect robust cross-platform mobile components used by millions of merchants worldwide',
      'Collaborate with backend engineers to define scalable API contracts',
      'Champion code quality, security audits, and automated release pipelines'
    ],
    skills: ['Flutter', 'Dart', 'TypeScript', 'REST APIs', 'Unit Testing', 'CI/CD Pipelines'],
    experienceLevel: 'senior',
    jobType: 'Full-time',
    location: 'San Francisco, CA',
    isRemote: true,
    minSalary: 175000,
    maxSalary: 235000,
    currency: 'USD',
    industry: 'Fintech',
    department: 'Mobile Infrastructure',
    postedAt: '2026-09-28T10:00:00Z',
    isActive: true,
    viewCount: 142,
    applyCount: 18,
    recruiterId: 'usr_recruiter_sarah',
    tags: ['Remote', 'Fintech', 'Flutter', 'Senior']
  },
  {
    id: 'job_google_ai_02',
    title: 'AI Full-Stack Systems Engineer',
    company: 'Google DeepMind',
    companyLogo: 'https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=120&auto=format&fit=crop&q=80',
    companyWebsite: 'https://deepmind.google',
    description: 'Join the team building user-facing intelligent developer tools, agent frameworks, and generative AI interfaces. You will bridge complex neural model capabilities into responsive, intuitive web and mobile products.',
    shortDescription: 'Architect developer-facing interfaces and agent orchestration platforms for cutting-edge AI models.',
    requirements: [
      '3+ years of full-stack engineering experience with React, TypeScript, and Node.js or Python',
      'Familiarity with LLM orchestration (streaming tokens, embeddings, function calling)',
      'Experience with PostgreSQL, Redis, and high-concurrency microservices',
      'Passion for developer tooling, speed, and modern reactive UI design'
    ],
    responsibilities: [
      'Design and implement high-performance client applications consuming streaming AI outputs',
      'Build resilient backend microservices with real-time WebSocket communication',
      'Collaborate closely with research scientists to deploy state-of-the-art multimodal features'
    ],
    skills: ['React', 'TypeScript', 'Node.js', 'Python', 'PostgreSQL', 'Generative AI', 'Docker'],
    experienceLevel: 'midLevel',
    jobType: 'Full-time',
    location: 'Mountain View, CA',
    isRemote: true,
    minSalary: 160000,
    maxSalary: 215000,
    currency: 'USD',
    industry: 'Artificial Intelligence',
    department: 'AI Interfaces',
    postedAt: '2026-09-29T14:30:00Z',
    isActive: true,
    viewCount: 289,
    applyCount: 42,
    recruiterId: 'usr_recruiter_sarah',
    tags: ['AI/ML', 'Full-Stack', 'React', 'Generative AI']
  },
  {
    id: 'job_airbnb_intern_03',
    title: 'Mobile Engineering Intern (Summer 2026)',
    company: 'Airbnb',
    companyLogo: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=120&auto=format&fit=crop&q=80',
    companyWebsite: 'https://airbnb.com',
    description: 'Are you an aspiring mobile developer eager to build world-class travel apps? As an Airbnb Mobile Engineering Intern, you will work side-by-side with senior mentors on features shipped directly to millions of global travelers and hosts.',
    shortDescription: '12-week paid summer internship working directly on production iOS & Android travel experiences.',
    requirements: [
      'Currently enrolled in a Bachelor’s or Master’s in Computer Science or related degree',
      'Knowledge of object-oriented programming (Dart, Kotlin, Swift, or TypeScript)',
      'Hands-on experience with mobile UI frameworks (Flutter, React Native, iOS, or Android)',
      'Eager to learn, collaborate in agile teams, and write clean readable code'
    ],
    responsibilities: [
      'Implement customer-facing UI components following Airbnb Design System guidelines',
      'Write comprehensive unit and snapshot tests for your pull requests',
      'Present your summer project to the entire engineering team at demo day'
    ],
    skills: ['Flutter', 'React Native', 'Dart', 'Git', 'Unit Testing'],
    experienceLevel: 'intern',
    jobType: 'Internship',
    location: 'San Francisco, CA',
    isRemote: false,
    minSalary: 55,
    maxSalary: 65,
    currency: 'USD',
    industry: 'Travel & Hospitality',
    department: 'Guest Experience Mobile',
    postedAt: '2026-09-25T09:00:00Z',
    isActive: true,
    viewCount: 410,
    applyCount: 88,
    recruiterId: 'usr_recruiter_sarah',
    tags: ['Internship', 'Mobile', 'Mentorship', 'Students']
  },
  {
    id: 'job_datadog_04',
    title: 'Cloud & DevOps Platform Engineer',
    company: 'Datadog',
    companyLogo: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=120&auto=format&fit=crop&q=80',
    companyWebsite: 'https://datadoghq.com',
    description: 'Help build and scale our multi-region Kubernetes infrastructure. You will design automated CI/CD pipelines, optimize observability metrics, and enforce security policies across thousands of compute nodes.',
    shortDescription: 'Scale multi-cloud Kubernetes clusters and automated CI/CD pipelines for mission-critical telemetry.',
    requirements: [
      '3+ years experience with Kubernetes, Docker, and Linux systems administration',
      'Proficiency in Golang, Python, or TypeScript for infrastructure automation',
      'Hands-on experience with AWS, Google Cloud (GCP), or Azure',
      'Experience with Terraform, GitHub Actions, and Prometheus monitoring'
    ],
    responsibilities: [
      'Manage and enhance container orchestration across global cloud regions',
      'Automate deployment pipelines and disaster recovery drills',
      'Partner with application teams to eliminate infrastructure bottlenecks'
    ],
    skills: ['Kubernetes', 'Docker', 'AWS', 'Linux', 'CI/CD Pipelines', 'Golang', 'Git'],
    experienceLevel: 'midLevel',
    jobType: 'Full-time',
    location: 'New York, NY',
    isRemote: true,
    minSalary: 155000,
    maxSalary: 205000,
    currency: 'USD',
    industry: 'DevOps & Observability',
    department: 'Platform Engineering',
    postedAt: '2026-09-27T11:15:00Z',
    isActive: true,
    viewCount: 165,
    applyCount: 24,
    recruiterId: 'usr_recruiter_sarah',
    tags: ['DevOps', 'Kubernetes', 'Cloud', 'Remote']
  },
  {
    id: 'job_uber_05',
    title: 'Frontend Platform Engineer (React & TypeScript)',
    company: 'Uber',
    companyLogo: 'https://images.unsplash.com/photo-1549923746-c502d488b3ea?w=120&auto=format&fit=crop&q=80',
    companyWebsite: 'https://uber.com',
    description: 'Join Uber’s Web Platform group. We build the core React architecture, design systems, and developer tooling used by hundreds of web developers across Uber Eats, Freight, and Mobility.',
    shortDescription: 'Architect high-speed web apps, shared component libraries, and performance tooling for Uber Web.',
    requirements: [
      '4+ years of professional React and TypeScript development experience',
      'Deep knowledge of web performance (Core Web Vitals, SSR, bundle chunking)',
      'Experience building accessible, reusable design systems (Tailwind CSS, CSS-in-JS)',
      'Strong communication skills and passion for engineering developer experience'
    ],
    responsibilities: [
      'Develop modular component primitives used across all web surfaces at Uber',
      'Profile and optimize page load speeds, memory leaks, and render cycles',
      'Mentor junior engineers and conduct technical design reviews'
    ],
    skills: ['React', 'TypeScript', 'Tailwind CSS', 'Next.js', 'Performance Optimization', 'Git'],
    experienceLevel: 'senior',
    jobType: 'Full-time',
    location: 'Seattle, WA',
    isRemote: true,
    minSalary: 165000,
    maxSalary: 220000,
    currency: 'USD',
    industry: 'Mobility & Delivery',
    department: 'Web Infrastructure',
    postedAt: '2026-09-26T16:00:00Z',
    isActive: true,
    viewCount: 230,
    applyCount: 31,
    recruiterId: 'usr_recruiter_sarah',
    tags: ['Frontend', 'React', 'TypeScript', 'Design Systems']
  },
  {
    id: 'job_openai_intern_06',
    title: 'Software Engineering Intern - Developer APIs',
    company: 'OpenAI',
    companyLogo: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=120&auto=format&fit=crop&q=80',
    companyWebsite: 'https://openai.com',
    description: 'Work on the APIs and SDKs that millions of developers use to build with frontier AI. You will build client libraries, sample applications, and developer telemetry pipelines.',
    shortDescription: '12-week internship crafting developer experiences, SDKs, and tooling for frontier AI APIs.',
    requirements: [
      'Enrolled in BS/MS Computer Science or graduating within 12 months',
      'Proficiency in at least one modern language: TypeScript, Python, or Go',
      'Understanding of REST APIs, streaming responses, and data serialization',
      'Strong problem solving and curious, experimental mindset'
    ],
    responsibilities: [
      'Contribute to open-source developer SDKs and developer documentation examples',
      'Design interactive web demos showcasing new model capabilities',
      'Collaborate with API infrastructure engineers on test coverage and benchmark latency'
    ],
    skills: ['TypeScript', 'Python', 'REST APIs', 'Git', 'Generative AI'],
    experienceLevel: 'intern',
    jobType: 'Internship',
    location: 'San Francisco, CA',
    isRemote: true,
    minSalary: 60,
    maxSalary: 75,
    currency: 'USD',
    industry: 'Artificial Intelligence',
    department: 'Developer Experience',
    postedAt: '2026-09-24T08:00:00Z',
    isActive: true,
    viewCount: 620,
    applyCount: 145,
    recruiterId: 'usr_recruiter_sarah',
    tags: ['Internship', 'OpenAI', 'Developer APIs', 'Remote']
  }
];

// Empty lists for fresh candidate account
export const initialApplications: JobApplicationModel[] = [];
export const initialResumes: ResumeModel[] = [];
export const initialNotifications: NotificationModel[] = [];
export const initialAnalysis: ResumeAnalysisModel | null = null;

export const roleSkillBenchmarks: Record<string, string[]> = {
  'Senior Flutter Developer': [
    'Flutter', 'Dart', 'State Management', 'REST APIs', 'Firebase',
    'Unit Testing', 'CI/CD Pipelines', 'Git', 'Agile & Scrum'
  ],
  'AI Full-Stack Systems Engineer': [
    'React', 'TypeScript', 'Node.js', 'Python', 'PostgreSQL',
    'Generative AI', 'Docker', 'REST APIs', 'Git'
  ],
  'Mobile Engineering Intern': [
    'Flutter', 'React Native', 'Dart', 'Git', 'Unit Testing', 'TypeScript'
  ],
  'Cloud & DevOps Platform Engineer': [
    'Kubernetes', 'Docker', 'AWS', 'Linux', 'CI/CD Pipelines', 'Golang', 'Git'
  ],
  'Frontend Platform Engineer': [
    'React', 'TypeScript', 'Tailwind CSS', 'Next.js', 'Performance Optimization', 'Git'
  ]
};

export const interviewQuestions = [
  {
    id: 'q1',
    category: 'System Design & State Management',
    difficulty: 'Advanced',
    question: 'How do you architect state management in a large-scale application to avoid unnecessary re-renders?',
    answer: `Situation: In high-throughput mobile/web applications, global state updates can trigger cascading re-renders that hurt frame rates.\n\nTask: Separate UI presentation from business logic and isolate widget rebuild scopes.\n\nAction: Implement scoped reactive state controllers (e.g., Riverpod, Bloc, or Redux Toolkit). Use selectors to ensure components only subscribe to the minimal required slices of state. Decouple long-running network operations with streaming observables.\n\nResult: Sustained steady 60-120 FPS animations, eliminating redundant rendering cycles by over 40%.`
  },
  {
    id: 'q2',
    category: 'Performance Tuning',
    difficulty: 'Medium',
    question: 'Describe how you diagnose and eliminate memory leaks or jank in mobile and frontend apps.',
    answer: `Situation: Encountering memory build-up and frame drops during heavy list scrolling and image caching.\n\nTask: Identify leaking listeners, unreleased stream subscriptions, and uncompressed asset footprints.\n\nAction: Profile with Chrome DevTools Memory Inspector / Flutter DevTools Allocation Tracer. Explicitly cancel stream subscriptions and timer instances in lifecycle disposal hooks. Apply virtualization for lists (e.g. ListView.builder or virtualized windowing) and implement disk-backed image caching.\n\nResult: Decreased resident memory consumption by 35% and achieved smooth 60fps scrolling across low-tier devices.`
  },
  {
    id: 'q3',
    category: 'Behavioral & Leadership',
    difficulty: 'General',
    question: 'Tell me about a time you had to push back on a product feature deadline due to technical debt or security.',
    answer: `Situation: Product management requested an urgent launch with unhashed sensitive local credentials and skipped automated tests.\n\nTask: Protect user security and codebase stability without blocking business milestones.\n\nAction: I presented a threat model demonstrating potential credential leaks. I proposed a phased compromise: release a minimal viable feature set protected by encrypted secure storage on day 1, while automating end-to-end integration tests over the subsequent 48-hour sprint.\n\nResult: The release occurred on schedule with zero critical vulnerabilities and 90%+ regression test coverage.`
  },
  {
    id: 'q4',
    category: 'Cloud & API Architecture',
    difficulty: 'Advanced',
    question: 'How do you design offline-first synchronization with conflict resolution?',
    answer: `Situation: Users frequently enter low-connectivity or airplane mode environments and expect uninterrupted app functionality.\n\nTask: Maintain a responsive local database cache and synchronize state with cloud servers once reconnected.\n\nAction: Store transactional mutations locally in an event queue using SQLite / IndexedDB with timestamped UUIDs. When network connectivity restores, dispatch idempotently via optimistic UI patterns. Resolve conflicts with server-authoritative timestamps or vector clocks for collaborative edits.\n\nResult: Ensured seamless zero-data-loss user experience even through intermittent network drops.`
  }
];

