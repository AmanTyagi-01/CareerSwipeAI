import React, { useState } from 'react';
import { 
  ArrowLeft, 
  CheckCircle2, 
  AlertCircle, 
  Sparkles, 
  Award, 
  Lightbulb, 
  BookOpen, 
  ExternalLink,
  Target,
  FileText,
  Share2,
  Calendar,
  Layers,
  HelpCircle,
  TrendingUp,
  ShieldCheck,
  ChevronDown,
  Info,
  Check
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';
import { calculateAtsCompatibility } from '../services/atsAnalyzer';
import { parseResumeText } from '../services/resumeParser';

export const ResumeAnalysisScreen: React.FC = () => {
  const { currentAnalysis, activeResume, jobs, navigate, showToast, currentUser } = useApp();

  // Selected target job for job-specific ATS evaluation
  const [selectedJobId, setSelectedJobId] = useState<string>(jobs[0]?.id || '');
  const [customJobText, setCustomJobText] = useState<string>('');
  const [isCustomTarget, setIsCustomTarget] = useState(false);

  // If no resume or analysis exists, show meaningful empty state
  if (!activeResume || !currentAnalysis) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12 text-center space-y-4">
        <div className="w-16 h-16 rounded-2xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400 mx-auto">
          <FileText className="w-8 h-8" />
        </div>
        <h2 className="text-xl font-bold text-slate-100">No Resume Analysis Available</h2>
        <p className="text-xs text-slate-400 max-w-sm mx-auto">
          Upload your resume in PDF or DOCX format to receive your evidence-based ATS compatibility score and job-specific breakdown.
        </p>
        <button
          onClick={() => navigate('/resume/upload')}
          className="mt-2 px-5 py-2.5 bg-gradient-to-r from-indigo-600 to-cyan-600 hover:opacity-95 text-white font-semibold rounded-xl text-xs shadow-md shadow-indigo-500/25 transition-all cursor-pointer"
        >
          Go to Resume Upload
        </button>
      </div>
    );
  }

  // Calculate live job-specific ATS compatibility if target job changes
  const targetJob = jobs.find(j => j.id === selectedJobId) || null;
  const parsedData = activeResume.extractedText 
    ? parseResumeText(activeResume.extractedText)
    : {
        rawText: `Skills: ${activeResume.skills.join(', ')}`,
        contact: { email: currentUser.email, name: currentUser.displayName },
        skills: activeResume.skills,
        experienceYears: 2,
        experienceItems: [],
        educationItems: [],
        projects: [],
        certifications: [],
        metricsCount: 2,
        sectionsFound: ['Skills', 'Experience']
      };

  const jobSpecificResult = calculateAtsCompatibility(
    parsedData, 
    isCustomTarget ? null : targetJob,
    isCustomTarget ? customJobText : undefined
  );

  const displayScore = jobSpecificResult.overallScore;

  const getScoreColor = (val: number) => {
    if (val >= 85) return 'text-emerald-400 border-emerald-500/40 bg-emerald-500/10';
    if (val >= 70) return 'text-cyan-400 border-cyan-500/40 bg-cyan-500/10';
    if (val >= 50) return 'text-amber-400 border-amber-500/40 bg-amber-500/10';
    return 'text-rose-400 border-rose-500/40 bg-rose-500/10';
  };

  return (
    <div className="max-w-4xl mx-auto px-4 py-6 space-y-6">
      {/* Top Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate('/resume/upload')}
            className="p-2 rounded-xl bg-slate-800/60 border border-slate-700/60 text-slate-400 hover:text-slate-200 transition-colors cursor-pointer"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-slate-100 flex items-center gap-2">
              <Sparkles className="w-6 h-6 text-indigo-400" />
              Evidence-Based ATS Analyzer
            </h1>
            <p className="text-xs text-slate-400">
              Active Resume: <span className="font-semibold text-slate-300">{activeResume.fileName}</span>
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => {
              showToast('ATS evaluation link copied to clipboard!', 'success');
            }}
            className="p-2.5 rounded-xl bg-slate-800/60 border border-slate-700/60 text-slate-400 hover:text-slate-200 transition-colors cursor-pointer"
            title="Share Analysis"
          >
            <Share2 className="w-4 h-4" />
          </button>
          <button
            onClick={() => navigate('/resume/pdf-preview')}
            className="px-3.5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs transition-colors flex items-center gap-1.5 cursor-pointer"
          >
            <FileText className="w-4 h-4" />
            PDF Formatter
          </button>
        </div>
      </div>

      {/* Transparent Disclaimer Box */}
      <div className="p-3.5 rounded-xl bg-indigo-950/30 border border-indigo-500/20 text-indigo-200 text-xs flex items-start gap-2.5">
        <Info className="w-4 h-4 text-indigo-400 shrink-0 mt-0.5" />
        <p className="leading-relaxed text-[11px] text-indigo-300">
          <strong className="font-semibold text-indigo-200">Algorithmic Compatibility Benchmark: </strong>
          There is no universal ATS score that guarantees matching every private company's hiring portal. Our score transparently reflects exact keyword alignment, required vs. preferred skill coverage, and quantified impact formatting.
        </p>
      </div>

      {/* Target Job Selector Bar */}
      <GlassCard className="p-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <Target className="w-4 h-4 text-cyan-400" />
            <label className="text-xs font-semibold text-slate-200">
              Benchmark Target:
            </label>
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <select
              value={isCustomTarget ? 'custom' : selectedJobId}
              onChange={e => {
                if (e.target.value === 'custom') {
                  setIsCustomTarget(true);
                } else {
                  setIsCustomTarget(false);
                  setSelectedJobId(e.target.value);
                }
              }}
              className="px-3 py-1.5 bg-slate-900 border border-slate-700 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500 cursor-pointer"
            >
              {jobs.map(j => (
                <option key={j.id} value={j.id}>
                  {j.company} — {j.title}
                </option>
              ))}
              <option value="custom">Paste Custom Job Description...</option>
            </select>
          </div>
        </div>

        {isCustomTarget && (
          <div className="mt-3 pt-3 border-t border-slate-800 space-y-2">
            <textarea
              value={customJobText}
              onChange={e => setCustomJobText(e.target.value)}
              placeholder="Paste job description requirements, qualifications, and tech stack here..."
              rows={3}
              className="w-full p-2.5 bg-slate-950/80 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
            />
            <p className="text-[11px] text-slate-400">
              Matches your active resume against pasted role requirements in real time.
            </p>
          </div>
        )}
      </GlassCard>

      {/* Hero ATS Score Card */}
      <GlassCard className="p-6 sm:p-8 bg-gradient-to-br from-indigo-950/40 via-slate-900/90 to-slate-900 border-indigo-500/20">
        <div className="flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-2 text-center sm:text-left">
            <span className={`inline-flex px-3 py-1 rounded-full text-xs font-bold border ${getScoreColor(displayScore)}`}>
              {jobSpecificResult.matchGrade} Compatibility ({displayScore}/100)
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-100">
              {isCustomTarget ? 'Custom Role Match' : targetJob ? `${targetJob.title} at ${targetJob.company}` : 'Standard Tech Match'}
            </h2>
            <p className="text-xs text-slate-400 max-w-lg">
              {jobSpecificResult.experienceMatch.assessment}
            </p>
          </div>

          <div className="relative w-36 h-36 flex items-center justify-center shrink-0">
            <svg className="w-full h-full transform -rotate-90" viewBox="0 0 100 100">
              <circle
                cx="50"
                cy="50"
                r="42"
                className="stroke-slate-800"
                strokeWidth="10"
                fill="transparent"
              />
              <circle
                cx="50"
                cy="50"
                r="42"
                className="stroke-indigo-500 transition-all duration-1000"
                strokeWidth="10"
                strokeDasharray={263.8}
                strokeDashoffset={263.8 - (263.8 * displayScore) / 100}
                strokeLinecap="round"
                fill="transparent"
              />
            </svg>
            <div className="absolute flex flex-col items-center justify-center text-center">
              <span className="text-4xl font-black text-indigo-400">{displayScore}</span>
              <span className="text-xs uppercase font-bold tracking-wider text-slate-400">/ 100</span>
            </div>
          </div>
        </div>

        {/* 4 Core Pillars Breakdown */}
        <div className="mt-8 pt-6 border-t border-slate-800/80">
          <h4 className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-3">
            Algorithmic Breakdown by Category
          </h4>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            <div className="p-3 rounded-xl bg-slate-800/50 border border-slate-700/50 text-center">
              <span className="text-lg font-bold text-cyan-400 block">
                {jobSpecificResult.requiredSkillsMatch.percentage}%
              </span>
              <span className="text-[11px] text-slate-400 block">
                Required Skills Match
              </span>
            </div>
            <div className="p-3 rounded-xl bg-slate-800/50 border border-slate-700/50 text-center">
              <span className="text-lg font-bold text-indigo-400 block">
                {jobSpecificResult.preferredSkillsMatch.percentage}%
              </span>
              <span className="text-[11px] text-slate-400 block">
                Preferred & Bonus Skills
              </span>
            </div>
            <div className="p-3 rounded-xl bg-slate-800/50 border border-slate-700/50 text-center">
              <span className="text-lg font-bold text-emerald-400 block">
                {jobSpecificResult.experienceMatch.score}%
              </span>
              <span className="text-[11px] text-slate-400 block">
                Experience Duration
              </span>
            </div>
            <div className="p-3 rounded-xl bg-slate-800/50 border border-slate-700/50 text-center">
              <span className="text-lg font-bold text-amber-400 block">
                {jobSpecificResult.formattingAndImpact.score}%
              </span>
              <span className="text-[11px] text-slate-400 block">
                Impact & Metrics Quality
              </span>
            </div>
          </div>
        </div>
      </GlassCard>

      {/* Skills Comparison: Matched vs Missing */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Matched Required Skills */}
        <GlassCard className="p-5 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-bold text-slate-100 text-sm flex items-center gap-2">
              <CheckCircle2 className="w-4 h-4 text-emerald-400" />
              Verified Matched Skills ({jobSpecificResult.requiredSkillsMatch.matched.length})
            </h3>
            <span className="text-xs text-emerald-400 font-semibold">
              Found in Resume
            </span>
          </div>

          {jobSpecificResult.requiredSkillsMatch.matched.length > 0 ? (
            <div className="flex flex-wrap gap-2">
              {jobSpecificResult.requiredSkillsMatch.matched.map(skill => (
                <span
                  key={skill}
                  className="px-2.5 py-1 rounded-lg text-xs font-medium bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 flex items-center gap-1.5"
                >
                  <Check className="w-3 h-3" />
                  {skill}
                </span>
              ))}
            </div>
          ) : (
            <p className="text-xs text-slate-400">
              No direct required skill overlap found yet.
            </p>
          )}

          <div className="text-[11px] text-slate-400 pt-2 border-t border-slate-800/60">
            Total extracted technical skills across document: <span className="font-semibold text-slate-200">{parsedData.skills.length}</span>
          </div>
        </GlassCard>

        {/* Missing Target Skills */}
        <GlassCard className="p-5 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-bold text-slate-100 text-sm flex items-center gap-2">
              <AlertCircle className="w-4 h-4 text-rose-400" />
              Missing Role Requirements ({jobSpecificResult.requiredSkillsMatch.missing.length})
            </h3>
            <span className="text-xs text-rose-400 font-semibold">
              Action Required
            </span>
          </div>

          {jobSpecificResult.requiredSkillsMatch.missing.length > 0 ? (
            <div className="space-y-2">
              <div className="flex flex-wrap gap-2">
                {jobSpecificResult.requiredSkillsMatch.missing.map(skill => (
                  <span
                    key={skill}
                    className="px-2.5 py-1 rounded-lg text-xs font-medium bg-rose-500/10 text-rose-400 border border-rose-500/20"
                  >
                    + Add {skill}
                  </span>
                ))}
              </div>
              <p className="text-xs text-slate-400 pt-1">
                Tip: Add these missing keywords into your experience descriptions with concrete project examples.
              </p>
            </div>
          ) : (
            <div className="p-3 rounded-xl bg-emerald-500/10 text-emerald-300 text-xs">
              Excellent! Your resume covers all key technical requirements for this role.
            </div>
          )}
        </GlassCard>
      </div>

      {/* Actionable Recommendations */}
      <GlassCard className="p-6 space-y-4">
        <h3 className="font-bold text-slate-100 text-base flex items-center gap-2">
          <Lightbulb className="w-5 h-5 text-amber-400" />
          Evidence-Based Recommendations for This Role
        </h3>

        <div className="space-y-2.5">
          {jobSpecificResult.actionableImprovements.map((imp, idx) => (
            <div
              key={idx}
              className="p-3 rounded-xl bg-slate-800/50 border border-slate-700/50 flex items-start gap-3 text-xs text-slate-300"
            >
              <span className="w-5 h-5 rounded-full bg-amber-500/20 text-amber-400 flex items-center justify-center font-bold shrink-0 mt-0.5 text-[11px]">
                {idx + 1}
              </span>
              <p className="leading-relaxed">{imp}</p>
            </div>
          ))}
        </div>
      </GlassCard>

      {/* Rewrite Suggestions */}
      {currentAnalysis.rewriteSuggestions.length > 0 && (
        <GlassCard className="p-6 space-y-4">
          <h3 className="font-bold text-slate-100 text-base flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-cyan-400" />
            High-Impact Bullet Point Transformations
          </h3>

          <div className="space-y-3">
            {currentAnalysis.rewriteSuggestions.map((sug, idx) => (
              <div
                key={idx}
                className="p-3.5 rounded-xl bg-slate-900/60 border border-slate-800 text-xs text-slate-300 leading-relaxed font-mono"
              >
                {sug}
              </div>
            ))}
          </div>
        </GlassCard>
      )}

      {/* 3-Month Learning Roadmap */}
      {currentAnalysis.roadmap && (
        <GlassCard className="p-6 space-y-4">
          <h3 className="font-bold text-slate-100 text-base flex items-center gap-2">
            <Calendar className="w-5 h-5 text-emerald-400" />
            3-Month Skill Roadmap & Growth Milestones
          </h3>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            {currentAnalysis.roadmap.map(month => (
              <div
                key={month.month}
                className="p-4 rounded-xl bg-slate-800/40 border border-slate-700/60 space-y-2"
              >
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold uppercase tracking-wider text-indigo-400">
                    Month {month.month}
                  </span>
                </div>
                <h4 className="font-bold text-sm text-slate-100">{month.theme}</h4>
                <ul className="text-xs text-slate-400 space-y-1 list-disc list-inside">
                  {month.goals.map((g, i) => (
                    <li key={i}>{g}</li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </GlassCard>
      )}
    </div>
  );
};
