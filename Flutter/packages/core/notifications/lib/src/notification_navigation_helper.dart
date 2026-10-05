import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../modules/notifications/logic/cubit/notification_cubit.dart';
import 'package:core_utils/core_utils.dart';
import '../../router/app_router.dart';

@lazySingleton
class NotificationNavigationHelper {
  static const int _maxRetries =
      100; // Prevent infinite loop if router is never ready
  bool _navigationInProgress = false;

  /// Navigates to the notifications page safely and immediately.
  /// Uses WidgetsBinding.instance.addPostFrameCallback with a localized retry count
  /// to wait for the navigator state to be ready and pushes the route immediately.
  void navigateToNotifications() {
    if (_navigationInProgress) {
      log('Navigation already in progress. Ignoring duplicate request.');
      return;
    }
    _navigationInProgress = true;
    unawaited(_doNavigate(0));
  }

  Future<void> _doNavigate(int retry) async {
    final state = AppRouter.navigatorKey.currentState;
    if (state != null && state.mounted) {
      try {
        final uri = AppRouter.router.routerDelegate.currentConfiguration.uri;

        // If already on the notifications page, refresh the content and release the lock immediately
        if (uri.path == AppRouter.notifications) {
          log('Already on notifications page. Refreshing content...');
          if (getIt.isRegistered<NotificationCubit>()) {
            await getIt<NotificationCubit>().loadNextPage(isRefresh: true);
          }
          _navigationInProgress = false;
          return;
        }

        log(
          'Adding listener to routerDelegate for event-driven lock release...',
        );
        final routerDelegate = AppRouter.router.routerDelegate;
        late void Function() listener;

        listener = () {
          // Once GoRouter updates its configuration (transitions to the page or redirects),
          // we release the lock and clean up the listener.
          log('GoRouter configuration updated. Releasing navigation lock.');
          _navigationInProgress = false;
          routerDelegate.removeListener(listener);
        };

        routerDelegate.addListener(listener);

        log('Pushing notifications page immediately...');
        try {
          if (getIt.isRegistered<NotificationCubit>()) {
            await getIt<NotificationCubit>().loadNextPage(isRefresh: true);
          }
          await AppRouter.router.push(AppRouter.notifications);
        } catch (error) {
          log('Push navigation failed: $error');
          _navigationInProgress = false;
          routerDelegate.removeListener(listener);
        }
      } catch (e) {
        log('Error routing to notifications: $e');
        _navigationInProgress = false;
      }
    } else {
      if (retry >= _maxRetries) {
        log('Reached maximum retries for notification navigation. Aborting.');
        _navigationInProgress = false;
        return;
      }
      log(
        'Navigator state not ready yet (Retry $retry/$_maxRetries). Scheduling on next frame...',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_doNavigate(retry + 1));
      });
    }
  }
}
