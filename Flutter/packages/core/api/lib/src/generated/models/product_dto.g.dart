// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAttributeDto _$ProductAttributeDtoFromJson(Map<String, dynamic> json) =>
    ProductAttributeDto(
      code: json['code'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$ProductAttributeDtoToJson(
        ProductAttributeDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'displayName': instance.displayName,
      'value': instance.value,
    };

ProductVariantDto _$ProductVariantDtoFromJson(Map<String, dynamic> json) =>
    ProductVariantDto(
      id: json['id'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      barcode: json['barcode'] as String?,
      widthCm: (json['widthCm'] as num?)?.toInt() ?? 0,
      lengthCm: (json['lengthCm'] as num?)?.toInt() ?? 0,
      heightCm: (json['heightCm'] as num?)?.toInt() ?? 0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ProductVariantDtoToJson(ProductVariantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'widthCm': instance.widthCm,
      'lengthCm': instance.lengthCm,
      'heightCm': instance.heightCm,
      'sellingPrice': instance.sellingPrice,
      'isActive': instance.isActive,
    };

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
      id: json['id'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      description: json['description'] as String?,
      warrantyYears: (json['warrantyYears'] as num?)?.toInt(),
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) =>
                  ProductAttributeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      variants: (json['variants'] as List<dynamic>?)
              ?.map(
                  (e) => ProductVariantDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'slug': instance.slug,
      'brand': instance.brand,
      'description': instance.description,
      'warrantyYears': instance.warrantyYears,
      'attributes': instance.attributes,
      'variants': instance.variants,
      'isActive': instance.isActive,
    };

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };

BrandDto _$BrandDtoFromJson(Map<String, dynamic> json) => BrandDto(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      description: json['description'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$BrandDtoToJson(BrandDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'logoUrl': instance.logoUrl,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };

ProductImageDto _$ProductImageDtoFromJson(Map<String, dynamic> json) =>
    ProductImageDto(
      id: json['id'] as String?,
      url: json['url'] as String? ?? '',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductImageDtoToJson(ProductImageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'sortOrder': instance.sortOrder,
    };

ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) => ReviewDto(
      id: json['id'] as String?,
      productId: json['productId'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      body: json['body'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      verifiedPurchase: json['verifiedPurchase'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReviewDtoToJson(ReviewDto instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'rating': instance.rating,
      'title': instance.title,
      'body': instance.body,
      'photos': instance.photos,
      'verifiedPurchase': instance.verifiedPurchase,
      'status': instance.status,
      'helpfulCount': instance.helpfulCount,
    };

CustomQuoteDto _$CustomQuoteDtoFromJson(Map<String, dynamic> json) =>
    CustomQuoteDto(
      productSlug: json['productSlug'] as String? ?? '',
      shape: json['shape'] as String? ?? '',
      dimensions: json['dimensions'] as String? ?? '',
      surfaceAreaM2: (json['surfaceAreaM2'] as num?)?.toDouble() ?? 0.0,
      pricePerMeter: (json['pricePerMeter'] as num?)?.toDouble() ?? 0.0,
      operatingBracketPercent:
          (json['operatingBracketPercent'] as num?)?.toDouble() ?? 0.0,
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      surchargeAmount: (json['surchargeAmount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'EGP',
    );

Map<String, dynamic> _$CustomQuoteDtoToJson(CustomQuoteDto instance) =>
    <String, dynamic>{
      'productSlug': instance.productSlug,
      'shape': instance.shape,
      'dimensions': instance.dimensions,
      'surfaceAreaM2': instance.surfaceAreaM2,
      'pricePerMeter': instance.pricePerMeter,
      'operatingBracketPercent': instance.operatingBracketPercent,
      'basePrice': instance.basePrice,
      'surchargeAmount': instance.surchargeAmount,
      'finalPrice': instance.finalPrice,
      'currency': instance.currency,
    };

QuizOptionDto _$QuizOptionDtoFromJson(Map<String, dynamic> json) =>
    QuizOptionDto(
      id: json['id'] as String?,
      label: json['label'] as String? ?? '',
    );

Map<String, dynamic> _$QuizOptionDtoToJson(QuizOptionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
    };

QuizQuestionDto _$QuizQuestionDtoFromJson(Map<String, dynamic> json) =>
    QuizQuestionDto(
      id: json['id'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      text: json['text'] as String? ?? '',
      dimension: json['dimension'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => QuizOptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuizQuestionDtoToJson(QuizQuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sortOrder': instance.sortOrder,
      'text': instance.text,
      'dimension': instance.dimension,
      'options': instance.options,
    };

RecommendationDto _$RecommendationDtoFromJson(Map<String, dynamic> json) =>
    RecommendationDto(
      productId: json['productId'] as String?,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      matchPercent: (json['matchPercent'] as num?)?.toInt() ?? 0,
      reasons: (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RecommendationDtoToJson(RecommendationDto instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'slug': instance.slug,
      'matchPercent': instance.matchPercent,
      'reasons': instance.reasons,
    };
