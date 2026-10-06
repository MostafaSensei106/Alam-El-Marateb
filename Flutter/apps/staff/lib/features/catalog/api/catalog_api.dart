import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../models/catalog_models.dart';

/// Staff catalog API layer: public storefront reads (no auth needed,
/// client-gate headers still apply via interceptors).
class CatalogApi {
  CatalogApi(this._dio);

  final Dio _dio;

  static const String productsPath = '/api/v1/catalog/public/products';
  static const String searchPath = '/api/v1/catalog/public/products/search';
  static const String suggestPath = '/api/v1/catalog/public/products/suggest';
  static const String featuredPath = '/api/v1/catalog/public/products/featured';
  static const String categoriesPath = '/api/v1/catalog/public/categories';
  static const String brandsPath = '/api/v1/catalog/public/brands';

  static String productPath(String slug) =>
      '/api/v1/catalog/public/products/$slug';
  static String variantsPath(String productId) =>
      '/api/v1/catalog/public/products/$productId/variants';

  Future<List<StoreProduct>> browse({
    String? category,
    String? brand,
    double? minPrice,
    double? maxPrice,
  }) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      productsPath,
      queryParameters: <String, dynamic>{
        'category': ?category,
        'brand': ?brand,
        'minPrice': ?minPrice,
        'maxPrice': ?maxPrice,
      },
    ),
    (json) => (json as List)
        .map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<List<StoreProduct>> search(String query) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      searchPath,
      queryParameters: <String, dynamic>{'q': query},
    ),
    (json) => (json as List)
        .map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<StoreProduct> details(String slug) => ApiExecutor.call(
    () => _dio.get<dynamic>(productPath(slug)),
    (json) => StoreProduct.fromJson(json as Map<String, dynamic>),
  );

  Future<List<ProductVariant>> variants(String productId) => ApiExecutor.call(
    () => _dio.get<dynamic>(variantsPath(productId)),
    (json) => (json as List)
        .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
