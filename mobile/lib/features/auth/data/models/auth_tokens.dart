import 'package:equatable/equatable.dart';

/// DTO for Access & Refresh JWT Token Pair.
class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresInSeconds;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresInSeconds = 900, // 15 Minutes
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      expiresInSeconds: json['expires_in'] as int? ?? 900,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresInSeconds,
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresInSeconds];
}
