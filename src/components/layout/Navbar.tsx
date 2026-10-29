import React, { useState } from 'react';
import { 
  Sparkles, 
  Bell, 
  Sun, 
  Moon, 
  ShieldCheck, 
  UserCheck, 
  BriefcaseBusiness,
  Bookmark,
  FileText,
  LogOut,
  User,
  PlusCircle,
  LogIn
} from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const Navbar: React.FC = () => {
  const { 
    currentUser, 
    isAuthenticated,
    notifications, 
    themeMode, 
    toggleTheme, 
    navigate, 
    currentRoute,
    switchPersona,
    openAuthModal,
    logout
  } = useApp();

  const [personaMenuOpen, setPersonaMenuOpen] = useState(false);
  const isDark = themeMode === 'dark';
  const unreadCount = notifications.filter(n => !n.isRead).length;

  return (
    <header className={`sticky top-0 z-40 border-b backdrop-blur-xl transition-colors duration-300 ${
      isDark 
        ? 'bg-slate-900/80 border-slate-800 text-slate-100' 
        : 'bg-white/80 border-slate-200 text-slate-900'
    }`}>
      <div className="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
        {/* Brand Logo */}
        <div 
          onClick={() => navigate('/home')}
          className="flex items-center gap-2.5 cursor-pointer group select-none"
        >
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 to-cyan-500 flex items-center justify-center shadow-lg shadow-indigo-500/25 group-hover:scale-105 transition-transform">
            <Sparkles className="w-5 h-5 text-white" />
          </div>
          <div>
            <div className="flex items-center gap-1.5">
              <span className="font-bold text-lg tracking-tight bg-gradient-to-r from-indigo-400 via-indigo-200 to-cyan-300 bg-clip-text text-transparent">
                CareerSwipe
              </span>
              <span className="px-1.5 py-0.5 text-[10px] font-bold rounded-md bg-indigo-500/20 text-indigo-400 border border-indigo-500/30">
                AI
              </span>
            </div>
            <p className="text-[10px] text-slate-400 -mt-1 hidden sm:block">
              Two-Sided Career & ATS Marketplace
            </p>
          </div>
        </div>

        {/* Desktop Quick Nav Links */}
        <nav className="hidden md:flex items-center gap-1">
          <button
            onClick={() => navigate('/home')}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
              currentRoute === '/home' || currentRoute === '/dashboard'
                ? 'bg-indigo-600/15 text-indigo-400 font-semibold'
                : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/40'
            }`}
          >
            Dashboard
          </button>
          <button
            onClick={() => navigate('/jobs/swipe')}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
              currentRoute.startsWith('/jobs')
                ? 'bg-indigo-600/15 text-indigo-400 font-semibold'
                : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/40'
            }`}
          >
            Discover Jobs
          </button>
          <button
            onClick={() => navigate('/resume/upload')}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
              currentRoute.startsWith('/resume')
                ? 'bg-indigo-600/15 text-indigo-400 font-semibold'
                : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/40'
            }`}
          >
            ATS Resume Analyzer
          </button>
          <button
            onClick={() => navigate('/resume/interview-prep')}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
              currentRoute === '/resume/interview-prep'
                ? 'bg-indigo-600/15 text-indigo-400 font-semibold'
                : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/40'
            }`}
          >
            Interview Prep
          </button>
          <button
            onClick={() => navigate('/admin')}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all flex items-center gap-1.5 ${
              currentRoute === '/admin'
                ? 'bg-indigo-600/15 text-indigo-400 font-semibold'
                : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/40'
            }`}
          >
            <ShieldCheck className="w-4 h-4 text-emerald-400" />
            Recruiter Portal
          </button>
        </nav>

        {/* Right Action Icons & Persona Manager */}
        <div className="flex items-center gap-2">
          {/* Quick Persona Switcher Dropdown */}
          <div className="relative">
            <button
              onClick={() => setPersonaMenuOpen(!personaMenuOpen)}
              className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-slate-800/80 border border-slate-700/80 text-xs font-medium text-slate-300 hover:text-white transition-colors"
              title="Switch user perspective"
            >
              <span className={`w-2 h-2 rounded-full ${
                currentUser.userType === 'recruiter' 
                  ? 'bg-emerald-400' 
                  : currentUser.savedJobIds.length === 0 && currentUser.appliedJobIds.length === 0
                    ? 'bg-cyan-400'
                    : 'bg-indigo-400'
              }`} />
              <span className="hidden sm:inline">
                {currentUser.userType === 'recruiter' 
                  ? 'Recruiter' 
                  : currentUser.savedJobIds.length === 0 && currentUser.appliedJobIds.length === 0
                    ? 'Fresh Candidate'
                    : 'Demo Candidate'}
              </span>
            </button>

            {personaMenuOpen && (
              <div 
                className="absolute right-0 mt-2 w-56 rounded-xl bg-slate-900 border border-slate-800 shadow-xl py-2 z-50 animate-in fade-in zoom-in-95 duration-100"
                onClick={() => setPersonaMenuOpen(false)}
              >
                <div className="px-3 py-1 text-[10px] font-semibold text-slate-500 uppercase tracking-wider">
                  Select Perspective:
                </div>
                <button
                  onClick={() => switchPersona('fresh')}
                  className="w-full px-3 py-2 text-left text-xs hover:bg-slate-800/80 flex items-center justify-between text-slate-200"
                >
                  <div>
                    <div className="font-medium text-cyan-300">Fresh Candidate</div>
                    <div className="text-[10px] text-slate-400">Zero fake data, clean empty states</div>
                  </div>
                  {currentUser.savedJobIds.length === 0 && currentUser.userType === 'talent' && (
                    <span className="text-emerald-400 text-xs">✓</span>
                  )}
                </button>
                <button
                  onClick={() => switchPersona('demo')}
                  className="w-full px-3 py-2 text-left text-xs hover:bg-slate-800/80 flex items-center justify-between text-slate-200"
                >
                  <div>
                    <div className="font-medium text-indigo-300">Demo Candidate</div>
                    <div className="text-[10px] text-slate-400">Aman Tyagi (Sample resume & app)</div>
                  </div>
                </button>
                <button
                  onClick={() => switchPersona('recruiter')}
                  className="w-full px-3 py-2 text-left text-xs hover:bg-slate-800/80 flex items-center justify-between text-slate-200"
                >
                  <div>
                    <div className="font-medium text-emerald-300">Recruiter Portal</div>
                    <div className="text-[10px] text-slate-400">Post jobs, review applicants</div>
                  </div>
                  {currentUser.userType === 'recruiter' && (
                    <span className="text-emerald-400 text-xs">✓</span>
                  )}
                </button>
              </div>
            )}
          </div>

          {/* Saved Jobs Icon */}
          <button
            onClick={() => navigate('/jobs/saved')}
            className="relative p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800/50 transition-colors"
            title="Saved Jobs"
          >
            <Bookmark className="w-5 h-5" />
            {currentUser.savedJobIds.length > 0 && (
              <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-indigo-500 ring-2 ring-slate-900" />
            )}
          </button>

          {/* Notifications Icon */}
          <button
            onClick={() => navigate('/profile/notifications')}
            className="relative p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800/50 transition-colors"
            title="Notifications"
          >
            <Bell className="w-5 h-5" />
            {unreadCount > 0 && (
              <span className="absolute top-1 right-1 px-1.5 py-0.2 min-w-4 text-[10px] font-bold text-white bg-rose-500 rounded-full flex items-center justify-center ring-2 ring-slate-900">
                {unreadCount}
              </span>
            )}
          </button>

          {/* Theme Toggle */}
          <button
            onClick={toggleTheme}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800/50 transition-colors"
            title={`Switch to ${isDark ? 'Light' : 'Dark'} mode`}
          >
            {isDark ? <Sun className="w-5 h-5 text-amber-300" /> : <Moon className="w-5 h-5 text-slate-700" />}
          </button>

          {/* Auth Action / User Profile */}
          {isAuthenticated ? (
            <div
              onClick={() => navigate('/profile')}
              className="flex items-center gap-2 pl-1 cursor-pointer group"
              title={`${currentUser.displayName || currentUser.email} (View Profile)`}
            >
              <div className="w-9 h-9 rounded-full bg-gradient-to-tr from-indigo-500 to-cyan-500 p-0.5 shadow-sm group-hover:ring-2 group-hover:ring-indigo-400 transition-all">
                <div className="w-full h-full rounded-full bg-slate-900 flex items-center justify-center text-xs font-bold text-indigo-300">
                  {currentUser.displayName ? currentUser.displayName.slice(0, 2).toUpperCase() : 'US'}
                </div>
              </div>
            </div>
          ) : (
            <button
              onClick={() => openAuthModal('signin')}
              className="px-3 py-1.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-medium text-xs flex items-center gap-1.5 transition-colors cursor-pointer"
            >
              <LogIn className="w-3.5 h-3.5" />
              Sign In
            </button>
          )}
        </div>
      </div>
    </header>
  );
};
