/// Centralized Android notification configuration for the application.
///
/// This class groups all notification-related constants in one place so that the
/// app can use a consistent icon, sound, and notification channel setup across
/// all screens and services. Keeping these values centralized makes the code
/// easier to read, maintain, and update when notification behavior changes.
///
/// Example:
/// ```dart
/// final channelId = ApplicationNotificationSettings.defaultChannelId;
/// final channelName = ApplicationNotificationSettings.defaultChannelName;
/// ```
final class ApplicationNotificationSettings {
  ApplicationNotificationSettings._();

  /// The Android launcher icon used for notification badges and notification
  /// content.
  ///
  /// This value should point to a valid mipmap resource defined in the Android
  /// project. In most apps, it matches the app launcher icon.
  static const String androidIcon = '@mipmap/launcher_icon';

  /// The default Android notification sound.
  ///
  /// Setting this to `'default'` tells Android to use the system notification
  /// sound unless a custom sound is explicitly configured elsewhere.
  static const String androidSound = 'default';

  /// The notification channel ID for low-priority notifications.
  ///
  /// This identifier is used when creating the Android channel for messages or
  /// alerts that should be shown without interrupting the user too strongly.
  static const String lowImportanceChannelId = 'low_importance_channel';

  /// The display name for the low-priority notification channel.
  ///
  /// This name is shown to users in Android notification settings and can help
  /// them identify the purpose of the channel.
  static const String lowImportanceChannelName = 'Low Importance Notifications';

  /// Description for the low-priority notification channel.
  ///
  /// This text explains the purpose of the channel to the user when they review
  /// notification preferences in the system settings.
  static const String lowImportanceChannelDescription =
      'This channel is used for low importance notifications.';

  /// The notification channel ID for standard app notifications.
  ///
  /// This is the default channel used for regular updates and messages that are
  /// important enough to notify the user but not urgent.
  static const String defaultChannelId = 'default_channel';

  /// The display name for the default notification channel.
  static const String defaultChannelName = 'Default Notifications';

  /// Description for the default notification channel.
  ///
  /// This helps Android users understand what kind of alerts are sent through
  /// this channel.
  static const String defaultChannelDescription =
      'This channel is used for default notifications.';

  /// The notification channel ID for important notifications.
  ///
  /// Use this channel for alerts that require the user's immediate attention,
  /// such as critical updates, reminders, or urgent events.
  static const String highImportanceChannelId = 'high_importance_channel';

  /// The display name for the high-priority notification channel.
  static const String highImportanceChannelName =
      'High Importance Notifications';

  /// Description for the high-priority notification channel.
  ///
  /// This text explains to users that this channel is reserved for important or
  /// disruptive notifications that may need immediate attention.
  static const String highImportanceChannelDescription =
      'This channel is used for important notifications.';
}
