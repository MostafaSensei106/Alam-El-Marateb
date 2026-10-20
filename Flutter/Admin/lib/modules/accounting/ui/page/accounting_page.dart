import 'package:flutter/material.dart';

import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';

/// Ledgers, expenses and financial reporting.
final class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const AdminModuleHubPage(moduleId: AdminModuleId.accounting);
}
