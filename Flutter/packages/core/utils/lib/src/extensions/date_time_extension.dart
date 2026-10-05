import 'package:intl/intl.dart';

import '../di/di.dart';
import '../utils/localization/logic/cubit/localization_cubit.dart';

extension AppDateTimeExtension on DateTime {
  /// Formats the date with a unified format for the app.
  /// Example: 20 يوليو 01:33 am
  /// [includeDayOfWeek] if true, adds the day of the week, e.g., الخميس 20 يوليو 01:33 am
  String toAppFormat({bool includeDayOfWeek = false}) {
    final langCode = getIt<LocalizationCubit>().state.langCode;
    final isAr = langCode == 'ar';

    final formatString = includeDayOfWeek
        ? 'EEEE dd MMMM hh:mm a'
        : 'dd MMMM hh:mm a';
    var formatted = DateFormat(formatString, langCode).format(toLocal());

    // Only apply numerals fix and am/pm substitution for Arabic
    if (isAr) {
      formatted = formatted
          .replaceAll('٠', '0')
          .replaceAll('١', '1')
          .replaceAll('٢', '2')
          .replaceAll('٣', '3')
          .replaceAll('٤', '4')
          .replaceAll('٥', '5')
          .replaceAll('٦', '6')
          .replaceAll('٧', '7')
          .replaceAll('٨', '8')
          .replaceAll('٩', '9');
    }

    return formatted;
  }
}

extension AppDateStringExtension on String {
  /// Formats the date string with a unified format for the app.
  /// Example: 20 يوليو 01:33 am
  String toAppFormat({bool includeDayOfWeek = false}) {
    try {
      final date = DateTime.parse(this).toLocal();
      return date.toAppFormat(includeDayOfWeek: includeDayOfWeek);
    } catch (e) {
      return this;
    }
  }
}
