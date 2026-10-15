import 'package:alam_el_marateb_extensions/extensions.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('AppDateTimeExtension', () {
    test('toAppFormat formats with given langCode', () {
      final date = DateTime(2026, 7, 20, 1, 33);
      final formatted = date.toAppFormat(langCode: 'en');
      expect(formatted, isNotEmpty);
      expect(formatted, contains('July'));
      expect(formatted, contains('20'));
    });

    test('String toAppFormat returns original on invalid input', () {
      expect('not-a-date'.toAppFormat(langCode: 'en'), 'not-a-date');
    });

    test('String toAppFormat parses valid ISO string', () {
      const iso = '2026-07-20T01:33:00.000';
      final formatted = iso.toAppFormat(langCode: 'en');
      expect(formatted, isNotEmpty);
      expect(formatted, isNot(iso));
      expect(formatted, contains('July'));
    });
  });
}
