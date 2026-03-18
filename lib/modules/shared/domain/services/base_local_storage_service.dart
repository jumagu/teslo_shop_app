abstract class BaseLocalStorageService {
  Future<void> setItem<T>(String key, T value);

  Future<T?> getItem<T>(String key);

  Future<bool> removeItem(String key);
}
