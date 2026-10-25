import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/navigation/app_bar/app_bar_component.dart';
import '../../navigation/admin_module.dart';
import '../../navigation/admin_modules.dart';
import '../widgets/admin_account_dialog.dart';
import '../widgets/admin_navigation_drawer.dart';
import '../widgets/admin_navigation_rail.dart';

/// Chrome shared by every admin branch: navigation plus the active branch
/// content.
///
/// Wide windows keep the persistent [AdminNavigationRail]; compact windows
/// (phones and small tablets) hide navigation behind a drawer so the branch
/// content keeps the full window width.
final class AdminShell extends StatelessWidget {
  const AdminShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onSelectModule,
    required this.child,
    super.key,
  });

  /// Window width below which navigation moves into a drawer.
  static const double drawerBreakpoint = 600;

  /// Branch index currently displayed.
  final int selectedIndex;

  /// Called when the user picks a rail destination or drawer entry.
  final ValueChanged<int> onDestinationSelected;

  /// Called when the account menu requests another module.
  final ValueChanged<AdminModuleId> onSelectModule;

  /// The routed page for the active branch.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < drawerBreakpoint;

    if (!isCompact) {
      return Scaffold(
        body: Row(
          children: [
            AdminNavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              onSelectModule: onSelectModule,
            ),
            Expanded(child: child),
          ],
        ),
      );
    }

    final l10n = context.localeKeys;
    final module = AdminModules.all(l10n)[selectedIndex];

    return Scaffold(
      appBar: AppBarComponent(
        leading: Builder(
          builder: (context) => IconButton(
            key: const ValueKey('admin-navigation-menu'),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(LucideIcons.menu),
          ),
        ),
        title: module.title,
      ),
      drawer: AdminNavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        onOpenAccount: () {
          unawaited(
            showAdminAccountDialog(context, onSelectModule: onSelectModule),
          );
        },
      ),
      body: child,
    );
  }
}
