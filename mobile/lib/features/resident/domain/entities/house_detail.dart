import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing House Details.
class HouseDetail extends Equatable {
  final String houseId;
  final String flatNumber;
  final String wingName;
  final int floorNumber;
  final String houseType;
  final double? areaSqFt;
  final String ownershipStatus;
  final String maintenanceCategory;
  final String? parkingSlot;
  final String societyName;
  final String? moveInDate;

  const HouseDetail({
    required this.houseId,
    required this.flatNumber,
    required this.wingName,
    required this.floorNumber,
    required this.houseType,
    this.areaSqFt,
    required this.ownershipStatus,
    required this.maintenanceCategory,
    this.parkingSlot,
    required this.societyName,
    this.moveInDate,
  });

  factory HouseDetail.fromJson(Map<String, dynamic> json) {
    return HouseDetail(
      houseId: json['house_id'] as String? ?? '',
      flatNumber: json['flat_number'] as String? ?? '',
      wingName: json['wing_name'] as String? ?? '',
      floorNumber: (json['floor_number'] as num?)?.toInt() ?? 0,
      houseType: json['house_type'] as String? ?? 'bhk2',
      areaSqFt: (json['area_sq_ft'] as num?)?.toDouble(),
      ownershipStatus: json['ownership_status'] as String? ?? 'OWNER',
      maintenanceCategory: json['maintenance_category'] as String? ?? 'STANDARD',
      parkingSlot: json['parking_slot'] as String?,
      societyName: json['society_name'] as String? ?? '',
      moveInDate: json['move_in_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'house_id': houseId,
      'flat_number': flatNumber,
      'wing_name': wingName,
      'floor_number': floorNumber,
      'house_type': houseType,
      'area_sq_ft': areaSqFt,
      'ownership_status': ownershipStatus,
      'maintenance_category': maintenanceCategory,
      'parking_slot': parkingSlot,
      'society_name': societyName,
      'move_in_date': moveInDate,
    };
  }

  @override
  List<Object?> get props => [
        houseId,
        flatNumber,
        wingName,
        floorNumber,
        houseType,
        areaSqFt,
        ownershipStatus,
        maintenanceCategory,
        parkingSlot,
        societyName,
        moveInDate,
      ];
}
