import React, { useState } from 'react';
import { 
  ShieldCheck, 
  Users, 
  Briefcase, 
  FileText, 
  TrendingUp, 
  Plus, 
  Check, 
  X, 
  ArrowLeft, 
  CheckCircle2, 
  AlertCircle, 
  Clock, 
  MapPin, 
  DollarSign, 
  ChevronRight, 
  Filter, 
  UserCheck,
  Sparkles
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';
import { ApplicationStatus, JobModel } from '../types';

export const AdminDashboardScreen: React.FC = () => {
  const { 
    jobs, 
    applications, 
    currentUser, 
    postJob, 
    updateApplicationStatus, 
    navigate, 
    showToast 
  } = useApp();

  const [activeTab, setActiveTab] = useState<'applicants' | 'postings' | 'overview'>('applicants');
  const [addJobModalOpen, setAddJobModalOpen] = useState(false);
  const [selectedApplicationId, setSelectedApplicationId] = useState<string | null>(null);

  // New Job form state
  const [title, setTitle] = useState('');
  const [company, setCompany] = useState(currentUser.userType === 'recruiter' ? 'Apex AI' : '');
  const [jobType, setJobType] = useState('Full-time');
  const [experienceLevel, setExperienceLevel] = useState('midLevel');
  const [location, setLocation] = useState('Remote');
  const [isRemote, setIsRemote] = useState(true);
  const [minSalary, setMinSalary] = useState(130000);
  const [maxSalary, setMaxSalary] = useState(180000);
  const [skillsInput, setSkillsInput] = useState('React, TypeScript, Node.js, REST APIs');
  const [description, setDescription] = useState('');
  const [requirementsInput, setRequirementsInput] = useState('3+ years professional software development\nExperience with modern web frameworks\nStrong communication and testing mindset');

  const handleCreateJob = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !company.trim()) {
      showToast('Please provide a job title and company name', 'error');
      return;
    }

    const skills = skillsInput.split(',').map(s => s.trim()).filter(Boolean);
    const requirements = requirementsInput.split('\n').map(s => s.trim()).filter(Boolean);

    postJob({
      title,
      company,
      description: description || `We are looking for a talented ${title} to join ${company} and help build state-of-the-art products.`,
      requirements: requirements.length > 0 ? requirements : ['Strong technical problem solving', 'Team collaboration'],
      skills: skills.length > 0 ? skills : ['Software Development', 'Git'],
      experienceLevel,
      jobType,
      location,
      isRemote,
      minSalary: Number(minSalary),
      maxSalary: Number(maxSalary)
    });

    setAddJobModalOpen(false);
    // Reset form
    setTitle('');
    setDescription('');
    setActiveTab('postings');
  };

  const handleStatusChange = (appId: string, status: ApplicationStatus) => {
    updateApplicationStatus(appId, status);
  };

  const selectedApp = applications.find(a => a.id === selectedApplicationId);

  return (
    <div className="max-w-5xl mx-auto px-4 py-6 space-y-6">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate('/home')}
            className="p-2 rounded-xl bg-slate-800/60 border border-slate-700/60 text-slate-400 hover:text-slate-200 transition-colors cursor-pointer"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-slate-100 flex items-center gap-2">
              <ShieldCheck className="w-6 h-6 text-emerald-400" />
              Recruiter & Hiring Portal
            </h1>
            <p className="text-xs text-slate-400">
              Manage postings, screen candidate ATS match scores, and track hiring decisions
            </p>
          </div>
        </div>

        <button
          onClick={() => setAddJobModalOpen(true)}
          className="px-4 py-2 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 hover:opacity-95 text-white font-semibold text-xs shadow-md shadow-emerald-600/30 flex items-center gap-1.5 cursor-pointer self-start sm:self-auto"
        >
          <Plus className="w-4 h-4" />
          Post New Job
        </button>
      </div>

      {/* Real Statistics Overview Grid (Zero fake telemetry) */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 sm:gap-4">
        <GlassCard className="p-4 space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-xs text-slate-400 font-medium">Active Postings</span>
            <Briefcase className="w-4 h-4 text-cyan-400" />
          </div>
          <div className="text-2xl font-bold text-slate-100">{jobs.length}</div>
          <span className="text-[11px] font-semibold text-cyan-400">Live in feed</span>
        </GlassCard>

        <GlassCard className="p-4 space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-xs text-slate-400 font-medium">Applicants</span>
            <Users className="w-4 h-4 text-indigo-400" />
          </div>
          <div className="text-2xl font-bold text-slate-100">{applications.length}</div>
          <span className="text-[11px] font-semibold text-indigo-400">Received submissions</span>
        </GlassCard>

        <GlassCard className="p-4 space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-xs text-slate-400 font-medium">In Interview</span>
            <CheckCircle2 className="w-4 h-4 text-emerald-400" />
          </div>
          <div className="text-2xl font-bold text-slate-100">
            {applications.filter(a => a.status === 'interview').length}
          </div>
          <span className="text-[11px] font-semibold text-emerald-400">Shortlisted candidates</span>
        </GlassCard>

        <GlassCard className="p-4 space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-xs text-slate-400 font-medium">Internships</span>
            <Sparkles className="w-4 h-4 text-amber-400" />
          </div>
          <div className="text-2xl font-bold text-slate-100">
            {jobs.filter(j => j.jobType?.toLowerCase().includes('intern')).length}
          </div>
          <span className="text-[11px] font-semibold text-amber-400">Student opportunities</span>
        </GlassCard>
      </div>

      {/* Tabs Row */}
      <div className="flex border-b border-slate-800">
        <button
          onClick={() => setActiveTab('applicants')}
          className={`pb-3 px-4 text-sm font-semibold border-b-2 transition-all cursor-pointer ${
            activeTab === 'applicants'
              ? 'border-emerald-400 text-emerald-400'
              : 'border-transparent text-slate-400 hover:text-slate-200'
          }`}
        >
          Candidate Applicants ({applications.length})
        </button>
        <button
          onClick={() => setActiveTab('postings')}
          className={`pb-3 px-4 text-sm font-semibold border-b-2 transition-all cursor-pointer ${
            activeTab === 'postings'
              ? 'border-emerald-400 text-emerald-400'
              : 'border-transparent text-slate-400 hover:text-slate-200'
          }`}
        >
          Manage Jobs ({jobs.length})
        </button>
      </div>

      {/* TAB 1: APPLICANTS PIPELINE */}
      {activeTab === 'applicants' && (
        <div className="space-y-4">
          {applications.length > 0 ? (
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
              {/* Applicant list (7 cols) */}
              <div className="lg:col-span-7 space-y-3">
                {applications.map(app => (
                  <GlassCard
                    key={app.id}
                    onClick={() => setSelectedApplicationId(app.id)}
                    className={`p-4 transition-all cursor-pointer ${
                      selectedApplicationId === app.id
                        ? 'border-emerald-500/60 ring-1 ring-emerald-500/30'
                        : 'border-slate-800 hover:border-slate-700'
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <div className="flex items-center gap-2">
                          <h3 className="font-semibold text-sm text-slate-100">
                            {app.applicantName || 'Candidate'}
                          </h3>
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider ${
                            app.status === 'interview' 
                              ? 'bg-emerald-500/20 text-emerald-400'
                              : app.status === 'rejected'
                                ? 'bg-rose-500/20 text-rose-400'
                                : 'bg-indigo-500/20 text-indigo-400'
                          }`}>
                            {app.status}
                          </span>
                        </div>
                        <p className="text-xs text-slate-400 mt-0.5">
                          Applied for: <strong className="text-slate-300">{app.jobTitle}</strong> ({app.companyName})
                        </p>
                        <p className="text-[11px] text-slate-400 mt-1">
                          {app.applicantEmail} • Applied on {new Date(app.appliedAt).toLocaleDateString()}
                        </p>
                      </div>

                      {app.atsScore !== undefined && (
                        <div className="text-right shrink-0">
                          <div className={`text-base font-bold ${
                            app.atsScore >= 80 ? 'text-emerald-400' : 'text-amber-400'
                          }`}>
                            {app.atsScore}%
                          </div>
                          <div className="text-[10px] text-slate-400">ATS Match</div>
                        </div>
                      )}
                    </div>
                  </GlassCard>
                ))}
              </div>

              {/* Applicant Detail & Action Drawer (5 cols) */}
              <div className="lg:col-span-5">
                {selectedApp ? (
                  <GlassCard className="p-5 space-y-4 sticky top-20">
                    <div className="flex items-center justify-between">
                      <h4 className="font-bold text-sm text-slate-100">Applicant Details</h4>
                      <button
                        onClick={() => setSelectedApplicationId(null)}
                        className="p-1 text-slate-400 hover:text-slate-200"
                      >
                        <X className="w-4 h-4" />
                      </button>
                    </div>

                    <div>
                      <div className="text-base font-bold text-slate-100">{selectedApp.applicantName || 'Candidate'}</div>
                      <div className="text-xs text-slate-400">{selectedApp.applicantEmail}</div>
                      <div className="text-xs text-emerald-400 font-semibold mt-1">
                        Role: {selectedApp.jobTitle}
                      </div>
                    </div>

                    {/* ATS Score and Skills */}
                    <div className="p-3 rounded-xl bg-slate-800/60 border border-slate-700/60 space-y-2">
                      <div className="flex items-center justify-between text-xs">
                        <span className="text-slate-400">Role Compatibility:</span>
                        <span className="font-bold text-emerald-400">{selectedApp.atsScore || 85}%</span>
                      </div>
                      {selectedApp.skills && selectedApp.skills.length > 0 && (
                        <div>
                          <div className="text-[11px] text-slate-400 mb-1">Extracted Skills:</div>
                          <div className="flex flex-wrap gap-1">
                            {selectedApp.skills.slice(0, 8).map(s => (
                              <span key={s} className="px-1.5 py-0.5 rounded text-[10px] bg-slate-700 text-slate-300">
                                {s}
                              </span>
                            ))}
                          </div>
                        </div>
                      )}
                    </div>

                    {/* Cover Letter */}
                    {selectedApp.coverLetter && (
                      <div>
                        <div className="text-xs font-semibold text-slate-300 mb-1">Candidate Note:</div>
                        <p className="text-xs text-slate-400 bg-slate-900/60 p-2.5 rounded-xl border border-slate-800 italic">
                          "{selectedApp.coverLetter}"
                        </p>
                      </div>
                    )}

                    {/* Change Status Decision Actions */}
                    <div className="space-y-2 pt-2 border-t border-slate-800">
                      <label className="block text-xs font-semibold text-slate-300">
                        Update Hiring Status:
                      </label>
                      <div className="grid grid-cols-2 gap-2 text-xs">
                        <button
                          onClick={() => handleStatusChange(selectedApp.id, 'reviewing')}
                          className={`py-1.5 px-2 rounded-lg border text-center font-medium transition-colors ${
                            selectedApp.status === 'reviewing' 
                              ? 'bg-indigo-600 text-white border-indigo-500' 
                              : 'border-slate-700 text-slate-300 hover:bg-slate-800'
                          }`}
                        >
                          Under Review
                        </button>
                        <button
                          onClick={() => handleStatusChange(selectedApp.id, 'interview')}
                          className={`py-1.5 px-2 rounded-lg border text-center font-medium transition-colors ${
                            selectedApp.status === 'interview' 
                              ? 'bg-emerald-600 text-white border-emerald-500' 
                              : 'border-slate-700 text-slate-300 hover:bg-slate-800'
                          }`}
                        >
                          Schedule Interview
                        </button>
                        <button
                          onClick={() => handleStatusChange(selectedApp.id, 'offered')}
                          className={`py-1.5 px-2 rounded-lg border text-center font-medium transition-colors ${
                            selectedApp.status === 'offered' 
                              ? 'bg-teal-600 text-white border-teal-500' 
                              : 'border-slate-700 text-slate-300 hover:bg-slate-800'
                          }`}
                        >
                          Extend Offer
                        </button>
                        <button
                          onClick={() => handleStatusChange(selectedApp.id, 'rejected')}
                          className={`py-1.5 px-2 rounded-lg border text-center font-medium transition-colors ${
                            selectedApp.status === 'rejected' 
                              ? 'bg-rose-600 text-white border-rose-500' 
                              : 'border-slate-700 text-slate-300 hover:bg-slate-800'
                          }`}
                        >
                          Decline
                        </button>
                      </div>
                      <p className="text-[10px] text-slate-400 text-center">
                        Applicant tracker and notifications synchronize immediately.
                      </p>
                    </div>
                  </GlassCard>
                ) : (
                  <div className="p-8 text-center rounded-2xl bg-slate-900/40 border border-slate-800 text-xs text-slate-400">
                    Select an applicant on the left to review their resume compatibility and update their application status.
                  </div>
                )}
              </div>
            </div>
          ) : (
            <GlassCard className="p-12 text-center space-y-3">
              <div className="w-14 h-14 mx-auto rounded-2xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400">
                <Users className="w-7 h-7" />
              </div>
              <h3 className="text-base font-bold text-slate-100">No candidate applications yet</h3>
              <p className="text-xs text-slate-400 max-w-sm mx-auto">
                When candidates discover your job postings and swipe right to apply, their profiles, parsed resumes, and ATS compatibility scores will appear here.
              </p>
              <button
                onClick={() => navigate('/jobs/swipe')}
                className="mt-2 px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold cursor-pointer"
              >
                View Live Candidate Feed
              </button>
            </GlassCard>
          )}
        </div>
      )}

      {/* TAB 2: MANAGE POSTED JOBS */}
      {activeTab === 'postings' && (
        <div className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {jobs.map(job => (
              <GlassCard key={job.id} className="p-5 flex flex-col justify-between space-y-4">
                <div>
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <h3 className="font-bold text-base text-slate-100">{job.title}</h3>
                      <p className="text-xs text-slate-400">{job.company} • {job.location}</p>
                    </div>
                    <span className="px-2 py-0.5 rounded-full text-[10px] font-bold uppercase bg-cyan-500/10 text-cyan-400 border border-cyan-500/20">
                      {job.jobType}
                    </span>
                  </div>

                  <p className="text-xs text-slate-300 mt-2 line-clamp-2">
                    {job.description}
                  </p>

                  <div className="flex flex-wrap gap-1.5 mt-3">
                    {job.skills.slice(0, 4).map(s => (
                      <span key={s} className="px-2 py-0.5 rounded-md text-[10px] font-medium bg-slate-800 text-slate-300 border border-slate-700">
                        {s}
                      </span>
                    ))}
                  </div>
                </div>

                <div className="pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs text-slate-400">
                  <span>${(job.minSalary || 100000).toLocaleString()} - ${(job.maxSalary || 150000).toLocaleString()}</span>
                  <div className="flex items-center gap-3">
                    <span className="text-emerald-400 font-semibold">
                      {job.applyCount} Applicants
                    </span>
                    <button
                      onClick={() => navigate(`/jobs/details/${job.id}`)}
                      className="text-indigo-400 hover:underline font-semibold"
                    >
                      View
                    </button>
                  </div>
                </div>
              </GlassCard>
            ))}
          </div>
        </div>
      )}

      {/* Post New Job Modal */}
      {addJobModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="relative w-full max-w-lg bg-slate-900 border border-slate-800 rounded-2xl shadow-2xl p-6 overflow-hidden text-slate-100 max-h-[90vh] overflow-y-auto">
            <button
              onClick={() => setAddJobModalOpen(false)}
              className="absolute top-4 right-4 p-2 text-slate-400 hover:text-slate-100 hover:bg-slate-800 rounded-xl transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <h2 className="text-xl font-bold tracking-tight mb-1">Post a New Position</h2>
            <p className="text-xs text-slate-400 mb-4">
              Newly created roles immediately become searchable and swipable in the candidate feed.
            </p>

            <form onSubmit={handleCreateJob} className="space-y-3.5">
              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">Job Title *</label>
                <input
                  type="text"
                  required
                  value={title}
                  onChange={e => setTitle(e.target.value)}
                  placeholder="e.g. Senior Mobile Engineer (Flutter)"
                  className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-medium text-slate-300 mb-1">Company Name *</label>
                  <input
                    type="text"
                    required
                    value={company}
                    onChange={e => setCompany(e.target.value)}
                    placeholder="e.g. Apex AI"
                    className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-slate-300 mb-1">Job Type</label>
                  <select
                    value={jobType}
                    onChange={e => setJobType(e.target.value)}
                    className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                  >
                    <option value="Full-time">Full-time</option>
                    <option value="Internship">Internship</option>
                    <option value="Contract">Contract</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-medium text-slate-300 mb-1">Location</label>
                  <input
                    type="text"
                    value={location}
                    onChange={e => setLocation(e.target.value)}
                    placeholder="San Francisco, CA or Remote"
                    className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-slate-300 mb-1">Experience Level</label>
                  <select
                    value={experienceLevel}
                    onChange={e => setExperienceLevel(e.target.value)}
                    className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                  >
                    <option value="intern">Intern / Student</option>
                    <option value="junior">Entry / Junior</option>
                    <option value="midLevel">Mid-Level</option>
                    <option value="senior">Senior</option>
                    <option value="lead">Lead / Staff</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-medium text-slate-300 mb-1">Min Salary ($ USD)</label>
                  <input
                    type="number"
                    value={minSalary}
                    onChange={e => setMinSalary(Number(e.target.value))}
                    className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-slate-300 mb-1">Max Salary ($ USD)</label>
                  <input
                    type="number"
                    value={maxSalary}
                    onChange={e => setMaxSalary(Number(e.target.value))}
                    className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">Required Skills (Comma separated)</label>
                <input
                  type="text"
                  value={skillsInput}
                  onChange={e => setSkillsInput(e.target.value)}
                  placeholder="e.g. Flutter, Dart, TypeScript, Firebase"
                  className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">Job Description</label>
                <textarea
                  rows={3}
                  value={description}
                  onChange={e => setDescription(e.target.value)}
                  placeholder="Describe the role responsibilities, tech stack, and company culture..."
                  className="w-full px-3 py-2 bg-slate-950/80 border border-slate-800 rounded-xl text-xs focus:outline-none focus:border-indigo-500"
                />
              </div>

              <button
                type="submit"
                className="w-full mt-2 py-2.5 bg-gradient-to-r from-emerald-600 to-teal-600 hover:opacity-95 text-white font-semibold rounded-xl text-xs shadow-md shadow-emerald-600/25 cursor-pointer"
              >
                Publish Job Immediately
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
