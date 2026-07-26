import 'package:flutter_test/flutter_test.dart';
import 'package:nivaas_mobile/features/auth/data/models/login_request.dart';
import 'package:nivaas_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nivaas_mobile/shared/models/user_role.dart';

import '../../mocks/mock_auth_datasources.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDS;
  late MockAuthLocalDataSource mockLocalDS;
  late MockTokenManager mockTokenManager;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDS = MockAuthRemoteDataSource();
    mockLocalDS = MockAuthLocalDataSource();
    mockTokenManager = MockTokenManager();
    mockNetworkInfo = MockNetworkInfo();

    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDS,
      localDataSource: mockLocalDS,
      tokenManager: mockTokenManager,
      networkInfo: mockNetworkInfo,
      isDevelopment: true,
    );
  });

  group('AuthRepository Unit Tests', () {
    test('Development mock login returns valid Resident profile', () async {
      final profile = await repository.loginWithPhone(
        const LoginRequest(phone: '9876543210', password: 'password123'),
      );

      expect(profile.role, equals(UserRole.resident));
      expect(profile.phone, equals('9876543210'));
      expect(profile.societyId, equals('soc_green_park_101'));
    });

    test('Development mock login for admin phone returns Admin profile', () async {
      final profile = await repository.loginWithPhone(
        const LoginRequest(phone: '9876543211', password: 'password123'),
      );

      expect(profile.role, equals(UserRole.societyAdmin));
      expect(profile.phone, equals('9876543211'));
    });

    test('Development mock login for watchman phone returns Watchman profile', () async {
      final profile = await repository.loginWithPhone(
        const LoginRequest(phone: '9876543212', password: 'password123'),
      );

      expect(profile.role, equals(UserRole.watchman));
      expect(profile.phone, equals('9876543212'));
    });
  });
}
