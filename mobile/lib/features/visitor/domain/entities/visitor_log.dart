import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Visitor Log entry.
class VisitorLog extends Equatable {
  final String id;
  final String visitorName;
  final String visitorPhone;
  final String flatNumber;
  final String wingName;
  final String purpose;
  final String entryType;
  final String status; // WAITING_APPROVAL, APPROVED, REJECTED, CHECKED_IN, CHECKED_OUT, CANCELLED, EXPIRED
  final String? passCode;
  final String? vehicleNumber;
  final int visitorCount;
  final String? photoUrl;
  final String checkInTime;
  final String? checkOutTime;
  final int? durationMinutes;
  final String gateName;
  final String guardName;

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.visitorPhone,
    required this.flatNumber,
    required this.wingName,
    required this.purpose,
    this.entryType = 'GUEST',
    this.status = 'WAITING_APPROVAL',
    this.passCode,
    this.vehicleNumber,
    this.visitorCount = 1,
    this.photoUrl,
    required this.checkInTime,
    this.checkOutTime,
    this.durationMinutes,
    this.gateName = 'Main Gate',
    this.guardName = 'Security Guard',
  });

  VisitorLog copyWith({
    String? id,
    String? visitorName,
    String? visitorPhone,
    String? flatNumber,
    String? wingName,
    String? purpose,
    String? entryType,
    String? status,
    String? passCode,
    String? vehicleNumber,
    int? visitorCount,
    String? photoUrl,
    String? checkInTime,
    String? checkOutTime,
    int? durationMinutes,
    String? gateName,
    String? guardName,
  }) {
    return VisitorLog(
      id: id ?? this.id,
      visitorName: visitorName ?? this.visitorName,
      visitorPhone: visitorPhone ?? this.visitorPhone,
      flatNumber: flatNumber ?? this.flatNumber,
      wingName: wingName ?? this.wingName,
      purpose: purpose ?? this.purpose,
      entryType: entryType ?? this.entryType,
      status: status ?? this.status,
      passCode: passCode ?? this.passCode,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      visitorCount: visitorCount ?? this.visitorCount,
      photoUrl: photoUrl ?? this.photoUrl,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      gateName: gateName ?? this.gateName,
      guardName: guardName ?? this.guardName,
    );
  }

  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'] as String? ?? '',
      visitorName: json['visitor_name'] as String? ?? '',
      visitorPhone: json['visitor_phone'] as String? ?? '',
      flatNumber: json['flat_number'] as String? ?? '',
      wingName: json['wing_name'] as String? ?? 'Wing A',
      purpose: json['purpose'] as String? ?? 'Guest',
      entryType: json['entry_type'] as String? ?? 'GUEST',
      status: json['status'] as String? ?? 'WAITING_APPROVAL',
      passCode: json['pass_code'] as String?,
      vehicleNumber: json['vehicle_number'] as String?,
      visitorCount: (json['visitor_count'] as num?)?.toInt() ?? 1,
      photoUrl: json['photo_url'] as String?,
      checkInTime: json['check_in_time'] as String? ?? '',
      checkOutTime: json['check_out_time'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      gateName: json['gate_name'] as String? ?? 'Main Gate',
      guardName: json['guard_name'] as String? ?? 'Security Guard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitor_name': visitorName,
      'visitor_phone': visitorPhone,
      'flat_number': flatNumber,
      'wing_name': wingName,
      'purpose': purpose,
      'entry_type': entryType,
      'status': status,
      'pass_code': passCode,
      'vehicle_number': vehicleNumber,
      'visitor_count': visitorCount,
      'photo_url': photoUrl,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'duration_minutes': durationMinutes,
      'gate_name': gateName,
      'guard_name': guardName,
    };
  }

  @override
  List<Object?> get props => [
        id,
        visitorName,
        visitorPhone,
        flatNumber,
        wingName,
        purpose,
        entryType,
        status,
        passCode,
        vehicleNumber,
        visitorCount,
        photoUrl,
        checkInTime,
        checkOutTime,
        durationMinutes,
        gateName,
        guardName,
      ];
}
