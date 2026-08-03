import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Delivery Log entry.
class DeliveryLog extends Equatable {
  final String id;
  final String vendor; // SWIGGY, ZOMATO, AMAZON, BLINKIT, BIGBASKET, COURIER, MILK, GAS_CYLINDER
  final String flatNumber;
  final String wingName;
  final String deliveryPersonName;
  final String? phone;
  final String passCode;
  final String status;
  final String entryTime;

  const DeliveryLog({
    required this.id,
    required this.vendor,
    required this.flatNumber,
    this.wingName = 'Wing A',
    required this.deliveryPersonName,
    this.phone,
    required this.passCode,
    this.status = 'CHECKED_IN',
    required this.entryTime,
  });

  factory DeliveryLog.fromJson(Map<String, dynamic> json) {
    return DeliveryLog(
      id: json['id'] as String? ?? '',
      vendor: json['vendor'] as String? ?? 'OTHER',
      flatNumber: json['flat_number'] as String? ?? '',
      wingName: json['wing_name'] as String? ?? 'Wing A',
      deliveryPersonName: json['delivery_person_name'] as String? ?? 'Delivery Partner',
      phone: json['phone'] as String?,
      passCode: json['pass_code'] as String? ?? '',
      status: json['status'] as String? ?? 'CHECKED_IN',
      entryTime: json['entry_time'] as String? ?? json['check_in_time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor': vendor,
      'flat_number': flatNumber,
      'wing_name': wingName,
      'delivery_person_name': deliveryPersonName,
      'phone': phone,
      'pass_code': passCode,
      'status': status,
      'entry_time': entryTime,
    };
  }

  @override
  List<Object?> get props => [
        id,
        vendor,
        flatNumber,
        wingName,
        deliveryPersonName,
        phone,
        passCode,
        status,
        entryTime,
      ];
}
