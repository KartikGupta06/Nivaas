import 'package:equatable/equatable.dart';
import '../../../../shared/models/user_role.dart';

/// Pure Domain Entity representing authenticated User Profile.
class UserProfile extends Equatable {
  final String id;
  final String phone;
  final String fullName;
  final UserRole role;
  final String? societyId;
  final String? societyName;
  final String? flatNumber;
  final String? avatarUrl;

  const UserProfile({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.role,
    this.societyId,
    this.societyName,
    this.flatNumber,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      role: UserRoleX.fromString(json['role'] as String? ?? 'RESIDENT'),
      societyId: json['society_id'] as String?,
      societyName: json['society_name'] as String?,
      flatNumber: json['flat_number'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': fullName,
      'role': role.nameString,
      'society_id': societyId,
      'society_name': societyName,
      'flat_number': flatNumber,
      'avatar_url': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [id, phone, fullName, role, societyId, societyName, flatNumber, avatarUrl];
}
