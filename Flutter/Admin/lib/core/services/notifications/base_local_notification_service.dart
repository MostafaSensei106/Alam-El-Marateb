abstract class BaseLocalNotificationService {
  /// Initializes the local notification service (settings, channels, callback listeners).
  Future<void> initialize();

  /// Displays a local notification with the given id, title, and body.
  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  });
}
