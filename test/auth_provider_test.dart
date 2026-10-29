import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:career_swipe_ai/services/auth_service.dart';
import 'package:career_swipe_ai/presentation/providers/auth_provider.dart';
import 'package:career_swipe_ai/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthService extends Fake implements AuthService {
  StreamController<User?> authStateController = StreamController<User?>.broadcast();
  UserModel? mockUser;
  bool signOutCalled = false;
  bool throwOnSignIn = false;

  @override
  Stream<User?> get authStateChanges => authStateController.stream;

  @override
  User? get currentUser => null;

  @override
  Future<UserModel?> getCurrentUserData() async => mockUser;

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    if (throwOnSignIn) {
      throw Exception('Invalid credentials');
    }
    if (mockUser != null) {
      return mockUser!;
    }
    return UserModel(id: 'mock-id', email: email, displayName: 'Mock User');
  }

  @override
  Future<UserModel> signUpWithEmail(
      String email, String password, String displayName,
      {UserType userType = UserType.talent}) async {
    return UserModel(id: 'new-id', email: email, displayName: displayName, userType: userType);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    if (mockUser != null) return mockUser!;
    throw Exception('Google sign in failed');
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }
}

void main() {
  group('AuthNotifier Tests', () {
    late FakeAuthService fakeAuthService;
    late ProviderContainer container;

    setUp(() {
      fakeAuthService = FakeAuthService();
      container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(fakeAuthService),
        ],
      );
    });

    tearDown(() {
      fakeAuthService.authStateController.close();
      container.dispose();
    });

    test('initial state is loading', () {
      final authNotifier = container.read(authNotifierProvider);
      expect(authNotifier.isLoading, true);
    });

    test('signInWithEmail updates state on success', () async {
      const testUser = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        displayName: 'Test User',
      );
      fakeAuthService.mockUser = testUser;

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signInWithEmail('test@example.com', 'password123');

      final state = container.read(authNotifierProvider);
      expect(state.value, equals(testUser));
    });

    test('signInWithEmail updates state on failure', () async {
      fakeAuthService.throwOnSignIn = true;

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signInWithEmail('test@example.com', 'wrong');

      final state = container.read(authNotifierProvider);
      expect(state.hasError, true);
    });

    test('signUpWithEmail creates candidate user correctly', () async {
      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signUpWithEmail(
        'candidate@example.com',
        'password123',
        'Candidate Name',
        userType: UserType.talent,
      );

      final state = container.read(authNotifierProvider);
      expect(state.value?.userType, UserType.talent);
      expect(state.value?.email, 'candidate@example.com');
    });

    test('signUpWithEmail creates recruiter user correctly', () async {
      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signUpWithEmail(
        'recruiter@company.com',
        'password123',
        'Recruiter Name',
        userType: UserType.recruiter,
      );

      final state = container.read(authNotifierProvider);
      expect(state.value?.userType, UserType.recruiter);
      expect(state.value?.email, 'recruiter@company.com');
    });

    test('signOut clears user state', () async {
      fakeAuthService.mockUser = null;

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signOut();

      final state = container.read(authNotifierProvider);
      expect(state.value, isNull);
      expect(fakeAuthService.signOutCalled, true);
    });
  });
}
