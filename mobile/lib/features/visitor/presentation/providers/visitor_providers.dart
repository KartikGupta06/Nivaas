import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_config_provider.dart';
import '../../../../app/providers/connectivity_provider.dart';
import '../../../../app/providers/dependency_injection_providers.dart';
import '../../data/datasources/visitor_remote_datasource.dart';
import '../../data/datasources/visitor_local_datasource.dart';
import '../../data/repositories/visitor_repository_impl.dart';
import '../../domain/entities/visitor_log.dart';
import '../../domain/entities/delivery_log.dart';
import '../../domain/entities/frequent_visitor.dart';
import '../../domain/entities/gate_summary.dart';

/// Datasource & Repository Providers
final visitorRemoteDataSourceProvider = Provider<VisitorRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VisitorRemoteDataSourceImpl(apiClient: apiClient);
});

final visitorLocalDataSourceProvider = Provider<VisitorLocalDataSource>((ref) {
  return VisitorLocalDataSourceImpl();
});

final visitorRepositoryProvider = Provider<VisitorRepositoryImpl>((ref) {
  final remoteDS = ref.watch(visitorRemoteDataSourceProvider);
  final localDS = ref.watch(visitorLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final appConfig = ref.watch(appConfigProvider);

  return VisitorRepositoryImpl(
    remoteDataSource: remoteDS,
    localDataSource: localDS,
    networkInfo: networkInfo,
    isDevelopment: appConfig.isDevelopment,
  );
});

/// Gate Notifier Provider (Live Summary & Check-In/Out state)
class GateNotifier extends StateNotifier<AsyncValue<GateSummary>> {
  final VisitorRepositoryImpl _repository;

  GateNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadGateSummary();
  }

  Future<void> loadGateSummary() async {
    state = const AsyncValue.loading();
    try {
      final summary = await _repository.getGateSummary();
      state = AsyncValue.data(summary);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<bool> checkOutVisitor(String logId) async {
    try {
      await _repository.checkOutVisitor(logId);
      await loadGateSummary();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final gateNotifierProvider = StateNotifierProvider<GateNotifier, AsyncValue<GateSummary>>((ref) {
  final repo = ref.watch(visitorRepositoryProvider);
  return GateNotifier(repo);
});

/// Visitor Notifier Provider (Visitor Registration & Emergency)
class VisitorNotifier extends StateNotifier<AsyncValue<VisitorLog?>> {
  final VisitorRepositoryImpl _repository;

  VisitorNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<VisitorLog?> registerVisitor({
    required String visitorName,
    required String phone,
    required String purpose,
    required String flatNumber,
    required String wingName,
    String? vehicleNumber,
    int visitorCount = 1,
    String? photoUrl,
    String? expectedDuration,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final log = await _repository.registerVisitor(
        visitorName: visitorName,
        phone: phone,
        purpose: purpose,
        flatNumber: flatNumber,
        wingName: wingName,
        vehicleNumber: vehicleNumber,
        visitorCount: visitorCount,
        photoUrl: photoUrl,
        expectedDuration: expectedDuration,
        notes: notes,
      );
      state = AsyncValue.data(log);
      return log;
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
      return null;
    }
  }

  Future<VisitorLog?> registerEmergency({
    required String emergencyType,
    String? flatNumber,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final log = await _repository.registerEmergencyEntry(
        emergencyType: emergencyType,
        flatNumber: flatNumber,
        notes: notes,
      );
      state = AsyncValue.data(log);
      return log;
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
      return null;
    }
  }
}

final visitorNotifierProvider = StateNotifierProvider<VisitorNotifier, AsyncValue<VisitorLog?>>((ref) {
  final repo = ref.watch(visitorRepositoryProvider);
  return VisitorNotifier(repo);
});

/// Delivery Notifier Provider
class DeliveryNotifier extends StateNotifier<AsyncValue<DeliveryLog?>> {
  final VisitorRepositoryImpl _repository;

  DeliveryNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<DeliveryLog?> registerDelivery({
    required String vendor,
    required String flatNumber,
    required String wingName,
    required String deliveryPersonName,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final delivery = await _repository.registerDelivery(
        vendor: vendor,
        flatNumber: flatNumber,
        wingName: wingName,
        deliveryPersonName: deliveryPersonName,
        phone: phone,
      );
      state = AsyncValue.data(delivery);
      return delivery;
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
      return null;
    }
  }
}

final deliveryNotifierProvider = StateNotifierProvider<DeliveryNotifier, AsyncValue<DeliveryLog?>>((ref) {
  final repo = ref.watch(visitorRepositoryProvider);
  return DeliveryNotifier(repo);
});

/// Approval Notifier Provider (Pending Approvals & Resident Actions)
class ApprovalNotifier extends StateNotifier<AsyncValue<List<VisitorLog>>> {
  final VisitorRepositoryImpl _repository;

  ApprovalNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPendingApprovals();
  }

  Future<void> loadPendingApprovals() async {
    state = const AsyncValue.loading();
    try {
      final pending = await _repository.getPendingApprovals();
      state = AsyncValue.data(pending);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<bool> respondToApproval(String logId, bool approved, {String? notes}) async {
    try {
      await _repository.approveVisitor(logId, approved, notes: notes);
      await loadPendingApprovals();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final approvalNotifierProvider = StateNotifierProvider<ApprovalNotifier, AsyncValue<List<VisitorLog>>>((ref) {
  final repo = ref.watch(visitorRepositoryProvider);
  return ApprovalNotifier(repo);
});

/// History Notifier Provider (Filtered Timeline Logs)
class HistoryNotifier extends StateNotifier<AsyncValue<List<VisitorLog>>> {
  final VisitorRepositoryImpl _repository;
  String _searchQuery = '';
  String _statusFilter = 'ALL';
  String _typeFilter = 'ALL';

  HistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final history = await _repository.getVisitorHistory(
        search: _searchQuery,
        status: _statusFilter,
        entryType: _typeFilter,
      );
      state = AsyncValue.data(history);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadHistory();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    loadHistory();
  }

  void setTypeFilter(String type) {
    _typeFilter = type;
    loadHistory();
  }
}

final historyNotifierProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<VisitorLog>>>((ref) {
  final repo = ref.watch(visitorRepositoryProvider);
  return HistoryNotifier(repo);
});

/// Frequent Visitors Provider
final frequentVisitorsProvider = FutureProvider<List<FrequentVisitor>>((ref) async {
  final repo = ref.watch(visitorRepositoryProvider);
  return await repo.getFrequentVisitors();
});
