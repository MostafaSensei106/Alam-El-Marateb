import 'package:alam_el_marateb_router/router.dart';
import 'package:test/test.dart';

void main() {
  group('AppAuthNotifier', () {
    test('notifies only on change', () {
      final notifier = AppAuthNotifier.instance;
      var calls = 0;
      void listener() => calls++;
      notifier.addListener(listener);

      notifier.notifyAuthChanged(false);
      final baseline = calls;
      notifier.notifyAuthChanged(true);
      expect(calls, baseline + 1);
      expect(notifier.isAuthenticated, isTrue);

      notifier.notifyAuthChanged(false);
      notifier.removeListener(listener);
    });
  });
}
