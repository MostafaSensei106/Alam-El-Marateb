import 'dart:async';

abstract class BaseNotificationService {
  /// Initializes the notification service (permissions, listeners, etc.)
  Future<void> initialize();

  /// Gets the current FCM token
  Future<String?> getToken();

  /// Stream of token updates
  Stream<String> get onTokenRefresh;

  /// Sets whether push notifications are enabled
  Future<void> setNotificationsEnabled(bool enabled);

  /// Gets whether push notifications are enabled
  Future<bool> isNotificationsEnabled();

  /// Sends the current FCM token to the backend server if the user is authenticated.
  Future<void> sendTokenToBackend();
}
