import 'env_config.dart';

/// Global App Specification & Runtime Configuration singleton container.
class AppConfig {
  static const String appName = 'Nivaas';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  final EnvConfig envConfig;

  AppConfig({required this.envConfig});

  bool get isDevelopment => envConfig.environment == Environment.development;
  bool get isStaging => envConfig.environment == Environment.staging;
  bool get isProduction => envConfig.environment == Environment.production;
}
