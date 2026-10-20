import 'package:flutter/material.dart';

import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';

/// Product catalogue overview and merchandising screens.
final class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const AdminModuleHubPage(moduleId: AdminModuleId.catalog);
}
