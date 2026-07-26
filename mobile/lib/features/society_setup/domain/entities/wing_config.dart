import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing a Wing configuration (e.g. Wing A, Wing B).
class WingConfig extends Equatable {
  final String id;
  final String name;
  final int totalFloors;
  final int flatsPerFloor;

  const WingConfig({
    required this.id,
    required this.name,
    this.totalFloors = 4,
    this.flatsPerFloor = 4,
  });

  WingConfig copyWith({
    String? id,
    String? name,
    int? totalFloors,
    int? flatsPerFloor,
  }) {
    return WingConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      totalFloors: totalFloors ?? this.totalFloors,
      flatsPerFloor: flatsPerFloor ?? this.flatsPerFloor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_floors': totalFloors,
      'flats_per_floor': flatsPerFloor,
    };
  }

  factory WingConfig.fromJson(Map<String, dynamic> json) {
    return WingConfig(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      totalFloors: json['total_floors'] as int? ?? 4,
      flatsPerFloor: json['flats_per_floor'] as int? ?? 4,
    );
  }

  @override
  List<Object?> get props => [id, name, totalFloors, flatsPerFloor];
}
