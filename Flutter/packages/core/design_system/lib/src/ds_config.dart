import 'dart:ui';

final class DsConfig {
  DsConfig._();
  static const String appName = 'Hadidi Win';
  static const bool isDebugMode = false;

  static const double margin = 8;

  static const double padding = 16.0;
  static const double paddingHalf = padding / 2;
  static const double paddingQuarter = padding / 4;
  static const double paddingThird = padding / 3;

  static const double iconSize = 27.0;
  static const double iconSizeHalf = iconSize / 2;
  static const double iconSizeQuarter = iconSize / 4;
  static const double iconSizeThird = iconSize / 3;

  static const double inBorderRadius = 8.0;
  static const double outBorderRadius = inBorderRadius + paddingHalf;

  static const double buttonHeight = 50;
  static const double otpFieldSize = 50.0;

  static const double avatarRadius = 30.0;

  static const int toastDurationInSec = 4;

  static const Duration dioTimeOut = Duration(seconds: 30);

  static const Color hadidiOrange = Color(0xffFF8A00);
}
