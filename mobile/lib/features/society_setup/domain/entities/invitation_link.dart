import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Society Resident Invitation Architecture.
class InvitationLink extends Equatable {
  final String societyId;
  final String inviteToken;
  final String deepLinkUrl;
  final DateTime expiresAt;
  final List<String> supportedChannels;

  const InvitationLink({
    required this.societyId,
    required this.inviteToken,
    required this.deepLinkUrl,
    required this.expiresAt,
    this.supportedChannels = const ['SMS', 'WhatsApp', 'Email'],
  });

  factory InvitationLink.generate(String societyId) {
    final token = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    return InvitationLink(
      societyId: societyId,
      inviteToken: token,
      deepLinkUrl: 'https://nivaas.app/invite/$societyId?token=$token',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'society_id': societyId,
      'invite_token': inviteToken,
      'deep_link_url': deepLinkUrl,
      'expires_at': expiresAt.toIso8601String(),
      'supported_channels': supportedChannels,
    };
  }

  factory InvitationLink.fromJson(Map<String, dynamic> json) {
    return InvitationLink(
      societyId: json['society_id'] as String? ?? '',
      inviteToken: json['invite_token'] as String? ?? '',
      deepLinkUrl: json['deep_link_url'] as String? ?? '',
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : DateTime.now(),
      supportedChannels: (json['supported_channels'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['SMS', 'WhatsApp', 'Email'],
    );
  }

  @override
  List<Object?> get props => [societyId, inviteToken, deepLinkUrl, expiresAt, supportedChannels];
}
