import 'package:flutter/material.dart';

import '../../navigation/admin_module.dart';
import '../widgets/admin_navigation_rail.dart';

/// Chrome shared by every admin branch: the navigation rail plus the active
/// branch content.
final class AdminShell extends StatelessWidget {
  const AdminShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onSelectModule,
    required this.child,
    super.key,
  });

  /// Branch index currently displayed.
  final int selectedIndex;

  /// Called when the user picks a rail destination.
  final ValueChanged<int> onDestinationSelected;

  /// Called when a profile menu shortcut requests another module.
  final ValueChanged<AdminModuleId> onSelectModule;

  /// The routed page for the active branch.
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
}
