import 'package:equatable/equatable.dart';

enum OccupancyStatus {
  ownerOccupied,
  tenantOccupied,
  vacant,
  unoccupied,
}

extension OccupancyStatusX on OccupancyStatus {
  String get displayName {
    switch (this) {
      case OccupancyStatus.ownerOccupied:
        return 'Owner Occupied';
      case OccupancyStatus.tenantOccupied:
        return 'Tenant Occupied';
      case OccupancyStatus.vacant:
        return 'Vacant';
      case OccupancyStatus.unoccupied:
        return 'Unoccupied';
    }
  }
}

/// Pure Domain Entity representing Initial Owner Assignment details.
class HouseOwner extends Equatable {
  final String flatNumber;
  final String name;
  final String phone;
  final String? email;
  final String? emergencyContact;
  final OccupancyStatus status;

  const HouseOwner({
    required this.flatNumber,
    required this.name,
    required this.phone,
    this.email,
    this.emergencyContact,
    this.status = OccupancyStatus.ownerOccupied,
  });

  bool get isValidPhone {
    final regExp = RegExp(r'^[6-9]\d{9}$');
    return regExp.hasMatch(phone.trim());
  }

  Map<String, dynamic> toJson() {
    return {
      'flat_number': flatNumber,
      'name': name,
      'phone': phone,
      'email': email,
      'emergency_contact': emergencyContact,
      'status': status.name,
    };
  }

  factory HouseOwner.fromJson(Map<String, dynamic> json) {
    return HouseOwner(
      flatNumber: json['flat_number'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      status: OccupancyStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OccupancyStatus.ownerOccupied,
      ),
    );
  }

  @override
  List<Object?> get props => [flatNumber, name, phone, email, emergencyContact, status];
}
