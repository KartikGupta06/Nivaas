import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nivaas_mobile/core/network/network_info.dart';
import 'package:nivaas_mobile/features/visitor/domain/entities/visitor.dart';
import 'package:nivaas_mobile/features/visitor/domain/entities/visitor_log.dart';
import 'package:nivaas_mobile/features/visitor/domain/entities/delivery_log.dart';
import 'package:nivaas_mobile/features/visitor/domain/entities/frequent_visitor.dart';
import 'package:nivaas_mobile/features/visitor/domain/entities/gate_summary.dart';
import 'package:nivaas_mobile/features/visitor/data/repositories/visitor_repository_impl.dart';
import 'package:nivaas_mobile/features/visitor/data/datasources/visitor_remote_datasource.dart';
import 'package:nivaas_mobile/features/visitor/data/datasources/visitor_local_datasource.dart';

class MockNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => Stream.value([ConnectivityResult.wifi]);
}

class MockVisitorRemoteDataSource implements VisitorRemoteDataSource {
  @override
  Future<GateSummary> getGateSummary() async {
    return const GateSummary(
      todayTotal: 25,
      visitorsInside: 6,
      visitorsExited: 17,
      pendingApprovals: 2,
      gateName: 'Main Gate',
    );
  }

  @override
  Future<VisitorLog> registerVisitor(Map<String, dynamic> payload) async {
    return VisitorLog(
      id: 'log_999',
      visitorName: payload['visitor_name'] as String,
      visitorPhone: payload['phone'] as String,
      flatNumber: payload['flat_number'] as String,
      wingName: payload['wing_name'] as String,
      purpose: payload['purpose'] as String,
      entryType: 'GUEST',
      status: 'WAITING_APPROVAL',
      passCode: 'PASS-9999',
      checkInTime: 'Today, 05:00 PM',
    );
  }

  @override
  Future<DeliveryLog> registerDelivery(Map<String, dynamic> payload) async {
    return DeliveryLog(
      id: 'del_999',
      vendor: payload['vendor'] as String,
      flatNumber: payload['flat_number'] as String,
      wingName: payload['wing_name'] as String,
      deliveryPersonName: payload['delivery_person_name'] as String,
      passCode: 'DEL-9999',
      entryTime: 'Today, 05:00 PM',
    );
  }

  @override
  Future<VisitorLog> registerEmergencyEntry(Map<String, dynamic> payload) async {
    return VisitorLog(
      id: 'emg_999',
      visitorName: 'EMERGENCY (${payload['emergency_type']})',
      visitorPhone: '112',
      flatNumber: payload['flat_number'] as String? ?? 'ALL',
      wingName: 'ALL',
      purpose: 'Emergency SOS',
      entryType: 'EMERGENCY',
      status: 'CHECKED_IN',
      passCode: 'SOS-9999',
      checkInTime: 'Today, 05:00 PM',
    );
  }

  @override
  Future<VisitorLog> approveVisitor(String logId, bool approved, {String? notes}) async {
    return VisitorLog(
      id: logId,
      visitorName: 'Rajesh Verma',
      visitorPhone: '+91 9876543210',
      flatNumber: '402',
      wingName: 'Wing A',
      purpose: 'Guest',
      status: approved ? 'APPROVED' : 'REJECTED',
      passCode: 'PASS-402',
      checkInTime: 'Today, 04:30 PM',
    );
  }

  @override
  Future<VisitorLog> checkOutVisitor(String logId) async {
    return VisitorLog(
      id: logId,
      visitorName: 'Rajesh Verma',
      visitorPhone: '+91 9876543210',
      flatNumber: '402',
      wingName: 'Wing A',
      purpose: 'Guest',
      status: 'CHECKED_OUT',
      passCode: 'PASS-402',
      checkInTime: 'Today, 04:30 PM',
      checkOutTime: 'Today, 05:15 PM',
      durationMinutes: 45,
    );
  }

  @override
  Future<List<VisitorLog>> getVisitorHistory({String? search, String? status, String? entryType}) async {
    return [
      const VisitorLog(
        id: 'log_001',
        visitorName: 'Rajesh Verma',
        visitorPhone: '+91 9876543210',
        flatNumber: '402',
        wingName: 'Wing A',
        purpose: 'Guest',
        status: 'CHECKED_IN',
        passCode: 'PASS-9102',
        checkInTime: 'Today, 04:30 PM',
      ),
    ];
  }

  @override
  Future<List<VisitorLog>> getPendingApprovals() async {
    return await getVisitorHistory(status: 'WAITING_APPROVAL');
  }
}

class MockVisitorLocalDataSource implements VisitorLocalDataSource {
  final List<VisitorLog> _cachedLogs = [];
  final List<DeliveryLog> _cachedDeliveries = [];
  final List<Map<String, dynamic>> _outbox = [];
  GateSummary? _cachedSummary;

  @override
  Future<void> cacheVisitorLog(VisitorLog log) async => _cachedLogs.add(log);
  @override
  Future<List<VisitorLog>> getCachedVisitorLogs() async => _cachedLogs;
  @override
  Future<void> updateVisitorLogStatus(String logId, String newStatus) async {
    final idx = _cachedLogs.indexWhere((l) => l.id == logId);
    if (idx != -1) {
      _cachedLogs[idx] = _cachedLogs[idx].copyWith(status: newStatus);
    }
  }

  @override
  Future<void> cacheDeliveryLog(DeliveryLog log) async => _cachedDeliveries.add(log);
  @override
  Future<List<DeliveryLog>> getCachedDeliveryLogs() async => _cachedDeliveries;

  @override
  Future<void> cacheGateSummary(GateSummary summary) async => _cachedSummary = summary;
  @override
  Future<GateSummary?> getCachedGateSummary() async => _cachedSummary;

  @override
  Future<void> enqueueOutboxSync(String payloadType, Map<String, dynamic> payload) async {
    _outbox.add({'type': payloadType, 'payload': payload});
  }

  @override
  Future<List<Map<String, dynamic>>> getOutboxSyncQueue() async => _outbox;

  @override
  Future<void> clearOutboxQueue() async => _outbox.clear();
}

void main() {
  late VisitorRepositoryImpl repository;
  late MockVisitorRemoteDataSource remoteDS;
  late MockVisitorLocalDataSource localDS;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDS = MockVisitorRemoteDataSource();
    localDS = MockVisitorLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = VisitorRepositoryImpl(
      remoteDataSource: remoteDS,
      localDataSource: localDS,
      networkInfo: networkInfo,
      isDevelopment: true,
    );
  });

  group('Phase 05 Visitor & Gate System Unit Tests', () {
    test('Visitor & VisitorLog serialization and props comparison', () {
      const visitor = Visitor(id: 'vis_1', fullName: 'Amit Sharma', phone: '+91 9876543210');
      expect(visitor.fullName, equals('Amit Sharma'));

      const log = VisitorLog(
        id: 'vlog_1',
        visitorName: 'Amit Sharma',
        visitorPhone: '+91 9876543210',
        flatNumber: '104',
        wingName: 'Wing B',
        purpose: 'Guest',
        checkInTime: '10:00 AM',
      );
      expect(log.status, equals('WAITING_APPROVAL'));
      expect(log.entryType, equals('GUEST'));
    });

    test('Gate Summary retrieval and counter validation', () async {
      final summary = await repository.getGateSummary();
      expect(summary.todayTotal, equals(24));
      expect(summary.visitorsInside, equals(5));
    });

    test('Visitor Registration generates pass code and updates cache', () async {
      final log = await repository.registerVisitor(
        visitorName: 'Karan Mehra',
        phone: '+91 98111 22334',
        purpose: 'Service',
        flatNumber: '202',
        wingName: 'Wing C',
      );

      expect(log.visitorName, equals('Karan Mehra'));
      expect(log.passCode, startsWith('PASS-'));
      expect(log.status, equals('WAITING_APPROVAL'));

      final history = await repository.getVisitorHistory();
      expect(history.any((l) => l.visitorName == 'Karan Mehra'), isTrue);
    });

    test('Delivery Entry creates delivery log and auto check-in', () async {
      final delivery = await repository.registerDelivery(
        vendor: 'SWIGGY',
        flatNumber: '402',
        wingName: 'Wing A',
        deliveryPersonName: 'Ravi',
      );

      expect(delivery.vendor, equals('SWIGGY'));
      expect(delivery.status, equals('CHECKED_IN'));
      expect(delivery.passCode, startsWith('DEL-'));
    });

    test('Emergency Entry bypasses approval with SOS pass code', () async {
      final log = await repository.registerEmergencyEntry(
        emergencyType: 'AMBULANCE',
        flatNumber: '402',
      );

      expect(log.entryType, equals('EMERGENCY'));
      expect(log.status, equals('CHECKED_IN'));
      expect(log.passCode, startsWith('SOS-'));
    });

    test('Frequent visitor quick check-in creates entry log', () async {
      const staff = FrequentVisitor(
        id: 'freq_1',
        name: 'Sunita Devi',
        phone: '+91 98111 22334',
        serviceType: 'Maid',
        flatsAssigned: 'A-402',
        passCode: 'PASS-STAFF-01',
      );

      final log = await repository.quickCheckInFrequentVisitor(staff, '402');
      expect(log.visitorName, equals('Sunita Devi'));
      expect(log.entryType, equals('FREQUENT'));
      expect(log.status, equals('CHECKED_IN'));
    });

    test('Check-Out updates status to CHECKED_OUT', () async {
      final updated = await repository.checkOutVisitor('log_001');
      expect(updated.status, equals('CHECKED_OUT'));
    });

    test('Approval flow updates visitor status to APPROVED or REJECTED', () async {
      final approvedLog = await repository.approveVisitor('log_003', true);
      expect(approvedLog.status, equals('APPROVED'));
    });
  });
}
