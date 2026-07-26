import 'dart:async';
import '../network/network_info.dart';
import 'local_cache_service.dart';
import 'sync_queue_interface.dart';

/// Abstract Base Offline Repository orchestrating Local Reads, Outbox Queueing, and Remote Sync triggers.
abstract class OfflineRepository<T> {
  final NetworkInfo networkInfo;
  final LocalCacheService<T> localCache;
  final ISyncQueue<T> syncQueue;

  const OfflineRepository({
    required this.networkInfo,
    required this.localCache,
    required this.syncQueue,
  });

  /// Reads entity from local database stream immediately (0ms latency)
  Future<List<T>> getLocalData() async {
    return await localCache.getAllItems();
  }

  /// Saves mutation locally and enqueues to outbox sync queue
  Future<void> saveOfflineMutation(T data) async {
    await localCache.cacheItem(data);
    await syncQueue.enqueue(data);
    if (await networkInfo.isConnected) {
      unawaited(triggerBackgroundSync());
    }
  }

  /// Triggers background outbox processing when connectivity is active
  Future<void> triggerBackgroundSync();
}
