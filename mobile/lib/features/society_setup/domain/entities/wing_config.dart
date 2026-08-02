import 'package:equatable/equatable.dart';

enum FloorNumberingStrategy {
  floorHundreds, // 101, 102 -> 201, 202
  sequential,    // 1, 2, 3...
  customPrefix,  // A-101, A-102
}

extension FloorNumberingStrategyX on FloorNumberingStrategy {
  String get displayName {
    switch (this) {
      case FloorNumberingStrategy.floorHundreds:
        return 'Standard (101, 201, 301)';
      case FloorNumberingStrategy.sequential:
        return 'Sequential (1, 2, 3)';
      case FloorNumberingStrategy.customPrefix:
        return 'Wing Prefixed (A-101, B-101)';
    }
  }
}

/// Pure Domain Entity representing a Wing configuration (e.g. Wing A, Wing B).
class WingConfig extends Equatable {
  final String id;
  final String name;
  final int totalFloors;
  final int flatsPerFloor;
  final int basementFloors;
  final bool hasTerrace;
  final FloorNumberingStrategy numberingStrategy;
  final int displayOrder;

  const WingConfig({
    required this.id,
    required this.name,
    this.totalFloors = 4,
    this.flatsPerFloor = 4,
    this.basementFloors = 0,
    this.hasTerrace = false,
    this.numberingStrategy = FloorNumberingStrategy.floorHundreds,
    this.displayOrder = 0,
  });

  WingConfig copyWith({
    String? id,
    String? name,
    int? totalFloors,
    int? flatsPerFloor,
    int? basementFloors,
    bool? hasTerrace,
    FloorNumberingStrategy? numberingStrategy,
    int? displayOrder,
  }) {
    return WingConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      totalFloors: totalFloors ?? this.totalFloors,
      flatsPerFloor: flatsPerFloor ?? this.flatsPerFloor,
      basementFloors: basementFloors ?? this.basementFloors,
      hasTerrace: hasTerrace ?? this.hasTerrace,
      numberingStrategy: numberingStrategy ?? this.numberingStrategy,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_floors': totalFloors,
      'flats_per_floor': flatsPerFloor,
      'basement_floors': basementFloors,
      'has_terrace': hasTerrace,
      'numbering_strategy': numberingStrategy.name,
      'display_order': displayOrder,
    };
  }

  factory WingConfig.fromJson(Map<String, dynamic> json) {
    return WingConfig(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      totalFloors: json['total_floors'] as int? ?? 4,
      flatsPerFloor: json['flats_per_floor'] as int? ?? 4,
      basementFloors: json['basement_floors'] as int? ?? 0,
      hasTerrace: json['has_terrace'] as bool? ?? false,
      numberingStrategy: FloorNumberingStrategy.values.firstWhere(
        (e) => e.name == json['numbering_strategy'],
        orElse: () => FloorNumberingStrategy.floorHundreds,
      ),
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        totalFloors,
        flatsPerFloor,
        basementFloors,
        hasTerrace,
        numberingStrategy,
        displayOrder,
      ];
}
