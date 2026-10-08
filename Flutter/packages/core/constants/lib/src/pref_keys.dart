/// Central storage keys used throughout the application for persisted preferences.
///
/// This class keeps all preference names in one place so they are easy to read,
/// reuse, and maintain. Use these constants whenever you read or write values in
/// local storage such as SharedPreferences, HydratedStorage, or any custom
/// persistence layer.
///
/// Example:
/// ```dart
/// final value = preferences.getBool(PrefKeys.isFirstLaunch) ?? true;
/// ```
final class PrefKeys {
  PrefKeys._();

  /// Indicates whether this is the first time the app has been launched.
  ///
  /// Commonly used to decide whether to show onboarding or an initial setup flow.
  static const String isFirstLaunch = 'is_first_launch';

  /// Prevents the app from showing the notification reminder again.
  ///
  /// Useful for temporary user preferences such as dismissing a notification
  /// prompt permanently.
  static const String dontShowNotificationAgain =
      'dont_show_notification_again';

  /// Tracks whether push notifications are enabled for the current user.
  static const String isNotificationEnabled = 'is_notification_enabled';

  /// Stores the selected localization language code, for example `en` or `fr`.
  static const String localizationLanguageCode = 'localization_language_code';

  /// Stores the selected app theme mode.
  ///
  /// Values usually correspond to a theme mode enum such as light, dark, or
  /// system default.
  static const String themeMode = 'theme_mode';

  /// Indicates whether the "remember me" option is enabled for authentication.
  static const String isRememberMeEnabled = 'is_remember_me_enabled';

  /// Indicates whether the onboarding flow has already been completed.
  static const String hasCompletedOnboarding = 'has_completed_onboarding';

  /// Stores the authenticated user access token.
  ///
  /// This value is typically used for authorizing requests to protected APIs.
  static const String userToken = 'user_token';

  /// Stores the Firebase Cloud Messaging device token used for push notifications.
  static const String firebaseMessagingToken = 'firebase_messaging_token';

  /// Stores the encryption key used by hydrated storage.
  ///
  /// This key is important for securely encrypting persisted state and should be
  /// handled carefully.
  static const String hydratedStorageEncryptionKey =
      'hydrated_storage_encryption_key';
}
