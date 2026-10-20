import 'package:flutter/material.dart';

import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';

/// Campaigns, promotions and audience messaging.
final class MarketingPage extends StatelessWidget {
  const MarketingPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const AdminModuleHubPage(moduleId: AdminModuleId.marketing);
}
