import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:alam_el_marateb_services/src/notifications/base_local_notification_service.dart';

/// Called when the user taps a local notification.
/// Implemented by the app (usually navigates to its notifications page) —
/// the old monolith hardcoded a router + domain cubit here.
typedef LocalNotificationTapHandler = FutureOr<void> Function(String? payload);

/// NOTE: intentionally NOT `@injectable` — [onNotificationTap] is
/// app-provided. Registered manually in `configureCoreDependencies()`.
class LocalNotificationService implements BaseLocalNotificationService {
  LocalNotificationService({this.onNotificationTap});

  final LocalNotificationTapHandler? onNotificationTap;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    // Initialize settings
    const androidInitSettings = AndroidInitializationSettings(
      ApplicationNotificationSettings.androidIcon,
    );
    const iosInitSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleLocalNotificationInteraction(details.payload);
      },
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        ApplicationNotificationSettings.highImportanceChannelId,
        ApplicationNotificationSettings.highImportanceChannelName,
        description: ApplicationNotificationSettings
            .highImportanceChannelDescription,
        importance: Importance.max,
      );
      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    // Handle interaction when app is opened from terminated state via local notification
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final details = await _localNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        _handleLocalNotificationInteraction(
          details.notificationResponse?.payload,
        );
      }
    });
  }

  @override
  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    await _localNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          ApplicationNotificationSettings.highImportanceChannelId,
          ApplicationNotificationSettings.highImportanceChannelName,
          channelDescription: ApplicationNotificationSettings
              .highImportanceChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: ApplicationNotificationSettings.androidIcon,
        ),
      ),
      payload: payload,
    );
  }

  void _handleLocalNotificationInteraction(String? payload) {
    log('Local notification clicked!');
    unawaited(
      Future.sync(() => onNotificationTap?.call(payload)),
    );
  }
}
