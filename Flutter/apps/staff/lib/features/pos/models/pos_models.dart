import '../../../shared/enums.dart';
import '../../catalog/models/catalog_models.dart';

/// POST /sales/pos/scan/{barcode} result.
class ScannedItem {
  const ScannedItem({
    required this.sku, this.variantId,
    this.productId,
    this.barcode,
    this.dimensions,
    this.sellingPrice = 0,
    this.isActive = true,
  });

  factory ScannedItem.fromJson(Map<String, dynamic> json) => ScannedItem(
    variantId: json['variantId']?.toString(),
    productId: json['productId']?.toString(),
    sku: json['sku']?.toString() ?? '',
    barcode: json['barcode']?.toString(),
    dimensions: json['dimensions']?.toString(),
    sellingPrice: _money(json['sellingPrice']),
    isActive: json['isActive'] as bool? ?? true,
  );

  final String? variantId;
  final String? productId;
  final String sku;
  final String? barcode;
  final String? dimensions;
  final double sellingPrice;
  final bool isActive;
}

/// One ticket row in the POS cart (UI-side).
class TicketLine {
  TicketLine({required this.variant, this.qty = 1});

  final ProductVariant variant;
  int qty;

  String get variantId => variant.id ?? '';
  double get lineTotal => variant.sellingPrice * qty;
}

/// POST /sales/pos/complete-sale result.
class CompletedOrder {
  const CompletedOrder({
    required this.status, required this.grandTotal, this.id,
    this.trackingNumber,
  });

  factory CompletedOrder.fromJson(Map<String, dynamic> json) => CompletedOrder(
    id: json['id']?.toString(),
    status: OrderStatus.fromValue(json['status']?.toString()),
    grandTotal: _money(json['grandTotal']),
    trackingNumber: json['trackingNumber']?.toString(),
  );

  final String? id;
  final OrderStatus status;
  final double grandTotal;
  final String? trackingNumber;
}

double _money(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};
