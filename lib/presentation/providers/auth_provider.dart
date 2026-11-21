import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import '../../core/utils/logger.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final selectedUserTypeProvider =
    StateProvider<UserType>((ref) => UserType.talent);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
});

final authProvider = StreamProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges.asyncMap((firebaseUser) async {
    if (firebaseUser == null) return null;
    return await repo.getCurrentUserData();
  });
});

final currentUserProvider = Provider<AsyncValue<UserModel?>>((ref) {
  return ref.watch(authProvider);
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;
  StreamSubscription<dynamic>? _authSubscription;
  bool _operationInProgress = false;

  AuthNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _authSubscription = _authRepository.authStateChanges.listen(
      (firebaseUser) async {
        if (firebaseUser == null) {
          AppLogger.info('Auth state: signed out', tag: 'AuthNotifier');
          state = const AsyncValue.data(null);
        } else {
          try {
            final userData = await _authRepository.getCurrentUserData();
            AppLogger.info('Auth state: signed in as ${firebaseUser.uid}',
                tag: 'AuthNotifier');
            state = AsyncValue.data(userData);
          } catch (e, stackTrace) {
            AppLogger.error('Failed to load user data',
                tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
            state = AsyncValue.error(e, stackTrace);
          }
        }
      },
      onError: (Object e, StackTrace stackTrace) {
        AppLogger.error('Auth stream error',
            tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
        state = AsyncValue.error(e, stackTrace);
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (_operationInProgress) return;
    _operationInProgress = true;
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      AppLogger.error('Sign in failed',
          tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _operationInProgress = false;
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String displayName,
      {UserType userType = UserType.talent}) async {
    if (_operationInProgress) return;
    _operationInProgress = true;
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository
          .signUpWithEmail(email, password, displayName, userType: userType);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      AppLogger.error('Sign up failed',
          tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _operationInProgress = false;
    }
  }

  Future<void> signInWithGoogle() async {
    if (_operationInProgress) return;
    _operationInProgress = true;
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      AppLogger.error('Google sign-in failed',
          tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _operationInProgress = false;
    }
  }

  /// Marks onboarding complete and sets the user's final role in Firestore.
  /// Updates local state so the router redirect fires immediately.
  Future<void> completeOnboarding({required UserType role}) async {
    try {
      final updatedUser = await _authRepository.completeOnboarding(role: role);
      state = AsyncValue.data(updatedUser);
      AppLogger.info('AuthNotifier: onboarding complete, role=${role.name}',
          tag: 'AuthNotifier');
    } catch (e, stackTrace) {
      AppLogger.error('completeOnboarding failed',
          tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    if (_operationInProgress) return;
    _operationInProgress = true;
    state = const AsyncValue.loading();
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      AppLogger.error('Sign out failed',
          tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _operationInProgress = false;
    }
  }

  Future<void> updateRole(UserType newRole) async {
    try {
      final current = state.value;
      if (current != null) {
        final updated = current.copyWith(userType: newRole);
        state = AsyncValue.data(updated);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Role update failed',
          tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    List<String>? skills,
    String? experienceLevel,
    String? industry,
    String? location,
  }) async {
    try {
      await _authRepository.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        bio: bio,
        skills: skills,
        experienceLevel: experienceLevel,
        industry: industry,
        location: location,
      );
      final userData = await _authRepository.getCurrentUserData();
      state = AsyncValue.data(userData);
      AppLogger.info('Profile updated', tag: 'AuthNotifier');
    } catch (e, stackTrace) {
      AppLogger.error('Profile update failed',
          tag: 'AuthNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
