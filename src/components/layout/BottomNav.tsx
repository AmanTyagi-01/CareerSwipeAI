import React from 'react';
import { Home, Briefcase, FileText, User, Sparkles, CheckCircle2, ShieldCheck } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const BottomNav: React.FC = () => {
  const { currentRoute, navigate, themeMode, currentUser } = useApp();
  const isDark = themeMode === 'dark';

  const isRecruiter = currentUser.userType === 'recruiter';

  const navItems = isRecruiter ? [
    {
      label: 'Home',
      path: '/home',
      icon: Home,
      isActive: currentRoute === '/home' || currentRoute === '/dashboard',
    },
    {
      label: 'Recruiter',
      path: '/admin',
      icon: ShieldCheck,
      isActive: currentRoute === '/admin',
    },
    {
      label: 'Jobs Feed',
      path: '/jobs/swipe',
      icon: Sparkles,
      isActive: currentRoute === '/jobs/swipe',
    },
    {
      label: 'Profile',
      path: '/profile',
      icon: User,
      isActive: currentRoute.startsWith('/profile'),
    },
  ] : [
    {
      label: 'Home',
      path: '/home',
      icon: Home,
      isActive: currentRoute === '/home' || currentRoute === '/dashboard',
    },
    {
      label: 'Discover',
      path: '/jobs/swipe',
      icon: Sparkles,
      isActive: currentRoute === '/jobs/swipe',
    },
    {
      label: 'Applications',
      path: '/jobs/applied',
      icon: CheckCircle2,
      isActive: currentRoute === '/jobs/applied',
    },
    {
      label: 'AI Resume',
      path: '/resume/upload',
      icon: FileText,
      isActive: currentRoute.startsWith('/resume'),
    },
    {
      label: 'Profile',
      path: '/profile',
      icon: User,
      isActive: currentRoute.startsWith('/profile'),
    },
  ];

  return (
    <div className={`fixed bottom-0 left-0 right-0 z-40 md:hidden border-t backdrop-blur-2xl transition-colors duration-300 ${
      isDark 
        ? 'bg-slate-900/90 border-slate-800 text-slate-100 shadow-[0_-8px_30px_rgba(0,0,0,0.5)]' 
        : 'bg-white/95 border-slate-200 text-slate-900 shadow-[0_-8px_30px_rgba(0,0,0,0.06)]'
    }`}>
      <div className="max-w-md mx-auto px-4 py-2 flex items-center justify-around">
        {navItems.map(item => {
          const Icon = item.icon;
          return (
            <button
              key={item.label}
              onClick={() => navigate(item.path)}
              className={`flex flex-col items-center justify-center py-1 px-2.5 rounded-xl transition-all duration-200 ${
                item.isActive 
                  ? 'text-indigo-400 bg-indigo-500/10 font-medium' 
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              <Icon className={`w-5 h-5 transition-transform ${item.isActive ? 'scale-110 text-indigo-400' : ''}`} />
              <span className={`text-[11px] mt-1 ${item.isActive ? 'font-semibold' : ''}`}>
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
};
