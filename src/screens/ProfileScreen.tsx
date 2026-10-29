import React, { useState } from 'react';
import { 
  User, 
  Mail, 
  Phone, 
  MapPin, 
  Briefcase, 
  Edit3, 
  Bookmark, 
  Send, 
  FileText, 
  Award, 
  ShieldCheck, 
  Bell, 
  LogOut, 
  ExternalLink,
  Github,
  Linkedin,
  CheckCircle2,
  X,
  Plus,
  LogIn,
  RefreshCw
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';

export const ProfileScreen: React.FC = () => {
  const { 
    currentUser, 
    activeResume, 
    applications, 
    isAuthenticated,
    navigate, 
    updateUserProfile, 
    switchPersona,
    openAuthModal,
    logout,
    showToast 
  } = useApp();

  const [isEditing, setIsEditing] = useState(false);
  const [editName, setEditName] = useState(currentUser.displayName);
  const [editTitle, setEditTitle] = useState(currentUser.targetRole || '');
  const [editBio, setEditBio] = useState(currentUser.bio || '');
  const [editLocation, setEditLocation] = useState(currentUser.location || '');
  const [editPhone, setEditPhone] = useState(currentUser.phoneNumber || '');
  const [newSkill, setNewSkill] = useState('');

  // Dynamically calculate completion
  let scorePoints = 20; // baseline
  if (currentUser.displayName) scorePoints += 15;
  if (currentUser.bio) scorePoints += 15;
  if (currentUser.targetRole) scorePoints += 10;
  if (currentUser.skills.length > 0) scorePoints += 15;
  if (currentUser.experience.length > 0) scorePoints += 15;
  if (activeResume) scorePoints += 10;
  const completionPercent = Math.min(100, scorePoints);

  const handleSaveProfile = (e: React.FormEvent) => {
    e.preventDefault();
    updateUserProfile({
      displayName: editName,
      targetRole: editTitle,
      bio: editBio,
      location: editLocation,
      phoneNumber: editPhone
    });
    setIsEditing(false);
  };

  const handleAddSkill = () => {
    if (!newSkill.trim()) return;
    if (currentUser.skills.some(s => s.toLowerCase() === newSkill.trim().toLowerCase())) {
      showToast('Skill already added', 'info');
      return;
    }
    updateUserProfile({
      skills: [...currentUser.skills, newSkill.trim()]
    });
    setNewSkill('');
  };

  const handleRemoveSkill = (skillToRemove: string) => {
    updateUserProfile({
      skills: currentUser.skills.filter(s => s !== skillToRemove)
    });
  };

  return (
    <div className="max-w-4xl mx-auto px-4 py-6 space-y-6">
      {/* Profile Header Card */}
      <GlassCard className="p-6 sm:p-8 bg-gradient-to-br from-indigo-950/40 via-slate-900/90 to-slate-900 border-indigo-500/20">
        <div className="flex flex-col sm:flex-row items-center sm:items-start justify-between gap-6">
          <div className="flex flex-col sm:flex-row items-center sm:items-start gap-5 text-center sm:text-left">
            <div className="relative">
              <div className="w-24 h-24 rounded-full bg-gradient-to-tr from-indigo-500 to-cyan-500 p-1 shadow-xl shadow-indigo-500/30">
                <div className="w-full h-full rounded-full bg-slate-900 flex items-center justify-center font-bold text-2xl text-indigo-300">
                  {currentUser.displayName ? currentUser.displayName.slice(0, 2).toUpperCase() : 'US'}
                </div>
              </div>
              <button
                onClick={() => setIsEditing(true)}
                className="absolute bottom-0 right-0 p-2 rounded-full bg-indigo-600 text-white shadow-lg hover:bg-indigo-500 transition-colors cursor-pointer"
                title="Edit Profile"
              >
                <Edit3 className="w-3.5 h-3.5" />
              </button>
            </div>

            <div className="space-y-1.5">
              <div className="flex items-center justify-center sm:justify-start gap-2">
                <h1 className="text-2xl font-bold text-slate-100">
                  {currentUser.displayName || 'Candidate Profile'}
                </h1>
                <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                  currentUser.userType === 'recruiter' 
                    ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/30'
                    : 'bg-indigo-500/20 text-indigo-300 border border-indigo-500/30'
                }`}>
                  {currentUser.userType.toUpperCase()}
                </span>
              </div>
              <p className="text-sm font-semibold text-indigo-400">
                {currentUser.targetRole || 'Software Professional'}
              </p>
              <p className="text-xs text-slate-400 flex items-center justify-center sm:justify-start gap-2">
                <MapPin className="w-3.5 h-3.5" />
                {currentUser.location || 'Remote'} • 
                <span className="capitalize">{currentUser.workMode || 'Remote'}</span>
              </p>
              <p className="text-xs text-slate-400 flex items-center justify-center sm:justify-start gap-2">
                <Mail className="w-3.5 h-3.5" />
                {currentUser.email}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => setIsEditing(true)}
              className="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold border border-slate-700 transition-colors flex items-center gap-1.5 cursor-pointer"
            >
              <Edit3 className="w-3.5 h-3.5" />
              Edit Profile
            </button>
            {isAuthenticated ? (
              <button
                onClick={logout}
                className="p-2 rounded-xl bg-slate-800/80 hover:bg-rose-500/20 text-slate-400 hover:text-rose-400 border border-slate-700 transition-colors cursor-pointer"
                title="Sign Out"
              >
                <LogOut className="w-4 h-4" />
              </button>
            ) : (
              <button
                onClick={() => openAuthModal('signin')}
                className="px-3.5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold flex items-center gap-1 cursor-pointer"
              >
                <LogIn className="w-3.5 h-3.5" />
                Sign In
              </button>
            )}
          </div>
        </div>

        {/* Profile Completion Meter */}
        <div className="mt-6 pt-5 border-t border-slate-800 space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-slate-400 font-medium">Profile Strength</span>
            <span className="text-indigo-400 font-bold">{completionPercent}%</span>
          </div>
          <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
            <div 
              className="h-full bg-gradient-to-r from-indigo-500 to-cyan-400 rounded-full transition-all duration-500"
              style={{ width: `${completionPercent}%` }}
            />
          </div>
        </div>
      </GlassCard>

      {/* Persona Quick Switcher Bar */}
      <GlassCard className="p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <RefreshCw className="w-4 h-4 text-cyan-400" />
          <span className="text-xs font-bold uppercase tracking-wider text-slate-300">
            Account Perspective:
          </span>
        </div>
        <div className="flex flex-wrap items-center gap-1.5">
          <button
            onClick={() => switchPersona('fresh')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors ${
              currentUser.savedJobIds.length === 0 && currentUser.appliedJobIds.length === 0 && currentUser.userType === 'talent'
                ? 'bg-cyan-600 text-white border-cyan-500'
                : 'bg-slate-800 text-slate-300 border-slate-700 hover:bg-slate-700'
            }`}
          >
            Fresh Candidate (Clean 0 Data)
          </button>
          <button
            onClick={() => switchPersona('demo')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors ${
              currentUser.id === 'usr_aman_01'
                ? 'bg-indigo-600 text-white border-indigo-500'
                : 'bg-slate-800 text-slate-300 border-slate-700 hover:bg-slate-700'
            }`}
          >
            Demo Candidate (Aman Tyagi)
          </button>
          <button
            onClick={() => switchPersona('recruiter')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors ${
              currentUser.userType === 'recruiter'
                ? 'bg-emerald-600 text-white border-emerald-500'
                : 'bg-slate-800 text-slate-300 border-slate-700 hover:bg-slate-700'
            }`}
          >
            Recruiter Mode (Sarah Jenkins)
          </button>
        </div>
      </GlassCard>

      {/* Professional Bio */}
      <GlassCard className="p-6 space-y-2">
        <h3 className="font-bold text-sm text-slate-200">About & Bio</h3>
        <p className="text-xs text-slate-300 leading-relaxed">
          {currentUser.bio || 'No professional bio added yet. Click "Edit Profile" to summarize your career objectives and experience.'}
        </p>
      </GlassCard>

      {/* Verified Skills Management */}
      <GlassCard className="p-6 space-y-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <h3 className="font-bold text-sm text-slate-200">
            Skills Profile ({currentUser.skills.length})
          </h3>
          <div className="flex items-center gap-2">
            <input
              type="text"
              value={newSkill}
              onChange={e => setNewSkill(e.target.value)}
              placeholder="Add skill (e.g. Flutter, React, AWS)..."
              onKeyDown={e => e.key === 'Enter' && (e.preventDefault(), handleAddSkill())}
              className="px-3 py-1.5 bg-slate-950/80 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
            />
            <button
              onClick={handleAddSkill}
              className="p-1.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white transition-colors cursor-pointer"
              title="Add Skill"
            >
              <Plus className="w-4 h-4" />
            </button>
          </div>
        </div>

        {currentUser.skills.length > 0 ? (
          <div className="flex flex-wrap gap-2">
            {currentUser.skills.map((skill, i) => (
              <span
                key={i}
                className="px-3 py-1 rounded-xl text-xs font-medium bg-slate-800/80 border border-slate-700/80 text-slate-200 flex items-center gap-1.5 group"
              >
                {skill}
                <button
                  onClick={() => handleRemoveSkill(skill)}
                  className="text-slate-400 hover:text-rose-400 transition-colors ml-0.5"
                >
                  <X className="w-3 h-3" />
                </button>
              </span>
            ))}
          </div>
        ) : (
          <p className="text-xs text-slate-400 italic">
            No skills added yet. Type a skill above or upload your resume to extract skills automatically.
          </p>
        )}
      </GlassCard>

      {/* Work History */}
      <GlassCard className="p-6 space-y-4">
        <h3 className="font-bold text-sm text-slate-200">Work Experience</h3>
        {currentUser.experience.length > 0 ? (
          <div className="space-y-4">
            {currentUser.experience.map((exp, i) => (
              <div key={i} className="p-3.5 rounded-xl bg-slate-800/40 border border-slate-700/40 space-y-1">
                <div className="flex items-center justify-between text-xs">
                  <span className="font-bold text-slate-100">{exp.role}</span>
                  <span className="text-slate-400">{exp.startYear} - {exp.isCurrent ? 'Present' : exp.endYear}</span>
                </div>
                <div className="text-[11px] text-indigo-400 font-semibold">{exp.company} • {exp.location || 'Remote'}</div>
                <p className="text-xs text-slate-300 pt-1 leading-relaxed">{exp.description}</p>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-xs text-slate-400 italic">
            No work experience entries recorded. Upload your resume to extract your history.
          </p>
        )}
      </GlassCard>

      {/* Edit Profile Modal */}
      {isEditing && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="relative w-full max-w-md bg-slate-900 border border-slate-800 rounded-2xl shadow-2xl p-6 text-slate-100 space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="font-bold text-base">Edit Candidate Profile</h3>
              <button
                onClick={() => setIsEditing(false)}
                className="p-1 text-slate-400 hover:text-slate-100"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSaveProfile} className="space-y-3.5">
              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">Full Name</label>
                <input
                  type="text"
                  required
                  value={editName}
                  onChange={e => setEditName(e.target.value)}
                  className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">Target Role / Title</label>
                <input
                  type="text"
                  value={editTitle}
                  onChange={e => setEditTitle(e.target.value)}
                  placeholder="e.g. Senior Mobile Engineer"
                  className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">Location</label>
                <input
                  type="text"
                  value={editLocation}
                  onChange={e => setEditLocation(e.target.value)}
                  placeholder="e.g. San Francisco, CA or Remote"
                  className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">Phone Number</label>
                <input
                  type="text"
                  value={editPhone}
                  onChange={e => setEditPhone(e.target.value)}
                  placeholder="+1 (555) 000-0000"
                  className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">Professional Bio</label>
                <textarea
                  rows={3}
                  value={editBio}
                  onChange={e => setEditBio(e.target.value)}
                  placeholder="Summarize your background and core engineering passions..."
                  className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setIsEditing(false)}
                  className="px-4 py-2 rounded-xl bg-slate-800 text-slate-300 text-xs font-medium hover:bg-slate-700"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold"
                >
                  Save Profile
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
