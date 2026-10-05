import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../modules/notifications/logic/cubit/notification_cubit.dart';
import '../../constants/pref_keys.dart';
import 'package:core_utils/core_utils.dart';
import '../../networking/api_service/api_service.dart';
import '../../services/shared_prefs/base_pref_storage_service.dart';
import '../permissions/base_permission_service.dart';
import '../shared_prefs/storage_facade.dart';
import 'base_local_notification_service.dart';
import 'base_notification_service.dart';
import 'notification_navigation_helper.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
}

@LazySingleton(as: BaseNotificationService)
class FirebaseNotificationService implements BaseNotificationService {
  FirebaseNotificationService(
    this._permissionService,
    this._storageService,
    this._localNotificationService,
    this._navigationHelper,
    this._messaging,
  );

  final BasePermissionService _permissionService;
  final StorageFacade _storageService;
  final BaseLocalNotificationService _localNotificationService;
  final NotificationNavigationHelper _navigationHelper;
  final FirebaseMessaging _messaging;

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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Enable foreground notification presentation options for iOS/macOS
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Got a message in the foreground!');
      log('Message data: ${message.data}');

      // If the app is open, refresh the notifications cubit to update the badge/list in real-time
      if (getIt.isRegistered<NotificationCubit>()) {
        unawaited(getIt<NotificationCubit>().loadNextPage(isRefresh: true));
      }

      // Show local notification for Android (since iOS shows it automatically via setForegroundNotificationPresentationOptions)
      if (Platform.isAndroid) {
        final notification = message.notification;
        if (notification != null) {
          await _localNotificationService.showNotification(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
          );
        }
      }
    });

    // 4. Handle interaction when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('App opened from notification in background!');
      await _handleNotificationInteraction(message);
    });

    // 5. Handle interaction when app is opened from terminated state
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        log('App opened from notification in terminated state!');
        await _handleNotificationInteraction(initialMessage);
      }
    });

    // 6. Listen to token refresh
    _messaging.onTokenRefresh
        .listen((fcmToken) async {
          log('FCM Token refreshed: $fcmToken');
          await _storageService.setData<String>(
            key: PrefKeys.fcmToken,
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
    _navigationHelper.navigateToNotifications();
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
      final token = await _messaging.getToken();
      if (token != null) {
        await _storageService.setData<String>(
          key: PrefKeys.fcmToken,
          value: token,
        );
      }
      log('FCM Token: $token');
      return token;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await getIt<BasePrefStorageService>().setData<bool>(
      key: PrefKeys.notificationsEnabled,
      value: enabled,
    );
    await _messaging.setAutoInitEnabled(enabled);
    if (!enabled) {
      try {
        if (Platform.isIOS) {
          final apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            log('APNS token not ready/available. Skipping deleteToken.');
            await _storageService.removeData(key: PrefKeys.fcmToken);
            await _permissionService.openAppSettings();
            return;
          }
        }
        await _messaging.deleteToken();
        await _storageService.removeData(key: PrefKeys.fcmToken);
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
    final enabled = await getIt<BasePrefStorageService>().getData<bool>(
      key: PrefKeys.notificationsEnabled,
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
      final userToken = await getIt<BasePrefStorageService>().getData<String>(
        key: PrefKeys.userToken,
      );
      if (userToken != null && userToken.isNotEmpty) {
        log('Sending FCM token to backend...');
        await getIt<ApiService>().updateFcmToken({'fcm_token': fcmToken});
        log('FCM token sent to backend successfully!');
      } else {
        log('User is not authenticated. Skip sending FCM token.');
      }
    } catch (e) {
      log('Error sending FCM token to backend: $e');
    }
  }
}
