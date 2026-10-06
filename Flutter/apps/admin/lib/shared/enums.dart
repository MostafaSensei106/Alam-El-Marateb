/// Backend string contracts as enums. Wire values match the API exactly;
/// never compare raw strings in UI code.
enum BackendRole {
  superAdmin('ROLE_SUPER_ADMIN'),
  branchManager('ROLE_BRANCH_MANAGER'),
  cashier('ROLE_CASHIER'),
  warehouseKeeper('ROLE_WAREHOUSE_KEEPER'),
  deliveryDriver('ROLE_DELIVERY_DRIVER'),
  accountant('ROLE_ACCOUNTANT'),
  customer('ROLE_CUSTOMER');

  const BackendRole(this.value);
  final String value;

  static BackendRole? fromValue(String? value) =>
      BackendRole.values.where((r) => r.value == value).firstOrNull;
}

enum PaymentMethod {
  cash('CASH'),
  card('CARD'),
  cod('COD'),
  transfer('TRANSFER'),
  wallet('WALLET'),
  installment('INSTALLMENT');

  const PaymentMethod(this.value);
  final String value;
}

enum OrderChannel {
  pos('pos'),
  shop('shop');

  const OrderChannel(this.value);
  final String value;
}

enum OrderStatus {
  draft('draft'),
  confirmed('confirmed'),
  preparing('preparing'),
  delivering('delivering'),
  delivered('delivered'),
  returned('returned'),
  cancelled('cancelled'),
  failed('failed');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus fromValue(String? value) =>
      OrderStatus.values.where((s) => s.value == value).firstOrNull ??
      OrderStatus.draft;
}

enum TransferStatus {
  draft('draft'),
  inTransit('in_transit'),
  partiallyReceived('partially_received'),
  received('received'),
  confirmed('confirmed'),
  cancelled('cancelled');

  const TransferStatus(this.value);
  final String value;

  static TransferStatus fromValue(String? value) =>
      TransferStatus.values.where((s) => s.value == value).firstOrNull ??
      TransferStatus.draft;
}

enum PriceChannel {
  platform('PLATFORM'),
  staff('STAFF'),
  dealer('DEALER');

  const PriceChannel(this.value);
  final String value;
}

enum LandedKind {
  freight('FREIGHT'),
  customs('CUSTOMS'),
  insurance('INSURANCE'),
  handling('HANDLING'),
  other('OTHER');

  const LandedKind(this.value);
  final String value;
}

enum AllocationMethod {
  byValue('BY_VALUE'),
  byQty('BY_QTY');

  const AllocationMethod(this.value);
  final String value;
}
