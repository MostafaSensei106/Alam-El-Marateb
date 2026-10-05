import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:core_utils/core_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import 'base_local_notification_service.dart';
import 'notification_navigation_helper.dart';

@LazySingleton(as: BaseLocalNotificationService)
class LocalNotificationService implements BaseLocalNotificationService {
  LocalNotificationService(this._navigationHelper);

  final NotificationNavigationHelper _navigationHelper;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    // Initialize settings
    const androidInitSettings = AndroidInitializationSettings(
      NotificationConstants.androidIcon,
    );
    const iosInitSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleLocalNotificationInteraction();
      },
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        NotificationConstants.channelId,
        NotificationConstants.channelName,
        description: NotificationConstants.channelDescription,
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
        _handleLocalNotificationInteraction();
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
          NotificationConstants.channelId,
          NotificationConstants.channelName,
          channelDescription: NotificationConstants.channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: NotificationConstants.androidIcon,
        ),
      ),
      payload: payload,
    );
  }

  void _handleLocalNotificationInteraction() {
    log('Local notification clicked!');
    _navigationHelper.navigateToNotifications();
  }
}
