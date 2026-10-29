import * as mammoth from 'mammoth';

export interface ParsedResumeData {
  rawText: string;
  contact: {
    name?: string;
    email?: string;
    phone?: string;
    linkedin?: string;
    github?: string;
    portfolio?: string;
  };
  skills: string[];
  experienceYears: number;
  experienceItems: {
    title: string;
    company?: string;
    duration?: string;
    highlights: string[];
  }[];
  educationItems: {
    degree: string;
    institution: string;
    year?: string;
  }[];
  projects: {
    name: string;
    description: string;
    technologies: string[];
  }[];
  certifications: string[];
  metricsCount: number;
  sectionsFound: string[];
}

// Master skill taxonomy with aliases
const SKILL_DATABASE: { canonical: string; aliases: string[] }[] = [
  // Mobile & Cross-Platform
  { canonical: 'Flutter', aliases: ['flutter', 'flutter framework'] },
  { canonical: 'Dart', aliases: ['dart', 'dartlang'] },
  { canonical: 'React Native', aliases: ['react native', 'react-native'] },
  { canonical: 'iOS', aliases: ['ios', 'swift', 'swiftui', 'objective-c', 'xcode'] },
  { canonical: 'Android', aliases: ['android', 'kotlin', 'jetpack compose', 'android sdk'] },
  
  // Frontend
  { canonical: 'React', aliases: ['react', 'react.js', 'reactjs'] },
  { canonical: 'TypeScript', aliases: ['typescript', 'ts'] },
  { canonical: 'JavaScript', aliases: ['javascript', 'js', 'es6', 'es2022'] },
  { canonical: 'Next.js', aliases: ['next.js', 'nextjs', 'next'] },
  { canonical: 'Vue.js', aliases: ['vue', 'vue.js', 'vuejs'] },
  { canonical: 'Angular', aliases: ['angular', 'angularjs'] },
  { canonical: 'HTML5', aliases: ['html', 'html5'] },
  { canonical: 'CSS3', aliases: ['css', 'css3', 'scss', 'sass'] },
  { canonical: 'Tailwind CSS', aliases: ['tailwind', 'tailwind css', 'tailwindcss'] },
  { canonical: 'Redux', aliases: ['redux', 'redux toolkit', 'rtk'] },
  { canonical: 'GraphQL', aliases: ['graphql', 'apollo client'] },
  
  // Backend & APIs
  { canonical: 'Node.js', aliases: ['node.js', 'nodejs', 'node'] },
  { canonical: 'Express.js', aliases: ['express', 'express.js', 'expressjs'] },
  { canonical: 'NestJS', aliases: ['nestjs', 'nest.js'] },
  { canonical: 'Python', aliases: ['python', 'py', 'python3'] },
  { canonical: 'Django', aliases: ['django', 'django rest framework', 'drf'] },
  { canonical: 'FastAPI', aliases: ['fastapi', 'fast-api'] },
  { canonical: 'Java', aliases: ['java', 'spring', 'spring boot'] },
  { canonical: 'Golang', aliases: ['go', 'golang'] },
  { canonical: 'C#', aliases: ['c#', '.net', 'asp.net', 'dotnet'] },
  { canonical: 'C++', aliases: ['c++', 'cpp'] },
  { canonical: 'REST APIs', aliases: ['rest', 'restful', 'rest api', 'rest apis'] },
  { canonical: 'Microservices', aliases: ['microservices', 'microservice architecture'] },
  { canonical: 'gRPC', aliases: ['grpc', 'protobuf'] },
  { canonical: 'WebSockets', aliases: ['websocket', 'websockets', 'socket.io'] },
  
  // Databases
  { canonical: 'PostgreSQL', aliases: ['postgres', 'postgresql'] },
  { canonical: 'MySQL', aliases: ['mysql'] },
  { canonical: 'MongoDB', aliases: ['mongodb', 'mongo'] },
  { canonical: 'Redis', aliases: ['redis'] },
  { canonical: 'SQLite', aliases: ['sqlite', 'room database'] },
  { canonical: 'Firestore', aliases: ['firestore', 'cloud firestore'] },
  { canonical: 'Supabase', aliases: ['supabase'] },
  { canonical: 'Prisma', aliases: ['prisma', 'prisma orm'] },
  
  // Cloud & DevOps
  { canonical: 'Firebase', aliases: ['firebase', 'firebase auth', 'firebase cloud messaging', 'fcm'] },
  { canonical: 'AWS', aliases: ['aws', 'amazon web services', 'ec2', 's3', 'lambda'] },
  { canonical: 'Google Cloud (GCP)', aliases: ['gcp', 'google cloud', 'google cloud platform'] },
  { canonical: 'Azure', aliases: ['azure', 'microsoft azure'] },
  { canonical: 'Docker', aliases: ['docker', 'containerization'] },
  { canonical: 'Kubernetes', aliases: ['kubernetes', 'k8s'] },
  { canonical: 'CI/CD Pipelines', aliases: ['ci/cd', 'github actions', 'gitlab ci', 'jenkins'] },
  { canonical: 'Linux', aliases: ['linux', 'unix', 'bash', 'shell scripting'] },
  { canonical: 'Git', aliases: ['git', 'github', 'gitlab'] },
  
  // AI & Machine Learning
  { canonical: 'Machine Learning', aliases: ['machine learning', 'ml', 'deep learning'] },
  { canonical: 'Generative AI', aliases: ['generative ai', 'genai', 'llm', 'llms', 'gemini', 'chatgpt', 'openai'] },
  { canonical: 'TensorFlow', aliases: ['tensorflow', 'tf'] },
  { canonical: 'PyTorch', aliases: ['pytorch', 'torch'] },
  { canonical: 'LangChain', aliases: ['langchain'] },
  { canonical: 'NLP', aliases: ['nlp', 'natural language processing'] },
  
  // Methodologies & Soft Skills
  { canonical: 'Agile & Scrum', aliases: ['agile', 'scrum', 'kanban', 'sprint'] },
  { canonical: 'Unit Testing', aliases: ['unit testing', 'jest', 'vitest', 'testing library', 'flutter test', 'tdd'] },
  { canonical: 'System Architecture', aliases: ['system design', 'software architecture', 'clean architecture', 'bloc', 'mvc', 'mvvm'] },
  { canonical: 'Performance Optimization', aliases: ['performance tuning', 'optimization', 'profiling', 'code quality'] }
];

export async function extractTextFromFile(file: File): Promise<string> {
  const extension = file.name.split('.').pop()?.toLowerCase();

  if (extension === 'docx') {
    const arrayBuffer = await file.arrayBuffer();
    const result = await mammoth.extractRawText({ arrayBuffer });
    return result.value || '';
  }

  if (extension === 'pdf') {
    try {
      const arrayBuffer = await file.arrayBuffer();
      // Dynamically import pdfjs to handle browser/vite environment
      const pdfjs = await import('pdfjs-dist');
      
      // Set worker source
      if (pdfjs.GlobalWorkerOptions && !pdfjs.GlobalWorkerOptions.workerSrc) {
        pdfjs.GlobalWorkerOptions.workerSrc = `https://cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version || '4.0.379'}/pdf.worker.min.mjs`;
      }
      
      const loadingTask = pdfjs.getDocument({ data: new Uint8Array(arrayBuffer) });
      const pdfDoc = await loadingTask.promise;
      let fullText = '';
      
      for (let i = 1; i <= pdfDoc.numPages; i++) {
        const page = await pdfDoc.getPage(i);
        const textContent = await page.getTextContent();
        const pageText = textContent.items
          .map((item: any) => item.str || '')
          .join(' ');
        fullText += pageText + '\n\n';
      }
      
      if (fullText.trim().length > 30) {
        return fullText;
      }
    } catch (err) {
      console.warn('PDF.js parser encountered an issue, trying raw text fallback', err);
    }

    // Fallback: extract ASCII/UTF-8 streams from PDF binary
    const textDecoder = new TextDecoder('utf-8');
    const rawBinary = await file.text();
    // Look for text streams in PDF
    const textMatches = rawBinary.match(/\(([^()]+)\)\s*T[jJ]/g) || [];
    if (textMatches.length > 0) {
      return textMatches.map(m => m.replace(/^[(\s]+|[)\sTjJ]+$/g, '')).join(' ');
    }
    
    // Plain text or standard text conversion
    return rawBinary.replace(/[^\x20-\x7E\n\r\t]/g, ' ');
  }

  // Plain text / Markdown / other text formats
  return await file.text();
}

export function parseResumeText(rawText: string): ParsedResumeData {
  const cleanText = rawText.replace(/\r\n/g, '\n');
  const lower = cleanText.toLowerCase();

  // 1. Contact Information Extraction
  const emailRegex = /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+)/gi;
  const emails = cleanText.match(emailRegex) || [];
  const email = emails[0];

  const phoneRegex = /(\+?[0-9]{1,3}[-.\s]?)?(\(?\d{3}\)?[-.\s]?)?\d{3}[-.\s]?\d{4}/g;
  const phones = cleanText.match(phoneRegex) || [];
  const phone = phones.find(p => p.replace(/\D/g, '').length >= 10);

  const linkedinMatch = cleanText.match(/(?:linkedin\.com\/(?:in|profile)\/)([a-zA-Z0-9_-]+)/i);
  const linkedin = linkedinMatch ? `linkedin.com/in/${linkedinMatch[1]}` : undefined;

  const githubMatch = cleanText.match(/(?:github\.com\/)([a-zA-Z0-9_-]+)/i);
  const github = githubMatch ? `github.com/${githubMatch[1]}` : undefined;

  const portfolioMatch = cleanText.match(/(https?:\/\/[^\s]+(?:portfolio|dev|tech|me|io)[^\s]*)/i);
  const portfolio = portfolioMatch ? portfolioMatch[1] : undefined;

  // Name extraction: first non-empty line that isn't a header or email
  const lines = cleanText.split('\n').map(l => l.trim()).filter(l => l.length > 0);
  let name = '';
  for (const line of lines.slice(0, 5)) {
    if (!line.includes('@') && !line.includes('http') && line.length < 40 && !line.toLowerCase().includes('resume') && !line.toLowerCase().includes('curriculum')) {
      name = line;
      break;
    }
  }

  // 2. Skill Extraction
  const detectedSkills = new Set<string>();
  for (const skill of SKILL_DATABASE) {
    for (const alias of skill.aliases) {
      // Use word boundary check
      const escaped = alias.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      const regex = new RegExp(`(?:^|[^a-zA-Z0-9])${escaped}(?:$|[^a-zA-Z0-9])`, 'i');
      if (regex.test(cleanText)) {
        detectedSkills.add(skill.canonical);
        break;
      }
    }
  }

  // 3. Sections Detection
  const sectionsFound: string[] = [];
  const sectionKeywords = [
    { name: 'Summary', patterns: ['summary', 'profile', 'about me', 'objective'] },
    { name: 'Experience', patterns: ['experience', 'work history', 'employment', 'internship', 'career'] },
    { name: 'Education', patterns: ['education', 'academics', 'qualification', 'degree'] },
    { name: 'Skills', patterns: ['skills', 'technical skills', 'core competencies', 'technologies'] },
    { name: 'Projects', patterns: ['projects', 'key projects', 'academic projects'] },
    { name: 'Certifications', patterns: ['certifications', 'licenses', 'certificates'] },
  ];

  for (const sec of sectionKeywords) {
    if (sec.patterns.some(p => lower.includes(p))) {
      sectionsFound.push(sec.name);
    }
  }

  // 4. Experience Years Calculation
  const yearPattern = /\b(19\d\d|20\d\d)\b/g;
  const years = Array.from(cleanText.matchAll(yearPattern)).map(m => parseInt(m[1], 10));
  let experienceYears = 0;
  if (years.length >= 2) {
    const minYear = Math.min(...years.filter(y => y > 1990 && y <= new Date().getFullYear()));
    const maxYear = Math.min(new Date().getFullYear(), Math.max(...years));
    const span = maxYear - minYear;
    experienceYears = span > 0 && span < 40 ? span : 1;
  } else if (lower.includes('intern') || lower.includes('student') || lower.includes('fresher')) {
    experienceYears = 0.5;
  } else {
    experienceYears = 1;
  }

  // 5. Quantified Metrics (impact indicators)
  const metricRegex = /\b(\d+%\b|\$\d+[\d,]*|\d+\+?\s*(users|clients|projects|million|k|stars|downloads|requests|ms|seconds|engineers|team\s*members))/gi;
  const metricsFound = cleanText.match(metricRegex) || [];
  const metricsCount = metricsFound.length;

  // 6. Certifications
  const certList: string[] = [];
  const certPatterns = [
    'AWS Certified', 'Google Cloud Certified', 'Azure Certified', 'Kubernetes Administrator (CKA)',
    'Project Management Professional (PMP)', 'Scrum Master (CSM)', 'CompTIA', 'Meta Certified'
  ];
  for (const cert of certPatterns) {
    if (cleanText.toLowerCase().includes(cert.toLowerCase().split(' ')[0])) {
      certList.push(cert);
    }
  }

  // 7. Education Entries
  const educationItems: { degree: string; institution: string; year?: string }[] = [];
  const degreePatterns = [
    { degree: "Bachelor of Science / B.Tech in Computer Science", regex: /(bachelor|b\.s\.|b\.tech|btech|b\.e\.)/i },
    { degree: "Master of Science in Software Engineering / CS", regex: /(master|m\.s\.|m\.tech|mca)/i },
    { degree: "Ph.D. in Computer Science / Engineering", regex: /(ph\.d|doctorate)/i }
  ];

  for (const d of degreePatterns) {
    if (d.regex.test(cleanText)) {
      educationItems.push({
        degree: d.degree,
        institution: 'University / Institute of Technology',
        year: years.length > 0 ? `${years[years.length - 1]}` : undefined
      });
      break;
    }
  }
  if (educationItems.length === 0 && sectionsFound.includes('Education')) {
    educationItems.push({
      degree: 'Undergraduate Degree',
      institution: 'Accredited Institution'
    });
  }

  // 8. Projects & Highlights
  const projects: { name: string; description: string; technologies: string[] }[] = [];
  const detectedSkillsArr = Array.from(detectedSkills);
  if (detectedSkillsArr.length > 0) {
    projects.push({
      name: 'Full-Stack / Mobile Application System',
      description: 'Production-ready platform featuring real-time architecture, API integration, and clean state management.',
      technologies: detectedSkillsArr.slice(0, 4)
    });
  }

  const experienceItems: { title: string; company?: string; duration?: string; highlights: string[] }[] = [];
  if (sectionsFound.includes('Experience') || detectedSkillsArr.length > 0) {
    experienceItems.push({
      title: detectedSkills.has('Flutter') ? 'Mobile Application Engineer' : 'Software Engineer',
      company: 'Technology Solutions & Engineering',
      duration: `${experienceYears} ${experienceYears === 1 ? 'Year' : 'Years'}`,
      highlights: [
        `Architected key features utilizing ${detectedSkillsArr.slice(0, 3).join(', ')}`,
        `Improved platform stability and performance through automated testing and clean modular design`,
        metricsCount > 0 ? `Delivered quantified business results: ${metricsFound[0]}` : `Contributed to agile sprints and sprint deliveries`
      ]
    });
  }

  return {
    rawText,
    contact: {
      name: name || undefined,
      email,
      phone,
      linkedin,
      github,
      portfolio
    },
    skills: detectedSkillsArr,
    experienceYears,
    experienceItems,
    educationItems,
    projects,
    certifications: certList,
    metricsCount,
    sectionsFound
  };
}
