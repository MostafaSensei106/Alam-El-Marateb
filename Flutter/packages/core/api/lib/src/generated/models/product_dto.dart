import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

/// Backend `ProductAttributeResponse`.
@JsonSerializable()
final class ProductAttributeDto {
  const ProductAttributeDto({
    this.code = '',
    this.displayName = '',
    this.value = '',
  });

  factory ProductAttributeDto.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAttributeDtoToJson(this);

  final String code;
  final String displayName;
  final String value;
}

/// Backend `ProductVariantPublicResponse` (no cost prices).
@JsonSerializable()
final class ProductVariantDto {
  const ProductVariantDto({
    this.id = '',
    this.sku = '',
    this.barcode,
    this.widthCm = 0,
    this.lengthCm = 0,
    this.heightCm = 0,
    this.sellingPrice = 0.0,
    this.isActive = true,
  });

  factory ProductVariantDto.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariantDtoToJson(this);

  final String id;
  final String sku;
  final String? barcode;
  final int widthCm;
  final int lengthCm;
  final int heightCm;
  final double sellingPrice;
  final bool isActive;

  String get dimensionsLabel => '$widthCm×$lengthCm×$heightCm';
}

/// Backend `ProductPublicResponse`.
@JsonSerializable()
final class ProductDto {
  const ProductDto({
    this.id = '',
    this.categoryId = '',
    this.name = '',
    this.slug = '',
    this.brand = '',
    this.description,
    this.warrantyYears,
    this.attributes = const [],
    this.variants = const [],
    this.isActive = true,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);

  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final String brand;
  final String? description;
  final int? warrantyYears;
  final List<ProductAttributeDto> attributes;
  final List<ProductVariantDto> variants;
  final bool isActive;
}

@JsonSerializable()
final class CategoryDto {
  const CategoryDto({this.id = '', this.slug = '', this.name = ''});

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);

  final String id;
  final String slug;
  final String name;
}

/// Backend `BrandView` (translations map excluded — resolved per X-Lang).
@JsonSerializable()
final class BrandDto {
  const BrandDto({
    this.id,
    this.name = '',
    this.slug = '',
    this.logoUrl,
    this.description,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory BrandDto.fromJson(Map<String, dynamic> json) =>
      _$BrandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BrandDtoToJson(this);

  final String? id;
  final String name;
  final String slug;
  final String? logoUrl;
  final String? description;
  final int sortOrder;
  final bool isActive;
}

/// Backend `ProductImageView`.
@JsonSerializable()
final class ProductImageDto {
  const ProductImageDto({this.id, this.url = '', this.sortOrder = 0});

  factory ProductImageDto.fromJson(Map<String, dynamic> json) =>
      _$ProductImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageDtoToJson(this);

  final String? id;
  final String url;
  final int sortOrder;
}

/// Backend `ReviewView`.
@JsonSerializable()
final class ReviewDto {
  const ReviewDto({
    this.id,
    this.productId,
    this.rating = 0,
    this.title,
    this.body,
    this.photos = const [],
    this.verifiedPurchase = false,
    this.status = '',
    this.helpfulCount = 0,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewDtoToJson(this);

  final String? id;
  final String? productId;
  final int rating;
  final String? title;
  final String? body;
  final List<String> photos;
  final bool verifiedPurchase;
  final String status;
  final int helpfulCount;
}

/// Backend `CustomQuote` result for `POST .../custom-quote`.
@JsonSerializable()
final class CustomQuoteDto {
  const CustomQuoteDto({
    this.productSlug = '',
    this.shape = '',
    this.dimensions = '',
    this.surfaceAreaM2 = 0.0,
    this.pricePerMeter = 0.0,
    this.operatingBracketPercent = 0.0,
    this.basePrice = 0.0,
    this.surchargeAmount = 0.0,
    this.finalPrice = 0.0,
    this.currency = 'EGP',
  });

  factory CustomQuoteDto.fromJson(Map<String, dynamic> json) =>
      _$CustomQuoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomQuoteDtoToJson(this);

  final String productSlug;
  final String shape;
  final String dimensions;
  final double surfaceAreaM2;
  final double pricePerMeter;
  final double operatingBracketPercent;
  final double basePrice;
  final double surchargeAmount;
  final double finalPrice;
  final String currency;
}

/// Backend `QuizQuestionView` + `QuizOptionView` (texts maps excluded —
/// resolved per X-Lang).
@JsonSerializable()
final class QuizOptionDto {
  const QuizOptionDto({this.id, this.label = ''});

  factory QuizOptionDto.fromJson(Map<String, dynamic> json) =>
      _$QuizOptionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuizOptionDtoToJson(this);

  final String? id;
  final String label;
}

@JsonSerializable()
final class QuizQuestionDto {
  const QuizQuestionDto({
    this.id,
    this.sortOrder = 0,
    this.text = '',
    this.dimension = '',
    this.options = const [],
  });

  factory QuizQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionDtoToJson(this);

  final String? id;
  final int sortOrder;
  final String text;
  final String dimension;
  final List<QuizOptionDto> options;
}

/// Backend `Recommendation(productId, name, slug, matchPercent, reasons)`.
@JsonSerializable()
final class RecommendationDto {
  const RecommendationDto({
    this.productId,
    this.name = '',
    this.slug = '',
    this.matchPercent = 0,
    this.reasons = const [],
  });

  factory RecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$RecommendationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationDtoToJson(this);

  final String? productId;
  final String name;
  final String slug;
  final int matchPercent;
  final List<String> reasons;
}
