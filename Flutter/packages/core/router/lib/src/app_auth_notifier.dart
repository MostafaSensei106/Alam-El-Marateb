import 'package:flutter/foundation.dart';

/// Listenable object used by GoRouter's `refreshListenable`.
/// Holds a synchronous, in-memory cache of the auth state so that
/// `authGuard` never has to await storage I/O during navigation.
///
/// Whenever `notifyAuthChanged()` is called with a *changed* value,
/// GoRouter automatically re-evaluates the `redirect` guard (`authGuard`)
/// and notifies its listeners.
final class AppAuthNotifier extends ChangeNotifier {
  AppAuthNotifier._();
  static final AppAuthNotifier instance = AppAuthNotifier._();

  bool _isAuthenticated = false;

  /// Synchronous snapshot of the current auth state.
  /// Safe to read from `authGuard` without any async work.
  bool get isAuthenticated => _isAuthenticated;

  /// Call this whenever login, logout, or token expiry occurs.
  /// Only notifies listeners (and triggers a GoRouter re-evaluation)
  /// when the value actually changes, to avoid redundant rebuilds.
  void notifyAuthChanged(bool isAuthenticated) {
    if (_isAuthenticated == isAuthenticated) return;
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }
}
