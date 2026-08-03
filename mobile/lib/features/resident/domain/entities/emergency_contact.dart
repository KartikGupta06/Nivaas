import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Emergency Contact in society directory.
class EmergencyContact extends Equatable {
  final String id;
  final String designation;
  final String name;
  final String phone;
  final String category;
  final String? iconName;

  const EmergencyContact({
    required this.id,
    required this.designation,
    required this.name,
    required this.phone,
    required this.category,
    this.iconName,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      category: json['category'] as String? ?? 'GENERAL',
      iconName: json['icon_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'name': name,
      'phone': phone,
      'category': category,
      'icon_name': iconName,
    };
  }

  @override
  List<Object?> get props => [id, designation, name, phone, category, iconName];
}
