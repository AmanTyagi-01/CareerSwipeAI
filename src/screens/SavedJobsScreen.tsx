import React from 'react';
import { 
  Bookmark, 
  ArrowLeft, 
  Trash2, 
  Send, 
  MapPin, 
  DollarSign, 
  Briefcase, 
  ExternalLink 
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';

export const SavedJobsScreen: React.FC = () => {
  const { 
    jobs, 
    currentUser, 
    toggleSaveJob, 
    applyForJob, 
    navigate 
  } = useApp();

  const savedJobs = jobs.filter(j => currentUser.savedJobIds.includes(j.id));

  const formatSalary = (min?: number, max?: number, currency = 'USD') => {
    if (!min && !max) return 'Competitive salary';
    const formatter = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency,
      maximumFractionDigits: 0
    });
    if (min && max) return `${formatter.format(min)} - ${formatter.format(max)}`;
    if (min) return `From ${formatter.format(min)}`;
    return `Up to ${formatter.format(max!)}`;
  };

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
              <Bookmark className="w-6 h-6 text-indigo-400 fill-indigo-500/20" />
              Saved Opportunities
            </h1>
            <p className="text-xs text-slate-400">
              {savedJobs.length} roles bookmarked for review
            </p>
          </div>
        </div>

        <button
          onClick={() => navigate('/jobs/swipe')}
          className="text-xs font-semibold text-indigo-400 hover:text-indigo-300"
        >
          + Discover More
        </button>
      </div>

      {/* Saved Jobs List */}
      {savedJobs.length > 0 ? (
        <div className="space-y-4">
          {savedJobs.map(job => {
            const isApplied = currentUser.appliedJobIds.includes(job.id);

            return (
              <GlassCard key={job.id} className="p-5 hover:border-slate-600 transition-all">
                <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                  <div className="flex items-start gap-4">
                    <div className="w-12 h-12 rounded-xl bg-gradient-to-tr from-indigo-600 to-cyan-500 flex items-center justify-center font-bold text-white text-lg shadow-md shrink-0">
                      {job.company.slice(0, 2).toUpperCase()}
                    </div>

                    <div className="space-y-1">
                      <div className="flex items-center gap-2">
                        <h3 
                          onClick={() => navigate(`/jobs/details/${job.id}`)}
                          className="font-bold text-base text-slate-100 hover:text-indigo-400 cursor-pointer transition-colors"
                        >
                          {job.title}
                        </h3>
                        {job.isRemote && (
                          <span className="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                            Remote
                          </span>
                        )}
                      </div>

                      <p className="text-xs text-slate-400">
                        {job.company} • <span className="text-slate-300">{job.location || 'San Francisco, CA'}</span>
                      </p>

                      <div className="flex flex-wrap items-center gap-2 pt-1 text-xs text-slate-400">
                        <span className="text-emerald-400 font-semibold flex items-center gap-1">
                          <DollarSign className="w-3.5 h-3.5" />
                          {formatSalary(job.minSalary, job.maxSalary, job.currency)}
                        </span>
                        <span>•</span>
                        <span>{job.jobType || 'Full-time'}</span>
                        <span>•</span>
                        <span>{job.experienceLevel || 'Senior'}</span>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center gap-2 self-end sm:self-center">
                    <button
                      onClick={() => toggleSaveJob(job.id)}
                      className="p-2.5 rounded-xl bg-slate-800/80 hover:bg-rose-500/15 text-slate-400 hover:text-rose-400 border border-slate-700/60 transition-colors"
                      title="Remove from Saved"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>

                    <button
                      onClick={() => navigate(`/jobs/details/${job.id}`)}
                      className="px-3 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 font-semibold text-xs border border-slate-700 transition-colors"
                    >
                      Details
                    </button>

                    {isApplied ? (
                      <span className="px-3.5 py-2 rounded-xl bg-emerald-500/15 text-emerald-400 font-bold text-xs border border-emerald-500/30">
                        Applied ✓
                      </span>
                    ) : (
                      <button
                        onClick={() => applyForJob(job.id)}
                        className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs shadow-md shadow-indigo-600/25 transition-all flex items-center gap-1.5"
                      >
                        <Send className="w-3.5 h-3.5" />
                        Quick Apply
                      </button>
                    )}
                  </div>
                </div>
              </GlassCard>
            );
          })}
        </div>
      ) : (
        <GlassCard className="p-12 text-center max-w-md mx-auto space-y-4">
          <div className="w-16 h-16 rounded-full bg-slate-800 flex items-center justify-center text-slate-400 mx-auto">
            <Bookmark className="w-8 h-8" />
          </div>
          <h3 className="text-lg font-bold text-slate-100">No Saved Jobs Yet</h3>
          <p className="text-xs text-slate-400">
            Swipe right on job cards or bookmark listings to revisit and apply later.
          </p>
          <button
            onClick={() => navigate('/jobs/swipe')}
            className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 text-white font-bold text-xs shadow-lg shadow-indigo-600/25"
          >
            Start Discovering
          </button>
        </GlassCard>
      )}
    </div>
  );
};
