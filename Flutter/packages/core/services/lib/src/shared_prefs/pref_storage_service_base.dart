/// Abstract interface for local Key-Value preferences storage.
abstract interface class PrefStorageServiceBase {
  /// Asynchronously retrieves a value of type [T] associated with [key].
  /// Returns `null` if the key does not exist or if type casting fails.
  /// NOTE: Must stay async because [SecureStorageService] reads via
  /// MethodChannel (`Future`), so a unified sync getter is impossible.
  Future<T?> getData<T>({required String key});

  /// Asynchronously writes a value of type [T] associated with [key].
  /// Returns `true` if the value was successfully written.
  Future<bool> setData<T>({required String key, required T value});

  /// Asynchronously removes the value associated with [key].
  /// Returns `true` if the key was successfully removed.
  Future<bool> removeData({required String key});

  /// Asynchronously clears all stored preferences.
  /// Returns `true` if the storage was successfully cleared.
  Future<bool> clearAll();
}
