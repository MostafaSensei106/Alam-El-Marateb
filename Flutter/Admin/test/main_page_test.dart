import 'package:alam_el_marateb_admin/l10n/app_localizations.dart';
import 'package:alam_el_marateb_admin/modules/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpMainPage(
    WidgetTester tester, {
    required Size surfaceSize,
  }) async {
    tester.view.physicalSize = surfaceSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('rail lays out extended on a wide window', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(1600, 900));

    expect(tester.takeException(), isNull);
    expect(find.byType(NavigationRail), findsOneWidget);
    // Expanded rail shows the brand name next to the menu mark.
    expect(find.text('Alm-El-Marateb'), findsOneWidget);
  });

  testWidgets('rail lays out collapsed on a narrow window', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(900, 800));

    expect(tester.takeException(), isNull);
    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('rail toggles between expanded and collapsed', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(1600, 900));

    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
  });
}
