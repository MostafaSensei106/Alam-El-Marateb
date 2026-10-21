import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';
import '../../../main/ui/widgets/admin_section_workspace.dart';
import '../widgets/permissions_matrix_panel.dart';

/// Roles, permissions and staff accounts for the admin workspace.
final class IdentityPage extends StatelessWidget {
  const IdentityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final module = AdminModules.byId(l10n, AdminModuleId.identity);

    return AdminModuleHubPage(
      moduleId: AdminModuleId.identity,
      sectionBuilder: (context, section, index) {
        if (section.id == 'identity.permissions') {
          return const PermissionsMatrixPanel();
        }

        return AdminSectionWorkspace(module: module, section: section);
      },
    );
  }
}
