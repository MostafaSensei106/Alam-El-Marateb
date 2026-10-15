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

/// Syncs the registration ID with the backend (authenticated endpoint).
/// Implemented by the app — the old monolith called its domain `ApiService`
/// directly. Receives the fresh ID; no-op when signed out.
typedef FcmTokenSync = Future<void> Function(String registrationId);

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

    // 7. Listen to (re-)registrations: every event carries the current
    // Installation ID (FID) — the backend's direct-send target.
    _messaging.onRegistered
        .listen((registrationId) async {
          log('FCM registered.');
          await _storage.setData<String>(
            key: PrefKeys.firebaseMessagingToken,
            value: registrationId,
          );
          unawaited(sendTokenToBackend());
        })
        .onError((Object err) {
          log('Error on registration: $err');
        });

    // Sync registration with the backend if already logged in
    unawaited(sendTokenToBackend());
  }

  Future<void> _handleNotificationInteraction(RemoteMessage message) async {
    log('Handling interaction for message: ${message.messageId}');
    await onNotificationTap?.call(message);
  }

  @override
  Future<String?> getRegistrationId() async {
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
          log('APNS token is not available. Skipping registration.');
          return null;
        }
      }
      // Subscribe BEFORE registering: registration may complete
      // synchronously with a cached ID and broadcast streams don't replay.
      final idFuture = _messaging.onRegistered.first.timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('FCM registration timed out'),
      );
      await _messaging.register();
      final registrationId = await idFuture;
      await _storage.setData<String>(
        key: PrefKeys.firebaseMessagingToken,
        value: registrationId,
      );
      return registrationId;
    } on TimeoutException {
      log('FCM registration timed out.');
      return null;
    } catch (e) {
      log('Error getting FCM registration ID: $e');
      return null;
    }
  }

  @override
  Stream<String> get onRegistered => _messaging.onRegistered;

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
            log('APNS token not ready/available. Skipping unregister.');
            await _storage.removeData(key: PrefKeys.firebaseMessagingToken);
            await _permissionService.openAppSettings();
            return;
          }
        }
        await _messaging.unregister();
        await _storage.removeData(key: PrefKeys.firebaseMessagingToken);
      } catch (e) {
        log('Error unregistering from FCM: $e');
      }
    } else {
      await initialize();
      await getRegistrationId();
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

    final registrationId = await getRegistrationId();
    if (registrationId == null || registrationId.isEmpty) return;

    try {
      await syncTokenToBackend?.call(registrationId);
    } catch (e) {
      log('Error sending FCM registration ID to backend: $e');
    }
  }
}
