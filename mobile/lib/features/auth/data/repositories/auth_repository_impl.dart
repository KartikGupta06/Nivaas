import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/security/token_manager.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../shared/repositories/base_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenManager _tokenManager;
  final NetworkInfo _networkInfo;
  final bool isDevelopment;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required TokenManager tokenManager,
    required NetworkInfo networkInfo,
    this.isDevelopment = true,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _tokenManager = tokenManager,
        _networkInfo = networkInfo;

  @override
  Future<UserProfile> loginWithPhone(LoginRequest request) async {
    // Development Mock Authentication Bypass
    if (isDevelopment && (request.phone.startsWith('987654321') || request.phone.startsWith('999'))) {
      final mockUser = _getMockUserForPhone(request.phone);
      await _tokenManager.saveAuthTokens(
        accessToken: 'mock_access_token_${mockUser.role.nameString}',
        refreshToken: 'mock_refresh_token',
      );
      await _localDataSource.saveUserProfile(mockUser);
      return mockUser;
    }

    if (!await _networkInfo.isConnected) {
      throw const NetworkException(message: 'No internet connection to perform login');
    }

    final response = await _remoteDataSource.login(request);
    await _tokenManager.saveAuthTokens(
      accessToken: response.tokens.accessToken,
      refreshToken: response.tokens.refreshToken,
    );
    await _localDataSource.saveUserProfile(response.user);
    return response.user;
  }

  @override
  Future<UserProfile> verifyOtp(String phone, String otp) async {
    if (isDevelopment && otp == '123456') {
      final mockUser = _getMockUserForPhone(phone);
      await _tokenManager.saveAuthTokens(
        accessToken: 'mock_access_token_${mockUser.role.nameString}',
        refreshToken: 'mock_refresh_token',
      );
      await _localDataSource.saveUserProfile(mockUser);
      return mockUser;
    }

    final response = await _remoteDataSource.verifyOtp(phone, otp);
    await _tokenManager.saveAuthTokens(
      accessToken: response.tokens.accessToken,
      refreshToken: response.tokens.refreshToken,
    );
    await _localDataSource.saveUserProfile(response.user);
    return response.user;
  }

  @override
  Future<void> sendOtp(String phone) async {
    if (isDevelopment) return;
    await _remoteDataSource.sendOtp(phone);
  }

  @override
  Future<UserProfile?> restoreSession() async {
    final hasToken = await _tokenManager.hasValidToken();
    if (!hasToken) return null;

    final profile = await _localDataSource.getUserProfile();
    if (profile == null) return null;

    return profile;
  }

  @override
  Future<void> logout() async {
    await _tokenManager.clearAuthSession();
    await _localDataSource.clearAuthData();
  }

  @override
  Future<UserProfile?> getSavedUserProfile() async {
    return await _localDataSource.getUserProfile();
  }

  UserProfile _getMockUserForPhone(String phone) {
    if (phone == '9876543211' || phone.endsWith('1')) {
      return const UserProfile(
        id: 'mock_admin_1',
        phone: '9876543211',
        fullName: 'Ramesh Sharma (Admin)',
        role: UserRole.societyAdmin,
        societyId: 'soc_green_park_101',
        societyName: 'Green Park Apartments RWA',
      );
    } else if (phone == '9876543212' || phone.endsWith('2')) {
      return const UserProfile(
        id: 'mock_guard_1',
        phone: '9876543212',
        fullName: 'Bahadur Singh (Watchman)',
        role: UserRole.watchman,
        societyId: 'soc_green_park_101',
        societyName: 'Green Park Main Gate',
      );
    }

    return const UserProfile(
      id: 'mock_resident_1',
      phone: '9876543210',
      fullName: 'Priya Nair (Resident)',
      role: UserRole.resident,
      societyId: 'soc_green_park_101',
      societyName: 'Green Park Apartments',
      flatNumber: 'A-402',
    );
  }
}
