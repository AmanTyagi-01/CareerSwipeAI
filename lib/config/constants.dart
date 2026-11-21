import 'package:flutter/material.dart';
import 'theme.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'CareerSwipe AI';
  static const String appTagline = 'Your AI Career Companion';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@careerswipe.ai';

  // API Endpoints
  static const String baseUrl = 'https://api.careerswipe.ai/v1';
  static const int apiTimeout = 30000; // milliseconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxResumeSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedResumeFormats = ['pdf', 'doc', 'docx'];
  static const int maxProfileImageSize = 5 * 1024 * 1024; // 5MB

  // Cache
  static const Duration cacheDuration = Duration(hours: 24);
  static const int maxCacheItems = 100;

  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int otpLength = 6;
  static const int maxBioLength = 500;
  static const int maxSkillsCount = 50;

  // UI
  static const double defaultPadding = 20.0;
  static const double smallPadding = 12.0;
  static const double largePadding = 32.0;
  static const double defaultRadius = 16.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 24.0;
  static const double cardElevation = 0.0;
  static const double maxContentWidth = 600.0;

  // Swipe
  static const double swipeThreshold = 0.3;
  static const double swipeVelocity = 1000.0;
  static const int maxDailySwipes = 100;

  // ATS Score Thresholds
  static const double excellentScore = 85.0;
  static const double goodScore = 70.0;
  static const double averageScore = 50.0;

  static Color getScoreColor(double score) {
    if (score >= excellentScore) return AppTheme.successColor;
    if (score >= goodScore) return AppTheme.warningColor;
    if (score >= averageScore) return AppTheme.infoColor;
    return AppTheme.errorColor;
  }

  static String getScoreLabel(double score) {
    if (score >= excellentScore) return 'Excellent';
    if (score >= goodScore) return 'Good';
    if (score >= averageScore) return 'Average';
    return 'Needs Improvement';
  }

  // Job Types
  static const List<String> jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Internship',
    'Remote',
  ];

  // Experience Levels
  static const List<String> experienceLevels = [
    'Entry Level',
    'Junior',
    'Mid-Level',
    'Senior',
    'Lead',
    'Executive',
  ];

  // Industries
  static const List<String> industries = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Marketing',
    'Design',
    'Engineering',
    'Sales',
    'Operations',
    'Human Resources',
    'Legal',
    'Media',
    'Consulting',
    'Manufacturing',
    'Retail',
  ];

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Please check your internet connection.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String fileTooLarge = 'File size exceeds the maximum limit.';
  static const String invalidFileFormat = 'Unsupported file format.';
  static const String emptyField = 'This field is required.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPassword =
      'Password must be at least 8 characters.';
  static const String passwordsDontMatch = 'Passwords do not match.';
  static const String invalidOTP = 'Please enter a valid 6-digit code.';
}
