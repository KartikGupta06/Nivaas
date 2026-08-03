import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Family Member linked to a house.
class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String relationship;
  final String role;
  final String? contactNumber;
  final bool isChild;
  final bool isSeniorCitizen;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    this.role = 'Family Member',
    this.contactNumber,
    this.isChild = false,
    this.isSeniorCitizen = false,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? 'Family Member',
      role: json['role'] as String? ?? 'Family Member',
      contactNumber: json['contact_number'] as String?,
      isChild: json['is_child'] as bool? ?? false,
      isSeniorCitizen: json['is_senior_citizen'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'role': role,
      'contact_number': contactNumber,
      'is_child': isChild,
      'is_senior_citizen': isSeniorCitizen,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        relationship,
        role,
        contactNumber,
        isChild,
        isSeniorCitizen,
      ];
}
