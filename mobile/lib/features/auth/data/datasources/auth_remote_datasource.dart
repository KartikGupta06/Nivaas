import '../../../../core/network/api_client.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> verifyOtp(String phone, String otp);
  Future<void> sendOtp(String phone);
  Future<AuthResponse> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    final data = response.data!;
    return AuthResponse.fromJson(data['data'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<AuthResponse> verifyOtp(String phone, String otp) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/verify-otp',
      data: {'phone': phone, 'otp': otp},
    );
    final data = response.data!;
    return AuthResponse.fromJson(data['data'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<void> sendOtp(String phone) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/auth/send-otp',
      data: {'phone': phone},
    );
  }

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    final data = response.data!;
    return AuthResponse.fromJson(data['data'] as Map<String, dynamic>? ?? data);
  }
}
