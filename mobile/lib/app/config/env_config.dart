/// Environment type enum for Nivaas app deployments.
enum Environment {
  development,
  staging,
  production,
}

/// Holds environment-specific runtime configurations.
class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableVerboseLogging;
  final bool enableCertificatePinning;

  const EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.enableVerboseLogging = true,
    this.enableCertificatePinning = false,
  });

  factory EnvConfig.development() {
    return const EnvConfig(
      environment: Environment.development,
      apiBaseUrl: 'https://dev-api.nivaas.app/api/v1',
      enableVerboseLogging: true,
      enableCertificatePinning: false,
    );
  }

  factory EnvConfig.staging() {
    return const EnvConfig(
      environment: Environment.staging,
      apiBaseUrl: 'https://staging-api.nivaas.app/api/v1',
      enableVerboseLogging: true,
      enableCertificatePinning: true,
    );
  }

  factory EnvConfig.production() {
    return const EnvConfig(
      environment: Environment.production,
      apiBaseUrl: 'https://api.nivaas.app/api/v1',
      enableVerboseLogging: false,
      enableCertificatePinning: true,
    );
  }
}
