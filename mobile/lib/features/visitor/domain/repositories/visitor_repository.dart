import '../entities/visitor_log.dart';
import '../entities/delivery_log.dart';
import '../entities/frequent_visitor.dart';
import '../entities/gate_summary.dart';

abstract class VisitorRepository {
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
  });

  Future<VisitorLog> registerEmergencyEntry({
    required String emergencyType,
    String? flatNumber,
    String? notes,
  });
}

abstract class GateRepository {
  Future<GateSummary> getGateSummary();
  Future<VisitorLog> checkInVisitor(String logId);
  Future<VisitorLog> checkOutVisitor(String logId);
}

abstract class DeliveryRepository {
  Future<DeliveryLog> registerDelivery({
    required String vendor,
    required String flatNumber,
    required String wingName,
    required String deliveryPersonName,
    String? phone,
  });

  Future<List<DeliveryLog>> getRecentDeliveries();
}

abstract class ApprovalRepository {
  Future<VisitorLog> approveVisitor(String logId, bool approved, {String? notes});
  Future<List<VisitorLog>> getPendingApprovals();
}

abstract class HistoryRepository {
  Future<List<VisitorLog>> getVisitorHistory({
    String? search,
    String? status,
    String? entryType,
    String? dateFilter,
  });

  Future<List<FrequentVisitor>> getFrequentVisitors();
  Future<VisitorLog> quickCheckInFrequentVisitor(FrequentVisitor frequent, String flatNumber);
}
