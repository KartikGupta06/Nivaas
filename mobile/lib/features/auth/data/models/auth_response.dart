import '../../domain/entities/user_profile.dart';
import 'auth_tokens.dart';

/// Auth Response payload containing Tokens and User Profile.
class AuthResponse {
  final AuthTokens tokens;
  final UserProfile user;

  const AuthResponse({
    required this.tokens,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>? ?? {}),
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
