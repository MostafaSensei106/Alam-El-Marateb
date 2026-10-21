import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';
import '../../../main/ui/widgets/admin_section_workspace.dart';
import '../widgets/operations_workspace.dart';

/// Internal tasks, branch load and customer holds.
final class OperationsPage extends StatelessWidget {
  const OperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final module = AdminModules.byId(l10n, AdminModuleId.operations);

    return AdminModuleHubPage(
      moduleId: AdminModuleId.operations,
      sectionBuilder: (context, section, index) {
        if (OperationsWorkspace.sectionIds.contains(section.id)) {
          return OperationsWorkspace(section: section);
        }

        return AdminSectionWorkspace(module: module, section: section);
      },
    );
  }
}
