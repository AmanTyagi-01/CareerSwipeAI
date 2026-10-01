import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../data/models/user_model.dart';

class AuthService {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  FirebaseFirestore? _firestore;
  UserModel? _mockUser;
  final StreamController<User?> _mockAuthStateController = StreamController<User?>.broadcast();

  AuthService() {
    _initFirebase();
  }

  void _initFirebase() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        AppLogger.info('AuthService initialized with Firebase', tag: 'AuthService');
      } else {
        AppLogger.info('AuthService running in Demo mode (Firebase not initialized)', tag: 'AuthService');
      }
    } catch (e) {
      AppLogger.warning('Firebase not initialized; AuthService using Demo mode', tag: 'AuthService', error: e);
    }
  }

  GoogleSignIn _getGoogleSignIn() {
    _googleSignIn ??= GoogleSignIn();
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
    if (_auth == null) {
      return _mockUser;
    }

    final user = _auth?.currentUser;
    if (user == null) return null;

    return _getOrCreateUserModel(user);
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    if (_auth == null) {
      _mockUser = UserModel(
        id: 'mock-user-1',
        email: email.isNotEmpty ? email : 'alex.turner@example.com',
        displayName: email.contains('@') ? email.split('@').first : 'Alex Turner',
        bio: 'Senior Full Stack Engineer',
        skills: const ['Flutter', 'Dart', 'Firebase', 'Riverpod', 'Clean Architecture'],
        location: 'San Francisco, CA',
        experienceLevel: 'Senior (5+ yrs)',
        industry: 'Technology',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _mockAuthStateController.add(null);
      return _mockUser!;
    }

    try {
      final result = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw AuthException(message: 'Sign in failed. Please try again.');
      }

      final userModel = await _getOrCreateUserModel(result.user!);
      await _updateLastLogin(result.user!.uid);
      return userModel;
    } on FirebaseAuthException catch (e) {
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
      String email, String password, String displayName) async {
    if (_auth == null) {
      _mockUser = UserModel(
        id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: displayName.isNotEmpty ? displayName : 'New User',
        bio: 'Software Engineer',
        skills: const ['Flutter', 'Dart', 'Firebase'],
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
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw AuthException(message: 'Sign up failed. Please try again.');
      }

      await result.user!.updateDisplayName(displayName);

      final userModel = UserModel(
        id: result.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore!
          .collection('users')
          .doc(result.user!.uid)
          .set(userModel.toMap());

      AppLogger.info('New user registered: ${result.user!.uid}', tag: 'AuthService');
      return userModel;
    } on FirebaseAuthException catch (e) {
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
        id: 'mock-google-user',
        email: 'alex.turner@example.com',
        displayName: 'Alex Turner',
        bio: 'Senior Flutter & AI Engineer',
        skills: const ['Flutter', 'Dart', 'Python', 'Firebase', 'Clean Architecture'],
        location: 'San Francisco, CA',
        experienceLevel: 'Senior (5+ yrs)',
        industry: 'Technology',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
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
        result = await _auth!.signInWithPopup(provider);
      } else {
        final googleUser = await _getGoogleSignIn().signIn();
        if (googleUser == null) {
          throw AuthException(message: 'Google sign in cancelled.');
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
      await _auth!.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  Future<void> verifyOTP(String code) async {
    // In a real app, you'd verify the OTP against your backend
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> resetPassword(String email) async {
    if (_auth == null) return;
    try {
      await _auth!.sendPasswordResetEmail(email: email);
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
    if (!kIsWeb) await _getGoogleSignIn().signOut();
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

  Future<void> updatePassword(String currentPassword, String newPassword) async {

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
    final docRef = _firestore!.collection('users').doc(firebaseUser.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }

    final userModel = UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await docRef.set(userModel.toMap());
    return userModel;
  }

  Future<void> _updateLastLogin(String userId) async {
    await _firestore!.collection('users').doc(userId).update({
      'lastLoginAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  AuthException _handleFirebaseAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No account found with this email.';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Please try again.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email.';
        break;
      case 'invalid-email':
        message = 'Please enter a valid email address.';
        break;
      case 'weak-password':
        message = 'Password is too weak. Please use a stronger password.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'operation-not-allowed':
        message = 'This operation is not allowed.';
        break;
      case 'api-key-not-valid':
      case 'invalid-api-key':
        message = 'Firebase is not configured correctly for this app.';
        break;
      case 'network-request-failed':
        message = 'Network connection failed. Please check your internet connection.';
        break;
      case 'popup-closed-by-user':
        message = 'Google sign in was cancelled.';
        break;
      case 'account-exists-with-different-credential':
        message = 'An account already exists with this email using another sign-in method.';
        break;
      default:
        message = e.message ?? 'Authentication failed.';
    }
    return AuthException(message: message, code: e.code);
  }

  AuthException _handleFirebaseException(FirebaseException e, StackTrace stackTrace) {
    final message = switch (e.code) {
      'permission-denied' => 'You do not have permission to access your profile.',
      'unavailable' || 'network-request-failed' =>
        'Network connection failed. Please try again.',
      'api-key-not-valid' || 'invalid-api-key' =>
        'Firebase is not configured correctly for this app.',
      _ => e.message ?? 'Authentication service unavailable. Please try again.',
    };
    return AuthException(message: message, code: e.code, stackTrace: stackTrace);
  }
}
