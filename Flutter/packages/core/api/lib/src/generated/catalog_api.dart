import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/product_dto.dart';

part 'catalog_api.g.dart';

/// Public storefront (anonymous, ETag-cached) + backoffice management.
@RestApi()
abstract class CatalogApi {
  factory CatalogApi(Dio dio) = _CatalogApi;

  @GET(CatalogStoreRoutes.products)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<PagedResponse<ProductDto>>> browseProducts(
    @Query('category') String? category,
    @Query('brand') String? brand,
    @Query('minPrice') double? minPrice,
    @Query('maxPrice') double? maxPrice,
    @Query('page') int page,
    @Query('size') int size,
  );

  @GET(CatalogStoreRoutes.search)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<ProductDto>>> searchProducts(
    @Query('q') String query,
  );

  @GET(CatalogStoreRoutes.suggest)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<String>>> suggestProducts(
    @Query('q') String query,
  );

  @GET(CatalogStoreRoutes.featured)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<ProductDto>>> featuredProducts();

  @GET(CatalogStoreRoutes.productBySlug)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<ProductDto>> productBySlug(
    @Path('slug') String slug,
  );

  @GET(CatalogStoreRoutes.productVariants)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<ProductVariantDto>>> productVariants(
    @Path('id') String id,
  );

  @GET(CatalogStoreRoutes.compare)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<ProductDto>>> compareProducts(
    @Query('ids') String ids,
  );

  @GET(CatalogStoreRoutes.categories)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<CategoryDto>>> publicCategories();

  @GET(CatalogStoreRoutes.brands)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<BrandDto>>> publicBrands();

  @GET(CatalogStoreRoutes.productImages)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<ProductImageDto>>> productImages(
    @Path('slug') String slug,
  );

  @GET(CatalogStoreRoutes.productReviews)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<ReviewDto>>> productReviews(
    @Path('slug') String slug,
  );

  @GET(CatalogStoreRoutes.quiz)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<QuizQuestionDto>>> quiz();

  @POST(CatalogStoreRoutes.quizRecommend)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<RecommendationDto>>> quizRecommend(
    @Body() Map<String, dynamic> body,
  );

  @POST(CatalogStoreRoutes.customQuote)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<CustomQuoteDto>> customQuote(
    @Path('slug') String slug,
    @Body() Map<String, dynamic> body,
  );

  @POST(CatalogStoreRoutes.productReviews)
  Future<ApiResponse<ReviewDto>> submitReview(
    @Path('slug') String slug,
    @Body() Map<String, dynamic> body,
  );

  @GET(CatalogAdminRoutes.products)
  Future<ApiResponse<PagedResponse<ProductDto>>> adminProducts(
    @Query('page') int page,
    @Query('size') int size,
  );

  @POST(CatalogAdminRoutes.searchReindex)
  Future<ApiResponse<EmptyDto>> triggerSearchReindex();
}
