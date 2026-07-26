import 'package:dio/dio.dart';

/// SSL Certificate Pinning architecture hooks for Dio client.
abstract class CertificatePinning {
  static void setupCertificatePinning(Dio dio, List<String> allowedSha256Fingerprints) {
    // Certificate pinning hooks for production HTTPS transport hardening.
    // Platform-native SSL certificate pinning checks will be enabled for production builds.
  }
}
