# CareerSwipe AI

## AI-Powered Career & Job Discovery Platform

CareerSwipe AI is a next-generation mobile application that transforms the traditional hiring experience into a smarter, faster, and more engaging ecosystem. The app combines advanced resume intelligence, ATS optimization, and Tinder-style job discovery within one unified platform.

---

## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Architecture](#architecture)
4. [Getting Started](#getting-started)
5. [Firebase Setup](#firebase-setup)
6. [Environment Variables](#environment-variables)
7. [Running the App](#running-the-app)
8. [Building APK](#building-apk)
9. [Project Structure](#project-structure)
10. [API Documentation](#api-documentation)
11. [Screenshots](#screenshots)
12. [Contributing](#contributing)
13. [License](#license)

---

## Features

### Core Features
- **AI Resume Analysis**: Upload PDF resumes and receive instant AI-driven insights on ATS compatibility, keyword relevance, formatting quality, and professional presentation
- **Swipe-Based Job Discovery**: Browse opportunities using intuitive left/right swipe gestures (like, save, reject)
- **Interactive Analysis Dashboard**: View ATS scores, resume match percentages, keyword alignment, and optimization insights
- **Career Intelligence**: Get personalized career recommendations, salary insights, and skill gap analysis

### Authentication
- Email/Password registration and login
- Google Sign-In integration
- OTP verification
- Password reset functionality
- Biometric authentication support

### Resume Management
- PDF, DOC, DOCX file upload support
- AI-powered text extraction and analysis
- Resume score tracking over time
- Multiple resume management
- Cloud storage via Firebase Storage

### Job Discovery
- Swipe-based job browsing
- Advanced filtering (industry, experience level, job type, location, remote)
- Job matching algorithm based on skills
- Save and apply to jobs
- Application tracking with status updates
- Real-time notifications for job matches

### Profile Management
- Complete user profile with skills, experience, and preferences
- Profile photo upload
- Professional bio
- Location and contact information
- Privacy and security settings

### Admin Dashboard
- Platform analytics and user statistics
- Job posting management
- User growth charts
- Application tracking
- System notifications

### UI/UX
- Premium dark-mode aesthetics
- Glassmorphism-inspired UI components
- Animated backgrounds with particles
- Smooth transitions and micro-interactions
- Responsive layouts for all screen sizes
- Material Design 3 compliance

---

## Tech Stack

### Frontend
- **Flutter** (SDK >= 3.0.0) - Cross-platform framework
- **Dart** - Programming language
- **flutter_riverpod** - State management
- **go_router** - Navigation and routing
- **flutter_animate** - Animations
- **glassmorphism** - Glass UI effects
- **fl_chart** - Data visualization
- **flutter_card_swiper** - Swipe cards
- **lottie** - Complex animations
- **shimmer** - Loading skeletons

### Backend
- **Firebase** - Backend-as-a-Service
  - **Firebase Auth** - Authentication
  - **Cloud Firestore** - NoSQL database
  - **Firebase Storage** - File storage
  - **Firebase Cloud Messaging** - Push notifications
  - **Firebase Analytics** - App analytics
  - **Firebase Crashlytics** - Crash reporting
- **Firebase Cloud Functions** - Serverless backend
  - Node.js 18
  - OpenAI GPT-4 integration
  - Job matching algorithms
  - Notification dispatch

### AI/ML
- **OpenAI GPT-4** - Resume analysis and career recommendations
- **Google Gemini** - Alternative AI engine
- Custom NLP pipelines for keyword extraction and matching

### DevOps
- **Git** - Version control
- **Firebase CLI** - Deployment
- **Gradle** - Android build system
- **Xcode** - iOS build system

---

## Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
  config/           # App configuration (theme, routes, constants)
  core/             # Core utilities and error handling
    errors/         # Custom exceptions and failures
    utils/          # Utility functions and helpers
  data/             # Data layer
    models/         # Data models (User, Job, Resume, etc.)
    repositories/   # Data repositories
    datasources/    # Data sources (local, remote)
  domain/           # Domain layer (business logic)
    entities/       # Domain entities
    repositories/   # Repository contracts
  presentation/     # Presentation layer (UI)
    providers/      # Riverpod state management
    screens/        # UI screens
      auth/         # Authentication screens
      home/         # Home and dashboard
      resume/       # Resume management
      jobs/         # Job discovery
      profile/      # User profile
      admin/        # Admin dashboard
    widgets/        # Reusable UI components
      common/       # Common widgets (glass cards, buttons, etc.)
      resume/       # Resume-specific widgets
      jobs/         # Job-specific widgets
  services/         # External services (Auth, AI, Jobs, etc.)
```

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode (for emulators)
- Firebase account
- OpenAI API key (for AI features)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/career-swipe-ai.git
   cd career-swipe-ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables** (see [Environment Variables](#environment-variables))

4. **Run the app**
   ```bash
   flutter run
   ```

---

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named `career-swipe-ai`
3. Enable the following services:
   - Authentication (Email/Password, Google)
   - Cloud Firestore
   - Firebase Storage
   - Firebase Cloud Messaging
   - Firebase Analytics
   - Firebase Crashlytics

### 2. Register Apps

**Android:**
- Package name: `com.careerswipe.ai`
- Download `google-services.json`
- Place in `android/app/`

**iOS:**
- Bundle ID: `com.careerswipe.ai`
- Download `GoogleService-Info.plist`
- Place in `ios/Runner/`

### 3. Firebase Cloud Functions

```bash
cd functions
npm install
firebase deploy --only functions
```

### 4. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null && request.auth.uid == userId;
      allow delete: if false;
    }

    // Resumes collection
    match /resumes/{resumeId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null && resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }

    // Jobs collection
    match /jobs/{jobId} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }

    // Applications collection
    match /applications/{applicationId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }

    // Notifications collection
    match /notifications/{notificationId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create, update, delete: if false;
    }

    // Swipes collection
    match /swipes/{swipeId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if false;
    }
  }
}
```

### 5. Firebase Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /resumes/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    match /profile_photos/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## Environment Variables

Create a `.env` file in the project root:

```env
# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MEASUREMENT_ID=your_measurement_id

# AI Services
OPENAI_API_KEY=your_openai_api_key
GEMINI_API_KEY=your_gemini_api_key

# Cloud Functions
CLOUD_FUNCTIONS_URL=https://us-central1-your-project.cloudfunctions.net

# App Config
APP_NAME=CareerSwipe AI
APP_VERSION=1.0.0
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true

# API Endpoints
RESUME_ANALYZE_ENDPOINT=/analyzeResume
JOB_MATCH_ENDPOINT=/matchJobs
AI_RECOMMEND_ENDPOINT=/recommendJobs
```

Use the values from Firebase Console -> Project settings -> Your apps -> Web app
for the `FIREBASE_*` entries. All Firebase values must belong to the same project;
do not use the Google OAuth client ID as the Firebase API key. The app validates
these values at startup and will stop with a configuration error if placeholders
are still present.

For Google sign-in on Flutter Web:

1. In Firebase Console -> Authentication -> Sign-in method, enable Google.
2. In Authentication -> Settings -> Authorized domains, add `localhost` and the
  production domain used by the deployed app.
3. In Google Cloud Console, select the project shown in the Firebase project
  settings and verify that the automatically managed Web OAuth client exists.
  The Flutter Web app uses Firebase Auth's popup flow, so no client ID belongs
  in `web/index.html`.

---

## Running the App

### Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run with hot reload
flutter run --hot

# Run in debug mode
flutter run --debug

# Run in profile mode (performance testing)
flutter run --profile

# Run on specific device
flutter run -d <device_id>
```

### iOS Simulator

```bash
# List available simulators
flutter emulators

# Launch iOS simulator
open -a Simulator

# Run on iOS simulator
flutter run -d ios
```

### Android Emulator

```bash
# List available emulators
flutter emulators

# Launch Android emulator
flutter emulators --launch <emulator_id>

# Run on Android emulator
flutter run -d android
```

---

## Building APK

### Debug APK

```bash
flutter build apk --debug
```

### Release APK

```bash
flutter build apk --release
```

### App Bundle (for Google Play Store)

```bash
flutter build appbundle --release
```

### iOS Release

```bash
flutter build ios --release
```

### Build with specific flavor

```bash
flutter build apk --flavor production --release
```

The built APK will be located at:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

---

## Project Structure

```
career_swipe_ai/
  android/                    # Android-specific code
    app/
      src/
        main/
          kotlin/com/careerswipe/ai/
            MainActivity.kt   # Android entry point
          res/
            drawable/         # Launch backgrounds
            values/           # Themes and styles
            xml/              # Network security config
  ios/                        # iOS-specific code
    Runner/
      AppDelegate.swift       # iOS entry point
      Info.plist              # iOS configuration
  lib/                        # Main Dart code
    config/                   # App configuration
      theme.dart              # Theme definitions
      routes.dart             # Navigation routes
      constants.dart          # App constants
    core/                     # Core utilities
      errors/
        exceptions.dart       # Custom exceptions
      utils/
        app_utils.dart        # Utility functions
    data/                     # Data layer
      models/
        user_model.dart       # User data model
        job_model.dart        # Job data model
        resume_model.dart     # Resume data model
        notification_model.dart # Notification model
    domain/                   # Domain layer
      entities/
      repositories/
    presentation/             # UI layer
      providers/
        auth_provider.dart    # Auth state management
        resume_provider.dart  # Resume state management
        job_provider.dart     # Job state management
        notification_provider.dart # Notification state management
      screens/
        auth/
          splash_screen.dart
          onboarding_screen.dart
          login_screen.dart
          signup_screen.dart
          otp_screen.dart
          forgot_password_screen.dart
        home/
          home_screen.dart
          dashboard_screen.dart
        resume/
          resume_upload_screen.dart
          resume_analysis_screen.dart
        jobs/
          job_swipe_screen.dart
          job_details_screen.dart
          saved_jobs_screen.dart
          applied_jobs_screen.dart
        profile/
          profile_screen.dart
          edit_profile_screen.dart
          settings_screen.dart
          notifications_screen.dart
        admin/
          admin_dashboard_screen.dart
      widgets/
        common/
          glass_card.dart     # Glassmorphism card widget
          animated_background.dart # Animated particle background
          loading_indicator.dart # Loading widgets
          custom_buttons.dart # Custom button components
        resume/               # Resume-specific widgets
        jobs/                 # Job-specific widgets
    services/                 # External services
      auth_service.dart       # Authentication service
      resume_service.dart     # Resume upload/service
      job_service.dart        # Job data service
      ai_service.dart         # AI analysis service
      notification_service.dart # Push notification service
  functions/                  # Firebase Cloud Functions
    src/
      index.js               # Cloud Functions entry point
    package.json             # Node.js dependencies
  assets/                     # Static assets
    images/                   # Image assets
    animations/               # Lottie animations
    fonts/                    # Custom fonts
  test/                       # Unit and widget tests
    auth_provider_test.dart
    login_screen_test.dart
    resume_upload_test.dart
    utils_test.dart
  pubspec.yaml                # Flutter dependencies
  analysis_options.yaml        # Dart analysis configuration
  .env                        # Environment variables (not in git)
  .gitignore                  # Git ignore rules
  README.md                   # This file
```

---

## API Documentation

### Authentication APIs

#### Sign Up with Email
```dart
await authNotifier.signUpWithEmail(email, password, displayName);
```

#### Sign In with Email
```dart
await authNotifier.signInWithEmail(email, password);
```

#### Sign In with Google
```dart
await authNotifier.signInWithGoogle();
```

#### Sign Out
```dart
await authNotifier.signOut();
```

### Resume APIs

#### Upload Resume
```dart
final resume = await resumeNotifier.uploadResume(userId, file);
```

#### Analyze Resume
```dart
final analysis = await aiService.analyzeResume(resume);
```

#### Get User Resumes
```dart
final resumes = await resumeService.getUserResumes(userId);
```

### Job APIs

#### Get Jobs
```dart
final jobs = await jobService.getJobs(
  industry: 'Technology',
  experienceLevel: 'Senior',
  jobType: 'Full-time',
);
```

#### Record Swipe
```dart
await jobService.recordSwipe(userId, jobId, 'like');
```

#### Apply for Job
```dart
await jobService.applyForJob(userId, jobId, coverLetter: '...');
```

#### Save Job
```dart
await jobService.saveJob(userId, jobId);
```

### AI APIs

#### Get Career Recommendations
```dart
final recommendations = await aiService.getCareerRecommendations(userId);
```

#### Match Jobs
```dart
final matches = await aiService.matchJobs(userId, skills, experienceLevel);
```

---

## Screenshots

### Splash Screen
Modern animated splash screen with brand logo and tagline.

### Onboarding
Multi-page onboarding with feature highlights and smooth transitions.

### Login/Signup
Clean authentication forms with email/password and Google Sign-In.

### Dashboard
Interactive dashboard with resume health, job match trends, and activity feed.

### Resume Upload
Drag-and-drop resume upload with AI analysis progress indicators.

### Resume Analysis
Detailed analysis dashboard with scores, skills, and improvement suggestions.

### Job Swipe
Tinder-style job discovery with swipe gestures and job cards.

### Job Details
Comprehensive job details with requirements, salary, and apply functionality.

### Profile
User profile with stats, skills, and navigation to settings.

### Admin Dashboard
Analytics dashboard with user growth charts and platform statistics.

---

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` before committing
- Write tests for new features
- Document public APIs

### Commit Messages
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests where appropriate

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Support

For support, email support@careerswipe.ai or join our Slack channel.

For bug reports and feature requests, please use the [GitHub Issues](https://github.com/your-org/career-swipe-ai/issues) page.

---

## Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Firebase](https://firebase.google.com/) - Backend services
- [OpenAI](https://openai.com/) - AI/ML capabilities
- [Riverpod](https://riverpod.dev/) - State management
- [Go Router](https://pub.dev/packages/go_router) - Navigation
- All open-source contributors

---

## Roadmap

### Version 1.1.0
- [ ] LinkedIn profile import
- [ ] Job application tracking with email integration
- [ ] In-app messaging with recruiters
- [ ] Dark/light mode toggle
- [ ] Multi-language support (i18n)

### Version 1.2.0
- [ ] AI-powered cover letter generator
- [ ] Interview preparation module
- [ ] Salary negotiation assistant
- [ ] Company culture matching
- [ ] Networking features

### Version 2.0.0
- [ ] Recruiter portal
- [ ] Company profiles and reviews
- [ ] Video resumes
- [ ] AI interview scheduling
- [ ] Premium subscription tier

---

**Built with love by the CareerSwipe AI Team** ❤️
