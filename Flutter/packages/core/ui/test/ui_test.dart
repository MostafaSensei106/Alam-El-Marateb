import 'package:alam_el_marateb_ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (_, _) => MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('ErrorStateWidget', () {
    testWidgets('renders message and default title', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorStateWidget(message: 'Boom')),
      );
      expect(find.text('Boom'), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('prefers explicit title', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorStateWidget(message: 'Boom', title: 'Oops')),
      );
      expect(find.text('Oops'), findsOneWidget);
      expect(find.text('Error'), findsNothing);
    });
  });

  group('RetryableErrorStateWidget', () {
    testWidgets('retry button fires onRetry', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        _wrap(
          RetryableErrorStateWidget(
            message: 'Nope',
            onRetry: () => pressed++,
          ),
        ),
      );
      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(pressed, 1);
    });
  });

  group('BadgeComponent', () {
    testWidgets('renders label over child', (tester) async {
      await tester.pumpWidget(
        _wrap(const BadgeComponent(label: '3', child: Icon(Icons.mail))),
      );
      expect(find.text('3'), findsOneWidget);
      expect(find.byIcon(Icons.mail), findsOneWidget);
    });
  });

  group('UiMetrics', () {
    test('exposes component metrics', () {
      expect(UiMetrics.buttonHeight, 50);
      expect(UiMetrics.otpFieldSize, 50);
    });
  });
}
