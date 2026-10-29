import React, { useState } from 'react';
import { 
  ArrowLeft, 
  HelpCircle, 
  Sparkles, 
  RotateCw, 
  ChevronLeft, 
  ChevronRight, 
  CheckCircle2, 
  Lightbulb,
  Award
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { GlassCard } from '../components/common/GlassCard';
import { interviewQuestions } from '../data/mockData';

export const InterviewPrepScreen: React.FC = () => {
  const { navigate, showToast } = useApp();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isFlipped, setIsFlipped] = useState(false);

  const currentQ = interviewQuestions[currentIndex];
  const progressPercent = Math.round(((currentIndex + 1) / interviewQuestions.length) * 100);

  const handleNext = () => {
    if (currentIndex < interviewQuestions.length - 1) {
      setCurrentIndex(prev => prev + 1);
      setIsFlipped(false);
    } else {
      showToast('Interview prep session completed! Great job. 🎉', 'success');
      setCurrentIndex(0);
      setIsFlipped(false);
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) {
      setCurrentIndex(prev => prev - 1);
      setIsFlipped(false);
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
              <HelpCircle className="w-6 h-6 text-indigo-400" />
              AI Interview Prep
            </h1>
            <p className="text-xs text-slate-400">
              Interactive 3D flashcards with STAR response guidance tailored to your role
            </p>
          </div>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="space-y-1.5">
        <div className="flex items-center justify-between text-xs text-slate-400 font-semibold">
          <span>Question {currentIndex + 1} of {interviewQuestions.length}</span>
          <span className="text-indigo-400">{progressPercent}% Completed</span>
        </div>
        <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
          <div 
            className="h-full bg-gradient-to-r from-indigo-500 to-cyan-400 rounded-full transition-all duration-300"
            style={{ width: `${progressPercent}%` }}
          />
        </div>
      </div>

      {/* 3D Flip Card Container */}
      <div className="perspective-1000 min-h-[380px] w-full flex items-center justify-center">
        <div
          onClick={() => setIsFlipped(!isFlipped)}
          className={`relative w-full h-[380px] rounded-3xl cursor-pointer transition-transform duration-700 transform-style-preserve-3d ${
            isFlipped ? 'rotate-y-180' : ''
          }`}
        >
          {/* Card Front (Question) */}
          <div className="absolute inset-0 backface-hidden">
            <GlassCard className="h-full p-8 flex flex-col justify-between border-slate-700/80 shadow-2xl hover:border-indigo-500/50 transition-all bg-gradient-to-br from-slate-900/95 via-slate-900/90 to-indigo-950/40">
              <div>
                <div className="flex items-center justify-between">
                  <span className="px-3 py-1 rounded-full text-xs font-bold bg-indigo-500/15 text-indigo-300 border border-indigo-500/30">
                    {currentQ.category}
                  </span>
                  <span className="px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-slate-800 text-slate-400 border border-slate-700">
                    {currentQ.difficulty}
                  </span>
                </div>

                <div className="mt-8">
                  <h2 className="text-xl sm:text-2xl font-extrabold text-slate-100 leading-snug">
                    "{currentQ.question}"
                  </h2>
                </div>
              </div>

              <div className="flex items-center justify-between pt-4 border-t border-slate-800 text-xs text-slate-400">
                <span className="flex items-center gap-1.5 text-indigo-400 font-semibold">
                  <RotateCw className="w-4 h-4 animate-spin-slow" />
                  Click to Flip & Reveal AI Guide
                </span>
                <span className="text-[11px] text-slate-500">STAR Methodology</span>
              </div>
            </GlassCard>
          </div>

          {/* Card Back (AI Response) */}
          <div className="absolute inset-0 backface-hidden rotate-y-180">
            <GlassCard className="h-full p-7 flex flex-col justify-between border-emerald-500/30 shadow-2xl bg-gradient-to-br from-slate-900/95 via-slate-900/90 to-emerald-950/30">
              <div className="overflow-y-auto pr-1 space-y-3">
                <div className="flex items-center justify-between pb-2 border-b border-slate-800">
                  <span className="px-2.5 py-0.5 rounded-md text-[10px] font-bold bg-emerald-500/15 text-emerald-400 border border-emerald-500/30 uppercase tracking-wider">
                    AI Suggested Response
                  </span>
                  <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                </div>

                <div className="text-xs sm:text-sm text-slate-200 leading-relaxed whitespace-pre-line font-normal">
                  {currentQ.answer}
                </div>
              </div>

              <div className="pt-3 border-t border-slate-800 text-center text-xs text-slate-400">
                Click to return to question
              </div>
            </GlassCard>
          </div>
        </div>
      </div>

      {/* Navigation Buttons */}
      <div className="flex items-center justify-between pt-2">
        <button
          onClick={handlePrev}
          disabled={currentIndex === 0}
          className="px-4 py-2.5 rounded-xl bg-slate-800 text-slate-300 font-semibold text-xs border border-slate-700 hover:bg-slate-700 disabled:opacity-40 transition-all flex items-center gap-1.5 cursor-pointer"
        >
          <ChevronLeft className="w-4 h-4" />
          Previous Question
        </button>

        <button
          onClick={() => setIsFlipped(!isFlipped)}
          className="px-4 py-2 rounded-xl bg-slate-800/80 hover:bg-slate-700 text-slate-300 text-xs font-semibold border border-slate-700 flex items-center gap-1.5"
        >
          <RotateCw className="w-3.5 h-3.5" />
          Flip Card
        </button>

        <button
          onClick={handleNext}
          className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 text-white font-bold text-xs shadow-lg shadow-indigo-600/30 hover:opacity-95 transition-all flex items-center gap-1.5 cursor-pointer"
        >
          {currentIndex === interviewQuestions.length - 1 ? 'Finish Session' : 'Next Question'}
          <ChevronRight className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};
