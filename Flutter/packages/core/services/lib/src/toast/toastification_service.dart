import 'package:alam_el_marateb_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:services/src/theme/theme_service.dart';
import 'package:services/src/toast/toast_service_base.dart';
import 'package:toastification/toastification.dart';

@LazySingleton(as: ToastServiceBase)
final class ToastificationService implements ToastServiceBase {
  const ToastificationService(this._themeService);

  final ThemeService _themeService;

  @override
  void showError(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      type: ToastificationType.error,
      icon: Iconsax.close_circle_copy,
    );
  }

  @override
  void showSuccess(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      type: ToastificationType.success,
      icon: Iconsax.tick_circle_copy,
    );
  }

  @override
  void showWarning(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      type: ToastificationType.warning,
      icon: Iconsax.warning_2_copy,
    );
  }

  @override
  void showInfo(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      type: ToastificationType.info,
      icon: Iconsax.info_circle_copy,
    );
  }

  @override
  void showSimple(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      type: ToastificationType.info,
      showIcon: false,
    );
  }

  void _showToast({
    required BuildContext context,
    required String message,
    required ToastificationType type,
    IconData? icon,
    bool showIcon = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = _themeService.get(context);
    final (accentColor, onAccentColor) = _getToastColors(type, colorScheme);

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      alignment: Alignment.topRight,
      autoCloseDuration: duration,
      dragToClose: true,
      pauseOnHover: true,
      showProgressBar: false,
      borderRadius: BorderRadius.circular(ApplicationRadius.outerBorderRadius),
      backgroundColor: colorScheme.surfaceContainerHigh,
      foregroundColor: colorScheme.onSurface,
      padding: const EdgeInsets.symmetric(
        horizontal: ApplicationPadding.padding,
        vertical: ApplicationPadding.paddingHalf + 2,
      ),

      title: Text(
        message,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          height: 1.3,
        ),
      ),
      icon: showIcon && icon != null
          ? Container(
              margin: const EdgeInsets.only(left: 2, right: 6),
              padding: const EdgeInsets.all(
                ApplicationPadding.paddingQuarter + 1,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: ApplicationIconsSize.iconSize - 2,
                color: accentColor,
              ),
            )
          : null,
    );
  }

  (Color, Color) _getToastColors(
    ToastificationType type,
    ColorScheme colorScheme,
  ) {
    return switch (type) {
      ToastificationType.success => (
        colorScheme.primary,
        colorScheme.onPrimary,
      ),
      ToastificationType.error => (colorScheme.error, colorScheme.onError),
      ToastificationType.warning => (
        colorScheme.tertiary,
        colorScheme.onTertiary,
      ),
      ToastificationType.info => (
        colorScheme.secondary,
        colorScheme.onSecondary,
      ),
      _ => (colorScheme.secondary, colorScheme.onSecondary),
    };
  }
}
