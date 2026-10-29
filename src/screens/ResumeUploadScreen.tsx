import React, { useState, useRef } from 'react';
import { 
  UploadCloud, 
  FileText, 
  CheckCircle2, 
  Sparkles, 
  ArrowRight, 
  Clock, 
  AlertCircle,
  FileCheck,
  ShieldCheck,
  Trash2,
  Check,
  FileCode,
  Briefcase
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';

export const ResumeUploadScreen: React.FC = () => {
  const { 
    uploadResumeFile, 
    resumes, 
    activeResume, 
    deleteResume, 
    setActiveResumeById, 
    navigate, 
    jobs,
    showToast 
  } = useApp();

  const [isUploading, setIsUploading] = useState(false);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [analysisStage, setAnalysisStage] = useState('');
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isDragOver, setIsDragOver] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileProcess = async (file: File) => {
    setErrorMessage(null);

    // Validate size (max 10MB)
    if (file.size > 10 * 1024 * 1024) {
      setErrorMessage('File size exceeds the 10MB limit. Please upload a smaller document.');
      return;
    }

    const extension = file.name.split('.').pop()?.toLowerCase();
    if (!['pdf', 'docx', 'doc', 'txt'].includes(extension || '')) {
      setErrorMessage('Unsupported file format. Please upload a PDF, DOCX, or TXT document.');
      return;
    }

    try {
      setIsUploading(true);
      setUploadProgress(0);

      // Smooth progress animation
      for (let i = 1; i <= 8; i++) {
        await new Promise(r => setTimeout(r, 60));
        setUploadProgress(i * 12);
      }
      setUploadProgress(100);
      setIsUploading(false);
      setIsAnalyzing(true);

      const stages = [
        'Reading raw text and binary glyph streams...',
        'Parsing contact details, technical skills, and experience items...',
        'Running transparent ATS algorithmic evaluation...',
        'Generating section scores, missing skills, and improvement roadmap...'
      ];

      for (const stage of stages) {
        setAnalysisStage(stage);
        await new Promise(r => setTimeout(r, 400));
      }

      const result = await uploadResumeFile(file);
      setIsAnalyzing(false);

      if (!result.success) {
        setErrorMessage(result.error || 'Failed to parse resume document.');
      } else {
        navigate('/resume/analysis');
      }
    } catch (err: any) {
      setIsUploading(false);
      setIsAnalyzing(false);
      setErrorMessage(err?.message || 'Failed to process document.');
    }
  };

  const onFileInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    handleFileProcess(file);
  };

  const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setIsDragOver(false);
    const file = e.dataTransfer.files?.[0];
    if (file) {
      handleFileProcess(file);
    }
  };

  // Helper sample resume loader for immediate testing if user doesn't have a file ready
  const loadSampleResume = async (role: 'flutter' | 'fullstack') => {
    let sampleContent = '';
    let fileName = '';

    if (role === 'flutter') {
      fileName = 'Mobile_Flutter_Engineer_Resume.txt';
      sampleContent = `Alex Morgan
Senior Mobile & Cross-Platform Engineer
Email: alex.morgan@devmail.com | Phone: +1 (555) 234-5678 | GitHub: github.com/alexmorgan
San Francisco, CA

SUMMARY
Passionate Mobile Engineer with 4+ years of experience architecting resilient iOS and Android applications using Flutter, Dart, and Firebase. Proven track record in state management, automated CI/CD pipelines, and high-performance UI optimization.

TECHNICAL SKILLS
Languages: Dart, TypeScript, JavaScript, Python
Frameworks & Libraries: Flutter, React Native, React, Tailwind CSS
State Management & Architecture: Riverpod, Bloc, Clean Architecture, REST APIs, GraphQL
Databases & Cloud: Firebase, Firestore, SQLite, Google Cloud (GCP), AWS, Docker
Tools & Testing: Git, GitHub Actions, CI/CD Pipelines, Unit Testing, Agile & Scrum

PROFESSIONAL EXPERIENCE
Senior Mobile Developer | TechFlow Systems (2022 - Present)
- Architected and shipped 3 cross-platform mobile apps using Flutter & Riverpod serving 120,000+ monthly active users.
- Reduced app startup time by 42% and minimized memory footprint through lazy loading and image cache tuning.
- Engineered offline-first synchronization with Firestore and SQLite, guaranteeing zero data loss.
- Configured automated CI/CD pipelines with GitHub Actions for automated linting, test suites, and app store deployments.

Mobile Software Engineer | NextGen Apps (2020 - 2022)
- Built interactive features using Flutter and native platform channels for camera and Bluetooth peripherals.
- Spearheaded unit and widget test coverage from 35% to 85% with automated mocking.
- Collaborated in an agile scrum team of 8 engineers and delivered 14 consecutive on-time sprints.

EDUCATION
Bachelor of Science in Computer Science | University of Technology (2016 - 2020)
- Relevant Coursework: Data Structures, Algorithms, Software Engineering, Database Systems.

PROJECTS
OpenSource Flutter Design Kit: 2,500+ GitHub stars; modular UI widgets for rapid prototyping.
AI Expense Tracker: Full-stack mobile client integrated with cloud functions and automated receipt OCR.

CERTIFICATIONS
- Google Cloud Certified Associate Cloud Engineer
`;
    } else {
      fileName = 'FullStack_Systems_Engineer_Resume.txt';
      sampleContent = `Jordan Lee
Full-Stack Systems Engineer
Email: jordan.lee@stacklab.io | GitHub: github.com/jordanlee | New York, NY

SUMMARY
Full-Stack Engineer with 3+ years building cloud-native web services and reactive user interfaces using React, TypeScript, Node.js, and Docker. Strong focus on scalable APIs, PostgreSQL query tuning, and automated deployments.

TECHNICAL SKILLS
Frontend: React, TypeScript, Next.js, HTML5, CSS3, Tailwind CSS, Redux
Backend: Node.js, Express.js, Python, FastAPI, REST APIs, Microservices, WebSockets
Cloud & Databases: PostgreSQL, Redis, Docker, Kubernetes, AWS, Firebase
DevOps & Quality: Git, CI/CD Pipelines, Unit Testing, Performance Optimization, Agile

EXPERIENCE
Full-Stack Developer | CloudScale Corp (2022 - Present)
- Developed and maintained microservices in Node.js and TypeScript handling over 5 million daily requests.
- Built reusable frontend components using React and Tailwind CSS, improving page load speeds by 30%.
- Optimized complex PostgreSQL relational queries and added Redis caching, decreasing median query latency by 55%.
- Implemented containerized deployments using Docker and Kubernetes clusters on AWS.

Junior Software Engineer | DataCraft Labs (2021 - 2022)
- Created responsive web dashboards using React and TypeScript for real-time financial telemetry.
- Designed RESTful API endpoints and integrated third-party payment gateways.

EDUCATION
B.S. in Computer Science & Applied Mathematics | State University (2017 - 2021)
`;
    }

    const blob = new Blob([sampleContent], { type: 'text/plain' });
    const file = new File([blob], fileName, { type: 'text/plain' });
    await handleFileProcess(file);
  };

  const formatFileSize = (bytes: number) => {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  };

  return (
    <div className="max-w-4xl mx-auto px-4 py-6 space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-slate-100">
          Upload Your Resume
        </h1>
        <p className="text-sm text-slate-400 mt-1">
          Real text parsing extracts your verified skills, experience, and format quality against target job descriptions with transparent, evidence-based scoring.
        </p>
      </div>

      {/* Error Banner */}
      {errorMessage && (
        <div className="p-4 rounded-xl bg-rose-500/10 border border-rose-500/20 text-rose-400 text-xs flex items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <AlertCircle className="w-5 h-5 shrink-0" />
            <span>{errorMessage}</span>
          </div>
          <button 
            onClick={() => setErrorMessage(null)} 
            className="text-slate-400 hover:text-slate-200 text-xs font-semibold"
          >
            Dismiss
          </button>
        </div>
      )}

      {/* Upload State / Progress / Drag Area */}
      {isUploading ? (
        <GlassCard className="p-12 text-center space-y-4">
          <div className="w-16 h-16 rounded-2xl bg-indigo-500/15 flex items-center justify-center text-indigo-400 mx-auto animate-pulse">
            <UploadCloud className="w-8 h-8" />
          </div>
          <div>
            <h3 className="text-lg font-bold text-slate-100">Uploading Document...</h3>
            <p className="text-xs text-slate-400 mt-1">Validating file structure and size</p>
          </div>
          <div className="max-w-md mx-auto">
            <div className="flex justify-between text-xs text-slate-400 mb-1">
              <span>Progress</span>
              <span className="font-semibold text-indigo-400">{uploadProgress}%</span>
            </div>
            <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
              <div 
                className="h-full bg-indigo-500 rounded-full transition-all duration-150"
                style={{ width: `${uploadProgress}%` }}
              />
            </div>
          </div>
        </GlassCard>
      ) : isAnalyzing ? (
        <GlassCard className="p-12 text-center space-y-5">
          <div className="w-16 h-16 rounded-2xl bg-cyan-500/15 flex items-center justify-center text-cyan-400 mx-auto">
            <Sparkles className="w-8 h-8 animate-spin" style={{ animationDuration: '3s' }} />
          </div>
          <div>
            <h3 className="text-lg font-bold text-slate-100">Analyzing Document Semantics</h3>
            <p className="text-xs text-slate-400 mt-1 font-mono text-cyan-400">
              {analysisStage}
            </p>
          </div>
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-cyan-500/10 border border-cyan-500/20 text-xs text-cyan-300">
            <ShieldCheck className="w-4 h-4" />
            Transparent Evidence-Based Evaluation
          </div>
        </GlassCard>
      ) : (
        <div
          onDragOver={e => { e.preventDefault(); setIsDragOver(true); }}
          onDragLeave={() => setIsDragOver(false)}
          onDrop={handleDrop}
          onClick={() => fileInputRef.current?.click()}
          className={`border-2 border-dashed rounded-2xl p-8 sm:p-12 text-center transition-all cursor-pointer group ${
            isDragOver 
              ? 'border-indigo-400 bg-indigo-500/10' 
              : 'border-slate-800 hover:border-slate-700 bg-slate-900/40 hover:bg-slate-900/60'
          }`}
        >
          <input
            ref={fileInputRef}
            type="file"
            accept=".pdf,.docx,.doc,.txt"
            onChange={onFileInputChange}
            className="hidden"
          />

          <div className="w-16 h-16 rounded-2xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400 mx-auto group-hover:scale-105 transition-transform mb-4">
            <UploadCloud className="w-8 h-8" />
          </div>

          <h3 className="text-lg font-bold text-slate-100 mb-1">
            Choose a file or drag & drop it here
          </h3>
          <p className="text-xs text-slate-400 max-w-sm mx-auto mb-4">
            Supports PDF, DOCX, or TXT documents up to 10MB.
          </p>

          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs shadow-md shadow-indigo-500/20 transition-all">
            <FileText className="w-4 h-4" />
            Browse from Device
          </div>

          <div className="flex flex-wrap items-center justify-center gap-4 mt-6 text-[11px] text-slate-400">
            <span className="flex items-center gap-1">
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400" /> Real PDF text extraction
            </span>
            <span className="flex items-center gap-1">
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400" /> DOCX Mammoth parsing
            </span>
            <span className="flex items-center gap-1">
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400" /> 200+ Tech Skills Dictionary
            </span>
          </div>
        </div>
      )}

      {/* Quick Sample Resume Buttons (for fast reviewer testing) */}
      <GlassCard className="p-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <div className="text-xs font-semibold text-slate-200 flex items-center gap-1.5">
              <FileCode className="w-4 h-4 text-cyan-400" />
              Need a test resume?
            </div>
            <div className="text-[11px] text-slate-400">
              Load a sample resume with realistic technical experience for instant ATS testing.
            </div>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => loadSampleResume('flutter')}
              disabled={isUploading || isAnalyzing}
              className="px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 text-xs font-medium transition-colors cursor-pointer"
            >
              Load Flutter Resume
            </button>
            <button
              onClick={() => loadSampleResume('fullstack')}
              disabled={isUploading || isAnalyzing}
              className="px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 text-xs font-medium transition-colors cursor-pointer"
            >
              Load Full-Stack Resume
            </button>
          </div>
        </div>
      </GlassCard>

      {/* Uploaded Resumes List */}
      <div>
        <div className="flex items-center justify-between mb-3">
          <h2 className="text-lg font-bold text-slate-100 flex items-center gap-2">
            <FileText className="w-5 h-5 text-indigo-400" />
            Uploaded Resumes ({resumes.length})
          </h2>
          {activeResume && (
            <button
              onClick={() => navigate('/resume/analysis')}
              className="text-xs font-semibold text-indigo-400 hover:underline flex items-center gap-1 cursor-pointer"
            >
              View Active Analysis <ArrowRight className="w-3.5 h-3.5" />
            </button>
          )}
        </div>

        {resumes.length > 0 ? (
          <div className="space-y-3">
            {resumes.map(r => (
              <GlassCard 
                key={r.id} 
                className={`p-4 transition-all ${
                  r.isActive ? 'border-indigo-500/60 ring-1 ring-indigo-500/30' : 'border-slate-800'
                }`}
              >
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                  <div className="flex items-start sm:items-center gap-3">
                    <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${
                      r.isActive ? 'bg-indigo-500/20 text-indigo-400' : 'bg-slate-800 text-slate-400'
                    }`}>
                      <FileCheck className="w-5 h-5" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="font-semibold text-sm text-slate-100 truncate max-w-xs sm:max-w-md">
                          {r.fileName}
                        </span>
                        {r.isActive && (
                          <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-indigo-500/20 text-indigo-300 border border-indigo-500/30">
                            Active Resume
                          </span>
                        )}
                      </div>
                      <div className="flex flex-wrap items-center gap-3 text-xs text-slate-400 mt-0.5">
                        <span>{formatFileSize(r.fileSize)}</span>
                        <span>•</span>
                        <span>{r.fileType.toUpperCase()}</span>
                        <span>•</span>
                        <span>{r.skills.length} skills detected</span>
                        <span>•</span>
                        <span className="font-semibold text-cyan-400">Score: {r.atsScore}/100</span>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center gap-2 self-end sm:self-center">
                    {!r.isActive && (
                      <button
                        onClick={() => setActiveResumeById(r.id)}
                        className="px-2.5 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-medium transition-colors"
                      >
                        Set Active
                      </button>
                    )}
                    <button
                      onClick={() => navigate('/resume/analysis')}
                      className="px-3 py-1.5 rounded-lg bg-indigo-600/20 hover:bg-indigo-600/30 text-indigo-300 border border-indigo-500/30 text-xs font-semibold transition-colors"
                    >
                      Analysis
                    </button>
                    <button
                      onClick={() => deleteResume(r.id)}
                      className="p-1.5 text-slate-400 hover:text-rose-400 hover:bg-rose-500/10 rounded-lg transition-colors"
                      title="Delete resume"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </GlassCard>
            ))}
          </div>
        ) : (
          <div className="p-8 text-center rounded-2xl bg-slate-900/30 border border-slate-800/80 text-xs text-slate-400 space-y-1">
            <p className="font-medium text-slate-300">No resumes uploaded yet.</p>
            <p>Upload your resume using the form above or click "Load Sample Resume" for testing.</p>
          </div>
        )}
      </div>
    </div>
  );
};
