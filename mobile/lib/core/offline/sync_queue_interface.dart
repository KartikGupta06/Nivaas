/// Status of an outbox sync queue item.
enum SyncStatus {
  pending,
  syncing,
  failed,
  completed,
}

/// Abstract Interface for Offline Outbox Sync Queue operations.
abstract class ISyncQueue<T> {
  Future<void> enqueue(T mutationPayload);
  Future<List<T>> getPendingQueue();
  Future<void> markCompleted(String mutationId);
  Future<void> markFailed(String mutationId, String errorMessage);
  Future<void> clearQueue();
}
