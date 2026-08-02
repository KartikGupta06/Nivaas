import 'package:equatable/equatable.dart';

enum SocietyType {
  apartment,
  housingSociety,
  residentialComplex,
  mixedUse,
}

extension SocietyTypeX on SocietyType {
  String get displayName {
    switch (this) {
      case SocietyType.apartment:
        return 'Apartment Building';
      case SocietyType.housingSociety:
        return 'Co-operative Housing Society';
      case SocietyType.residentialComplex:
        return 'Gated Residential Complex';
      case SocietyType.mixedUse:
        return 'Mixed Use (Residential + Commercial)';
    }
  }
}

/// Pure Domain Entity representing Society Profile information.
class SocietyProfile extends Equatable {
  final String id;
  final String name;
  final SocietyType type;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String country;
  final String contactNumber;
  final String? email;
  final String? registrationNumber;
  final String? logoUrl;

  const SocietyProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    this.country = 'India',
    required this.contactNumber,
    this.email,
    this.registrationNumber,
    this.logoUrl,
  });

  factory SocietyProfile.initial() {
    return const SocietyProfile(
      id: '',
      name: '',
      type: SocietyType.housingSociety,
      address: '',
      city: '',
      state: '',
      pinCode: '',
      contactNumber: '',
    );
  }

  bool get isValid =>
      name.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      state.trim().isNotEmpty &&
      pinCode.trim().length == 6 &&
      contactNumber.trim().length == 10;

  String? get nameValidationError {
    if (name.trim().isEmpty) return 'Society name is required';
    if (name.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? get phoneValidationError {
    if (contactNumber.trim().isEmpty) return 'Contact number is required';
    final regExp = RegExp(r'^[6-9]\d{9}$');
    if (!regExp.hasMatch(contactNumber.trim())) return 'Enter valid 10-digit Indian phone number';
    return null;
  }

  SocietyProfile copyWith({
    String? id,
    String? name,
    SocietyType? type,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? country,
    String? contactNumber,
    String? email,
    String? registrationNumber,
    String? logoUrl,
  }) {
    return SocietyProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      country: country ?? this.country,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'address': address,
      'city': city,
      'state': state,
      'pin_code': pinCode,
      'country': country,
      'contact_number': contactNumber,
      'email': email,
      'registration_number': registrationNumber,
      'logo_url': logoUrl,
    };
  }

  factory SocietyProfile.fromJson(Map<String, dynamic> json) {
    return SocietyProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: SocietyType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SocietyType.housingSociety,
      ),
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pinCode: json['pin_code'] as String? ?? '',
      country: json['country'] as String? ?? 'India',
      contactNumber: json['contact_number'] as String? ?? '',
      email: json['email'] as String?,
      registrationNumber: json['registration_number'] as String?,
      logoUrl: json['logo_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        address,
        city,
        state,
        pinCode,
        country,
        contactNumber,
        email,
        registrationNumber,
        logoUrl,
      ];
}
