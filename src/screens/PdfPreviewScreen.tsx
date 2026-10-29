import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Printer, 
  Download, 
  FileText, 
  Sparkles,
  Check
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';

export const PdfPreviewScreen: React.FC = () => {
  const { currentUser, activeResume, navigate, showToast } = useApp();
  const [selectedTemplate, setSelectedTemplate] = useState<'Modern' | 'Minimalist' | 'Executive'>('Modern');

  const templates: ('Modern' | 'Minimalist' | 'Executive')[] = ['Modern', 'Minimalist', 'Executive'];

  const handlePrint = () => {
    window.print();
  };

  const handleDownload = () => {
    showToast('Exporting high-resolution PDF document...', 'success');
    setTimeout(() => {
      window.print();
    }, 500);
  };

  const skills = activeResume?.skills || currentUser.skills;

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
              <FileText className="w-6 h-6 text-emerald-400" />
              Resume PDF Preview
            </h1>
            <p className="text-xs text-slate-400">
              Live multi-layout presentation generator reflecting your active ATS profile
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={handleDownload}
            className="px-3.5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs shadow-md shadow-indigo-600/30 flex items-center gap-1.5 cursor-pointer"
          >
            <Download className="w-4 h-4" />
            Download PDF
          </button>
        </div>
      </div>

      {/* Template Selector Bar */}
      <GlassCard className="p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-400">
            Layout Template:
          </span>
          <div className="flex gap-2">
            {templates.map(tmpl => {
              const isSelected = selectedTemplate === tmpl;
              return (
                <button
                  key={tmpl}
                  onClick={() => setSelectedTemplate(tmpl)}
                  className={`px-3.5 py-1.5 rounded-xl text-xs font-semibold transition-all border ${
                    isSelected
                      ? 'bg-indigo-600 text-white border-indigo-500 shadow-sm'
                      : 'bg-slate-800/70 text-slate-400 border-slate-700 hover:bg-slate-700'
                  }`}
                >
                  {tmpl}
                </button>
              );
            })}
          </div>
        </div>

        <span className="text-xs text-slate-400">
          Paper standard: US Letter (8.5" x 11")
        </span>
      </GlassCard>

      {/* Styled Printable PDF Canvas */}
      <div className="p-2 sm:p-6 bg-slate-950/60 rounded-3xl border border-slate-800 flex justify-center">
        <div className="w-full max-w-2xl bg-white text-slate-900 rounded-xl shadow-2xl p-8 sm:p-12 space-y-6 font-sans">
          {/* Header by Template */}
          {selectedTemplate === 'Minimalist' && (
            <div className="text-center pb-4 border-b border-slate-300 space-y-1.5">
              <h1 className="text-2xl font-light tracking-[0.2em] text-slate-900 uppercase">
                {currentUser.displayName}
              </h1>
              <p className="text-[11px] text-slate-500 tracking-wider">
                {currentUser.email} • {currentUser.phoneNumber || '+1 (555) 489-2041'} • {currentUser.location || 'San Francisco, CA'}
              </p>
            </div>
          )}

          {selectedTemplate === 'Executive' && (
            <div className="flex items-start justify-between pb-4 border-b-2 border-blue-900">
              <div>
                <h1 className="text-2xl font-bold text-blue-900 tracking-tight">
                  {currentUser.displayName}
                </h1>
                <p className="text-xs font-bold text-slate-600 uppercase tracking-wider">
                  {currentUser.targetRole || 'Senior Mobile & Full Stack Engineer'}
                </p>
              </div>
              <div className="text-right text-[11px] text-slate-600 space-y-0.5">
                <p>{currentUser.email}</p>
                <p>{currentUser.phoneNumber || '+1 (555) 489-2041'}</p>
                <p>{currentUser.location || 'San Francisco, CA'}</p>
              </div>
            </div>
          )}

          {selectedTemplate === 'Modern' && (
            <div className="p-6 -mx-8 -mt-8 sm:-mx-12 sm:-mt-12 bg-slate-900 text-white rounded-t-xl flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div>
                <h1 className="text-2xl font-bold tracking-tight text-white">
                  {currentUser.displayName}
                </h1>
                <p className="text-xs text-indigo-300 font-medium">
                  {currentUser.targetRole || 'Senior Mobile & Full-Stack Developer'}
                </p>
              </div>
              <div className="text-right text-[11px] text-slate-300 space-y-0.5">
                <p>{currentUser.email}</p>
                <p>{currentUser.phoneNumber || '+1 (555) 489-2041'}</p>
                <p>{currentUser.location || 'San Francisco, CA'}</p>
              </div>
            </div>
          )}

          {/* Professional Summary */}
          <div className="space-y-1.5">
            <h2 className={`text-xs font-bold uppercase tracking-wider ${
              selectedTemplate === 'Executive' ? 'text-blue-900' : 'text-indigo-600'
            }`}>
              Professional Summary
            </h2>
            <div className="h-0.5 w-full bg-slate-200" />
            <p className="text-xs text-slate-700 leading-relaxed pt-1">
              {currentUser.bio || (activeResume ? `Software engineering candidate with verified skills in ${skills.slice(0, 5).join(', ')}.` : 'Upload your resume to automatically extract your professional summary, skills, and work history.')}
            </p>
          </div>

          {/* Technical Skills */}
          <div className="space-y-1.5">
            <h2 className={`text-xs font-bold uppercase tracking-wider ${
              selectedTemplate === 'Executive' ? 'text-blue-900' : 'text-indigo-600'
            }`}>
              Core Competencies & Technologies
            </h2>
            <div className="h-0.5 w-full bg-slate-200" />
            <div className="flex flex-wrap gap-1.5 pt-1">
              {skills.length > 0 ? (
                skills.map((skill, i) => (
                  <span
                    key={i}
                    className="px-2 py-0.5 rounded bg-slate-100 text-slate-800 text-[11px] font-medium border border-slate-200"
                  >
                    {skill}
                  </span>
                ))
              ) : (
                <span className="text-xs text-slate-400 italic">No technical skills detected yet. Upload a resume to populate.</span>
              )}
            </div>
          </div>

          {/* Professional Experience */}
          <div className="space-y-3">
            <h2 className={`text-xs font-bold uppercase tracking-wider ${
              selectedTemplate === 'Executive' ? 'text-blue-900' : 'text-indigo-600'
            }`}>
              Professional Experience
            </h2>
            <div className="h-0.5 w-full bg-slate-200 -mt-1.5" />

            <div className="space-y-4 pt-1">
              {currentUser.experience.length > 0 ? (
                currentUser.experience.map((exp, i) => (
                  <div key={i} className="space-y-1">
                    <div className="flex items-center justify-between text-xs">
                      <span className="font-bold text-slate-900">{exp.role}</span>
                      <span className="text-slate-500 font-medium">
                        {exp.startYear} - {exp.isCurrent ? 'Present' : exp.endYear}
                      </span>
                    </div>
                    <p className="text-[11px] font-semibold text-slate-600">
                      {exp.company} • {exp.location || 'Remote'}
                    </p>
                    <p className="text-xs text-slate-700 leading-relaxed">
                      {exp.description}
                    </p>
                  </div>
                ))
              ) : (
                <div className="text-xs text-slate-400 italic">
                  No experience entries logged yet. Upload your resume or edit your profile.
                </div>
              )}
            </div>
          </div>

          {/* Education */}
          <div className="space-y-2">
            <h2 className={`text-xs font-bold uppercase tracking-wider ${
              selectedTemplate === 'Executive' ? 'text-blue-900' : 'text-indigo-600'
            }`}>
              Education & Certifications
            </h2>
            <div className="h-0.5 w-full bg-slate-200" />
            <div className="space-y-2 pt-1 text-xs">
              {currentUser.education.length > 0 ? (
                currentUser.education.map((edu, i) => (
                  <div key={i} className="flex justify-between">
                    <div>
                      <span className="font-bold text-slate-900">{edu.degree} in {edu.field}</span>
                      <p className="text-slate-600 text-[11px]">{edu.institution}</p>
                    </div>
                    <span className="text-slate-500">{edu.endYear}</span>
                  </div>
                ))
              ) : (
                <div className="text-xs text-slate-400 italic">
                  No education history added yet.
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
