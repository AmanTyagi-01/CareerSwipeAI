import React from 'react';
import { useApp } from '../../context/AppContext';

export const AnimatedBackground: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { themeMode } = useApp();
  const isDark = themeMode === 'dark';

  return (
    <div className={`relative min-h-screen transition-colors duration-500 ${
      isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'
    }`}>
      {/* Ambient gradient orbs */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden z-0">
        <div 
          className={`absolute -top-32 -left-32 w-96 h-96 rounded-full blur-3xl opacity-20 animate-pulse ${
            isDark ? 'bg-indigo-600' : 'bg-indigo-300'
          }`}
          style={{ animationDuration: '8s' }}
        />
        <div 
          className={`absolute top-1/3 -right-32 w-96 h-96 rounded-full blur-3xl opacity-15 animate-pulse ${
            isDark ? 'bg-cyan-500' : 'bg-cyan-300'
          }`}
          style={{ animationDuration: '10s' }}
        />
        <div 
          className={`absolute -bottom-32 left-1/3 w-[30rem] h-[30rem] rounded-full blur-3xl opacity-10 animate-pulse ${
            isDark ? 'bg-indigo-700' : 'bg-indigo-200'
          }`}
          style={{ animationDuration: '12s' }}
        />
      </div>

      <div className="relative z-10 flex flex-col min-h-screen">
        {children}
      </div>
    </div>
  );
};
