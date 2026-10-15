import 'package:alam_el_marateb_di/di.dart';
import 'package:test/test.dart';

void main() {
  group('Core DI', () {
    test('getIt is a singleton', () {
      expect(identical(getIt, getIt), isTrue);
    });

    test('configureCoreDependencies completes', () async {
      await expectLater(configureCoreDependencies(), completes);
    });
  });
}
