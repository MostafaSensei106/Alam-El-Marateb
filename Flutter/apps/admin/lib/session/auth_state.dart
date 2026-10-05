import 'dart:async';

import 'package:flutter/foundation.dart';

/// Minimal session state for router redirects. The full session
/// (user, roles, token versioning) arrives with modules/auth logic slice.
class AuthState extends ChangeNotifier {
  AuthState({required Future<bool> Function() hasSession}) {
    unawaited(_init(hasSession));
  }

  bool _ready = false;
  bool _loggedIn = false;

  bool get isReady => _ready;
  bool get isLoggedIn => _loggedIn;

  Future<void> _init(Future<bool> Function() hasSession) async {
    _loggedIn = await hasSession();
    _ready = true;
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    _loggedIn = value;
    _ready = true;
    notifyListeners();
  }
}
