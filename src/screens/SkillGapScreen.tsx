import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Briefcase, 
  CheckCircle2, 
  AlertTriangle, 
  Sparkles, 
  BookOpen, 
  Target,
  ArrowRight,
  ChevronDown
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';
import { roleSkillBenchmarks } from '../data/mockData';

export const SkillGapScreen: React.FC = () => {
  const { activeResume, currentUser, navigate } = useApp();
  const [selectedRole, setSelectedRole] = useState<string>('Senior Flutter Developer');

  const targetSkills = roleSkillBenchmarks[selectedRole] || [];
  const userSkills = activeResume?.skills && activeResume.skills.length > 0 
    ? activeResume.skills 
    : currentUser.skills;

  const matchingSkills = targetSkills.filter(skill =>
    userSkills.some(u => u.toLowerCase() === skill.toLowerCase())
  );

  const missingSkills = targetSkills.filter(skill =>
    !userSkills.some(u => u.toLowerCase() === skill.toLowerCase())
  );

  const matchPercentage = targetSkills.length > 0
    ? Math.round((matchingSkills.length / targetSkills.length) * 100)
    : 0;

  return (
    <div className="max-w-4xl mx-auto px-4 py-6 space-y-6">
      {/* Top Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate('/home')}
            className="p-2 rounded-xl bg-slate-800/60 border border-slate-700/60 text-slate-400 hover:text-slate-200 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-slate-100 flex items-center gap-2">
              <Sparkles className="w-6 h-6 text-cyan-400" />
              AI Skill Gap Analysis
            </h1>
            <p className="text-xs text-slate-400">
              Benchmark your resume against specific target positions & industry requirements
            </p>
          </div>
        </div>
      </div>

      {/* Role Selector Card */}
      <GlassCard className="p-4 sm:p-5">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-cyan-500/15 flex items-center justify-center text-cyan-400 shrink-0">
              <Briefcase className="w-5 h-5" />
            </div>
            <div>
              <label className="text-xs font-bold text-slate-400 uppercase tracking-wider block">
                Target Role Benchmark
              </label>
              <div className="relative mt-1">
                <select
                  value={selectedRole}
                  onChange={(e) => setSelectedRole(e.target.value)}
                  className="appearance-none bg-slate-800 border border-slate-700 text-slate-100 font-bold text-sm rounded-xl py-2 pl-3 pr-8 focus:outline-none focus:ring-2 focus:ring-indigo-500 cursor-pointer"
                >
                  {Object.keys(roleSkillBenchmarks).map(role => (
                    <option key={role} value={role} className="bg-slate-900 text-slate-200">
                      {role}
                    </option>
                  ))}
                </select>
                <ChevronDown className="w-4 h-4 text-slate-400 absolute right-2.5 top-1/2 -translate-y-1/2 pointer-events-none" />
              </div>
            </div>
          </div>

          <div className="text-xs text-slate-400 self-end sm:self-center">
            Comparing with <span className="text-indigo-400 font-semibold">{activeResume?.fileName || 'resume_v4.pdf'}</span>
          </div>
        </div>
      </GlassCard>

      {/* Compatibility Score Circular Gauge */}
      <GlassCard className="p-8 text-center space-y-4">
        <h2 className="text-lg font-bold text-slate-100">Role ATS Compatibility Score</h2>

        <div className="relative w-40 h-40 mx-auto flex items-center justify-center">
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
              className="stroke-cyan-400 transition-all duration-1000 ease-out"
              strokeWidth="10"
              strokeDasharray={251.2}
              strokeDashoffset={251.2 - (251.2 * matchPercentage) / 100}
              strokeLinecap="round"
              fill="transparent"
            />
          </svg>
          <div className="absolute flex flex-col items-center justify-center text-center">
            <span className="text-3xl font-black text-cyan-400">{matchPercentage}%</span>
            <span className="text-xs font-semibold text-slate-400">Match</span>
          </div>
        </div>

        <p className="text-sm text-slate-300 max-w-md mx-auto">
          {matchPercentage >= 75
            ? 'Excellent fit! You possess the primary core skills required for this job title.'
            : 'Moderate fit. Closing the high-priority gaps below will significantly boost your callback rate.'}
        </p>
      </GlassCard>

      {/* Matching Skills */}
      <GlassCard className="p-6 space-y-3">
        <h3 className="text-base font-bold text-emerald-400 flex items-center gap-2">
          <CheckCircle2 className="w-5 h-5 text-emerald-400" />
          Matching Skills ({matchingSkills.length})
        </h3>
        <div className="flex flex-wrap gap-2">
          {matchingSkills.map((skill, i) => (
            <span
              key={i}
              className="px-3.5 py-1.5 rounded-xl text-xs font-semibold bg-emerald-500/10 text-emerald-300 border border-emerald-500/30 flex items-center gap-1.5"
            >
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400" />
              {skill}
            </span>
          ))}
        </div>
      </GlassCard>

      {/* Missing Skills & Actionable AI Recommendations */}
      <GlassCard className="p-6 space-y-4">
        <div>
          <h3 className="text-base font-bold text-rose-400 flex items-center gap-2">
            <AlertTriangle className="w-5 h-5 text-rose-400" />
            Identified Skill Gaps ({missingSkills.length})
          </h3>
          <p className="text-xs text-slate-400 mt-1">
            Recruiter filters screen for these keywords. Here is how to acquire and showcase them:
          </p>
        </div>

        {missingSkills.length === 0 ? (
          <div className="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm font-semibold flex items-center gap-2">
            <CheckCircle2 className="w-5 h-5" />
            Perfect match! You have zero missing skill gaps for this target role.
          </div>
        ) : (
          <div className="space-y-3">
            {missingSkills.map((skill, i) => (
              <div key={i} className="p-4 rounded-2xl bg-slate-800/40 border border-slate-700/60 space-y-2">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-rose-400" />
                    <span className="text-sm font-bold text-slate-100">{skill}</span>
                  </div>
                  <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-rose-500/15 text-rose-400 border border-rose-500/30">
                    High Priority
                  </span>
                </div>

                <div className="text-xs text-slate-300 space-y-1 pt-1 border-t border-slate-700/40">
                  <span className="font-semibold text-indigo-400 block">AI Recommendation:</span>
                  <p className="text-slate-400 leading-relaxed">
                    To close this gap, complete a dedicated open-source project or tutorial utilizing <strong className="text-slate-200">{skill}</strong>. Adding 1-2 bullet points demonstrating practical production experience with {skill} will eliminate automated ATS keyword rejections.
                  </p>
                </div>
              </div>
            ))}
          </div>
        )}
      </GlassCard>

      {/* Bottom CTA */}
      <div className="flex justify-center pt-2">
        <button
          onClick={() => navigate('/resume/interview-prep')}
          className="px-6 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 text-white font-bold text-xs shadow-lg shadow-indigo-600/30 flex items-center gap-2"
        >
          Prepare For {selectedRole} Interviews
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};
