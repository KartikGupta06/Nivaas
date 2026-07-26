import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/network/interceptors/auth_interceptor.dart';
import '../../core/network/interceptors/logging_interceptor.dart';
import '../../core/offline/isar_database_service.dart';
import '../../core/permissions/permission_service.dart';
import '../../core/security/secure_storage_service.dart';
import '../../core/security/token_manager.dart';
import 'app_config_provider.dart';
import 'logger_provider.dart';

/// Centralized Dependency Injection Providers via Riverpod.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final tokenManagerProvider = Provider<TokenManager>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenManager(storage);
});

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthInterceptor(storage);
});

final loggingInterceptorProvider = Provider<LoggingInterceptor>((ref) {
  final logger = ref.watch(loggerProvider);
  return LoggingInterceptor(logger);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  final authInterceptor = ref.watch(authInterceptorProvider);
  final loggingInterceptor = ref.watch(loggingInterceptorProvider);

  return ApiClient(
    envConfig: appConfig.envConfig,
    authInterceptor: authInterceptor,
    loggingInterceptor: loggingInterceptor,
  );
});

final isarDatabaseServiceProvider = Provider<IsarDatabaseService>((ref) {
  return IsarDatabaseService();
});

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});
