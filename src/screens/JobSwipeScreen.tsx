import React, { useState, useRef } from 'react';
import { 
  Heart, 
  X, 
  RotateCcw, 
  Star, 
  Filter, 
  Bookmark, 
  MapPin, 
  Clock, 
  DollarSign, 
  Home, 
  TrendingUp, 
  Check, 
  Briefcase, 
  SlidersHorizontal,
  Search,
  Sparkles,
  ChevronRight,
  Info
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';
import { JobModel } from '../types';

export const JobSwipeScreen: React.FC = () => {
  const { 
    jobs, 
    activeResume,
    recordSwipe, 
    undoSwipe, 
    runJobSpecificAtsCheck,
    navigate, 
    currentUser 
  } = useApp();

  const [currentIndex, setCurrentIndex] = useState(0);
  const [filterModalOpen, setFilterModalOpen] = useState(false);
  const [selectedJobTypes, setSelectedJobTypes] = useState<string[]>([]);
  const [selectedLevels, setSelectedLevels] = useState<string[]>([]);
  const [remoteOnly, setRemoteOnly] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [quickTab, setQuickTab] = useState<'all' | 'internship' | 'fulltime'>('all');

  // Drag state for interactive card swiping
  const [dragOffset, setDragOffset] = useState<{ x: number; y: number }>({ x: 0, y: 0 });
  const [isDragging, setIsDragging] = useState(false);
  const dragStartRef = useRef<{ x: number; y: number }>({ x: 0, y: 0 });

  const allJobTypes = ['Full-time', 'Internship', 'Contract', 'Part-time'];
  const allLevels = ['intern', 'junior', 'midLevel', 'senior', 'lead'];

  // Apply filters
  const filteredJobs = jobs.filter(job => {
    if (quickTab === 'internship' && !job.jobType?.toLowerCase().includes('intern')) return false;
    if (quickTab === 'fulltime' && job.jobType?.toLowerCase().includes('intern')) return false;
    if (remoteOnly && !job.isRemote) return false;
    if (selectedJobTypes.length > 0 && job.jobType && !selectedJobTypes.includes(job.jobType)) return false;
    if (selectedLevels.length > 0 && job.experienceLevel && !selectedLevels.includes(job.experienceLevel)) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchTitle = job.title.toLowerCase().includes(q);
      const matchComp = job.company.toLowerCase().includes(q);
      const matchLoc = (job.location || '').toLowerCase().includes(q);
      const matchSkill = job.skills.some(s => s.toLowerCase().includes(q));
      if (!matchTitle && !matchComp && !matchLoc && !matchSkill) return false;
    }
    return true;
  });

  const currentJob: JobModel | undefined = filteredJobs[currentIndex];
  const nextJob: JobModel | undefined = filteredJobs[currentIndex + 1];

  const handleSwipe = (action: 'like' | 'dislike' | 'save' | 'superlike') => {
    if (!currentJob) return;
    recordSwipe(currentJob.id, action);
    setDragOffset({ x: 0, y: 0 });
    setIsDragging(false);
    setCurrentIndex(prev => prev + 1);
  };

  const handleUndo = () => {
    if (currentIndex > 0) {
      undoSwipe();
      setCurrentIndex(prev => prev - 1);
    }
  };

  // Drag handlers
  const onPointerDown = (e: React.PointerEvent) => {
    setIsDragging(true);
    dragStartRef.current = { x: e.clientX, y: e.clientY };
  };

  const onPointerMove = (e: React.PointerEvent) => {
    if (!isDragging) return;
    const dx = e.clientX - dragStartRef.current.x;
    const dy = e.clientY - dragStartRef.current.y;
    setDragOffset({ x: dx, y: dy });
  };

  const onPointerUp = () => {
    if (!isDragging) return;
    setIsDragging(false);
    const threshold = 110;
    if (dragOffset.x > threshold) {
      handleSwipe('like');
    } else if (dragOffset.x < -threshold) {
      handleSwipe('dislike');
    } else if (dragOffset.y < -threshold) {
      handleSwipe('superlike');
    } else {
      setDragOffset({ x: 0, y: 0 });
    }
  };

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

  const currentAts = currentJob ? runJobSpecificAtsCheck(currentJob) : null;

  return (
    <div className="max-w-2xl mx-auto px-4 py-4 min-h-[calc(100vh-5rem)] flex flex-col justify-between">
      {/* Top Search & Filter Bar */}
      <div className="space-y-3 mb-3">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-xl font-bold text-slate-100 flex items-center gap-2">
              Discover Opportunities
              <span className="text-xs font-normal text-slate-400">
                ({Math.max(0, filteredJobs.length - currentIndex)} remaining)
              </span>
            </h1>
            <p className="text-xs text-slate-400">Swipe right to save/apply, left to pass</p>
          </div>

          <button
            onClick={() => setFilterModalOpen(true)}
            className={`p-2.5 rounded-xl border transition-all cursor-pointer ${
              selectedJobTypes.length > 0 || selectedLevels.length > 0 || remoteOnly
                ? 'bg-indigo-600/20 border-indigo-500/50 text-indigo-400'
                : 'bg-slate-800/60 border-slate-700/60 text-slate-400 hover:text-slate-200'
            }`}
            title="Filters"
          >
            <SlidersHorizontal className="w-4 h-4" />
          </button>
        </div>

        {/* Search Input & Quick Tabs */}
        <div className="flex flex-col sm:flex-row items-center gap-2">
          <div className="relative w-full flex-1">
            <Search className="absolute left-3 top-2.5 w-4 h-4 text-slate-500" />
            <input
              type="text"
              value={searchQuery}
              onChange={e => { setSearchQuery(e.target.value); setCurrentIndex(0); }}
              placeholder="Filter by role, skill (Flutter, React, Python), company..."
              className="w-full pl-9 pr-3 py-1.5 bg-slate-900 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
            />
          </div>

          <div className="flex items-center gap-1 self-start sm:self-auto bg-slate-900 p-0.5 rounded-xl border border-slate-800 text-xs">
            <button
              onClick={() => { setQuickTab('all'); setCurrentIndex(0); }}
              className={`px-3 py-1 rounded-lg transition-all ${
                quickTab === 'all' ? 'bg-indigo-600 text-white font-semibold' : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              All Roles
            </button>
            <button
              onClick={() => { setQuickTab('internship'); setCurrentIndex(0); }}
              className={`px-3 py-1 rounded-lg transition-all ${
                quickTab === 'internship' ? 'bg-indigo-600 text-white font-semibold' : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              Internships
            </button>
            <button
              onClick={() => { setQuickTab('fulltime'); setCurrentIndex(0); }}
              className={`px-3 py-1 rounded-lg transition-all ${
                quickTab === 'fulltime' ? 'bg-indigo-600 text-white font-semibold' : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              Full-time
            </button>
          </div>
        </div>
      </div>

      {/* Swipe Card Deck Area */}
      <div className="relative flex-1 flex items-center justify-center my-2 min-h-[460px]">
        {currentJob ? (
          <div className="relative w-full max-w-lg h-[480px]">
            {/* Background next card placeholder */}
            {nextJob && (
              <div className="absolute inset-0 scale-95 opacity-60 translate-y-3 pointer-events-none transition-all">
                <GlassCard className="w-full h-full p-6 border-slate-800 opacity-50 overflow-hidden">
                  <h3 className="font-bold text-slate-300">{nextJob.title}</h3>
                  <p className="text-xs text-slate-500">{nextJob.company}</p>
                </GlassCard>
              </div>
            )}

            {/* Active Swipable Card */}
            <div
              onPointerDown={onPointerDown}
              onPointerMove={onPointerMove}
              onPointerUp={onPointerUp}
              style={{
                transform: `translate3d(${dragOffset.x}px, ${dragOffset.y}px, 0) rotate(${dragOffset.x * 0.07}deg)`,
                cursor: isDragging ? 'grabbing' : 'grab'
              }}
              className="absolute inset-0 touch-none select-none transition-transform duration-75"
            >
              <GlassCard className="w-full h-full overflow-hidden flex flex-col justify-between border-slate-700/80 shadow-2xl relative">
                {/* Visual Like/Dislike Overlay Stamps */}
                {dragOffset.x > 50 && (
                  <div className="absolute top-6 left-6 z-30 px-4 py-1.5 rounded-xl border-2 border-emerald-400 text-emerald-400 font-extrabold text-lg uppercase tracking-wider -rotate-12 bg-slate-950/70 shadow-lg">
                    SAVE & APPLY
                  </div>
                )}
                {dragOffset.x < -50 && (
                  <div className="absolute top-6 right-6 z-30 px-4 py-1.5 rounded-xl border-2 border-rose-500 text-rose-500 font-extrabold text-lg uppercase tracking-wider rotate-12 bg-slate-950/70 shadow-lg">
                    PASS
                  </div>
                )}
                {dragOffset.y < -50 && (
                  <div className="absolute top-6 left-1/2 -translate-x-1/2 z-30 px-4 py-1.5 rounded-xl border-2 border-amber-400 text-amber-400 font-extrabold text-lg uppercase tracking-wider bg-slate-950/70 shadow-lg">
                    SUPERLIKE ⭐
                  </div>
                )}

                {/* Card Header Banner */}
                <div className="p-5 border-b border-slate-800/80 bg-gradient-to-r from-slate-900/90 to-indigo-950/30">
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex items-center gap-3">
                      <div className="w-12 h-12 rounded-xl bg-gradient-to-tr from-indigo-600 to-cyan-500 flex items-center justify-center font-bold text-white text-sm shrink-0 shadow-md">
                        {currentJob.company.slice(0, 2).toUpperCase()}
                      </div>
                      <div>
                        <h2 className="font-bold text-lg text-slate-100 leading-tight">
                          {currentJob.title}
                        </h2>
                        <p className="text-xs text-slate-400 font-medium">
                          {currentJob.company} • {currentJob.location}
                        </p>
                      </div>
                    </div>

                    <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-cyan-500/15 text-cyan-300 border border-cyan-500/30 shrink-0">
                      {currentJob.jobType || 'Full-time'}
                    </span>
                  </div>
                </div>

                {/* Card Body */}
                <div className="p-5 flex-1 overflow-y-auto space-y-3.5">
                  {/* Real-time ATS match badge */}
                  {currentAts && (
                    <div className="flex items-center justify-between p-2.5 rounded-xl bg-indigo-500/10 border border-indigo-500/20 text-xs">
                      <div className="flex items-center gap-2">
                        <Sparkles className="w-4 h-4 text-indigo-400" />
                        <span className="text-indigo-300 font-semibold">
                          ATS Match Compatibility:
                        </span>
                      </div>
                      <span className={`font-bold ${currentAts.gradeColor}`}>
                        {currentAts.overallScore}% ({currentAts.matchGrade})
                      </span>
                    </div>
                  )}

                  {/* Badges */}
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
                      <Briefcase className="w-3.5 h-3.5" />
                      {currentJob.experienceLevel || 'Mid-Level'}
                    </span>
                    {currentJob.isRemote && (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                        <Home className="w-3.5 h-3.5" />
                        Remote
                      </span>
                    )}
                    {(currentJob.minSalary || currentJob.maxSalary) && (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold bg-amber-500/10 text-amber-400 border border-amber-500/20">
                        <DollarSign className="w-3.5 h-3.5" />
                        {formatSalary(currentJob.minSalary, currentJob.maxSalary, currentJob.currency)}
                      </span>
                    )}
                  </div>

                  {/* Description */}
                  <p className="text-xs text-slate-300 leading-relaxed line-clamp-3">
                    {currentJob.shortDescription || currentJob.description}
                  </p>

                  {/* Required Skills Chips */}
                  <div>
                    <h4 className="text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-1.5">
                      Required Skills ({currentJob.skills.length})
                    </h4>
                    <div className="flex flex-wrap gap-1.5">
                      {currentJob.skills.map((skill, i) => {
                        const candidateSkills = activeResume?.skills || currentUser.skills;
                        const userHas = candidateSkills.some(s => s.toLowerCase() === skill.toLowerCase());
                        return (
                          <span
                            key={i}
                            className={`px-2 py-0.5 rounded-md text-[11px] font-medium border flex items-center gap-1 ${
                              userHas 
                                ? 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30' 
                                : 'bg-slate-800 text-slate-400 border-slate-700'
                            }`}
                          >
                            {userHas && <Check className="w-3 h-3 text-emerald-400" />}
                            {skill}
                          </span>
                        );
                      })}
                    </div>
                  </div>
                </div>

                {/* Bottom View Details Link */}
                <div 
                  onClick={(e) => {
                    e.stopPropagation();
                    navigate(`/jobs/details/${currentJob.id}`);
                  }}
                  className="p-3 border-t border-slate-800 bg-slate-900/60 flex items-center justify-between text-xs text-slate-400 hover:text-indigo-300 hover:bg-slate-800/60 transition-colors cursor-pointer"
                >
                  <span>Tap to view requirements, responsibilities & full details</span>
                  <ChevronRight className="w-4 h-4 text-indigo-400" />
                </div>
              </GlassCard>
            </div>
          </div>
        ) : (
          /* Empty Deck State */
          <GlassCard className="p-10 text-center max-w-md mx-auto space-y-4">
            <div className="w-16 h-16 rounded-2xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400 mx-auto">
              <Check className="w-8 h-8 text-emerald-400" />
            </div>
            <h3 className="text-lg font-bold text-slate-100">You're All Caught Up!</h3>
            <p className="text-xs text-slate-400">
              You have evaluated all jobs matching your current filter criteria.
            </p>
            <div className="flex items-center justify-center gap-2 pt-2">
              <button
                onClick={() => setCurrentIndex(0)}
                className="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold cursor-pointer"
              >
                Reset Cards
              </button>
              <button
                onClick={() => navigate('/jobs/saved')}
                className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold cursor-pointer"
              >
                View Saved Jobs
              </button>
            </div>
          </GlassCard>
        )}
      </div>

      {/* Swipe Action Controls Bar */}
      <div className="flex items-center justify-center gap-4 py-2">
        <button
          onClick={handleUndo}
          disabled={currentIndex === 0}
          className="p-3 rounded-full bg-slate-800/80 hover:bg-slate-700 border border-slate-700 text-amber-400 transition-all disabled:opacity-30 cursor-pointer shadow-md"
          title="Undo last swipe"
        >
          <RotateCcw className="w-5 h-5" />
        </button>

        <button
          onClick={() => handleSwipe('dislike')}
          disabled={!currentJob}
          className="p-4 rounded-full bg-slate-800/80 hover:bg-rose-500/20 border border-slate-700 hover:border-rose-500/40 text-rose-400 transition-all disabled:opacity-30 cursor-pointer shadow-lg hover:scale-105"
          title="Pass (Swipe Left)"
        >
          <X className="w-7 h-7" />
        </button>

        <button
          onClick={() => handleSwipe('superlike')}
          disabled={!currentJob}
          className="p-3.5 rounded-full bg-slate-800/80 hover:bg-amber-500/20 border border-slate-700 hover:border-amber-500/40 text-amber-400 transition-all disabled:opacity-30 cursor-pointer shadow-lg hover:scale-105"
          title="Superlike (Priority Apply)"
        >
          <Star className="w-6 h-6 fill-amber-400/20" />
        </button>

        <button
          onClick={() => handleSwipe('like')}
          disabled={!currentJob}
          className="p-4 rounded-full bg-slate-800/80 hover:bg-emerald-500/20 border border-slate-700 hover:border-emerald-500/40 text-emerald-400 transition-all disabled:opacity-30 cursor-pointer shadow-lg hover:scale-105"
          title="Save & Apply (Swipe Right)"
        >
          <Heart className="w-7 h-7 fill-emerald-400/20" />
        </button>
      </div>

      {/* Filter Modal */}
      {filterModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm">
          <div className="relative w-full max-w-md bg-slate-900 border border-slate-800 rounded-2xl shadow-2xl p-6 text-slate-100 space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="font-bold text-base">Filter Opportunities</h3>
              <button
                onClick={() => setFilterModalOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-100"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Remote Only */}
            <div className="flex items-center justify-between py-2 border-b border-slate-800">
              <span className="text-xs font-semibold text-slate-300">Remote Only</span>
              <input
                type="checkbox"
                checked={remoteOnly}
                onChange={e => setRemoteOnly(e.target.checked)}
                className="w-4 h-4 rounded text-indigo-600 focus:ring-indigo-500"
              />
            </div>

            {/* Job Types */}
            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-2">Job Type</label>
              <div className="flex flex-wrap gap-2">
                {allJobTypes.map(type => (
                  <button
                    key={type}
                    onClick={() => {
                      setSelectedJobTypes(prev => 
                        prev.includes(type) ? prev.filter(t => t !== type) : [...prev, type]
                      );
                    }}
                    className={`px-3 py-1.5 rounded-xl text-xs font-medium border transition-colors ${
                      selectedJobTypes.includes(type)
                        ? 'bg-indigo-600 border-indigo-500 text-white'
                        : 'border-slate-800 text-slate-400 hover:border-slate-700'
                    }`}
                  >
                    {type}
                  </button>
                ))}
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-3 border-t border-slate-800">
              <button
                onClick={() => {
                  setSelectedJobTypes([]);
                  setSelectedLevels([]);
                  setRemoteOnly(false);
                  setSearchQuery('');
                  setFilterModalOpen(false);
                  setCurrentIndex(0);
                }}
                className="px-3 py-1.5 rounded-lg text-xs text-slate-400 hover:text-slate-200"
              >
                Reset
              </button>
              <button
                onClick={() => {
                  setFilterModalOpen(false);
                  setCurrentIndex(0);
                }}
                className="px-4 py-1.5 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold"
              >
                Apply Filters
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
