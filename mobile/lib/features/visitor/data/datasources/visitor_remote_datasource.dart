import '../../../../core/network/api_client.dart';
import '../../domain/entities/visitor_log.dart';
import '../../domain/entities/delivery_log.dart';
import '../../domain/entities/gate_summary.dart';

abstract class VisitorRemoteDataSource {
  Future<GateSummary> getGateSummary();
  Future<VisitorLog> registerVisitor(Map<String, dynamic> payload);
  Future<DeliveryLog> registerDelivery(Map<String, dynamic> payload);
  Future<VisitorLog> registerEmergencyEntry(Map<String, dynamic> payload);
  Future<VisitorLog> approveVisitor(String logId, bool approved, {String? notes});
  Future<VisitorLog> checkOutVisitor(String logId);
  Future<List<VisitorLog>> getVisitorHistory({String? search, String? status, String? entryType});
  Future<List<VisitorLog>> getPendingApprovals();
}

class VisitorRemoteDataSourceImpl implements VisitorRemoteDataSource {
  final ApiClient apiClient;

  VisitorRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<GateSummary> getGateSummary() async {
    final response = await apiClient.get<Map<String, dynamic>>('/api/v1/visitor/summary');
    if (response.data != null) {
      return GateSummary.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<VisitorLog> registerVisitor(Map<String, dynamic> payload) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/v1/visitor/register',
      data: payload,
    );
    if (response.data != null) {
      return VisitorLog.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<DeliveryLog> registerDelivery(Map<String, dynamic> payload) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/v1/visitor/delivery',
      data: payload,
    );
    if (response.data != null) {
      return DeliveryLog.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<VisitorLog> registerEmergencyEntry(Map<String, dynamic> payload) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/v1/visitor/emergency',
      data: payload,
    );
    if (response.data != null) {
      return VisitorLog.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<VisitorLog> approveVisitor(String logId, bool approved, {String? notes}) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/v1/visitor/approve',
      data: {'log_id': logId, 'approved': approved, 'notes': notes},
    );
    if (response.data != null) {
      return VisitorLog.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<VisitorLog> checkOutVisitor(String logId) async {
    final response = await apiClient.post<Map<String, dynamic>>('/api/v1/visitor/check-out/$logId');
    if (response.data != null) {
      return VisitorLog.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<List<VisitorLog>> getVisitorHistory({String? search, String? status, String? entryType}) async {
    final response = await apiClient.get<List<dynamic>>(
      '/api/v1/visitor/history',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
        if (entryType != null && entryType.isNotEmpty) 'entry_type': entryType,
      },
    );
    if (response.data != null) {
      return response.data!
          .map((e) => VisitorLog.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<VisitorLog>> getPendingApprovals() async {
    return await getVisitorHistory(status: 'WAITING_APPROVAL');
  }
}
