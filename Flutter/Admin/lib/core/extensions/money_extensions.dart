import 'package:money2/money2.dart';

final egpCurrency = CommonCurrencies().egp;

extension MoneyFormatterExtension on Money {
  /// Formats the money value with proper thousands separators and currency symbol.
  /// Displays decimals when minor units are present.
  String get formatted {
    final hasSpace = currency.symbol.isNotEmpty;
    final hasDecimals = minorUnits.toInt() % 100 != 0;
    final pattern = hasDecimals
        ? (hasSpace ? 'S ###,###,###,###,##0.00' : 'S###,###,###,###,##0.00')
        : (hasSpace ? 'S ###,###,###,###,##0' : 'S###,###,###,###,##0');
    return format(pattern);
  }

  /// Formats strictly with 2 decimal places.
  String get formattedWithDecimals {
    final hasSpace = currency.symbol.isNotEmpty;
    final pattern = hasSpace
        ? 'S ###,###,###,###,##0.00'
        : 'S###,###,###,###,##0.00';
    return format(pattern);
  }

  /// Formats integer value without decimals.
  String get formattedCompact {
    final hasSpace = currency.symbol.isNotEmpty;
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
  /// Safely attempts to parse this string into a [Money] value.
  ///
  /// Supports:
  /// - Negative amounts (`-125.50`)
  /// - Thousands separators (`1,250.00` or `1 250.00`)
  /// - Arabic-Indic numerals (`١٢٣.٤٥` or `١٢٣٫٤٥`)
  ///
  /// Returns `null` if the string cannot be parsed into a valid finite monetary amount.
  Money? tryToMoney([Currency? currency]) {
    final raw = trim();
    if (raw.isEmpty) return null;

    // Normalize Arabic/Indic digits and punctuation
    var normalized = raw
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9')
        .replaceAll('٫', '.') // Arabic decimal separator
        .replaceAll('،', '') // Arabic thousands separator
        .replaceAll(',', '') // Western thousands separator
        .replaceAll(' ', ''); // Spaces

    // Preserve leading negative sign if present
    final isNegative = normalized.startsWith('-');
    if (isNegative) {
      normalized = normalized.substring(1);
    }

    // Strip any unexpected currency codes/symbols while preserving decimal dot
    normalized = normalized.replaceAll(RegExp(r'[^\d.]'), '');
    if (normalized.isEmpty) return null;

    final parsedAmount = double.tryParse(normalized);
    if (parsedAmount == null || !parsedAmount.isFinite) return null;

    final finalAmount = isNegative ? -parsedAmount : parsedAmount;
    return Money.fromNumWithCurrency(finalAmount, currency ?? egpCurrency);
  }

  /// Converts this string to [Money] with a defined fallback when invalid.
  ///
  /// By default, falls back to `0.0`, but unlike the legacy implementation,
  /// preserves negative numbers, handles commas and Arabic numerals properly.
  Money toMoney([Currency? currency, double fallbackOnInvalid = 0.0]) {
    return tryToMoney(currency) ??
        Money.fromNumWithCurrency(fallbackOnInvalid, currency ?? egpCurrency);
  }
}
