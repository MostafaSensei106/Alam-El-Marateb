import 'package:flutter/material.dart';

import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';

/// Orders, invoices and customer-facing sales screens.
final class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const AdminModuleHubPage(moduleId: AdminModuleId.sales);
}
