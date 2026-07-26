import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nivaas_mobile/core/network/network_info.dart';
import 'package:nivaas_mobile/core/security/token_manager.dart';
import 'package:nivaas_mobile/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:nivaas_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nivaas_mobile/features/auth/data/models/auth_response.dart';
import 'package:nivaas_mobile/features/auth/data/models/auth_tokens.dart';
import 'package:nivaas_mobile/features/auth/data/models/login_request.dart';
import 'package:nivaas_mobile/features/auth/domain/entities/user_profile.dart';
import 'package:nivaas_mobile/shared/models/user_role.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthResponse> login(LoginRequest request) async {
    return const AuthResponse(
      tokens: AuthTokens(accessToken: 'mock_token', refreshToken: 'mock_refresh'),
      user: UserProfile(
        id: 'user_101',
        phone: '9876543210',
        fullName: 'Test Resident',
        role: UserRole.resident,
      ),
    );
  }

  @override
  Future<AuthResponse> verifyOtp(String phone, String otp) async => login(LoginRequest(phone: phone, password: ''));

  @override
  Future<void> sendOtp(String phone) async {}

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async => login(const LoginRequest(phone: '9876543210', password: ''));
}

class MockAuthLocalDataSource implements AuthLocalDataSource {
  UserProfile? _savedProfile;

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    _savedProfile = profile;
  }

  @override
  Future<UserProfile?> getUserProfile() async => _savedProfile;

  @override
  Future<void> clearAuthData() async {
    _savedProfile = null;
  }
}

class MockTokenManager implements TokenManager {
  String? _token;

  @override
  Future<bool> hasValidToken() async => _token != null;

  @override
  Future<void> saveAuthTokens({required String accessToken, required String refreshToken}) async {
    _token = accessToken;
  }

  @override
  Future<void> clearAuthSession() async {
    _token = null;
  }
}

class MockNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => Stream.value([]);
}
