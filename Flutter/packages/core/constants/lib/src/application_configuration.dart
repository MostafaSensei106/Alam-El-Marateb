/// General application settings, including project and app variant names and debug mode.
final class ApplicationConfiguration {
  ApplicationConfiguration._();

  /// The project display name.
  static const String projectName = 'Alamel Marateb';

  /// The admin app display name.
  static const String appConsumerAdmin = 'Alamel Marateb Admin';

  /// The user app display name.
  static const String appConsumerUser = 'Alamel Marateb User';

  /// The staff app display name.
  static const String appConsumerStaff = 'Alamel Marateb Staff';

  /// Whether debug mode is enabled.
  static const bool isDebugMode = false;
}

/// Margin and padding constants used to lay out interface spacing.
final class ApplicationPadding {
  ApplicationPadding._();

  /// Extra-small margin of 4 units.
  static const marginExtraSmall = 4.0;

  /// Small margin of 8 units.
  static const double marginSmall = 8.0;

  /// Default margin of 8 units.
  static const double margin = 8.0;

  /// Medium margin of 16 units.
  static const double marginMedium = 16.0;

  /// Large margin of 24 units.
  static const double marginLarge = 24.0;

  /// Extra-small padding of 4 units.
  static const double paddingExtraSmall = 4.0;

  /// Small padding of 8 units.
  static const double paddingSmall = 8.0;

  /// Medium padding of 16 units.
  static const double paddingMedium = 16.0;

  /// Large padding of 24 units.
  static const double paddingLarge = 24.0;

  /// Base padding of 16 units.
  static const double padding = 16.0;

  /// Half the base padding.
  static const double paddingHalf = padding / 2;

  /// One quarter of the base padding.
  static const double paddingQuarter = padding / 4;

  /// Twice the base padding.
  static const double paddingDouble = padding * 2;

  /// One third of the base padding.
  static const double paddingThird = padding / 3;

  /// Three quarters of the base padding.
  static const double paddingThreeQuarter = padding * 3 / 4;
}

/// Radius constants for component corners, borders, and avatars.
final class ApplicationRadius {
  ApplicationRadius._();

  /// Extra-small radius of 4 units.
  static const double radiusExtraSmall = 4.0;

  /// Small radius of 8 units.
  static const double radiusSmall = 8.0;

  /// Medium radius of 16 units.
  static const double radiusMedium = 16.0;

  /// Large radius of 24 units.
  static const double radiusLarge = 24.0;

  /// Extra-large radius of 32 units.
  static const double radiusExtraLarge = 32.0;

  /// Inner border radius of 8 units.
  static const double innerBorderRadius = 8.0;

  /// Outer border radius: the inner radius plus half the base padding.
  static const double outerBorderRadius =
      innerBorderRadius + ApplicationPadding.paddingHalf;

  /// Avatar radius of 30 units.
  static const double avatarRadius = 30.0;
}

/// Icon size constants for application icons.
final class ApplicationIconsSize {
  ApplicationIconsSize._();

  /// Extra-small icon size of 16 units.
  static const double iconSizeExtraSmall = 16.0;

  /// Small icon size of 24 units.
  static const double iconSizeSmall = 24.0;

  /// Base icon size of 27 units.
  static const double iconSize = 27.0;

  /// Medium icon size of 32 units.
  static const double iconSizeMedium = 32.0;

  /// Large icon size of 48 units.
  static const double iconSizeLarge = 48.0;
}

/// Duration constants for application timeouts and delays.
final class ApplicationDuration {
  ApplicationDuration._();

  /// Network timeout duration of 30 seconds.
  static const Duration networkTimeout = Duration(seconds: 30);

  /// Short network timeout duration of 15 seconds.
  static const Duration networkTimeoutShort = Duration(seconds: 15);

  /// Long network timeout duration of 60 seconds.
  static const Duration networkTimeoutLong = Duration(seconds: 60);

  /// Extra-long network timeout duration of 120 seconds.
  static const Duration networkTimeoutExtraLong = Duration(seconds: 120);

  /// Toast display duration of 4 seconds.
  static const Duration toastDisplayDuration = Duration(seconds: 4);

  /// Maximum allowed stale duration for extra-short cache entries.
  static const Duration maxCacheStaleExtraShort = Duration(hours: 12);

  /// Maximum allowed stale duration for short cache entries.
  static const Duration maxCacheStaleShort = Duration(days: 3);

  /// Maximum allowed stale duration for regular cache entries.
  static const Duration maxCacheStale = Duration(days: 7);

  /// Maximum allowed stale duration for long cache entries.
  static const Duration maxCacheStaleLong = Duration(days: 15);

  /// Maximum allowed stale duration for extra-long cache entries.
  static const Duration maxCacheStaleExtraLong = Duration(days: 25);
}

/// Animation duration constants for application transitions and effects.
final class ApplicationAnimationDuration {
  ApplicationAnimationDuration._();

  // Extra-short animation duration of 100 milliseconds.
  static const Duration extraShort = Duration(milliseconds: 100);

  /// Short animation duration of 200 milliseconds.
  static const Duration short = Duration(milliseconds: 200);

  // Default animation duration of 300 milliseconds.
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Medium animation duration of 400 milliseconds.
  static const Duration medium = Duration(milliseconds: 400);

  /// Long animation duration of 600 milliseconds.
  static const Duration long = Duration(milliseconds: 600);

  // Extra-long animation duration of 800 milliseconds.
  static const Duration extraLong = Duration(milliseconds: 800);
}
