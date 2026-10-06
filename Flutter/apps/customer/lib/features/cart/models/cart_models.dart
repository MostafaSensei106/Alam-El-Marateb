double _money(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};

int _int(Object? value) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? 0,
  _ => 0,
};

class PreviewLine {
  const PreviewLine({required this.variantId, required this.qty});

  final String variantId;
  final int qty;
}

class CartItem {
  const CartItem({
    required this.variantId, this.id,
    this.qty = 1,
    this.unitPrice = 0,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id']?.toString(),
    variantId: json['variantId']?.toString() ?? '',
    qty: _int(json['qty']),
    unitPrice: _money(json['unitPrice']),
  );

  final String? id;
  final String variantId;
  final int qty;
  final double unitPrice;
}

class CartView {
  const CartView({this.items = const <CartItem>[], this.total = 0});

  factory CartView.fromJson(Map<String, dynamic> json) => CartView(
    items: json['items'] is List
        ? (json['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map(CartItem.fromJson)
              .toList()
        : const <CartItem>[],
    total: _money(json['total']),
  );

  final List<CartItem> items;
  final double total;
}

class PricePreview {
  const PricePreview({this.subtotal = 0, this.discount = 0, this.total = 0});

  factory PricePreview.fromJson(Map<String, dynamic> json) => PricePreview(
    subtotal: _money(json['subtotal']),
    discount: _money(json['discount'] ?? json['discountTotal']),
    total: _money(json['total'] ?? json['grandTotal']),
  );

  final double subtotal;
  final double discount;
  final double total;
}

class PlacedShopOrder {
  const PlacedShopOrder({
    this.id,
    this.trackingNumber,
    this.grandTotal = 0,
    this.status = 'draft',
  });

  factory PlacedShopOrder.fromJson(Map<String, dynamic> json) =>
      PlacedShopOrder(
        id: json['id']?.toString(),
        trackingNumber: json['trackingNumber']?.toString(),
        grandTotal: _money(json['grandTotal']),
        status: json['status']?.toString() ?? 'draft',
      );

  final String? id;
  final String? trackingNumber;
  final double grandTotal;
  final String status;
}

class ShopOrder {
  const ShopOrder({
    this.id,
    this.trackingNumber,
    this.status = '',
    this.grandTotal = 0,
  });

  factory ShopOrder.fromJson(Map<String, dynamic> json) => ShopOrder(
    id: json['id']?.toString(),
    trackingNumber: json['trackingNumber']?.toString(),
    status: json['status']?.toString() ?? '',
    grandTotal: _money(json['grandTotal']),
  );

  final String? id;
  final String? trackingNumber;
  final String status;
  final double grandTotal;
}

class TrackingInfo {
  const TrackingInfo({this.trackingNumber, this.status = '', this.driverName});

  factory TrackingInfo.fromJson(Map<String, dynamic> json) => TrackingInfo(
    trackingNumber: json['trackingNumber']?.toString(),
    status: json['status']?.toString() ?? '',
    driverName: json['driverName']?.toString(),
  );

  final String? trackingNumber;
  final String status;
  final String? driverName;
}
