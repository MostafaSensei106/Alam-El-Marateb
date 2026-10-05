import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

import '../../l10n/app_localizations.dart';
import '../di/di.dart';
import '../services/l10n/l10n_service.dart';
import '../services/theme/theme_service.dart';
import '../services/toast/base_toast_service.dart';
import '../widgets/feedback/dialog/dialog_component.dart';

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

extension DialogExtensions on BuildContext {
  DialogProxy get dialog => DialogProxy(this);
}

class DialogProxy {
  DialogProxy(this.context);
  final BuildContext context;

  Future<T?> showDialog<T>({
    required Widget title,
    required List<Widget> actions,
    Widget? content,
    Widget? icon,
  }) {
    return DialogComponent.showCustom<T>(
      context: context,
      title: title,
      content: content,
      actions: actions,
      icon: icon,
    );
  }

  Future<T?> showConfirmation<T>({
    required String title,
    required String body,
    required VoidCallback onConfirm,
  }) {
    return DialogComponent.showConfirmation<T>(
      context: context,
      title: title,
      body: body,
      onConfirm: onConfirm,
    );
  }

  void showLoading() {
    DialogComponent.showLoading(context);
  }

  void dismiss() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> showInfo({required String title, required String body}) {
    return DialogComponent.showInfo(context: context, title: title, body: body);
  }

  Future<void> showError({required String title, required String error}) {
    return DialogComponent.showError(
      context: context,
      title: title,
      error: error,
    );
  }
}

extension MoneyFormatterExtension on Money {
  String get formatted {
    final hasSpace = currency.symbol.length > 1;
    final pattern = hasSpace ? 'S ###,###,###,###,##0' : 'S###,###,###,###,##0';
    return format(pattern);
  }
}

extension MoneyDoubleExtensions on double {
  Money toMoney([Currency? currency]) {
    return Money.fromNumWithCurrency(this, currency ?? egpCurrency);
  }
}

extension MoneyNumExtensions on num {
  Money toMoney([Currency? currency]) {
    return Money.fromNumWithCurrency(this, currency ?? egpCurrency);
  }
}

extension MoneyStringExtensions on String {
  Money toMoney([Currency? currency]) {
    final sanitized = replaceAll(RegExp(r'[^\d.]'), '');
    final amount = sanitized.isEmpty
        ? 0.0
        : (double.tryParse(sanitized) ?? 0.0);
    return Money.fromNumWithCurrency(amount, currency ?? egpCurrency);
  }
}

extension StringVersionExtension on String {
  bool isLowerThan(String requiredVersion) {
    try {
      final currentParts = split('.').map(int.parse).toList();
      final requiredParts = requiredVersion.split('.').map(int.parse).toList();
      for (var i = 0; i < requiredParts.length; i++) {
        if (i >= currentParts.length) return true;
        if (requiredParts[i] > currentParts[i]) return true;
        if (requiredParts[i] < currentParts[i]) return false;
      }
    } catch (_) {}
    return false;
  }
}
