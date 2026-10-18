import 'dart:ui';

import 'app_metadata.dart';
import 'design_system/tokens/tokens.dart';

/// Legacy facade retained for backward compatibility during migration.
///
/// Prefer importing specific tokens directly:
/// - [AppSpacing] for spacing and padding.
/// - [AppRadii] for border radii.
/// - [AppIconSizes] for icons.
/// - [AppControlSizes] for component sizing.
/// - [AppMotion] for animation durations.
/// - [AppBrandColors] or `Theme.of(context).colorScheme` for colors.
/// - [AppMetadata] for application identity.
/// - [NetworkTimeouts] for network layer durations.
@Deprecated(
  'Use domain tokens (AppSpacing, AppRadii, AppBrandColors, etc.) directly.',
)
final class AppConfig {
  AppConfig._();

  static const String appName = AppMetadata.name;
  static const bool isDebugMode = false;

  // Spacing
  static const double margin = AppSpacing.small;
  static const double marginHalf = AppSpacing.xSmall;
  static const double marginDouble = AppSpacing.large;

  static const double padding = AppSpacing.large;
  static const double paddingHalf = AppSpacing.small;
  static const double paddingQuarter = AppSpacing.xSmall;
  static const double paddingThird = 16.0 / 3;
  static const double paddingDouble = AppSpacing.xxLarge;
  static const double sectionGap = AppSpacing.xLarge;

  // Icon Sizes
  static const double iconSize = 27.0;
  static const double iconSizeHalf = iconSize / 2;
  static const double iconSizeQuarter = iconSize / 4;
  static const double iconSizeThird = iconSize / 3;
  static const double small = AppIconSizes.small;
  static const double large = AppIconSizes.large;

  // Radii
  static const double inBorderRadius = AppRadii.medium;
  static const double outBorderRadius = 16.0;
  static const double card = AppRadii.large;
  static const double pill = AppRadii.pill;

  // Control Dimensions
  static const double buttonHeight = 50;
  static const double buttonMinWidth = AppControlSizes.buttonMinWidth;
  static const double otpFieldSize = 50.0;
  static const double avatarRadius = 30.0;
  static const double appBarHeight = AppControlSizes.appBarHeight;
  static const double dividerThickness = AppControlSizes.dividerThickness;

  // Durations & Timeouts
  static const int toastDurationInSec = 4;
  static const Duration dioTimeOut = NetworkTimeouts.receive;
  static const Duration animation = Duration(milliseconds: 300);
  static const Duration debounce = Duration(milliseconds: 500);

  // Colors
  static const Color hadidiOrange = AppBrandColors.primary;
  static const Color success = Color(0xff2E7D32);
  static const Color warning = Color(0xffF9A825);
  static const Color error = Color(0xffC62828);
  static const Color textPrimary = Color(0xff212121);
  static const Color surface = Color(0xffFFFFFF);
}

@Deprecated('Use AppMetadata instead')
typedef ApplicationConfig = AppConfig;

@Deprecated('Use AppSpacing instead')
typedef ApplicationSpacing = AppConfig;

@Deprecated('Use AppIconSizes instead')
typedef ApplicationIconSize = AppConfig;

@Deprecated('Use AppRadii instead')
typedef ApplicationRadius = AppConfig;

@Deprecated('Use AppControlSizes instead')
typedef ApplicationDimensions = AppConfig;

@Deprecated('Use AppMotion or NetworkTimeouts instead')
typedef ApplicationDuration = AppConfig;

@Deprecated('Use Theme.of(context).colorScheme or AppBrandColors instead')
typedef ApplicationColors = AppConfig;
