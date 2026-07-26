import '../entities/user_profile.dart';
import '../../data/models/login_request.dart';

/// Contract for Auth Repository operations.
abstract class AuthRepository {
  Future<UserProfile> loginWithPhone(LoginRequest request);
  Future<UserProfile> verifyOtp(String phone, String otp);
  Future<void> sendOtp(String phone);
  Future<UserProfile?> restoreSession();
  Future<void> logout();
  Future<UserProfile?> getSavedUserProfile();
}
