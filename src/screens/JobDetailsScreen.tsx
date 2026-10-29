import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Bookmark, 
  Share2, 
  MapPin, 
  Briefcase, 
  TrendingUp, 
  Home, 
  DollarSign, 
  Check, 
  Send, 
  FileText, 
  Sparkles,
  CheckCircle2,
  X
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';

export const JobDetailsScreen: React.FC = () => {
  const { 
    jobs, 
    routeParams, 
    navigate, 
    currentUser, 
    toggleSaveJob, 
    applyForJob, 
    activeResume 
  } = useApp();

  const [applyModalOpen, setApplyModalOpen] = useState(false);
  const [coverLetter, setCoverLetter] = useState('');
  const [isGeneratingAiLetter, setIsGeneratingAiLetter] = useState(false);

  const jobId = routeParams.id || 'job_1';
  const job = jobs.find(j => j.id === jobId) || jobs[0];

  const isSaved = currentUser.savedJobIds.includes(job.id);
  const isApplied = currentUser.appliedJobIds.includes(job.id);

  const formatSalary = (min?: number, max?: number, currency = 'USD') => {
    if (!min && !max) return 'Competitive compensation';
    const formatter = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency,
      maximumFractionDigits: 0
    });
    if (min && max) return `${formatter.format(min)} - ${formatter.format(max)}`;
    if (min) return `From ${formatter.format(min)}`;
    return `Up to ${formatter.format(max!)}`;
  };

  const generateAiCoverLetter = () => {
    setIsGeneratingAiLetter(true);
    setTimeout(() => {
      setCoverLetter(
        `Dear Hiring Team at ${job.company},\n\nI am writing to express my strong enthusiasm for the ${job.title} role. With over 4 years of proven software engineering experience in ${job.skills.slice(0, 3).join(', ')}, I have architected high-performance mobile and web applications serving high-scale consumer bases.\n\nMy background in state management, CI/CD automation, and clean architecture directly aligns with ${job.company}'s engineering standards. I am eager to bring my problem-solving mindset and collaborative energy to your team.\n\nSincerely,\n${currentUser.displayName}`
      );
      setIsGeneratingAiLetter(false);
    }, 800);
  };

  const handleApplySubmit = (e: React.FormEvent) => {
    e.preventDefault();
    applyForJob(job.id, coverLetter);
    setApplyModalOpen(false);
  };

  return (
    <div className="max-w-4xl mx-auto px-4 py-6 space-y-6">
      {/* Top Navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => navigate('/jobs/swipe')}
          className="flex items-center gap-2 text-sm font-semibold text-slate-400 hover:text-slate-200 transition-colors p-2 rounded-xl bg-slate-800/60 border border-slate-700/60 cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
          Back to Jobs
        </button>

        <div className="flex items-center gap-2">
          <button
            onClick={() => toggleSaveJob(job.id)}
            className={`p-2.5 rounded-xl border transition-all cursor-pointer ${
              isSaved 
                ? 'bg-indigo-600 text-white border-indigo-500 shadow-md shadow-indigo-600/30' 
                : 'bg-slate-800/60 border-slate-700/60 text-slate-400 hover:text-slate-200'
            }`}
            title={isSaved ? 'Remove from Saved' : 'Save Job'}
          >
            <Bookmark className={`w-5 h-5 ${isSaved ? 'fill-current' : ''}`} />
          </button>
        </div>
      </div>

      {/* Hero Header Card */}
      <GlassCard className="p-6 md:p-8 bg-gradient-to-br from-indigo-950/40 via-slate-900/90 to-slate-900 border-indigo-500/20">
        <div className="flex flex-col sm:flex-row items-start sm:items-center gap-5">
          <div className="w-20 h-20 rounded-2xl bg-gradient-to-tr from-indigo-600 to-cyan-500 flex items-center justify-center font-bold text-white text-3xl shadow-xl shadow-indigo-500/30 shrink-0">
            {job.company.slice(0, 2).toUpperCase()}
          </div>

          <div className="flex-1 space-y-1.5 min-w-0">
            <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-100 tracking-tight">
              {job.title}
            </h1>
            <p className="text-base font-semibold text-indigo-400">
              {job.company} • <span className="text-slate-400 font-normal">{job.industry || 'Technology'}</span>
            </p>

            <div className="flex flex-wrap items-center gap-2 pt-2">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs font-semibold bg-indigo-500/15 text-indigo-300 border border-indigo-500/30">
                <Briefcase className="w-3.5 h-3.5" />
                {job.jobType || 'Full-time'}
              </span>
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs font-semibold bg-cyan-500/15 text-cyan-300 border border-cyan-500/30">
                <TrendingUp className="w-3.5 h-3.5" />
                {job.experienceLevel || 'Senior'}
              </span>
              {job.isRemote && (
                <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs font-semibold bg-emerald-500/15 text-emerald-300 border border-emerald-500/30">
                  <Home className="w-3.5 h-3.5" />
                  Remote Available
                </span>
              )}
            </div>
          </div>
        </div>

        {/* Salary and Location Banner */}
        <div className="mt-6 pt-5 border-t border-slate-800 flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-center gap-2 text-slate-300 text-sm">
            <MapPin className="w-4 h-4 text-slate-400" />
            <span>{job.location || 'San Francisco, CA'}</span>
          </div>

          <div className="flex items-center gap-2 px-3.5 py-1.5 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 font-bold text-sm">
            <DollarSign className="w-4 h-4" />
            {formatSalary(job.minSalary, job.maxSalary, job.currency)}
          </div>
        </div>
      </GlassCard>

      {/* Main Content Grid: Description & Requirements */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column: Description & Responsibilities (2 cols) */}
        <div className="lg:col-span-2 space-y-6">
          {/* Job Overview */}
          <GlassCard className="p-6 space-y-4">
            <h3 className="text-lg font-bold text-slate-100">About the Role</h3>
            <div className="text-slate-300 text-sm leading-relaxed whitespace-pre-line space-y-3">
              {job.description}
            </div>
          </GlassCard>

          {/* Key Responsibilities */}
          {job.responsibilities && job.responsibilities.length > 0 && (
            <GlassCard className="p-6 space-y-4">
              <h3 className="text-lg font-bold text-slate-100">Responsibilities</h3>
              <ul className="space-y-2.5">
                {job.responsibilities.map((resp, i) => (
                  <li key={i} className="flex items-start gap-2.5 text-sm text-slate-300">
                    <span className="w-1.5 h-1.5 rounded-full bg-indigo-400 mt-2 shrink-0" />
                    <span>{resp}</span>
                  </li>
                ))}
              </ul>
            </GlassCard>
          )}

          {/* Requirements */}
          {job.requirements && job.requirements.length > 0 && (
            <GlassCard className="p-6 space-y-4">
              <h3 className="text-lg font-bold text-slate-100">Requirements & Qualifications</h3>
              <ul className="space-y-2.5">
                {job.requirements.map((req, i) => (
                  <li key={i} className="flex items-start gap-2.5 text-sm text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-emerald-400 mt-0.5 shrink-0" />
                    <span>{req}</span>
                  </li>
                ))}
              </ul>
            </GlassCard>
          )}
        </div>

        {/* Right Sidebar: Skills Match & Apply (1 col) */}
        <div className="space-y-6">
          {/* Apply Action Card */}
          <GlassCard className="p-6 space-y-4 text-center">
            <h4 className="font-bold text-slate-100 text-base">Interested in this role?</h4>
            <p className="text-xs text-slate-400">
              Submit your active AI-optimized resume directly to the recruiting team at {job.company}.
            </p>

            {isApplied ? (
              <div className="p-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 font-semibold text-sm flex items-center justify-center gap-2">
                <Check className="w-4 h-4" />
                Application Submitted
              </div>
            ) : (
              <button
                onClick={() => setApplyModalOpen(true)}
                className="w-full py-3 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:opacity-95 text-white font-bold text-sm shadow-xl shadow-indigo-600/30 transition-all flex items-center justify-center gap-2 cursor-pointer"
              >
                <Send className="w-4 h-4" />
                Apply Now
              </button>
            )}

            <button
              onClick={() => toggleSaveJob(job.id)}
              className="w-full py-2.5 rounded-xl bg-slate-800/80 hover:bg-slate-700 text-slate-300 font-semibold text-xs border border-slate-700 transition-colors cursor-pointer"
            >
              {isSaved ? 'Remove from Saved' : 'Save for Later'}
            </button>
          </GlassCard>

          {/* Required Skills & Candidate Match */}
          <GlassCard className="p-6 space-y-3">
            <h4 className="font-bold text-slate-100 text-sm flex items-center justify-between">
              Skills Required ({job.skills.length})
            </h4>
            <div className="flex flex-wrap gap-1.5">
              {job.skills.map((skill, i) => {
                const userHas = currentUser.skills.some(
                  s => s.toLowerCase() === skill.toLowerCase()
                );
                return (
                  <span
                    key={i}
                    className={`px-3 py-1 rounded-xl text-xs font-semibold border flex items-center gap-1.5 ${
                      userHas
                        ? 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30'
                        : 'bg-slate-800/70 text-slate-400 border-slate-700/60'
                    }`}
                  >
                    {userHas && <Check className="w-3.5 h-3.5 text-emerald-400" />}
                    {skill}
                  </span>
                );
              })}
            </div>

            <div className="pt-3 border-t border-slate-800">
              <button
                onClick={() => navigate('/resume/skill-gap')}
                className="text-xs text-indigo-400 hover:text-indigo-300 font-semibold flex items-center gap-1"
              >
                <Sparkles className="w-3.5 h-3.5" />
                Check detailed ATS Skill Gap
              </button>
            </div>
          </GlassCard>

          {/* Attached Resume */}
          <GlassCard className="p-4 flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-indigo-500/15 flex items-center justify-center text-indigo-400 shrink-0">
              <FileText className="w-5 h-5" />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-xs font-bold text-slate-200 truncate">
                {activeResume?.fileName || 'Profile Credentials'}
              </p>
              <p className="text-[11px] text-emerald-400 font-medium">
                {activeResume ? `ATS Score: ${activeResume.atsScore}/100` : 'Candidate Profile Direct'}
              </p>
            </div>
          </GlassCard>
        </div>
      </div>

      {/* Apply Modal */}
      {applyModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4 animate-in fade-in duration-200">
          <div className="w-full max-w-lg bg-slate-900 border border-slate-800 rounded-3xl p-6 space-y-5 shadow-2xl">
            <div className="flex items-center justify-between pb-3 border-b border-slate-800">
              <div>
                <h3 className="text-lg font-bold text-slate-100">Apply to {job.company}</h3>
                <p className="text-xs text-slate-400">{job.title}</p>
              </div>
              <button
                onClick={() => setApplyModalOpen(false)}
                className="text-slate-400 hover:text-slate-200 p-1"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleApplySubmit} className="space-y-4">
              {/* Resume Selector */}
              <div>
                <label className="text-xs font-bold text-slate-300 block mb-1.5">
                  Attached Resume
                </label>
                <div className="p-3 rounded-xl bg-slate-800/70 border border-slate-700/60 flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <FileText className="w-4 h-4 text-indigo-400" />
                    <span className="text-xs font-semibold text-slate-200 truncate max-w-[200px]">
                      {activeResume?.fileName || 'Default Profile Submission'}
                    </span>
                  </div>
                  {activeResume && (
                    <span className="text-xs font-bold text-emerald-400">
                      {activeResume.atsScore} ATS
                    </span>
                  )}
                </div>
              </div>

              {/* Cover Letter */}
              <div>
                <div className="flex items-center justify-between mb-1.5">
                  <label className="text-xs font-bold text-slate-300">
                    Cover Letter (Optional)
                  </label>
                  <button
                    type="button"
                    onClick={generateAiCoverLetter}
                    disabled={isGeneratingAiLetter}
                    className="text-xs font-semibold text-indigo-400 hover:text-indigo-300 flex items-center gap-1 cursor-pointer"
                  >
                    <Sparkles className="w-3.5 h-3.5" />
                    {isGeneratingAiLetter ? 'Generating AI...' : 'Auto-Generate with AI'}
                  </button>
                </div>
                <textarea
                  value={coverLetter}
                  onChange={(e) => setCoverLetter(e.target.value)}
                  placeholder="Share a short note explaining why you're a great fit for this team..."
                  rows={6}
                  className="w-full p-3 rounded-xl bg-slate-800/80 border border-slate-700 text-slate-100 text-xs placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 leading-relaxed"
                />
              </div>

              <div className="flex gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setApplyModalOpen(false)}
                  className="flex-1 py-2.5 rounded-xl bg-slate-800 text-slate-300 font-semibold text-sm hover:bg-slate-700 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 text-white font-bold text-sm shadow-lg shadow-indigo-600/30 hover:opacity-95 transition-opacity"
                >
                  Submit Application
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
