import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/visitor_log.dart';
import '../../domain/entities/delivery_log.dart';
import '../../domain/entities/gate_summary.dart';

abstract class VisitorLocalDataSource {
  Future<void> cacheVisitorLog(VisitorLog log);
  Future<List<VisitorLog>> getCachedVisitorLogs();
  Future<void> updateVisitorLogStatus(String logId, String newStatus);

  Future<void> cacheDeliveryLog(DeliveryLog log);
  Future<List<DeliveryLog>> getCachedDeliveryLogs();

  Future<void> cacheGateSummary(GateSummary summary);
  Future<GateSummary?> getCachedGateSummary();

  Future<void> enqueueOutboxSync(String payloadType, Map<String, dynamic> payload);
  Future<List<Map<String, dynamic>>> getOutboxSyncQueue();
  Future<void> clearOutboxQueue();
}

class VisitorLocalDataSourceImpl implements VisitorLocalDataSource {
  static const String _visitorLogsKey = 'cached_visitor_logs';
  static const String _deliveryLogsKey = 'cached_delivery_logs';
  static const String _gateSummaryKey = 'cached_gate_summary';
  static const String _outboxQueueKey = 'visitor_outbox_queue';

  SharedPreferences? _prefs;

  VisitorLocalDataSourceImpl({SharedPreferences? sharedPreferences}) : _prefs = sharedPreferences;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<void> cacheVisitorLog(VisitorLog log) async {
    final logs = await getCachedVisitorLogs();
    final updated = [log, ...logs.where((l) => l.id != log.id)];
    final prefs = await _getPrefs();
    await prefs.setString(_visitorLogsKey, jsonEncode(updated.map((l) => l.toJson()).toList()));
  }

  @override
  Future<List<VisitorLog>> getCachedVisitorLogs() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_visitorLogsKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((e) => VisitorLog.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> updateVisitorLogStatus(String logId, String newStatus) async {
    final logs = await getCachedVisitorLogs();
    final updated = logs.map((l) {
      if (l.id == logId) {
        return l.copyWith(status: newStatus);
      }
      return l;
    }).toList();
    final prefs = await _getPrefs();
    await prefs.setString(_visitorLogsKey, jsonEncode(updated.map((l) => l.toJson()).toList()));
  }

  @override
  Future<void> cacheDeliveryLog(DeliveryLog log) async {
    final logs = await getCachedDeliveryLogs();
    final updated = [log, ...logs.where((l) => l.id != log.id)];
    final prefs = await _getPrefs();
    await prefs.setString(_deliveryLogsKey, jsonEncode(updated.map((l) => l.toJson()).toList()));
  }

  @override
  Future<List<DeliveryLog>> getCachedDeliveryLogs() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_deliveryLogsKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((e) => DeliveryLog.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> cacheGateSummary(GateSummary summary) async {
    final prefs = await _getPrefs();
    await prefs.setString(_gateSummaryKey, jsonEncode(summary.toJson()));
  }

  @override
  Future<GateSummary?> getCachedGateSummary() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_gateSummaryKey);
    if (raw != null) {
      try {
        return GateSummary.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> enqueueOutboxSync(String payloadType, Map<String, dynamic> payload) async {
    final prefs = await _getPrefs();
    final queue = await getOutboxSyncQueue();
    queue.add({'type': payloadType, 'payload': payload, 'timestamp': DateTime.now().toIso8601String()});
    await prefs.setString(_outboxQueueKey, jsonEncode(queue));
  }

  @override
  Future<List<Map<String, dynamic>>> getOutboxSyncQueue() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_outboxQueueKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((e) => e as Map<String, dynamic>).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> clearOutboxQueue() async {
    final prefs = await _getPrefs();
    await prefs.remove(_outboxQueueKey);
  }
}
