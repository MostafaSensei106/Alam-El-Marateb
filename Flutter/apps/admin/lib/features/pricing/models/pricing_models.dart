double _money(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};

class SheetLineInput {
  const SheetLineInput({
    required this.variantId,
    required this.listCost,
    required this.suggestedSelling,
  });

  final String variantId;
  final double listCost;
  final double suggestedSelling;
}

class SheetLine {
  const SheetLine({
    this.variantId,
    this.listCost = 0,
    this.suggestedSelling = 0,
  });

  factory SheetLine.fromJson(Map<String, dynamic> json) => SheetLine(
    variantId: json['variantId']?.toString(),
    listCost: _money(json['listCost']),
    suggestedSelling: _money(json['suggestedSelling']),
  );

  final String? variantId;
  final double listCost;
  final double suggestedSelling;
}

class PriceSheet {
  const PriceSheet({
    required this.sheetNo, this.id,
    this.supplierId,
    this.validFrom,
    this.validUntil,
    this.lines = const <SheetLine>[],
  });

  factory PriceSheet.fromJson(Map<String, dynamic> json) => PriceSheet(
    id: json['id']?.toString(),
    supplierId: json['supplierId']?.toString(),
    sheetNo: json['sheetNo']?.toString() ?? '',
    validFrom: json['validFrom']?.toString(),
    validUntil: json['validUntil']?.toString(),
    lines: json['lines'] is List
        ? (json['lines'] as List)
              .whereType<Map<String, dynamic>>()
              .map(SheetLine.fromJson)
              .toList()
        : const <SheetLine>[],
  );

  final String? id;
  final String? supplierId;
  final String sheetNo;
  final String? validFrom;
  final String? validUntil;
  final List<SheetLine> lines;
}

class PriceHistoryPoint {
  const PriceHistoryPoint({
    this.channel = '',
    this.price = 0,
    this.effectiveFrom,
  });

  factory PriceHistoryPoint.fromJson(Map<String, dynamic> json) =>
      PriceHistoryPoint(
        channel: json['channel']?.toString() ?? '',
        price: _money(json['price']),
        effectiveFrom: json['effectiveFrom']?.toString(),
      );

  final String channel;
  final double price;
  final String? effectiveFrom;
}
