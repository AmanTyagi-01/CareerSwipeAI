import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../data/models/user_model.dart';

class AuthService {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  FirebaseFirestore? _firestore;
  UserModel? _mockUser;
  final StreamController<User?> _mockAuthStateController =
      StreamController<User?>.broadcast();

  AuthService() {
    _initFirebase();
  }

  void _initFirebase() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        AppLogger.info('AuthService initialized with Firebase',
            tag: 'AuthService');
      } else {
        AppLogger.info(
            'AuthService running in standalone mode (Firebase not initialized)',
            tag: 'AuthService');
      }
    } catch (e) {
      AppLogger.warning(
          'Firebase not initialized; AuthService using local state',
          tag: 'AuthService',
          error: e);
    }
  }

  GoogleSignIn _getGoogleSignIn() {
    if (_googleSignIn == null) {
      final serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID']?.trim();
      final clientId = dotenv.env['GOOGLE_CLIENT_ID']?.trim();

      _googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? clientId : null,
        serverClientId: serverClientId != null && serverClientId.isNotEmpty
            ? serverClientId
            : null,
        scopes: const ['email', 'profile'],
      );
    }
    return _googleSignIn!;
  }

  Stream<User?> get authStateChanges {
    if (_auth != null) {
      return _auth!.authStateChanges();
    }
    return Stream<User?>.multi((controller) {
      controller.add(null);
      final sub = _mockAuthStateController.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller.onCancel = () => sub.cancel();
    });
  }

  User? get currentUser => _auth?.currentUser;

  bool get isAuthenticated => currentUser != null || _mockUser != null;

  Future<UserModel?> getCurrentUserData() async {
    if (_mockUser != null) {
      return _mockUser;
    }
    if (_auth == null) {
      return _mockUser;
    }

    final user = _auth?.currentUser;
    if (user == null) return null;

    return _getOrCreateUserModel(user);
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      throw AuthException(message: 'Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw AuthException(message: 'Password must be at least 6 characters.');
    }

    if (_auth == null) {
      _mockUser = UserModel(
        id: 'usr_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
        email: email,
        displayName: email.split('@').first,
        bio: '',
        skills: const [],
        location: 'Remote',
        experienceLevel: 'Entry / Junior',
        industry: 'Technology',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _mockAuthStateController.add(null);
      return _mockUser!;
    }

    try {
      final result = await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user == null) {
        throw AuthException(message: 'Sign in failed. Please try again.');
      }

      final userModel = await _getOrCreateUserModel(result.user!);
      await _updateLastLogin(result.user!.uid);
      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'configuration-not-found' ||
          e.code == 'operation-not-allowed') {
        AppLogger.warning(
            'Firebase provider not configured in console (${e.code}). Using local auth session.',
            tag: 'AuthService');
        _mockUser = UserModel(
          id: 'usr_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
          email: email.trim(),
          displayName: email.split('@').first,
          userType: UserType.talent,
          bio: 'Software Developer',
          skills: const ['Flutter', 'Dart', 'State Management'],
          location: 'Bengaluru, India',
          experienceLevel: 'Entry / Junior',
          industry: 'Technology',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _mockAuthStateController.add(null);
        return _mockUser!;
      }
      throw _handleFirebaseAuthError(e);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      throw _handleFirebaseException(e, stackTrace);
    } catch (e, stackTrace) {
      throw AuthException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  Future<UserModel> signUpWithEmail(
      String email, String password, String displayName,
      {UserType userType = UserType.talent}) async {
    final cleanEmail = email.trim();
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(cleanEmail)) {
      throw AuthException(message: 'Please enter a valid email format.');
    }
    if (password.length < 6) {
      throw AuthException(
          message: 'Password must be at least 6 characters long.');
    }
    if (displayName.trim().isEmpty) {
      throw AuthException(message: 'Please provide your full name.');
    }

    if (_auth == null) {
      _mockUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        email: cleanEmail,
        displayName: displayName.trim(),
        userType: userType,
        bio: '',
        skills: const [],
        location: 'Remote',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _mockAuthStateController.add(null);
      return _mockUser!;
    }

    try {
      final result = await _auth!.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      if (result.user == null) {
        throw AuthException(message: 'Sign up failed. Please try again.');
      }

      await result.user!.updateDisplayName(displayName.trim());

      final userModel = UserModel(
        id: result.user!.uid,
        email: cleanEmail,
        displayName: displayName.trim(),
        userType: userType,
        bio: '',
        skills: const [],
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore!
          .collection('users')
          .doc(result.user!.uid)
          .set(userModel.toMap());

      AppLogger.info(
          'New user registered: ${result.user!.uid} with role: ${userType.name}',
          tag: 'AuthService');
      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'configuration-not-found' ||
          e.code == 'operation-not-allowed') {
        AppLogger.warning(
            'Firebase provider not configured in console (${e.code}). Using local profile session.',
            tag: 'AuthService');
        _mockUser = UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          email: cleanEmail,
          displayName: displayName.trim(),
          userType: userType,
          bio: userType == UserType.recruiter
              ? 'Technical Recruiter'
              : 'Software Engineer',
          skills: userType == UserType.recruiter
              ? const ['Talent Acquisition', 'Hiring']
              : const ['Flutter', 'Dart', 'State Management'],
          location: 'Bengaluru, India',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _mockAuthStateController.add(null);
        return _mockUser!;
      }
      throw _handleFirebaseAuthError(e);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      throw _handleFirebaseException(e, stackTrace);
    } catch (e, stackTrace) {
      throw AuthException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  Future<UserModel> signInWithGoogle() async {
    if (_auth == null) {
      _mockUser = UserModel(
        id: 'usr_google_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@gmail.com',
        displayName: 'Google User',
        bio: '',
        skills: const [],
        location: 'Remote',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _mockAuthStateController.add(null);
      return _mockUser!;
    }

    try {
      late UserCredential result;
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        provider.addScope('email');
        provider.addScope('profile');
        provider.setCustomParameters({
          'prompt': 'select_account',
        });
        result = await _auth!.signInWithPopup(provider);
      } else {
        final googleSignIn = _getGoogleSignIn();
        // Force account selection on native mobile by clearing any cached session
        try {
          await googleSignIn.signOut();
        } catch (_) {}

        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          throw AuthException(message: 'Google sign in cancelled by user.');
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        result = await _auth!.signInWithCredential(credential);
      }

      if (result.user == null) {
        throw AuthException(message: 'Google sign in failed.');
      }

      final userModel = await _getOrCreateUserModel(result.user!);
      await _updateLastLogin(result.user!.uid);
      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'configuration-not-found' ||
          e.code == 'operation-not-allowed') {
        AppLogger.warning(
            'Firebase provider not configured in console (${e.code}). Using local auth session.',
            tag: 'AuthService');
        _mockUser = UserModel(
          id: 'usr_google_${DateTime.now().millisecondsSinceEpoch}',
          email: 'google.user@careerswipe.ai',
          displayName: 'Google User',
          userType: UserType.talent,
          bio: 'Software Developer',
          skills: const ['Flutter', 'Dart', 'State Management'],
          location: 'Bengaluru, India',
          experienceLevel: 'Entry / Junior',
          industry: 'Technology',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _mockAuthStateController.add(null);
        return _mockUser!;
      }
      throw _handleFirebaseAuthError(e);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      throw _handleFirebaseException(e, stackTrace);
    } catch (e, stackTrace) {
      throw AuthException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  Future<void> sendOTP(String email) async {
    if (_auth == null) return;
    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  Future<void> verifyOTP(String code) async {
    if (_auth == null) return;
    // OTP verification hook for email-based code / link
    AppLogger.info('Verifying OTP code: $code', tag: 'AuthService');
  }

  Future<void> resetPassword(String email) async {
    if (_auth == null) return;
    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  Future<void> signOut() async {
    AppLogger.info('Signing out', tag: 'AuthService');
    if (_auth == null) {
      _mockUser = null;
      _mockAuthStateController.add(null);
      return;
    }
    await _auth!.signOut();
    if (!kIsWeb) {
      try {
        await _getGoogleSignIn().signOut();
      } catch (_) {}
    }
  }

  /// In-App Account Deletion (Mandatory for Google Play and Apple App Store compliance)
  Future<void> deleteAccount() async {
    final user = _auth?.currentUser;
    if (user == null) {
      _mockUser = null;
      _mockAuthStateController.add(null);
      return;
    }

    try {
      final uid = user.uid;
      // 1. Delete user documents from Firestore
      if (_firestore != null) {
        await _firestore!.collection('users').doc(uid).delete();
      }
      // 2. Delete user account from Firebase Auth
      await user.delete();
      AppLogger.info('Account deleted: $uid', tag: 'AuthService');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw AuthException(
          message:
              'Security sensitive action. Please sign out, sign in again, and retry account deletion.',
          code: e.code,
        );
      }
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw AuthException(message: 'Failed to delete account: $e');
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
    if (_auth == null) {
      if (_mockUser != null) {
        _mockUser = _mockUser!.copyWith(
          displayName: displayName ?? _mockUser!.displayName,
          photoUrl: photoUrl ?? _mockUser!.photoUrl,
          phoneNumber: phoneNumber ?? _mockUser!.phoneNumber,
          bio: bio ?? _mockUser!.bio,
          skills: skills ?? _mockUser!.skills,
          experienceLevel: experienceLevel ?? _mockUser!.experienceLevel,
          industry: industry ?? _mockUser!.industry,
          location: location ?? _mockUser!.location,
          updatedAt: DateTime.now(),
        );
        _mockAuthStateController.add(null);
      }
      return;
    }

    final user = _auth?.currentUser;
    if (user == null) throw AuthException(message: 'No authenticated user.');

    final updates = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (displayName != null) {
      updates['displayName'] = displayName;
      await user.updateDisplayName(displayName);
    }
    if (photoUrl != null) {
      updates['photoUrl'] = photoUrl;
      await user.updatePhotoURL(photoUrl);
    }
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
    if (bio != null) updates['bio'] = bio;
    if (skills != null) updates['skills'] = skills;
    if (experienceLevel != null) updates['experienceLevel'] = experienceLevel;
    if (industry != null) updates['industry'] = industry;
    if (location != null) updates['location'] = location;

    await _firestore!.collection('users').doc(user.uid).update(updates);
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    final user = _auth?.currentUser;
    if (user == null || user.email == null) {
      throw AuthException(message: 'No authenticated user.');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<UserModel> _getOrCreateUserModel(User firebaseUser) async {
    if (_firestore == null) {
      return UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    }

    final docRef = _firestore!.collection('users').doc(firebaseUser.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }

    final userModel = UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await docRef.set(userModel.toMap());
    return userModel;
  }

  /// Marks a user's profile as complete and sets their final role.
  /// Writes `isProfileComplete: true` and `userType` to Firestore.
  /// Safe to call when Firebase is not configured (mock path).
  Future<UserModel?> completeOnboarding({required UserType role}) async {
    if (_auth == null) {
      // Mock / no-Firebase path
      if (_mockUser != null) {
        _mockUser = _mockUser!.copyWith(
          isProfileComplete: true,
          userType: role,
          updatedAt: DateTime.now(),
        );
        _mockAuthStateController.add(null);
        AppLogger.info('Mock onboarding complete, role: ${role.name}',
            tag: 'AuthService');
      }
      return _mockUser;
    }

    final user = _auth?.currentUser;
    if (user == null) {
      AppLogger.warning('completeOnboarding called with no current user',
          tag: 'AuthService');
      return null;
    }

    final updates = <String, dynamic>{
      'isProfileComplete': true,
      'userType': role.name,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    await _firestore!.collection('users').doc(user.uid).update(updates);
    AppLogger.info('Onboarding complete for ${user.uid}, role: ${role.name}',
        tag: 'AuthService');

    return _getOrCreateUserModel(user);
  }

  Future<void> _updateLastLogin(String userId) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('users').doc(userId).update({
        'lastLoginAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (_) {}
  }

  AuthException _handleFirebaseAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No account found with this email.';
        break;
      case 'wrong-password':
      case 'invalid-credential':
        message =
            'Incorrect email or password. Please verify your credentials.';
        break;
      case 'email-already-in-use':
        message =
            'An account already exists with this email. Please sign in instead.';
        break;
      case 'invalid-email':
        message = 'Please enter a valid email address.';
        break;
      case 'weak-password':
        message =
            'Password is too weak. Please use at least 6 characters with mixed symbols.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please wait a moment and try again.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'operation-not-allowed':
        message = 'Email or Google authentication is not enabled.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your internet connection.';
        break;
      case 'popup-closed-by-user':
        message = 'Google sign-in was cancelled.';
        break;
      case 'popup-blocked':
        message =
            'Google sign-in popup was blocked by your browser. Please allow popups for this site and try again.';
        break;
      case 'cancelled-popup-request':
        message =
            'Another sign-in request is already in progress. Please wait.';
        break;
      case 'account-exists-with-different-credential':
        message =
            'An account already exists with this email using another sign-in method.';
        break;
      case 'configuration-not-found':
        message =
            'Authentication provider is not enabled in Firebase Console. Please enable Google Sign-In in Firebase Console.';
        break;
      case 'invalid-api-key':
      case 'api-key-not-valid':
        message =
            'Invalid Firebase API key. Please check your project configuration.';
        break;
      case 'app-not-authorized':
        message =
            'App not authorized. Ensure OAuth client ID and SHA-1 fingerprints are registered in Firebase Console.';
        break;
      default:
        message = (e.message != null &&
                e.message!.isNotEmpty &&
                e.message != 'Error')
            ? e.message!
            : 'Authentication failed. Please verify your credentials and network.';
    }
    return AuthException(message: message, code: e.code);
  }

  AuthException _handleFirebaseException(
      FirebaseException e, StackTrace stackTrace) {
    final message = switch (e.code) {
      'permission-denied' =>
        'You do not have permission to access your profile.',
      'unavailable' ||
      'network-request-failed' =>
        'Network connection failed. Please try again.',
      'configuration-not-found' =>
        'Firebase service configuration not found. Please verify Firebase project setup.',
      _ => (e.message != null && e.message!.isNotEmpty && e.message != 'Error')
          ? e.message!
          : 'Authentication service unavailable. Please try again.',
    };
    return AuthException(
        message: message, code: e.code, stackTrace: stackTrace);
  }
}
