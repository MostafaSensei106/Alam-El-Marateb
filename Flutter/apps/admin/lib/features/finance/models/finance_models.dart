double _money(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};

class Shipment {
  const Shipment({this.id, this.supplierId, required this.shipmentNo});

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
    id: json['id']?.toString(),
    supplierId: json['supplierId']?.toString(),
    shipmentNo: json['shipmentNo']?.toString() ?? '',
  );

  final String? id;
  final String? supplierId;
  final String shipmentNo;
}

class InstallmentInput {
  const InstallmentInput({required this.amount, required this.dueDate});

  final double amount;
  final String dueDate;
}

class SupplierInvoice {
  const SupplierInvoice({
    this.id,
    this.invoiceNo = '',
    this.total = 0,
    this.status = '',
    this.paid = 0,
    this.remaining = 0,
  });

  factory SupplierInvoice.fromJson(Map<String, dynamic> json) =>
      SupplierInvoice(
        id: json['id']?.toString(),
        invoiceNo: json['invoiceNo']?.toString() ?? '',
        total: _money(json['total']),
        status: json['status']?.toString() ?? '',
        paid: _money(json['paid']),
        remaining: _money(json['remaining']),
      );

  final String? id;
  final String invoiceNo;
  final double total;
  final String status;
  final double paid;
  final double remaining;
}

class SupplierStatement {
  const SupplierStatement({
    this.invoices = const <SupplierInvoice>[],
    this.totalOwed = 0,
  });

  factory SupplierStatement.fromJson(Map<String, dynamic> json) =>
      SupplierStatement(
        invoices: json['invoices'] is List
            ? (json['invoices'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map(SupplierInvoice.fromJson)
                  .toList()
            : const <SupplierInvoice>[],
        totalOwed: _money(json['totalOwed']),
      );

  final List<SupplierInvoice> invoices;
  final double totalOwed;
}

class LandedCost {
  const LandedCost({
    this.id,
    this.kind = '',
    this.amount = 0,
    this.method = '',
    this.status = '',
    this.varianceAmount = 0,
    this.allocatedTotal = 0,
  });

  factory LandedCost.fromJson(Map<String, dynamic> json) => LandedCost(
    id: json['id']?.toString(),
    kind: json['kind']?.toString() ?? '',
    amount: _money(json['amount']),
    method: json['allocationMethod']?.toString() ?? '',
    status: json['status']?.toString() ?? '',
    varianceAmount: _money(json['varianceAmount']),
    allocatedTotal: _money(json['allocatedTotal']),
  );

  final String? id;
  final String kind;
  final double amount;
  final String method;
  final String status;
  final double varianceAmount;
  final double allocatedTotal;
}
