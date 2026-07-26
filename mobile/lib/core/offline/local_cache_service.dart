/// Interface contract for Local Cache Data Sources.
abstract class LocalCacheService<T> {
  Future<void> cacheItem(T item);
  Future<void> cacheList(List<T> items);
  Future<T?> getItem(String id);
  Future<List<T>> getAllItems();
  Future<void> clearCache();
}
