import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Resident Profile details.
class ResidentProfile extends Equatable {
  final String id;
  final String phone;
  final String fullName;
  final String? email;
  final String role;
  final String? emergencyContact;
  final String? fullAddress;
  final String? avatarUrl;
  final String? houseAssignment;

  const ResidentProfile({
    required this.id,
    required this.phone,
    required this.fullName,
    this.email,
    this.role = 'OWNER',
    this.emergencyContact,
    this.fullAddress,
    this.avatarUrl,
    this.houseAssignment,
  });

  ResidentProfile copyWith({
    String? id,
    String? phone,
    String? fullName,
    String? email,
    String? role,
    String? emergencyContact,
    String? fullAddress,
    String? avatarUrl,
    String? houseAssignment,
  }) {
    return ResidentProfile(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      fullAddress: fullAddress ?? this.fullAddress,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      houseAssignment: houseAssignment ?? this.houseAssignment,
    );
  }

  factory ResidentProfile.fromJson(Map<String, dynamic> json) {
    return ResidentProfile(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String?,
      role: json['role'] as String? ?? 'OWNER',
      emergencyContact: json['emergency_contact'] as String?,
      fullAddress: json['full_address'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      houseAssignment: json['house_assignment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': fullName,
      'email': email,
      'role': role,
      'emergency_contact': emergencyContact,
      'full_address': fullAddress,
      'avatar_url': avatarUrl,
      'house_assignment': houseAssignment,
    };
  }

  @override
  List<Object?> get props => [
        id,
        phone,
        fullName,
        email,
        role,
        emergencyContact,
        fullAddress,
        avatarUrl,
        houseAssignment,
      ];
}
