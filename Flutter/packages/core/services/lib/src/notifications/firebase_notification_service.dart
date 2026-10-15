import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import 'package:alam_el_marateb_services/src/notifications/base_local_notification_service.dart';
import 'package:alam_el_marateb_services/src/notifications/base_notification_service.dart';
import 'package:alam_el_marateb_services/src/permissions/permission_service_base.dart';
import 'package:alam_el_marateb_services/src/shared_prefs/pref_storage_service_base.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
}

/// Syncs the FCM token with the backend (authenticated endpoint).
/// Implemented by the app — the old monolith called its domain `ApiService`
/// directly. Receives the fresh token; no-op when signed out.
typedef FcmTokenSync = Future<void> Function(String fcmToken);

/// Handles a foreground FCM message (e.g. refresh the app's notifications
/// list). The default behavior shows a local notification on Android.
typedef ForegroundMessageHandler = Future<void> Function(
  RemoteMessage message,
  BaseLocalNotificationService localNotifications,
);

/// Called when the user taps a push notification (app opened/resumed).
/// Implemented by the app (usually navigates to its notifications page).
typedef PushNotificationTapHandler = Future<void> Function(
  RemoteMessage message,
);

Future<void> _defaultForegroundHandler(
  RemoteMessage message,
  BaseLocalNotificationService localNotifications,
) async {
  log('Got a message in the foreground! data: ${message.data}');
  if (Platform.isAndroid) {
    final notification = message.notification;
    if (notification != null) {
      await localNotifications.showNotification(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
      );
    }
  }
}

/// NOTE: intentionally NOT `@injectable` — the optional callbacks
/// ([syncTokenToBackend], [onForegroundMessage], [onNotificationTap]) are
/// app-provided. Registered manually in `configureCoreDependencies()`.
class FirebaseNotificationService implements BaseNotificationService {
  FirebaseNotificationService(
    this._permissionService,
    this._storage,
    this._localNotificationService,
    this._messaging, {
    this.syncTokenToBackend,
    this.onForegroundMessage = _defaultForegroundHandler,
    this.onNotificationTap,
  });

  final PermissionServiceBase _permissionService;
  final PrefStorageServiceBase _storage;
  final BaseLocalNotificationService _localNotificationService;
  final FirebaseMessaging _messaging;
  final FcmTokenSync? syncTokenToBackend;
  final ForegroundMessageHandler onForegroundMessage;
  final PushNotificationTapHandler? onNotificationTap;

  @override
  Future<void> initialize() async {
    final enabled = await isNotificationsEnabled();
    await _messaging.setAutoInitEnabled(enabled);
    if (!enabled) return;

    // 1. Request permissions (Android 13+ and iOS)
    final granted = await _permissionService.requestNotificationPermission();
    log('User granted notification permission: $granted');

    // Initialize local notification service
    await _localNotificationService.initialize();

    // 2. Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 3. Enable foreground notification presentation options for iOS/macOS
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await onForegroundMessage(message, _localNotificationService);
    });

    // 5. Handle interaction when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('App opened from notification in background!');
      await _handleNotificationInteraction(message);
    });

    // 6. Handle interaction when app is opened from terminated state
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        log('App opened from notification in terminated state!');
        await _handleNotificationInteraction(initialMessage);
      }
    });

    // 7. Listen to token refresh
    // ignore: deprecated_member_use_from_same_package /* FCM v17 FID migration needs backend change (see file doc) */
    _messaging.onTokenRefresh
        .listen((fcmToken) async {
          log('FCM Token refreshed.');
          await _storage.setData<String>(
            key: PrefKeys.firebaseMessagingToken,
            value: fcmToken,
          );
          unawaited(sendTokenToBackend());
        })
        .onError((Object err) {
          log('Error on token refresh: $err');
        });

    // Sync token with the backend if already logged in
    unawaited(sendTokenToBackend());
  }

  Future<void> _handleNotificationInteraction(RemoteMessage message) async {
    log('Handling interaction for message: ${message.messageId}');
    await onNotificationTap?.call(message);
  }

  @override
  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        var apnsToken = await _messaging.getAPNSToken();
        var retries = 0;
        while (apnsToken == null && retries < 3) {
          log(
            'APNS token not ready yet. Retrying in 2 seconds... (Retry $retries/3)',
          );
          await Future<void>.delayed(const Duration(seconds: 2));
          apnsToken = await _messaging.getAPNSToken();
          retries++;
        }
        if (apnsToken == null) {
          log('APNS token is not available. Skipping FCM token retrieval.');
          return null;
        }
      }
      // ignore: deprecated_member_use_from_same_package
      final token = await _messaging.getToken();
      if (token != null) {
        await _storage.setData<String>(
          key: PrefKeys.firebaseMessagingToken,
          value: token,
        );
      }
      return token;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _storage.setData<bool>(
      key: PrefKeys.isNotificationEnabled,
      value: enabled,
    );
    await _messaging.setAutoInitEnabled(enabled);
    if (!enabled) {
      try {
        if (Platform.isIOS) {
          final apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            log('APNS token not ready/available. Skipping deleteToken.');
            await _storage.removeData(key: PrefKeys.firebaseMessagingToken);
            await _permissionService.openAppSettings();
            return;
          }
        }
        // ignore: deprecated_member_use_from_same_package
        await _messaging.deleteToken();
        await _storage.removeData(key: PrefKeys.firebaseMessagingToken);
      } catch (e) {
        log('Error deleting FCM token: $e');
      }
    } else {
      await initialize();
      await getToken();
    }
  }

  @override
  Future<bool> isNotificationsEnabled() async {
    final enabled = await _storage.getData<bool>(
      key: PrefKeys.isNotificationEnabled,
    );
    return enabled ?? true;
  }

  @override
  Future<void> sendTokenToBackend() async {
    final enabled = await isNotificationsEnabled();
    if (!enabled) return;

    final fcmToken = await getToken();
    if (fcmToken == null || fcmToken.isEmpty) return;

    try {
      await syncTokenToBackend?.call(fcmToken);
    } catch (e) {
      log('Error sending FCM token to backend: $e');
    }
  }
}
