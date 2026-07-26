import 'dart:convert';

/// High-Performance Lightweight JWT Claims Decoder & Expiry Validator.
abstract class JwtDecoder {
  /// Decodes JWT payload map without external heavy dependencies.
  static Map<String, dynamic> decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid JWT Token structure');
    }
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw const FormatException('Invalid JWT Payload');
    }
    return payloadMap;
  }

  /// Checks if JWT token has expired based on 'exp' claim.
  static bool isExpired(String token) {
    try {
      final payload = decode(token);
      if (!payload.containsKey('exp')) return false;
      final exp = payload['exp'] as int;
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return currentTime >= exp;
    } catch (_) {
      return true;
    }
  }

  /// Extracts User Role claim from JWT token payload.
  static String? getRole(String token) {
    try {
      final payload = decode(token);
      return payload['role'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Extracts Society ID claim from JWT token payload.
  static String? getSocietyId(String token) {
    try {
      final payload = decode(token);
      return payload['society_id'] as String?;
    } catch (_) {
      return null;
    }
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw const FormatException('Illegal base64url string');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
