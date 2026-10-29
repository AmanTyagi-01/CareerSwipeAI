import React from 'react';
import { useApp } from './context/AppContext';
import { Navbar } from './components/layout/Navbar';
import { BottomNav } from './components/layout/BottomNav';
import { Toast } from './components/common/Toast';
import { AuthModal } from './components/auth/AuthModal';
import { AnimatedBackground } from './components/common/AnimatedBackground';

// Screens
import { DashboardScreen } from './screens/DashboardScreen';
import { JobSwipeScreen } from './screens/JobSwipeScreen';
import { JobDetailsScreen } from './screens/JobDetailsScreen';
import { SavedJobsScreen } from './screens/SavedJobsScreen';
import { AppliedJobsScreen } from './screens/AppliedJobsScreen';
import { ResumeUploadScreen } from './screens/ResumeUploadScreen';
import { ResumeAnalysisScreen } from './screens/ResumeAnalysisScreen';
import { SkillGapScreen } from './screens/SkillGapScreen';
import { InterviewPrepScreen } from './screens/InterviewPrepScreen';
import { PdfPreviewScreen } from './screens/PdfPreviewScreen';
import { ProfileScreen } from './screens/ProfileScreen';
import { NotificationsScreen } from './screens/NotificationsScreen';
import { AdminDashboardScreen } from './screens/AdminDashboardScreen';

export const App: React.FC = () => {
  const { currentRoute } = useApp();

  const renderCurrentScreen = () => {
    if (currentRoute === '/jobs/swipe') {
      return <JobSwipeScreen />;
    }
    if (currentRoute.startsWith('/jobs/details/')) {
      return <JobDetailsScreen />;
    }
    if (currentRoute === '/jobs/saved') {
      return <SavedJobsScreen />;
    }
    if (currentRoute === '/jobs/applied') {
      return <AppliedJobsScreen />;
    }
    if (currentRoute === '/resume/upload') {
      return <ResumeUploadScreen />;
    }
    if (currentRoute === '/resume/analysis') {
      return <ResumeAnalysisScreen />;
    }
    if (currentRoute === '/resume/skill-gap') {
      return <SkillGapScreen />;
    }
    if (currentRoute === '/resume/interview-prep') {
      return <InterviewPrepScreen />;
    }
    if (currentRoute === '/resume/pdf-preview') {
      return <PdfPreviewScreen />;
    }
    if (currentRoute === '/profile') {
      return <ProfileScreen />;
    }
    if (currentRoute === '/profile/notifications') {
      return <NotificationsScreen />;
    }
    if (currentRoute === '/admin') {
      return <AdminDashboardScreen />;
    }
    // Default to Dashboard
    return <DashboardScreen />;
  };

  return (
    <AnimatedBackground>
      <Navbar />
      <main className="flex-1 pb-24 md:pb-12">
        {renderCurrentScreen()}
      </main>
      <BottomNav />
      <Toast />
      <AuthModal />
    </AnimatedBackground>
  );
};
