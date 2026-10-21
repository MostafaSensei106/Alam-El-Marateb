import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';
import '../../../main/ui/widgets/admin_section_workspace.dart';
import '../widgets/inventory_workspace.dart';

/// Stock levels, movements and warehouse controls.
final class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final module = AdminModules.byId(l10n, AdminModuleId.inventory);

    return AdminModuleHubPage(
      moduleId: AdminModuleId.inventory,
      sectionBuilder: (context, section, index) {
        if (InventoryWorkspace.sectionIds.contains(section.id)) {
          return InventoryWorkspace(section: section);
        }

        return AdminSectionWorkspace(module: module, section: section);
      },
    );
  }
}
