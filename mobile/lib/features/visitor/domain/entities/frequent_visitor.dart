import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Daily Staff & Frequent Visitors.
class FrequentVisitor extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String serviceType; // Maid, Driver, Electrician, Plumber, Tutor, Housekeeping
  final String flatsAssigned;
  final String passCode;
  final bool isActive;
  final String? avatarUrl;

  const FrequentVisitor({
    required this.id,
    required this.name,
    required this.phone,
    required this.serviceType,
    required this.flatsAssigned,
    required this.passCode,
    this.isActive = true,
    this.avatarUrl,
  });

  factory FrequentVisitor.fromJson(Map<String, dynamic> json) {
    return FrequentVisitor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      serviceType: json['service_type'] as String? ?? 'Staff',
      flatsAssigned: json['flats_assigned'] as String? ?? '',
      passCode: json['pass_code'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'service_type': serviceType,
      'flats_assigned': flatsAssigned,
      'pass_code': passCode,
      'is_active': isActive,
      'avatar_url': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, phone, serviceType, flatsAssigned, passCode, isActive, avatarUrl];
}
