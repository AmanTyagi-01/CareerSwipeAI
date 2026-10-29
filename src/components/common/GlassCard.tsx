import React from 'react';
import { clsx } from 'clsx';
import { useApp } from '../../context/AppContext';

interface GlassCardProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode;
  className?: string;
  glow?: 'primary' | 'accent' | 'success' | 'none';
  hoverEffect?: boolean;
}

export const GlassCard: React.FC<GlassCardProps> = ({
  children,
  className,
  glow = 'none',
  hoverEffect = false,
  ...props
}) => {
  const { themeMode } = useApp();
  const isDark = themeMode === 'dark';

  const glowClasses = {
    primary: 'glow-primary',
    accent: 'glow-accent',
    success: 'glow-success',
    none: '',
  };

  return (
    <div
      className={clsx(
        'rounded-2xl transition-all duration-300',
        isDark ? 'glass-card text-slate-100' : 'glass-card-light text-slate-900',
        glowClasses[glow],
        hoverEffect && 'hover:translate-y-[-2px] hover:shadow-xl',
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
};
