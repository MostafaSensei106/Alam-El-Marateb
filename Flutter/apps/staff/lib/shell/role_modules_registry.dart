import '../shared/enums.dart';

/// Module ids available in the staff app.
enum StaffModule {
  catalog('catalog', 'Catalog'),
  pos('pos', 'POS sale'),
  shifts('shifts', 'Cash shift'),
  inventory('inventory', 'Stocks'),
  transfers('transfers', 'Transfers'),
  delivery('delivery', 'Delivery'),
  warranty('warranty', 'Warranty');

  const StaffModule(this.id, this.label);
  final String id;
  final String label;
}

/// Capabilities per role — UI composition only. Real authorization
/// always stays in the backend; hiding a module is not a security boundary.
class RoleModulesRegistry {
  const RoleModulesRegistry._();

  static const Map<BackendRole, List<StaffModule>> modulesForRole =
      <BackendRole, List<StaffModule>>{
        BackendRole.branchManager: StaffModule.values,
        BackendRole.cashier: [StaffModule.catalog, StaffModule.pos],
        BackendRole.warehouseKeeper: [
          StaffModule.catalog,
          StaffModule.inventory,
          StaffModule.transfers,
        ],
        BackendRole.deliveryDriver: [StaffModule.delivery],
        BackendRole.superAdmin: StaffModule.values,
      };

  static List<StaffModule> forRoles(List<String> roleValues) {
    final roles = roleValues
        .map(BackendRole.fromValue)
        .whereType<BackendRole>()
        .toList();
    if (roles.isEmpty) {
      return const [StaffModule.catalog];
    }
    final seen = <StaffModule>{};
    for (final role in roles) {
      seen.addAll(modulesForRole[role] ?? const <StaffModule>[]);
    }
    return StaffModule.values.where(seen.contains).toList();
  }
}
