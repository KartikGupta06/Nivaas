import 'package:equatable/equatable.dart';

enum HouseType {
  rk1,
  bhk1,
  bhk2,
  bhk3,
  bhk4,
  penthouse,
  duplex,
  custom,
}

extension HouseTypeX on HouseType {
  String get displayName {
    switch (this) {
      case HouseType.rk1:
        return '1 RK';
      case HouseType.bhk1:
        return '1 BHK';
      case HouseType.bhk2:
        return '2 BHK';
      case HouseType.bhk3:
        return '3 BHK';
      case HouseType.bhk4:
        return '4 BHK';
      case HouseType.penthouse:
        return 'Penthouse';
      case HouseType.duplex:
        return 'Duplex';
      case HouseType.custom:
        return 'Custom';
    }
  }
}

/// Pure Domain Entity representing a Generated House/Flat Unit.
class HouseUnit extends Equatable {
  final String id;
  final String wingName;
  final int floorNumber;
  final String flatNumber; // e.g. "101", "A-204"
  final HouseType type;
  final double? areaSqFt;
  final String maintenanceCategory; // e.g. "STANDARD", "PREMIUM"
  final String? parkingSlot; // e.g. "P-12"
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final String? emergencyContact;
  final bool isCustomized; // Inherited vs Floor Exception

  const HouseUnit({
    required this.id,
    required this.wingName,
    required this.floorNumber,
    required this.flatNumber,
    this.type = HouseType.bhk2,
    this.areaSqFt,
    this.maintenanceCategory = 'STANDARD',
    this.parkingSlot,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.emergencyContact,
    this.isCustomized = false,
  });

  HouseUnit copyWith({
    String? id,
    String? wingName,
    int? floorNumber,
    String? flatNumber,
    HouseType? type,
    double? areaSqFt,
    String? maintenanceCategory,
    String? parkingSlot,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    String? emergencyContact,
    bool? isCustomized,
  }) {
    return HouseUnit(
      id: id ?? this.id,
      wingName: wingName ?? this.wingName,
      floorNumber: floorNumber ?? this.floorNumber,
      flatNumber: flatNumber ?? this.flatNumber,
      type: type ?? this.type,
      areaSqFt: areaSqFt ?? this.areaSqFt,
      maintenanceCategory: maintenanceCategory ?? this.maintenanceCategory,
      parkingSlot: parkingSlot ?? this.parkingSlot,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      isCustomized: isCustomized ?? this.isCustomized,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wing_name': wingName,
      'floor_number': floorNumber,
      'flat_number': flatNumber,
      'type': type.name,
      'area_sq_ft': areaSqFt,
      'maintenance_category': maintenanceCategory,
      'parking_slot': parkingSlot,
      'owner_name': ownerName,
      'owner_phone': ownerPhone,
      'owner_email': ownerEmail,
      'emergency_contact': emergencyContact,
      'is_customized': isCustomized,
    };
  }

  factory HouseUnit.fromJson(Map<String, dynamic> json) {
    return HouseUnit(
      id: json['id'] as String? ?? '',
      wingName: json['wing_name'] as String? ?? '',
      floorNumber: json['floor_number'] as int? ?? 1,
      flatNumber: json['flat_number'] as String? ?? '',
      type: HouseType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => HouseType.bhk2,
      ),
      areaSqFt: (json['area_sq_ft'] as num?)?.toDouble(),
      maintenanceCategory: json['maintenance_category'] as String? ?? 'STANDARD',
      parkingSlot: json['parking_slot'] as String?,
      ownerName: json['owner_name'] as String?,
      ownerPhone: json['owner_phone'] as String?,
      ownerEmail: json['owner_email'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      isCustomized: json['is_customized'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        wingName,
        floorNumber,
        flatNumber,
        type,
        areaSqFt,
        maintenanceCategory,
        parkingSlot,
        ownerName,
        ownerPhone,
        ownerEmail,
        emergencyContact,
        isCustomized,
      ];
}
