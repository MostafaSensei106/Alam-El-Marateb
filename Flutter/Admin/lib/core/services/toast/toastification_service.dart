import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

import '../../constants/app_config.dart';
import '../../di/di.dart';
import '../l10n/l10n_service.dart';
import '../theme/theme_service.dart';
import 'base_toast_service.dart';

@LazySingleton(as: BaseToastService)
class ToastificationService implements BaseToastService {
  ToastificationService(this._themeService);
  final ThemeService _themeService;

  @override
  void showError(BuildContext context, String message) {
    final l10n = getIt<L10nService>().get(context);

    _showToast(
      context: context,
      config: _ToastConfig(
        type: ToastificationType.error,
        icon: Iconsax.cloud_cross_copy,
        title: Text(l10n.error),
        description: Text(message),
        borderRadius: BorderRadius.circular(AppConfig.padding),
      ),
    );
  }

  @override
  void showInfo(BuildContext context, String message) {
    final l10n = getIt<L10nService>().get(context);
    _showToast(
      context: context,
      config: _ToastConfig(
        type: ToastificationType.info,
        title: Text(l10n.info),
        icon: Iconsax.information_copy,
        description: Text(message),
      ),
    );
  }

  @override
  void showSimple(BuildContext context, String message) {
    _showToast(
      context: context,
      config: _ToastConfig(
        type: ToastificationType.info,
        style: ToastificationStyle.simple,
        title: Text(message),
      ),
    );
  }

  @override
  void showSuccess(BuildContext context, String message) {
    final l10n = getIt<L10nService>().get(context);

    _showToast(
      context: context,
      config: _ToastConfig(
        type: ToastificationType.success,
        icon: Iconsax.tick_circle_copy,
        title: Text(l10n.success),
        description: Text(message),
      ),
    );
  }

  @override
  void showWarning(BuildContext context, String message) {
    final l10n = getIt<L10nService>().get(context);

    _showToast(
      context: context,
      config: _ToastConfig(
        type: ToastificationType.warning,
        title: Text(l10n.warning),
        icon: Iconsax.warning_2_copy,
        description: Text(message),
      ),
    );
  }

  void _showToast({
    required BuildContext context,
    required _ToastConfig config,
  }) {
    final colorScheme = _themeService.get(context);

    toastification.show(
      type: config.type,
      style: config.style,
      title: config.title,
      description: config.description,
      alignment: Alignment.topRight,
      autoCloseDuration: config.autoCloseDuration,
      padding: const EdgeInsets.symmetric(
        vertical: AppConfig.padding,
        horizontal: AppConfig.paddingHalf,
      ),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      borderRadius:
          config.borderRadius ??
          BorderRadius.circular(AppConfig.outBorderRadius),
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      dragToClose: true,
      pauseOnHover: true,
      showProgressBar: config.showProgressBar,
      icon: Container(
        padding: const EdgeInsets.all(AppConfig.paddingQuarter + 2),
        decoration: config.type == ToastificationType.success
            ? BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
              )
            : config.type == ToastificationType.error
            ? BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
              )
            : config.type == ToastificationType.warning
            ? BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
              )
            : BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
              ),
        child: Icon(config.icon, size: AppConfig.iconSize),
      ),
      progressBarTheme: ProgressIndicatorThemeData(
        // ignore: deprecated_member_use
        year2023: false,
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      ),
    );
  }
}

class _ToastConfig {
  const _ToastConfig({
    required this.type,
    required this.title,
    this.description,
    this.icon,
    this.style = ToastificationStyle.minimal,
    this.borderRadius,
  }) : showProgressBar = false,
       autoCloseDuration = const Duration(seconds: 2);

  final ToastificationType type;
  final Widget title;
  final Widget? description;
  final IconData? icon;
  final ToastificationStyle style;
  final bool showProgressBar;
  final Duration? autoCloseDuration;
  final BorderRadiusGeometry? borderRadius;
}
