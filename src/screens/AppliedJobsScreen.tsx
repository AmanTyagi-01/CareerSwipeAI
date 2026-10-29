import React, { useState } from 'react';
import { 
  ArrowLeft, 
  CheckCircle2, 
  Clock, 
  Building, 
  MapPin, 
  Calendar, 
  ChevronRight,
  FileText
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';
import { ApplicationStatus } from '../types';

export const AppliedJobsScreen: React.FC = () => {
  const { applications, navigate } = useApp();
  const [selectedFilter, setSelectedFilter] = useState<string>('all');

  const filterTabs = [
    { label: 'All', value: 'all' },
    { label: 'In Review', value: 'reviewing' },
    { label: 'Interview', value: 'interview' },
    { label: 'Offered', value: 'offered' },
  ];

  const filteredApplications = applications.filter(app => {
    if (selectedFilter === 'all') return true;
    if (selectedFilter === 'reviewing') return app.status === 'pending' || app.status === 'reviewing';
    return app.status === selectedFilter;
  });

  const getStatusBadge = (status: ApplicationStatus) => {
    switch (status) {
      case 'interview':
        return (
          <span className="px-2.5 py-1 rounded-full text-xs font-bold bg-cyan-500/15 text-cyan-300 border border-cyan-500/30">
            Interview Scheduled 🎯
          </span>
        );
      case 'offered':
        return (
          <span className="px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-500/15 text-emerald-300 border border-emerald-500/30">
            Offer Received 🎉
          </span>
        );
      case 'reviewing':
        return (
          <span className="px-2.5 py-1 rounded-full text-xs font-bold bg-indigo-500/15 text-indigo-300 border border-indigo-500/30">
            Under Review ⏳
          </span>
        );
      case 'rejected':
        return (
          <span className="px-2.5 py-1 rounded-full text-xs font-bold bg-rose-500/15 text-rose-300 border border-rose-500/30">
            Archived
          </span>
        );
      default:
        return (
          <span className="px-2.5 py-1 rounded-full text-xs font-bold bg-slate-700/60 text-slate-300 border border-slate-600/50">
            Pending Review
          </span>
        );
    }
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
              <CheckCircle2 className="w-6 h-6 text-emerald-400" />
              Applied Applications
            </h1>
            <p className="text-xs text-slate-400">
              Track real-time hiring stage milestones and recruiter responses
            </p>
          </div>
        </div>
      </div>

      {/* Filter Tabs */}
      <div className="flex items-center gap-2 border-b border-slate-800 pb-2 overflow-x-auto">
        {filterTabs.map(tab => {
          const isSelected = selectedFilter === tab.value;
          return (
            <button
              key={tab.value}
              onClick={() => setSelectedFilter(tab.value)}
              className={`px-4 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition-all ${
                isSelected
                  ? 'bg-indigo-600 text-white shadow-sm'
                  : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
              }`}
            >
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* Application Cards List */}
      {filteredApplications.length > 0 ? (
        <div className="space-y-4">
          {filteredApplications.map(app => (
            <GlassCard key={app.id} className="p-6 space-y-4">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-3 border-b border-slate-800">
                <div>
                  <h3 
                    onClick={() => navigate(`/jobs/details/${app.jobId}`)}
                    className="font-bold text-lg text-slate-100 hover:text-indigo-400 cursor-pointer transition-colors"
                  >
                    {app.jobTitle}
                  </h3>
                  <p className="text-xs text-slate-400 flex items-center gap-2 mt-0.5">
                    <span className="font-semibold text-slate-300">{app.companyName}</span>
                    <span>•</span>
                    <span className="flex items-center gap-1">
                      <MapPin className="w-3 h-3 text-slate-500" />
                      {app.location || 'Remote'}
                    </span>
                  </p>
                </div>

                <div className="flex items-center gap-3">
                  {getStatusBadge(app.status)}
                </div>
              </div>

              {/* Timeline Milestones */}
              <div className="py-2">
                <h4 className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-3">
                  Application Timeline
                </h4>
                <div className="space-y-3 relative before:absolute before:left-2 before:top-2 before:bottom-2 before:w-0.5 before:bg-slate-800">
                  {app.timeline.map((step, i) => (
                    <div key={i} className="flex items-start gap-4 relative">
                      <div className="w-4 h-4 rounded-full bg-indigo-500 border-2 border-slate-900 shrink-0 mt-0.5 z-10" />
                      <div className="flex-1 text-xs">
                        <div className="flex items-center justify-between">
                          <span className="font-semibold text-slate-200 capitalize">
                            {step.status === 'pending' ? 'Application Received' : step.status}
                          </span>
                          <span className="text-slate-500">{step.date}</span>
                        </div>
                        {step.note && (
                          <p className="text-slate-400 mt-0.5">{step.note}</p>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Cover Letter & Resume Attached */}
              {app.coverLetter && (
                <div className="p-3 rounded-xl bg-slate-800/40 border border-slate-700/40 text-xs text-slate-400">
                  <span className="font-semibold text-slate-300 block mb-1">Attached Cover Letter Note:</span>
                  <p className="italic line-clamp-2">"{app.coverLetter}"</p>
                </div>
              )}
            </GlassCard>
          ))}
        </div>
      ) : (
        <GlassCard className="p-12 text-center max-w-md mx-auto space-y-4">
          <div className="w-16 h-16 rounded-2xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400 mx-auto">
            <CheckCircle2 className="w-8 h-8" />
          </div>
          <h3 className="text-lg font-bold text-slate-100">You haven't applied to any jobs yet</h3>
          <p className="text-xs text-slate-400">
            Swipe through curated roles or click Quick Apply on saved listings to submit your application.
          </p>
          <button
            onClick={() => navigate('/jobs/swipe')}
            className="mt-2 px-5 py-2.5 bg-gradient-to-r from-indigo-600 to-cyan-600 hover:opacity-95 text-white font-semibold rounded-xl text-xs shadow-md shadow-indigo-500/25 transition-all cursor-pointer"
          >
            Discover Open Roles
          </button>
        </GlassCard>
      )}
    </div>
  );
};
