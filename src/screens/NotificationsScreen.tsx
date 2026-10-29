import React from 'react';
import { 
  ArrowLeft, 
  Bell, 
  CheckCheck, 
  Sparkles, 
  Briefcase, 
  FileText, 
  Clock 
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';

export const NotificationsScreen: React.FC = () => {
  const { 
    notifications, 
    markNotificationRead, 
    markAllNotificationsRead, 
    navigate 
  } = useApp();

  const getIcon = (type: string) => {
    switch (type) {
      case 'job_match':
        return <Sparkles className="w-4 h-4 text-cyan-400" />;
      case 'application_update':
        return <Briefcase className="w-4 h-4 text-emerald-400" />;
      case 'resume_tip':
        return <FileText className="w-4 h-4 text-amber-400" />;
      default:
        return <Bell className="w-4 h-4 text-indigo-400" />;
    }
  };

  return (
    <div className="max-w-3xl mx-auto px-4 py-6 space-y-6">
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
              <Bell className="w-6 h-6 text-indigo-400" />
              Notifications
            </h1>
            <p className="text-xs text-slate-400">
              Stay updated on recruiter reviews, new job matches, and optimization tips
            </p>
          </div>
        </div>

        <button
          onClick={markAllNotificationsRead}
          className="text-xs font-semibold text-indigo-400 hover:text-indigo-300 flex items-center gap-1.5"
        >
          <CheckCheck className="w-4 h-4" />
          Mark All Read
        </button>
      </div>

      {/* Notifications List */}
      {notifications.length > 0 ? (
        <div className="space-y-3">
          {notifications.map(notif => (
            <GlassCard
              key={notif.id}
              onClick={() => {
                markNotificationRead(notif.id);
                if (notif.actionUrl) {
                  navigate(notif.actionUrl);
                }
              }}
              className={`p-4 transition-all cursor-pointer ${
                !notif.isRead 
                  ? 'border-indigo-500/40 bg-slate-800/80 shadow-md' 
                  : 'hover:border-slate-700'
              }`}
            >
              <div className="flex items-start gap-3.5">
                <div className="w-9 h-9 rounded-xl bg-slate-800 flex items-center justify-center shrink-0 mt-0.5 border border-slate-700">
                  {getIcon(notif.type)}
                </div>

                <div className="flex-1 space-y-1">
                  <div className="flex items-center justify-between gap-2">
                    <h4 className="text-sm font-bold text-slate-200">
                      {notif.title}
                    </h4>
                    {!notif.isRead && (
                      <span className="w-2 h-2 rounded-full bg-indigo-500 shrink-0" />
                    )}
                  </div>
                  <p className="text-xs text-slate-300 leading-relaxed">
                    {notif.message}
                  </p>
                  <div className="flex items-center gap-1 text-[11px] text-slate-500 pt-1">
                    <Clock className="w-3 h-3" />
                    <span>{new Date(notif.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                  </div>
                </div>
              </div>
            </GlassCard>
          ))}
        </div>
      ) : (
        <GlassCard className="p-12 text-center max-w-md mx-auto space-y-3">
          <Bell className="w-8 h-8 text-slate-500 mx-auto" />
          <h3 className="text-base font-bold text-slate-200">No Notifications</h3>
          <p className="text-xs text-slate-400">
            You're all up to date. You will be alerted when recruiters take action.
          </p>
        </GlassCard>
      )}
    </div>
  );
};
