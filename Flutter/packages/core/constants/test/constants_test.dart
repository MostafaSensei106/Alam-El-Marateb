import 'package:alam_el_marateb_constants/constants.dart';
import 'package:test/test.dart';

void main() {
  group('Constants smoke', () {
    test('ApiRoutes has baseUrl', () {
      expect(ApiRoutes.baseUrl, isNotEmpty);
    });

    test('PrefKeys exposes storage keys', () {
      expect(PrefKeys.userToken, isNotEmpty);
      expect(PrefKeys.localizationLanguageCode, isNotEmpty);
    });

    test('ApiHeader exposes locale headers', () {
      expect(ApiHeader.locale, isNotEmpty);
      expect(ApiHeader.acceptLanguage, isNotEmpty);
    });
  });
}
