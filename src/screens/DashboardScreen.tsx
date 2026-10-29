import React from 'react';
import { 
  FileText, 
  Briefcase, 
  Bookmark, 
  TrendingUp, 
  CheckCircle2, 
  Sparkles, 
  ArrowRight, 
  Clock, 
  DollarSign, 
  Layers, 
  HelpCircle, 
  Eye, 
  Award,
  UploadCloud,
  ChevronRight,
  ShieldCheck
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';

export const DashboardScreen: React.FC = () => {
  const { 
    currentUser, 
    activeResume, 
    resumes, 
    applications, 
    jobs,
    navigate, 
    themeMode 
  } = useApp();

  const isDark = themeMode === 'dark';
  const hasResume = !!activeResume;
  const score = activeResume?.atsScore || 0;

  // Breakdown percentages if resume exists
  const keywordsScore = activeResume?.atsBreakdown?.Keywords || 0;
  const formattingScore = activeResume?.atsBreakdown?.Formatting || 0;
  const readabilityScore = activeResume?.atsBreakdown?.Readability || 0;
  const impactScore = activeResume?.atsBreakdown?.Impact || 0;

  // Application stats
  const pendingCount = applications.filter(a => a.status === 'pending' || a.status === 'reviewing').length;
  const interviewCount = applications.filter(a => a.status === 'interview').length;
  const offersCount = applications.filter(a => a.status === 'offered').length;
  const rejectedCount = applications.filter(a => a.status === 'rejected').length;

  return (
    <div className="max-w-6xl mx-auto px-4 py-6 space-y-6">
      {/* Header Welcome Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <p className="text-sm font-medium text-slate-400">Welcome back,</p>
          <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-slate-100 flex items-center gap-2">
            {currentUser.displayName || 'Candidate'}
            <span className={`inline-flex items-center px-2 py-0.5 rounded-full text-xs font-semibold ${
              currentUser.userType === 'recruiter' 
                ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' 
                : 'bg-indigo-500/10 text-indigo-400 border border-indigo-500/20'
            }`}>
              {currentUser.userType === 'recruiter' ? 'Hiring Recruiter' : 'Active Job Seeker'}
            </span>
          </h1>
        </div>

        <div className="flex items-center gap-3">
          {currentUser.userType === 'recruiter' ? (
            <button
              onClick={() => navigate('/admin')}
              className="px-4 py-2 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 text-white font-semibold text-sm shadow-lg shadow-emerald-500/25 hover:opacity-95 transition-all flex items-center gap-2 cursor-pointer"
            >
              <ShieldCheck className="w-4 h-4" />
              Recruiter Portal
            </button>
          ) : (
            <button
              onClick={() => navigate('/jobs/swipe')}
              className="px-4 py-2 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 text-white font-semibold text-sm shadow-lg shadow-indigo-500/25 hover:opacity-95 transition-all flex items-center gap-2 cursor-pointer"
            >
              <Sparkles className="w-4 h-4" />
              Start Discovering Jobs
            </button>
          )}
        </div>
      </div>

      {/* Quick Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-4">
        <GlassCard className="p-4 flex items-center gap-3.5">
          <div className="w-12 h-12 rounded-xl bg-indigo-500/15 flex items-center justify-center text-indigo-400 shrink-0">
            <FileText className="w-6 h-6" />
          </div>
          <div>
            <div className="text-2xl font-bold text-indigo-400">
              {hasResume ? score : '—'}
            </div>
            <div className="text-xs text-slate-400">
              {hasResume ? `ATS Score (${score >= 80 ? 'Good' : 'Moderate'})` : 'No Resume Uploaded'}
            </div>
          </div>
        </GlassCard>

        <GlassCard className="p-4 flex items-center gap-3.5">
          <div className="w-12 h-12 rounded-xl bg-cyan-500/15 flex items-center justify-center text-cyan-400 shrink-0">
            <Eye className="w-6 h-6" />
          </div>
          <div>
            <div className="text-2xl font-bold text-cyan-400">
              {currentUser.dailySwipeCount}
            </div>
            <div className="text-xs text-slate-400">Opportunities Evaluated</div>
          </div>
        </GlassCard>

        <GlassCard className="p-4 flex items-center gap-3.5">
          <div className="w-12 h-12 rounded-xl bg-amber-500/15 flex items-center justify-center text-amber-400 shrink-0">
            <Bookmark className="w-6 h-6" />
          </div>
          <div>
            <div className="text-2xl font-bold text-amber-400">{currentUser.savedJobIds.length}</div>
            <div className="text-xs text-slate-400">Saved Opportunities</div>
          </div>
        </GlassCard>

        <GlassCard className="p-4 flex items-center gap-3.5">
          <div className="w-12 h-12 rounded-xl bg-emerald-500/15 flex items-center justify-center text-emerald-400 shrink-0">
            <CheckCircle2 className="w-6 h-6" />
          </div>
          <div>
            <div className="text-2xl font-bold text-emerald-400">{applications.length}</div>
            <div className="text-xs text-slate-400">Applications Tracked</div>
          </div>
        </GlassCard>
      </div>

      {/* Recruiter Banner if recruiter persona */}
      {currentUser.userType === 'recruiter' && (
        <div className="p-4 rounded-2xl bg-gradient-to-r from-emerald-950/60 to-slate-900 border border-emerald-500/30 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-emerald-500/20 flex items-center justify-center text-emerald-400 shrink-0">
              <ShieldCheck className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-semibold text-sm text-emerald-300">Recruiter Portal Active</h3>
              <p className="text-xs text-slate-400">You can post new jobs, screen applicants, and review ATS match scores.</p>
            </div>
          </div>
          <button
            onClick={() => navigate('/admin')}
            className="px-3.5 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-semibold self-start sm:self-auto cursor-pointer"
          >
            Open Recruiter Suite
          </button>
        </div>
      )}

      {/* AI Career Tools Row */}
      <div>
        <div className="flex items-center justify-between mb-3">
          <h2 className="text-lg font-bold text-slate-100 flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-indigo-400" />
            AI Career Tools
          </h2>
          <span className="text-xs text-slate-400">Real algorithmic ATS engine</span>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          {/* Skill Gap */}
          <div
            onClick={() => navigate('/resume/skill-gap')}
            className="group cursor-pointer"
          >
            <GlassCard className="p-4 border-indigo-500/20 group-hover:border-indigo-500/50 transition-all flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-cyan-500/15 flex items-center justify-center text-cyan-400 group-hover:scale-105 transition-transform">
                  <Layers className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-semibold text-sm text-slate-100 group-hover:text-cyan-400 transition-colors">
                    Skill Gap Analysis
                  </h3>
                  <p className="text-xs text-slate-400">Match target role requirements</p>
                </div>
              </div>
              <ArrowRight className="w-4 h-4 text-slate-500 group-hover:text-cyan-400 group-hover:translate-x-1 transition-all" />
            </GlassCard>
          </div>

          {/* Interview Prep */}
          <div
            onClick={() => navigate('/resume/interview-prep')}
            className="group cursor-pointer"
          >
            <GlassCard className="p-4 border-indigo-500/20 group-hover:border-indigo-500/50 transition-all flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-indigo-500/15 flex items-center justify-center text-indigo-400 group-hover:scale-105 transition-transform">
                  <HelpCircle className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-semibold text-sm text-slate-100 group-hover:text-indigo-400 transition-colors">
                    AI Interview Prep
                  </h3>
                  <p className="text-xs text-slate-400">Interactive STAR flashcards</p>
                </div>
              </div>
              <ArrowRight className="w-4 h-4 text-slate-500 group-hover:text-indigo-400 group-hover:translate-x-1 transition-all" />
            </GlassCard>
          </div>

          {/* PDF Preview */}
          <div
            onClick={() => navigate('/resume/pdf-preview')}
            className="group cursor-pointer"
          >
            <GlassCard className="p-4 border-indigo-500/20 group-hover:border-indigo-500/50 transition-all flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-emerald-500/15 flex items-center justify-center text-emerald-400 group-hover:scale-105 transition-transform">
                  <FileText className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-semibold text-sm text-slate-100 group-hover:text-emerald-400 transition-colors">
                    ATS Resume Formatter
                  </h3>
                  <p className="text-xs text-slate-400">Clean parsed layout export</p>
                </div>
              </div>
              <ArrowRight className="w-4 h-4 text-slate-500 group-hover:text-emerald-400 group-hover:translate-x-1 transition-all" />
            </GlassCard>
          </div>
        </div>
      </div>

      {/* Main Grid: Resume Health + Application Pipeline */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Resume Health Card (5 cols) */}
        <div className="lg:col-span-5 space-y-6">
          <GlassCard className="p-5">
            <div className="flex items-center justify-between mb-4">
              <div>
                <h3 className="font-bold text-slate-100 text-base">Resume Health</h3>
                <p className="text-xs text-slate-400">Algorithmic ATS Compatibility</p>
              </div>
              <button
                onClick={() => navigate('/resume/upload')}
                className="text-xs font-semibold text-indigo-400 hover:text-indigo-300 transition-colors cursor-pointer"
              >
                {hasResume ? 'Replace' : 'Upload'}
              </button>
            </div>

            {hasResume ? (
              <>
                {/* Circular Gauge */}
                <div className="flex flex-col sm:flex-row items-center gap-6 py-2">
                  <div className="relative w-32 h-32 flex items-center justify-center shrink-0">
                    <svg className="w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                      <circle
                        cx="50"
                        cy="50"
                        r="40"
                        className="stroke-slate-800"
                        strokeWidth="10"
                        fill="transparent"
                      />
                      <circle
                        cx="50"
                        cy="50"
                        r="40"
                        className="stroke-indigo-500 transition-all duration-1000 ease-out"
                        strokeWidth="10"
                        strokeDasharray={251.2}
                        strokeDashoffset={251.2 - (251.2 * score) / 100}
                        strokeLinecap="round"
                        fill="transparent"
                      />
                    </svg>
                    <div className="absolute flex flex-col items-center justify-center text-center">
                      <span className="text-2xl font-black text-indigo-400">{score}</span>
                      <span className="text-[10px] uppercase font-bold tracking-wider text-slate-400">/ 100</span>
                    </div>
                  </div>

                  {/* Score Meters */}
                  <div className="w-full space-y-2.5">
                    <div>
                      <div className="flex justify-between text-xs mb-1">
                        <span className="text-slate-400">Required Skills</span>
                        <span className="font-semibold text-cyan-400">{keywordsScore}%</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div 
                          className="h-full bg-cyan-400 rounded-full transition-all duration-1000" 
                          style={{ width: `${keywordsScore}%` }}
                        />
                      </div>
                    </div>

                    <div>
                      <div className="flex justify-between text-xs mb-1">
                        <span className="text-slate-400">Formatting & Sections</span>
                        <span className="font-semibold text-indigo-400">{formattingScore}%</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div 
                          className="h-full bg-indigo-400 rounded-full transition-all duration-1000" 
                          style={{ width: `${formattingScore}%` }}
                        />
                      </div>
                    </div>

                    <div>
                      <div className="flex justify-between text-xs mb-1">
                        <span className="text-slate-400">Readability</span>
                        <span className="font-semibold text-emerald-400">{readabilityScore}%</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div 
                          className="h-full bg-emerald-400 rounded-full transition-all duration-1000" 
                          style={{ width: `${readabilityScore}%` }}
                        />
                      </div>
                    </div>

                    <div>
                      <div className="flex justify-between text-xs mb-1">
                        <span className="text-slate-400">Quantified Impact</span>
                        <span className="font-semibold text-amber-400">{impactScore}%</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div 
                          className="h-full bg-amber-400 rounded-full transition-all duration-1000" 
                          style={{ width: `${impactScore}%` }}
                        />
                      </div>
                    </div>
                  </div>
                </div>

                <div className="pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs text-slate-400">
                  <span className="truncate max-w-[200px]">{activeResume.fileName}</span>
                  <button
                    onClick={() => navigate('/resume/analysis')}
                    className="text-indigo-400 hover:underline font-semibold flex items-center gap-1 cursor-pointer"
                  >
                    Full Analysis <ChevronRight className="w-3.5 h-3.5" />
                  </button>
                </div>
              </>
            ) : (
              /* Meaningful Clean Empty State */
              <div className="text-center py-8 px-4 space-y-3">
                <div className="w-14 h-14 mx-auto rounded-2xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400">
                  <UploadCloud className="w-7 h-7" />
                </div>
                <h4 className="font-semibold text-slate-200 text-sm">Upload your resume to get started</h4>
                <p className="text-xs text-slate-400 max-w-xs mx-auto">
                  Our transparent ATS analyzer parses your PDF or DOCX file, extracts verified skills, and evaluates role readiness without fake numbers.
                </p>
                <button
                  onClick={() => navigate('/resume/upload')}
                  className="mt-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-500 text-white rounded-xl text-xs font-semibold shadow-md shadow-indigo-500/20 cursor-pointer"
                >
                  Upload Resume File
                </button>
              </div>
            )}
          </GlassCard>
        </div>

        {/* Right Column: Application Pipeline & Discovery (7 cols) */}
        <div className="lg:col-span-7 space-y-6">
          <GlassCard className="p-5">
            <div className="flex items-center justify-between mb-4">
              <div>
                <h3 className="font-bold text-slate-100 text-base">Application Tracker</h3>
                <p className="text-xs text-slate-400">Real-time status updates</p>
              </div>
              <button
                onClick={() => navigate('/jobs/applied')}
                className="text-xs font-semibold text-indigo-400 hover:text-indigo-300 transition-colors cursor-pointer"
              >
                View All
              </button>
            </div>

            {applications.length > 0 ? (
              <div className="space-y-3">
                {/* Pipeline Counter Pills */}
                <div className="grid grid-cols-4 gap-2 mb-3 text-center">
                  <div className="p-2 rounded-xl bg-slate-800/50 border border-slate-700/50">
                    <div className="text-base font-bold text-amber-400">{pendingCount}</div>
                    <div className="text-[10px] text-slate-400">Pending</div>
                  </div>
                  <div className="p-2 rounded-xl bg-slate-800/50 border border-slate-700/50">
                    <div className="text-base font-bold text-cyan-400">{interviewCount}</div>
                    <div className="text-[10px] text-slate-400">Interview</div>
                  </div>
                  <div className="p-2 rounded-xl bg-slate-800/50 border border-slate-700/50">
                    <div className="text-base font-bold text-emerald-400">{offersCount}</div>
                    <div className="text-[10px] text-slate-400">Offered</div>
                  </div>
                  <div className="p-2 rounded-xl bg-slate-800/50 border border-slate-700/50">
                    <div className="text-base font-bold text-slate-400">{rejectedCount}</div>
                    <div className="text-[10px] text-slate-400">Passed</div>
                  </div>
                </div>

                {applications.slice(0, 3).map(app => (
                  <div
                    key={app.id}
                    onClick={() => navigate('/jobs/applied')}
                    className="p-3 rounded-xl bg-slate-800/40 hover:bg-slate-800/70 border border-slate-700/50 flex items-center justify-between transition-colors cursor-pointer"
                  >
                    <div>
                      <div className="font-semibold text-sm text-slate-100">{app.jobTitle}</div>
                      <div className="text-xs text-slate-400">{app.companyName} • {app.location}</div>
                    </div>
                    <span className="px-2.5 py-1 rounded-full text-[11px] font-semibold uppercase tracking-wider bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
                      {app.status}
                    </span>
                  </div>
                ))}
              </div>
            ) : (
              /* Clean Empty State */
              <div className="text-center py-8 px-4 space-y-3">
                <div className="w-14 h-14 mx-auto rounded-2xl bg-cyan-500/10 border border-cyan-500/20 flex items-center justify-center text-cyan-400">
                  <Briefcase className="w-7 h-7" />
                </div>
                <h4 className="font-semibold text-slate-200 text-sm">You haven't applied to any jobs yet</h4>
                <p className="text-xs text-slate-400 max-w-sm mx-auto">
                  Browse the job catalog, check your transparent ATS compatibility match, and swipe right or submit direct applications.
                </p>
                <button
                  onClick={() => navigate('/jobs/swipe')}
                  className="mt-2 px-4 py-2 bg-gradient-to-r from-indigo-600 to-cyan-600 hover:opacity-95 text-white rounded-xl text-xs font-semibold shadow-md shadow-indigo-500/20 cursor-pointer"
                >
                  Discover Open Roles
                </button>
              </div>
            )}
          </GlassCard>

          {/* Quick Saved Jobs Card */}
          <GlassCard className="p-5">
            <div className="flex items-center justify-between mb-3">
              <div>
                <h3 className="font-bold text-slate-100 text-base">Saved Opportunities</h3>
                <p className="text-xs text-slate-400">{currentUser.savedJobIds.length} bookmarks</p>
              </div>
              <button
                onClick={() => navigate('/jobs/saved')}
                className="text-xs font-semibold text-indigo-400 hover:text-indigo-300 transition-colors cursor-pointer"
              >
                View Saved
              </button>
            </div>

            {currentUser.savedJobIds.length > 0 ? (
              <div className="space-y-2">
                {jobs.filter(j => currentUser.savedJobIds.includes(j.id)).slice(0, 2).map(job => (
                  <div
                    key={job.id}
                    onClick={() => navigate(`/jobs/details/${job.id}`)}
                    className="p-3 rounded-xl bg-slate-800/40 hover:bg-slate-800/70 border border-slate-700/50 flex items-center justify-between cursor-pointer"
                  >
                    <div>
                      <div className="font-semibold text-sm text-slate-100">{job.title}</div>
                      <div className="text-xs text-slate-400">{job.company} • {job.location}</div>
                    </div>
                    <span className="text-xs font-semibold text-indigo-400">View Details →</span>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-5 text-xs text-slate-400">
                No saved jobs yet. Tap the bookmark icon or swipe right on jobs to save them here.
              </div>
            )}
          </GlassCard>
        </div>
      </div>
    </div>
  );
};
