/// Backend role names (mirror `AppRole` in the Kotlin backend).
///
/// Each app declares its [allowedRoles]; `registerAuthModule` rejects logins
/// whose `/me` roles don't intersect, so a customer account can never open
/// the staff app and vice versa.
abstract final class AppRoles {
  static const superAdmin = 'ROLE_SUPER_ADMIN';
  static const branchManager = 'ROLE_BRANCH_MANAGER';
  static const deliveryDriver = 'ROLE_DELIVERY_DRIVER';
  static const customer = 'ROLE_CUSTOMER';
  static const cashier = 'ROLE_CASHIER';
  static const warehouseKeeper = 'ROLE_WAREHOUSE_KEEPER';

  /// Roles accepted by the customer (shopping) app.
  static const customerApp = [customer, superAdmin];

  /// Roles accepted by the staff (operations) app.
  static const staffApp = [
    branchManager,
    cashier,
    warehouseKeeper,
    deliveryDriver,
    superAdmin,
  ];

  /// Roles accepted by the admin app.
  static const adminApp = [superAdmin];
}
