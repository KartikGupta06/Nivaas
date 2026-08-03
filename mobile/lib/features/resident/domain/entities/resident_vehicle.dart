import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Resident Vehicle.
class ResidentVehicle extends Equatable {
  final String id;
  final String vehicleNumber;
  final String vehicleType;
  final String? parkingSlot;
  final String? stickerNumber;
  final String status;

  const ResidentVehicle({
    required this.id,
    required this.vehicleNumber,
    this.vehicleType = 'FOUR_WHEELER',
    this.parkingSlot,
    this.stickerNumber,
    this.status = 'ACTIVE',
  });

  factory ResidentVehicle.fromJson(Map<String, dynamic> json) {
    return ResidentVehicle(
      id: json['id'] as String? ?? '',
      vehicleNumber: json['vehicle_number'] as String? ?? '',
      vehicleType: json['vehicle_type'] as String? ?? 'FOUR_WHEELER',
      parkingSlot: json['parking_slot'] as String?,
      stickerNumber: json['sticker_number'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_number': vehicleNumber,
      'vehicle_type': vehicleType,
      'parking_slot': parkingSlot,
      'sticker_number': stickerNumber,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        vehicleNumber,
        vehicleType,
        parkingSlot,
        stickerNumber,
        status,
      ];
}
