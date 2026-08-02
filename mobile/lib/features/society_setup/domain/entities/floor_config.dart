import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Floor level configuration per wing.
class FloorConfig extends Equatable {
  final String id;
  final String wingId;
  final int floorNumber;
  final String? customName; // e.g. "Ground Floor", "Mezzanine", "1st Floor"
  final bool isBasement;
  final bool isTerrace;

  const FloorConfig({
    required this.id,
    required this.wingId,
    required this.floorNumber,
    this.customName,
    this.isBasement = false,
    this.isTerrace = false,
  });

  String get displayName {
    if (customName != null && customName!.isNotEmpty) return customName!;
    if (isBasement) return 'Basement B$floorNumber';
    if (isTerrace) return 'Terrace Floor';
    if (floorNumber == 0) return 'Ground Floor';
    return 'Floor $floorNumber';
  }

  FloorConfig copyWith({
    String? id,
    String? wingId,
    int? floorNumber,
    String? customName,
    bool? isBasement,
    bool? isTerrace,
  }) {
    return FloorConfig(
      id: id ?? this.id,
      wingId: wingId ?? this.wingId,
      floorNumber: floorNumber ?? this.floorNumber,
      customName: customName ?? this.customName,
      isBasement: isBasement ?? this.isBasement,
      isTerrace: isTerrace ?? this.isTerrace,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wing_id': wingId,
      'floor_number': floorNumber,
      'custom_name': customName,
      'is_basement': isBasement,
      'is_terrace': isTerrace,
    };
  }

  factory FloorConfig.fromJson(Map<String, dynamic> json) {
    return FloorConfig(
      id: json['id'] as String? ?? '',
      wingId: json['wing_id'] as String? ?? '',
      floorNumber: json['floor_number'] as int? ?? 1,
      customName: json['custom_name'] as String?,
      isBasement: json['is_basement'] as bool? ?? false,
      isTerrace: json['is_terrace'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, wingId, floorNumber, customName, isBasement, isTerrace];
}
