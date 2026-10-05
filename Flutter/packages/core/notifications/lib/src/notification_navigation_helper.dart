import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';

/// Router-agnostic navigation guard: retries until the app reports
/// a handled navigation or gives up. Apps wire [onNavigate] to their
/// own GoRouter (push notifications route), keeping this helper portable.
class NotificationNavigationHelper {
  NotificationNavigationHelper({
    required Future<bool> Function() onNavigate,
    this.maxRetries = 100,
  }) : _onNavigate = onNavigate;

  final Future<bool> Function() _onNavigate;
  final int maxRetries;
  bool _navigationInProgress = false;

  /// Navigates to the notifications page safely and immediately.
  void navigateToNotifications() {
    if (_navigationInProgress) {
      log('Navigation already in progress. Ignoring duplicate request.');
      return;
    }
    _navigationInProgress = true;
    unawaited(_doNavigate(0));
  }

  Future<void> _doNavigate(int retry) async {
    try {
      if (await _onNavigate()) {
        log('Notification navigation handled. Releasing lock.');
        _navigationInProgress = false;
        return;
      }
    } catch (error) {
      log('Push navigation failed: $error');
      _navigationInProgress = false;
      return;
    }
    if (retry >= maxRetries) {
      log('Reached maximum retries for notification navigation. Aborting.');
      _navigationInProgress = false;
      return;
    }
    log(
      'Navigator not ready yet (Retry $retry/$maxRetries). Scheduling on next frame...',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_doNavigate(retry + 1));
    });
  }
}
