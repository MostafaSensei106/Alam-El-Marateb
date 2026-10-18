import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../di/di.dart';
import '../services/l10n/l10n_service.dart';
import '../services/theme/theme_service.dart';
import '../services/toast/base_toast_service.dart';

extension LocalizationExtensions on BuildContext {
  /// Quick accessor to localized strings.
  /// Defaults directly to [AppLocalizations.of], while honoring [L10nService] if registered/mocked in tests.
  AppLocalizations get localeKeys => getIt.isRegistered<L10nService>()
      ? getIt<L10nService>().get(this)
      : AppLocalizations.of(this)!;

  /// Returns true if the current active locale is Arabic.
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}

extension ThemeExtensions on BuildContext {
  /// Quick accessor to current [ColorScheme].
  /// Defaults directly to [Theme.of], while honoring [ThemeService] if registered/mocked in tests.
  ColorScheme get colorScheme => getIt.isRegistered<ThemeService>()
      ? getIt<ThemeService>().get(this)
      : Theme.of(this).colorScheme;
}

extension TextThemeExtensions on BuildContext {
  /// Quick accessor to current [TextTheme].
  /// Defaults directly to [Theme.of], while honoring [ThemeService] if registered/mocked in tests.
  TextTheme get textTheme => getIt.isRegistered<ThemeService>()
      ? getIt<ThemeService>().getTextTheme(this)
      : Theme.of(this).textTheme;
}

extension ToastExtensions on BuildContext {
  /// Accesses the registered [BaseToastService] for displaying feedback messages.
  BaseToastService get toast => getIt<BaseToastService>();
}
