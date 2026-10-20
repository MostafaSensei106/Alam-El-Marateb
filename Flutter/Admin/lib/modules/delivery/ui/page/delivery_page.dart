import 'package:flutter/material.dart';

import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';

/// Delivery routes, drivers and shipment tracking.
final class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const AdminModuleHubPage(moduleId: AdminModuleId.delivery);
}
