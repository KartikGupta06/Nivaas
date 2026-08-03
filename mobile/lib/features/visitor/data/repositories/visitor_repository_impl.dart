import 'dart:async';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/visitor_log.dart';
import '../../domain/entities/delivery_log.dart';
import '../../domain/entities/frequent_visitor.dart';
import '../../domain/entities/gate_summary.dart';
import '../../domain/repositories/visitor_repository.dart';
import '../datasources/visitor_remote_datasource.dart';
import '../datasources/visitor_local_datasource.dart';

class VisitorRepositoryImpl
    implements
        VisitorRepository,
        GateRepository,
        DeliveryRepository,
        ApprovalRepository,
        HistoryRepository {
  final VisitorRemoteDataSource remoteDataSource;
  final VisitorLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final bool isDevelopment;

  VisitorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    this.isDevelopment = true,
  });

  static const GateSummary _mockSummary = GateSummary(
    todayTotal: 24,
    visitorsInside: 5,
    visitorsExited: 17,
    pendingApprovals: 2,
    gateName: 'Main Gate 01',
  );

  static final List<VisitorLog> _mockLogs = [
    const VisitorLog(
      id: 'log_001',
      visitorName: 'Rajesh Verma',
      visitorPhone: '+91 9876543210',
      flatNumber: '402',
      wingName: 'Wing A',
      purpose: 'Guest',
      entryType: 'GUEST',
      status: 'CHECKED_IN',
      passCode: 'PASS-9102',
      vehicleNumber: 'DL 01 AB 1234',
      visitorCount: 2,
      checkInTime: 'Today, 04:30 PM',
      gateName: 'Main Gate',
      guardName: 'Guard Bahadur Singh',
    ),
    const VisitorLog(
      id: 'log_002',
      visitorName: 'Swiggy Delivery (Ravi Kumar)',
      visitorPhone: '+91 9876511111',
      flatNumber: '104',
      wingName: 'Wing B',
      purpose: 'Food Delivery (Swiggy)',
      entryType: 'DELIVERY',
      status: 'CHECKED_OUT',
      passCode: 'DEL-8812',
      checkInTime: 'Today, 03:10 PM',
      checkOutTime: 'Today, 03:22 PM',
      durationMinutes: 12,
      gateName: 'Main Gate',
      guardName: 'Guard Bahadur Singh',
    ),
    const VisitorLog(
      id: 'log_003',
      visitorName: 'Sunita Devi',
      visitorPhone: '+91 98111 22334',
      flatNumber: '402',
      wingName: 'Wing A',
      purpose: 'Daily Maid',
      entryType: 'FREQUENT',
      status: 'WAITING_APPROVAL',
      passCode: 'FRQ-1002',
      checkInTime: 'Today, 09:00 AM',
      gateName: 'Main Gate',
      guardName: 'Guard Bahadur Singh',
    ),
  ];

  static const List<FrequentVisitor> _mockFrequentVisitors = [
    FrequentVisitor(
      id: 'freq_1',
      name: 'Sunita Devi',
      phone: '+91 98111 22334',
      serviceType: 'Maid',
      flatsAssigned: 'A-402, B-101',
      passCode: 'PASS-STAFF-01',
    ),
    FrequentVisitor(
      id: 'freq_2',
      name: 'Ramesh Kumar',
      phone: '+91 98222 33445',
      serviceType: 'Driver',
      flatsAssigned: 'A-402',
      passCode: 'PASS-STAFF-02',
    ),
    FrequentVisitor(
      id: 'freq_3',
      name: 'Suresh Verma',
      phone: '+91 98333 44556',
      serviceType: 'Plumber',
      flatsAssigned: 'Society Maintenance',
      passCode: 'PASS-STAFF-03',
    ),
  ];

  @override
  Future<GateSummary> getGateSummary() async {
    try {
      if (await networkInfo.isConnected && !isDevelopment) {
        final summary = await remoteDataSource.getGateSummary();
        await localDataSource.cacheGateSummary(summary);
        return summary;
      }
      final cached = await localDataSource.getCachedGateSummary();
      if (cached != null) return cached;
      await localDataSource.cacheGateSummary(_mockSummary);
      return _mockSummary;
    } catch (_) {
      final cached = await localDataSource.getCachedGateSummary();
      if (cached != null) return cached;
      return _mockSummary;
    }
  }

  @override
  Future<VisitorLog> registerVisitor({
    required String visitorName,
    required String phone,
    required String purpose,
    required String flatNumber,
    required String wingName,
    String? vehicleNumber,
    int visitorCount = 1,
    String? photoUrl,
    String? idProofUrl,
    String? expectedDuration,
    String? notes,
  }) async {
    final nowStr = '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} PM';
    final passCode = 'PASS-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final newLog = VisitorLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      visitorName: visitorName,
      visitorPhone: phone,
      flatNumber: flatNumber,
      wingName: wingName,
      purpose: purpose,
      entryType: 'GUEST',
      status: 'WAITING_APPROVAL',
      passCode: passCode,
      vehicleNumber: vehicleNumber,
      visitorCount: visitorCount,
      photoUrl: photoUrl,
      checkInTime: nowStr,
    );

    await localDataSource.cacheVisitorLog(newLog);

    if (await networkInfo.isConnected && !isDevelopment) {
      try {
        final remoteLog = await remoteDataSource.registerVisitor({
          'visitor_name': visitorName,
          'phone': phone,
          'purpose': purpose,
          'wing_name': wingName,
          'flat_number': flatNumber,
          'vehicle_number': vehicleNumber,
          'visitor_count': visitorCount,
          'photo_url': photoUrl,
          'notes': notes,
        });
        await localDataSource.cacheVisitorLog(remoteLog);
        return remoteLog;
      } catch (_) {
        await localDataSource.enqueueOutboxSync('REGISTER_VISITOR', newLog.toJson());
      }
    } else {
      await localDataSource.enqueueOutboxSync('REGISTER_VISITOR', newLog.toJson());
    }

    return newLog;
  }

  @override
  Future<DeliveryLog> registerDelivery({
    required String vendor,
    required String flatNumber,
    required String wingName,
    required String deliveryPersonName,
    String? phone,
  }) async {
    final nowStr = '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} PM';
    final passCode = 'DEL-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    final delivery = DeliveryLog(
      id: 'del_${DateTime.now().millisecondsSinceEpoch}',
      vendor: vendor,
      flatNumber: flatNumber,
      wingName: wingName,
      deliveryPersonName: deliveryPersonName,
      phone: phone,
      passCode: passCode,
      status: 'CHECKED_IN',
      entryTime: nowStr,
    );

    final visitorLogEquivalent = VisitorLog(
      id: delivery.id,
      visitorName: '${delivery.vendor} ($deliveryPersonName)',
      visitorPhone: phone ?? '+91 9876500000',
      flatNumber: flatNumber,
      wingName: wingName,
      purpose: 'Delivery (${delivery.vendor})',
      entryType: 'DELIVERY',
      status: 'CHECKED_IN',
      passCode: passCode,
      checkInTime: nowStr,
    );

    await localDataSource.cacheDeliveryLog(delivery);
    await localDataSource.cacheVisitorLog(visitorLogEquivalent);

    if (await networkInfo.isConnected && !isDevelopment) {
      try {
        await remoteDataSource.registerDelivery({
          'vendor': vendor,
          'flat_number': flatNumber,
          'wing_name': wingName,
          'delivery_person_name': deliveryPersonName,
          'phone': phone,
        });
      } catch (_) {
        await localDataSource.enqueueOutboxSync('REGISTER_DELIVERY', delivery.toJson());
      }
    } else {
      await localDataSource.enqueueOutboxSync('REGISTER_DELIVERY', delivery.toJson());
    }

    return delivery;
  }

  @override
  Future<VisitorLog> registerEmergencyEntry({
    required String emergencyType,
    String? flatNumber,
    String? notes,
  }) async {
    final nowStr = '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} PM';
    final log = VisitorLog(
      id: 'emg_${DateTime.now().millisecondsSinceEpoch}',
      visitorName: 'EMERGENCY ($emergencyType)',
      visitorPhone: '112',
      flatNumber: flatNumber ?? 'ALL',
      wingName: 'ALL',
      purpose: 'Emergency Response ($emergencyType)',
      entryType: 'EMERGENCY',
      status: 'CHECKED_IN',
      passCode: 'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      checkInTime: nowStr,
    );

    await localDataSource.cacheVisitorLog(log);
    return log;
  }

  @override
  Future<VisitorLog> checkInVisitor(String logId) async {
    await getVisitorHistory(); // Ensure cache is populated
    await localDataSource.updateVisitorLogStatus(logId, 'CHECKED_IN');
    final logs = await getVisitorHistory();
    return logs.firstWhere((l) => l.id == logId);
  }

  @override
  Future<VisitorLog> checkOutVisitor(String logId) async {
    await getVisitorHistory(); // Ensure cache is populated
    await localDataSource.updateVisitorLogStatus(logId, 'CHECKED_OUT');
    if (await networkInfo.isConnected && !isDevelopment) {
      try {
        final remote = await remoteDataSource.checkOutVisitor(logId);
        await localDataSource.cacheVisitorLog(remote);
        return remote;
      } catch (_) {
        await localDataSource.enqueueOutboxSync('CHECK_OUT', {'log_id': logId});
      }
    } else {
      await localDataSource.enqueueOutboxSync('CHECK_OUT', {'log_id': logId});
    }

    final logs = await getVisitorHistory();
    return logs.firstWhere((l) => l.id == logId);
  }

  @override
  Future<VisitorLog> approveVisitor(String logId, bool approved, {String? notes}) async {
    await getVisitorHistory(); // Ensure cache is populated
    final status = approved ? 'APPROVED' : 'REJECTED';
    await localDataSource.updateVisitorLogStatus(logId, status);

    if (await networkInfo.isConnected && !isDevelopment) {
      try {
        final remote = await remoteDataSource.approveVisitor(logId, approved, notes: notes);
        await localDataSource.cacheVisitorLog(remote);
        return remote;
      } catch (_) {
        await localDataSource.enqueueOutboxSync('APPROVE_VISITOR', {'log_id': logId, 'approved': approved});
      }
    }

    final logs = await getVisitorHistory();
    return logs.firstWhere((l) => l.id == logId);
  }

  @override
  Future<List<VisitorLog>> getPendingApprovals() async {
    final history = await getVisitorHistory();
    return history.where((l) => l.status == 'WAITING_APPROVAL').toList();
  }

  @override
  Future<List<VisitorLog>> getVisitorHistory({
    String? search,
    String? status,
    String? entryType,
    String? dateFilter,
  }) async {
    try {
      var cached = await localDataSource.getCachedVisitorLogs();
      if (cached.isEmpty) {
        if (await networkInfo.isConnected && !isDevelopment) {
          final remote = await remoteDataSource.getVisitorHistory(search: search, status: status, entryType: entryType);
          for (final l in remote) {
            await localDataSource.cacheVisitorLog(l);
          }
          cached = remote;
        } else {
          for (final l in _mockLogs) {
            await localDataSource.cacheVisitorLog(l);
          }
          cached = _mockLogs;
        }
      }
      return _applyFilters(cached, search: search, status: status, entryType: entryType);
    } catch (_) {
      final cached = await localDataSource.getCachedVisitorLogs();
      return _applyFilters(cached.isNotEmpty ? cached : _mockLogs, search: search, status: status, entryType: entryType);
    }
  }

  @override
  Future<List<DeliveryLog>> getRecentDeliveries() async {
    try {
      final cached = await localDataSource.getCachedDeliveryLogs();
      if (cached.isNotEmpty) return cached;
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<FrequentVisitor>> getFrequentVisitors() async {
    return _mockFrequentVisitors;
  }

  @override
  Future<VisitorLog> quickCheckInFrequentVisitor(FrequentVisitor frequent, String flatNumber) async {
    final nowStr = '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} PM';
    final log = VisitorLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      visitorName: frequent.name,
      visitorPhone: frequent.phone,
      flatNumber: flatNumber,
      wingName: 'Wing A',
      purpose: frequent.serviceType,
      entryType: 'FREQUENT',
      status: 'CHECKED_IN',
      passCode: frequent.passCode,
      checkInTime: nowStr,
    );

    await localDataSource.cacheVisitorLog(log);
    return log;
  }

  List<VisitorLog> _applyFilters(
    List<VisitorLog> logs, {
    String? search,
    String? status,
    String? entryType,
  }) {
    return logs.where((l) {
      if (search != null && search.isNotEmpty) {
        final query = search.toLowerCase();
        final matchesName = l.visitorName.toLowerCase().contains(query);
        final matchesPhone = l.visitorPhone.contains(query);
        final matchesFlat = l.flatNumber.toLowerCase().contains(query);
        final matchesVehicle = l.vehicleNumber?.toLowerCase().contains(query) ?? false;
        if (!matchesName && !matchesPhone && !matchesFlat && !matchesVehicle) return false;
      }
      if (status != null && status.isNotEmpty && status != 'ALL') {
        if (l.status.toUpperCase() != status.toUpperCase()) return false;
      }
      if (entryType != null && entryType.isNotEmpty && entryType != 'ALL') {
        if (l.entryType.toUpperCase() != entryType.toUpperCase()) return false;
      }
      return true;
    }).toList();
  }
}
