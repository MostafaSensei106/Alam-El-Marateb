import 'package:alam_el_marateb_admin/l10n/app_localizations.dart';
import 'package:alam_el_marateb_admin/modules/main/main_page.dart';
import 'package:alam_el_marateb_admin/modules/main/navigation/admin_modules.dart';
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

  testWidgets('rail exposes every admin module branch', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(1600, 900));

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

    expect(rail.destinations, hasLength(13));

    await tester.tap(find.text('Identity'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Identity & Access'), findsOneWidget);
  });

  testWidgets('every branch renders on a phone-sized window', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(411, 900));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final modules = AdminModules.all(l10n);
    final rail = find.byType(NavigationRail);

    expect(modules, hasLength(13));

    for (final module in modules.skip(1)) {
      final label = find.descendant(
        of: rail,
        matching: find.text(module.label),
      );

      await tester.ensureVisible(label);
      await tester.pumpAndSettle();
      await tester.tap(label);
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: '${module.id.name} failed to lay out',
      );
    }
  });

  testWidgets('profile tile opens the account dialog', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(1600, 900));

    await tester.tap(find.byTooltip('Open account menu'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('My profile'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });
}
