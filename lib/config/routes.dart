import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/auth/onboarding_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/auth/otp_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/home/dashboard_screen.dart';
import '../presentation/screens/resume/resume_upload_screen.dart';
import '../presentation/screens/resume/resume_analysis_screen.dart';
import '../presentation/screens/resume/skill_gap_screen.dart';
import '../presentation/screens/resume/interview_prep_screen.dart';
import '../presentation/screens/resume/pdf_preview_screen.dart';
import '../presentation/screens/jobs/job_swipe_screen.dart';
import '../presentation/screens/jobs/job_details_screen.dart';
import '../presentation/screens/jobs/saved_jobs_screen.dart';
import '../presentation/screens/jobs/applied_jobs_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/profile/edit_profile_screen.dart';
import '../presentation/screens/profile/settings_screen.dart';
import '../presentation/screens/profile/notifications_screen.dart';
import '../presentation/screens/admin/admin_dashboard_screen.dart';
import '../presentation/providers/auth_provider.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.read(authServiceProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(
      authService.authStateChanges
    ),
    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
          
      final isAuthRoute = state.matchedLocation.startsWith('/auth') || 
                          state.matchedLocation == '/';

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login';
      }

      if (isAuthenticated && isAuthRoute && state.matchedLocation != '/') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) {
          final email = state.extra as String?;
          return OtpScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/resume/upload',
        builder: (context, state) => const ResumeUploadScreen(),
      ),
      GoRoute(
        path: '/resume/analysis',
        builder: (context, state) {
          final analysisId = state.extra as String?;
          return ResumeAnalysisScreen(analysisId: analysisId ?? '');
        },
      ),
      GoRoute(
        path: '/resume/skill-gap',
        builder: (context, state) => const SkillGapScreen(),
      ),
      GoRoute(
        path: '/resume/interview-prep',
        builder: (context, state) => const InterviewPrepScreen(),
      ),
      GoRoute(
        path: '/resume/pdf-preview',
        builder: (context, state) => const PdfPreviewScreen(),
      ),
      GoRoute(
        path: '/jobs/swipe',
        builder: (context, state) => const JobSwipeScreen(),
      ),
      GoRoute(
        path: '/jobs/details/:id',
        builder: (context, state) {
          final jobId = state.pathParameters['id'] ?? '';
          return JobDetailsScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: '/jobs/saved',
        builder: (context, state) => const SavedJobsScreen(),
      ),
      GoRoute(
        path: '/jobs/applied',
        builder: (context, state) => const AppliedJobsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    ),
  );
});
