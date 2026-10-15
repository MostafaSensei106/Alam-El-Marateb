import 'dart:async';

/// Push-notification port (FCM v17 registration model).
///
/// Identity is the Firebase Installation ID (FID): [register] the app, read
/// the FID from [onRegistered], send it to the backend as the direct-send
/// target. There is no token-refresh stream anymore — re-registration emits
/// a fresh [onRegistered] event.
abstract class BaseNotificationService {
  /// Initializes the notification service (permissions, listeners, etc.)
  Future<void> initialize();

  /// Registers with FCM and returns the Installation ID (FID), or `null`
  /// when registration can't complete (e.g. APNS unavailable on iOS).
  Future<String?> getRegistrationId();

  /// Stream of registration IDs (fires on every registration).
  Stream<String> get onRegistered;

  /// Sets whether push notifications are enabled
  Future<void> setNotificationsEnabled(bool enabled);

  /// Gets whether push notifications are enabled
  Future<bool> isNotificationsEnabled();

  /// Sends the current registration ID to the backend server if the user
  /// is authenticated.
  Future<void> sendTokenToBackend();
}
