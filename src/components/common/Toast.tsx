import React from 'react';
import { CheckCircle2, AlertCircle, Info, X } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const Toast: React.FC = () => {
  const { toast } = useApp();

  if (!toast) return null;

  const icons = {
    success: <CheckCircle2 className="w-5 h-5 text-emerald-400 shrink-0" />,
    error: <AlertCircle className="w-5 h-5 text-rose-400 shrink-0" />,
    info: <Info className="w-5 h-5 text-indigo-400 shrink-0" />,
  };

  const borderColors = {
    success: 'border-emerald-500/40 bg-slate-900/90 text-emerald-200',
    error: 'border-rose-500/40 bg-slate-900/90 text-rose-200',
    info: 'border-indigo-500/40 bg-slate-900/90 text-indigo-200',
  };

  return (
    <div className="fixed top-20 right-4 z-50 max-w-sm animate-in fade-in slide-in-from-top-4 duration-300">
      <div className={`flex items-center gap-3 px-4 py-3 rounded-xl border backdrop-blur-xl shadow-2xl ${borderColors[toast.type]}`}>
        {icons[toast.type]}
        <p className="text-sm font-medium text-slate-100">{toast.message}</p>
      </div>
    </div>
  );
};
