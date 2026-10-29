import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../services/auth_service.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserModel?> getCurrentUserData();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(
      String email, String password, String displayName,
      {UserType userType = UserType.talent});
  Future<UserModel> signInWithGoogle();
  Future<void> sendOTP(String email);
  Future<void> verifyOTP(String code);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    List<String>? skills,
    String? experienceLevel,
    String? industry,
    String? location,
  });
  Future<void> updatePassword(String currentPassword, String newPassword);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Future<UserModel?> getCurrentUserData() => _authService.getCurrentUserData();

  @override
  Future<UserModel> signInWithEmail(String email, String password) =>
      _authService.signInWithEmail(email, password);

  @override
  Future<UserModel> signUpWithEmail(
          String email, String password, String displayName,
          {UserType userType = UserType.talent}) =>
      _authService.signUpWithEmail(email, password, displayName, userType: userType);

  @override
  Future<UserModel> signInWithGoogle() => _authService.signInWithGoogle();

  @override
  Future<void> sendOTP(String email) => _authService.sendOTP(email);

  @override
  Future<void> verifyOTP(String code) => _authService.verifyOTP(code);

  @override
  Future<void> resetPassword(String email) => _authService.resetPassword(email);

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    List<String>? skills,
    String? experienceLevel,
    String? industry,
    String? location,
  }) =>
      _authService.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        bio: bio,
        skills: skills,
        experienceLevel: experienceLevel,
        industry: industry,
        location: location,
      );

  @override
  Future<void> updatePassword(String currentPassword, String newPassword) =>
      _authService.updatePassword(currentPassword, newPassword);
}
