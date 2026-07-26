/// API Configuration & Header Constants.
abstract class ApiConstants {
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static const String headerAuthorization = 'Authorization';
  static const String headerSocietyId = 'X-Society-ID';
  static const String headerAppVersion = 'X-App-Version';
  static const String headerCorrelationId = 'X-Correlation-ID';

  static const String bearerPrefix = 'Bearer ';
}
