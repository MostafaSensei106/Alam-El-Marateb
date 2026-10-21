import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';
import '../../../main/ui/widgets/admin_section_workspace.dart';
import '../widgets/catalog_workspace.dart';

/// Product catalogue overview and merchandising screens.
final class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final module = AdminModules.byId(l10n, AdminModuleId.catalog);

    return AdminModuleHubPage(
      moduleId: AdminModuleId.catalog,
      sectionBuilder: (context, section, index) {
        if (CatalogWorkspace.sectionIds.contains(section.id)) {
          return CatalogWorkspace(section: section);
        }

        return AdminSectionWorkspace(module: module, section: section);
      },
    );
  }
}
