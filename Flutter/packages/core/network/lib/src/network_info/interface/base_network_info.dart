/// Async connectivity probe. Lives behind an interface so interceptors
/// stay unit-testable without platform channels.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
