import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Society Information.
class SocietyInfo extends Equatable {
  final String id;
  final String name;
  final String address;
  final String officeContact;
  final String officeTiming;
  final List<String> emergencyNumbers;
  final List<String> committeeMembers;

  const SocietyInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.officeContact,
    required this.officeTiming,
    this.emergencyNumbers = const [],
    this.committeeMembers = const [],
  });

  factory SocietyInfo.fromJson(Map<String, dynamic> json) {
    return SocietyInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      officeContact: json['office_contact'] as String? ?? '',
      officeTiming: json['office_timing'] as String? ?? '',
      emergencyNumbers: (json['emergency_numbers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      committeeMembers: (json['committee_members'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'office_contact': officeContact,
      'office_timing': officeTiming,
      'emergency_numbers': emergencyNumbers,
      'committee_members': committeeMembers,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        officeContact,
        officeTiming,
        emergencyNumbers,
        committeeMembers,
      ];
}
