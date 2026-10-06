import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

import '../../l10n/app_localizations.dart';
import '../di/di.dart';
import '../services/l10n/l10n_service.dart';
import '../services/theme/theme_service.dart';
import '../services/toast/base_toast_service.dart';

export 'date_time_extension.dart';

final egpCurrency = CommonCurrencies().egp;

extension LocalizationExtensions on BuildContext {
  AppLocalizations get localeKeys => getIt<L10nService>().get(this);
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}

extension ToastExtensions on BuildContext {
  BaseToastService get toast => getIt<BaseToastService>();
}

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => getIt<ThemeService>().get(this);
}

extension TextThemeExtensions on BuildContext {
  TextTheme get textTheme => getIt<ThemeService>().getTextTheme(this);
}
