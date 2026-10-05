import 'package:flutter/foundation.dart';

/// App-agnostic auth-status bus. Session services notify here;
/// each app forwards to its own router/session state in DI setup.
class SessionAuthNotifier extends ChangeNotifier {
  SessionAuthNotifier._();

  static final SessionAuthNotifier instance = SessionAuthNotifier._();

  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  void notifyAuthChanged(bool loggedIn) {
    _loggedIn = loggedIn;
    notifyListeners();
  }

  @visibleForTesting
  void resetForTesting(bool value) {
    _loggedIn = value;
    notifyListeners();
  }
}
