import 'package:alam_el_marateb_admin/l10n/app_localizations.dart';
import 'package:alam_el_marateb_admin/modules/identity/ui/widgets/permissions_matrix_panel.dart';
import 'package:alam_el_marateb_admin/modules/main/main_page.dart';
import 'package:alam_el_marateb_admin/modules/main/navigation/admin_modules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  setUp(resetPermissionsSessionCache);

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

  Future<void> openIdentityTab(WidgetTester tester, String label) async {
    final tab = find.text(label);
    await tester.ensureVisible(tab);
    await tester.pumpAndSettle();
    await tester.tap(tab);
    await tester.pumpAndSettle();
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('admin-navigation-menu')));
    await tester.pumpAndSettle();
  }

  Future<void> selectModuleFromDrawer(WidgetTester tester, String label) async {
    await openDrawer(tester);

    final entry = find.descendant(
      of: find.byType(Drawer),
      matching: find.text(label),
    );
    final list = find.descendant(
      of: find.byType(Drawer),
      matching: find.byType(Scrollable),
    );

    await tester.scrollUntilVisible(entry, 120, scrollable: list);
    await tester.ensureVisible(entry);
    await tester.pumpAndSettle();
    await tester.tap(entry);
    await tester.pumpAndSettle();
  }

  Future<void> openIdentityPermissions(WidgetTester tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(411, 900));

    await selectModuleFromDrawer(tester, 'Identity');

    await openIdentityTab(tester, 'Roles and the permissions matrix');
  }

  final permissionChecks = find.descendant(
    of: find.byType(PermissionsMatrixPanel),
    matching: find.byIcon(LucideIcons.check),
  );

  testWidgets('rail lays out extended on a wide window', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(1600, 900));

    expect(tester.takeException(), isNull);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
    // Expanded rail shows the brand name next to the menu mark.
    expect(find.text('Alm-El-Marateb'), findsOneWidget);
  });

  testWidgets('rail lays out collapsed on a narrow window', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(900, 800));

    expect(tester.takeException(), isNull);
    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('compact windows replace the rail with a drawer', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(411, 900));

    expect(tester.takeException(), isNull);
    expect(find.byType(NavigationRail), findsNothing);

    await openDrawer(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(Drawer), findsOneWidget);
    expect(
      find.descendant(of: find.byType(Drawer), matching: find.text('Identity')),
      findsOneWidget,
    );
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

    expect(rail.destinations, hasLength(14));

    await tester.tap(find.text('Identity'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Identity & Access'), findsOneWidget);
  });

  testWidgets('every branch renders on a phone-sized window', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(411, 900));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final modules = AdminModules.all(l10n);

    expect(modules, hasLength(14));

    for (final module in modules.skip(1)) {
      await selectModuleFromDrawer(tester, module.label);

      expect(
        tester.takeException(),
        isNull,
        reason: '${module.id.name} failed to lay out',
      );
    }
  });

  testWidgets('settings exposes an app info tab', (tester) async {
    await pumpMainPage(tester, surfaceSize: const Size(411, 900));

    await selectModuleFromDrawer(tester, 'Settings');

    final appInfoTab = find.text('App info');
    await tester.ensureVisible(appInfoTab);
    await tester.pumpAndSettle();
    await tester.tap(appInfoTab);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('App information unavailable'), findsOneWidget);
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

  testWidgets('identity permissions tab renders the local matrix', (
    tester,
  ) async {
    await openIdentityPermissions(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Permissions matrix'), findsOneWidget);

    final grantedBefore = permissionChecks.evaluate().length;

    final hrDelete = find.byKey(const ValueKey('hr.delete'));
    await tester.ensureVisible(hrDelete);
    await tester.pumpAndSettle();
    await tester.tap(hrDelete);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(permissionChecks.evaluate().length, grantedBefore + 1);
  });

  testWidgets('permissions keep their grants when the tab is reopened', (
    tester,
  ) async {
    await openIdentityPermissions(tester);

    final hrDelete = find.byKey(const ValueKey('hr.delete'));
    await tester.ensureVisible(hrDelete);
    await tester.pumpAndSettle();
    await tester.tap(hrDelete);
    await tester.pumpAndSettle();

    final granted = permissionChecks.evaluate().length;

    await openIdentityTab(tester, 'Manage branches and showrooms');
    await openIdentityTab(tester, 'Roles and the permissions matrix');

    expect(tester.takeException(), isNull);
    expect(permissionChecks.evaluate().length, granted);
  });

  testWidgets('permissions matrix fits a narrow RTL window', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: PermissionsMatrixPanel(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('مصفوفة الصلاحيات'), findsOneWidget);
  });

  testWidgets('planned sections show the pill and disable the create action', (
    tester,
  ) async {
    await pumpMainPage(tester, surfaceSize: const Size(411, 900));

    await selectModuleFromDrawer(tester, 'CRM');

    expect(tester.takeException(), isNull);
    expect(find.text('Warranty registry'), findsWidgets);
    expect(find.text('Planned'), findsOneWidget);

    final createButton = find.ancestor(
      of: find.text('New'),
      matching: find.byWidgetPredicate((widget) => widget is FilledButton),
    );

    expect(createButton, findsOneWidget);
    expect(tester.widget<FilledButton>(createButton).onPressed, isNull);
  });
}
