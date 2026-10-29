import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'core/utils/logger.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    AppLogger.warning('Could not load .env file', tag: 'main', error: e);
  }

  final firebaseApiKey = dotenv.env['FIREBASE_API_KEY']?.trim();
  final hasValidFirebase = firebaseApiKey != null &&
      firebaseApiKey.isNotEmpty &&
      !firebaseApiKey.startsWith('your_');

  if (hasValidFirebase && Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: _requiredFirebaseConfig('FIREBASE_API_KEY'),
          appId: _requiredFirebaseConfig('FIREBASE_APP_ID'),
          messagingSenderId: _requiredFirebaseConfig('FIREBASE_MESSAGING_SENDER_ID'),
          projectId: _requiredFirebaseConfig('FIREBASE_PROJECT_ID'),
          authDomain: _requiredFirebaseConfig('FIREBASE_AUTH_DOMAIN'),
          storageBucket: _requiredFirebaseConfig('FIREBASE_STORAGE_BUCKET'),
          measurementId: _optionalFirebaseConfig('FIREBASE_MEASUREMENT_ID'),
        ),
      );
      AppLogger.info('Firebase initialized successfully', tag: 'main');
    } catch (e) {
      AppLogger.warning('Firebase initialization failed (falling back to demo mode)', tag: 'main', error: e);
    }
  } else {
    AppLogger.info('Firebase not configured. Running in Demo mode.', tag: 'main');
  }

  // Initialize push notifications (non-blocking) only when Firebase is active
  if (Firebase.apps.isNotEmpty) {
    NotificationService().initialize().catchError((e) {
      AppLogger.warning('Notification service init failed (non-fatal)', tag: 'main', error: e);
    });
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  AppLogger.info('App starting', tag: 'main');

  runApp(
    const ProviderScope(
      child: CareerSwipeApp(),
    ),
  );
}

String _requiredFirebaseConfig(String key) {
  final value = dotenv.env[key]?.trim();
  if (value == null || value.isEmpty || value.startsWith('your_')) {
    throw StateError(
      'Missing Firebase configuration: $key. Add the value from the Firebase Console Web app settings to .env.',
    );
  }
  return value;
}

String? _optionalFirebaseConfig(String key) {
  final value = dotenv.env[key]?.trim();
  if (value == null || value.isEmpty || value.startsWith('your_')) return null;
  return value;
}

class CareerSwipeApp extends ConsumerWidget {
  const CareerSwipeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CareerSwipe AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
