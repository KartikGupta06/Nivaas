import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_config_provider.dart';
import '../../../../app/providers/connectivity_provider.dart';
import '../../../../app/providers/dependency_injection_providers.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for Auth Remote Data Source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

/// Provider for Auth Local Data Source
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDataSourceImpl(secureStorage);
});

/// Provider for Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDS = ref.watch(authRemoteDataSourceProvider);
  final localDS = ref.watch(authLocalDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final appConfig = ref.watch(appConfigProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDS,
    localDataSource: localDS,
    tokenManager: tokenManager,
    networkInfo: networkInfo,
    isDevelopment: appConfig.isDevelopment,
  );
});
