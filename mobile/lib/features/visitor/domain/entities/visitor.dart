import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Visitor identity.
class Visitor extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String? photoUrl;
  final String? idProofUrl;
  final String? vendorName;

  const Visitor({
    required this.id,
    required this.fullName,
    required this.phone,
    this.photoUrl,
    this.idProofUrl,
    this.vendorName,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? json['visitor_name'] as String? ?? '',
      phone: json['phone'] as String? ?? json['visitor_phone'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      idProofUrl: json['id_proof_url'] as String?,
      vendorName: json['vendor_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'photo_url': photoUrl,
      'id_proof_url': idProofUrl,
      'vendor_name': vendorName,
    };
  }

  @override
  List<Object?> get props => [id, fullName, phone, photoUrl, idProofUrl, vendorName];
}
