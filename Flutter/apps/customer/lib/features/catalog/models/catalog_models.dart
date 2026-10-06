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

/// GET /catalog/public/products[*] item.
class StoreProduct {
  const StoreProduct({
    required this.name,
    required this.slug,
    required this.brand,
    this.id,
    this.description,
    this.warrantyYears,
    this.variants = const <ProductVariant>[],
  });

  factory StoreProduct.fromJson(Map<String, dynamic> json) => StoreProduct(
    id: json['id']?.toString(),
    name: json['name']?.toString() ?? '',
    slug: json['slug']?.toString() ?? '',
    brand: json['brand']?.toString() ?? '',
    description: json['description']?.toString(),
    warrantyYears: json['warrantyYears'] is num
        ? (json['warrantyYears'] as num).toInt()
        : null,
    variants: json['variants'] is List
        ? (json['variants'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ProductVariant.fromJson)
              .toList()
        : const <ProductVariant>[],
  );

  final String? id;
  final String name;
  final String slug;
  final String brand;
  final String? description;
  final int? warrantyYears;
  final List<ProductVariant> variants;
}

/// Product variant (sellable dimension).
class ProductVariant {
  const ProductVariant({
    required this.sku,
    this.id,
    this.barcode,
    this.widthCm = 0,
    this.lengthCm = 0,
    this.heightCm = 0,
    this.sellingPrice = 0,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    id: json['id']?.toString(),
    sku: json['sku']?.toString() ?? '',
    barcode: json['barcode']?.toString(),
    widthCm: _int(json['widthCm']),
    lengthCm: _int(json['lengthCm']),
    heightCm: _int(json['heightCm']),
    sellingPrice: _money(json['sellingPrice']),
  );

  final String? id;
  final String sku;
  final String? barcode;
  final int widthCm;
  final int lengthCm;
  final int heightCm;
  final double sellingPrice;

  String get dimensionsLabel => '$widthCm×$lengthCm×$heightCm';
}
