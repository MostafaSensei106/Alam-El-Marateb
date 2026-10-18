import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../modules/cart/data/models/place_order_mixed/place_order_mixed_request_body.dart';
import '../../../modules/cart/data/models/place_order_mixed/place_order_mixed_response_body.dart';
import '../../../modules/cart/data/models/place_order_shop/place_order_shop_requset_body.dart';
import '../../../modules/cart/data/models/place_order_shop/place_order_shop_response_body.dart';
import '../../../modules/estimator/data/models/catalog_brand_accessories/catalog_brand_accessories_response_body.dart';
import '../../../modules/estimator/data/models/catalog_preview_unit_price/catalog_preview_unit_price_request_body.dart';
import '../../../modules/estimator/data/models/catalog_preview_unit_price/catalog_preview_unit_price_response_body.dart';
import '../../../modules/estimator/data/models/catalog_products/catalog_products_response_body.dart';
import '../../../modules/estimator/data/models/glass_options_for_brand_type/glass_options_for_brand_type_response_body.dart';
import '../../../modules/estimator/data/models/product_catalog_brand_types/product_catalog_brand_types_response_body.dart';
import '../../../modules/estimator/data/models/product_catalog_brands/product_catalog_brands_response_body.dart';
import '../../../modules/estimator/data/models/product_catalog_colors/product_catalog_colors_response_body.dart';
import '../../../modules/estimator/data/models/seals_for_brand_type/seals_for_brand_type_response_body.dart';
import '../../../modules/force_update/data/models/get_app_info_settings_response_body.dart';
import '../../../modules/forget_password/data/models/change_password/reset_password_request_body.dart';
import '../../../modules/forget_password/data/models/change_password/reset_password_response_body.dart';
import '../../../modules/help_and_support/data/model/social_links_response_body.dart';
import '../../../modules/home/data/models/banners/home_banners_response_body.dart';
import '../../../modules/invoices/data/models/list_invoices_response_body.dart';
import '../../../modules/login/data/models/login_request_body.dart';
import '../../../modules/login/data/models/login_response_body.dart';
import '../../../modules/notifications/data/models/delete_notification_response_body.dart';
import '../../../modules/notifications/data/models/notifications_response_body.dart';
import '../../../modules/products/data/models/product_categories/shop_categories_response_body.dart';
import '../../../modules/products/data/models/products/shop_products_response_body.dart';
import '../../../modules/products/data/models/shop_porudcts_params/shop_porudcts_params.dart';
import '../../../modules/profile/data/models/edit_profile/edit_user_profile_request_body.dart';
import '../../../modules/profile/data/models/edit_profile/edit_user_profile_response_body.dart';
import '../../../modules/profile/data/models/profile/user_profile_response_body.dart';
import '../../../modules/register/data/models/register/register_request_body.dart';
import '../../../modules/register/data/models/register/register_response_body.dart';
import '../../../modules/register/data/models/send_otp/send_otp_request_body.dart';
import '../../../modules/register/data/models/send_otp/send_otp_response_body.dart';
import '../../../modules/register/data/models/verify_otp/verify_otp_request_body.dart';
import '../../../modules/register/data/models/verify_otp/verify_otp_response_body.dart';
import '../../../modules/sectors_prices/data/models/sectors_prices_response_body.dart';
import '../../../modules/shiping_addresses/data/models/shipping_addresses/add_shipping_address_request_body.dart';
import '../../../modules/shiping_addresses/data/models/shipping_addresses/add_shipping_address_response_body.dart';
import '../../../modules/shiping_addresses/data/models/shipping_addresses/delete_shipping_address_response_body.dart';
import '../../../modules/shiping_addresses/data/models/shipping_addresses/list_shipping_addresses_response_body.dart';
import '../../../modules/shiping_addresses/data/models/shipping_addresses/set_default_shipping_address_response_body.dart';
import '../../../modules/shiping_addresses/data/models/shipping_addresses/update_shipping_address_request_body.dart';
import '../../../modules/shiping_addresses/data/models/shipping_addresses/update_shipping_address_response_body.dart';
import '../../../modules/track_order/data/models/get_order_response_body.dart';
import '../../../modules/track_order/data/models/list_orders_response_body.dart';
import '../../../modules/wishlist/data/models/toggle_wishlist_response_body.dart';
import '../../../modules/wishlist/data/models/wishlist_response_body.dart';
import '../../constants/api_routes.dart';
import '../../constants/security_configs.dart';
import '../../utils/models/logout_model/logout_response_body.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiRoutes.apiBaseURL)
abstract class ApiService {
  /// Creates an instance of [ApiService] with the provided [Dio] client and optional [baseUrl].
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  /// Auths
  @POST(ApiRoutes.authLogin)
  @Extra({SecurityConfigs.requireToken: false})
  Future<LoginResponseBody> login(@Body() LoginRequestBody body);

  /// Register
  @POST(ApiRoutes.authRegister)
  @Extra({SecurityConfigs.requireToken: false})
  Future<RegisterResponseBody> register(@Body() RegisterRequestBody body);

  /// OTP
  @POST(ApiRoutes.authOtpRequest)
  @Extra({SecurityConfigs.requireToken: false})
  Future<SendOtpResponseBody> sendOtp(@Body() SendOtpRequestBody body);

  /// Verify OTP
  @POST(ApiRoutes.authOtpVerify)
  @Extra({SecurityConfigs.requireToken: false})
  Future<VerifyOtpResponseBody> verifyOTP(@Body() VerifyOtpRequestBody body);

  /// Reset Password
  @POST(ApiRoutes.authRestPassword)
  @Extra({SecurityConfigs.requireToken: false})
  Future<ResetPasswordResponseBody> resetPassword(
    @Body() ResetPasswordRequestBody body,
  );

  /// Logout
  @POST(ApiRoutes.authLogout)
  Future<LogoutResponseBody> logout();

  /// FCM Token
  @POST(ApiRoutes.authFcmToken)
  @Extra({SecurityConfigs.requireToken: true})
  Future<void> updateFcmToken(@Body() Map<String, dynamic> body);

  /// App Settings
  @GET(ApiRoutes.settingsAppInfo)
  @Extra({SecurityConfigs.requireToken: false})
  Future<GetAppInfoSettingsResponseBody> getAppInfoSettings();

  /// Home
  @GET(ApiRoutes.getActiveBanners)
  @Extra({SecurityConfigs.requireToken: true})
  Future<HomeBannersResponseBody> getHomeBanners();

  /// Profile
  @PATCH(ApiRoutes.profilePatch)
  @Extra({SecurityConfigs.requireToken: true})
  Future<EditUserProfileResponseBody> editUserProfile(
    @Body() EditUserProfileRequestBody body,
  );

  @GET(ApiRoutes.profileGetUser)
  @Extra({SecurityConfigs.requireToken: true})
  Future<UserProfileResponseBody> getUserProfile();

  /// notifications
  @GET(ApiRoutes.notificationsList)
  @Extra({SecurityConfigs.requireToken: true})
  Future<NotificationsResponseBody> getAllNotifications({
    @Query('page') required int page,
  });

  /// Mark notifications as read
  @POST(ApiRoutes.notificationsMarkReadAll)
  @Extra({SecurityConfigs.requireToken: true})
  Future<MarkAllReadNotificationsResponseBody> markAllReadNotifications();

  /// Mark one notification as read
  @POST(ApiRoutes.notificationsMarkAsRead)
  @Extra({SecurityConfigs.requireToken: true})
  Future<MarkOneNotificationReadResponseBody> markOneNotificationAsRead(
    @Path('id') int id,
  );

  /// Delete notifications
  @DELETE(ApiRoutes.notificationDelete)
  @Extra({SecurityConfigs.requireToken: true})
  Future<DeleteNotificationResponseBody> deleteNotification(
    @Path('notification_id') int notificationId,
  );

  @DELETE(ApiRoutes.notificationDeleteAll)
  @Extra({SecurityConfigs.requireToken: true})
  Future<DeleteNotificationResponseBody> deleteAllNotifications();

  /// favorites
  @GET(ApiRoutes.favoritesList)
  @Extra({SecurityConfigs.requireToken: true})
  Future<WishlistResponseBody> getWishlist({@Query('page') required int page});

  /// Toggle wishlist
  @POST(ApiRoutes.favoritesToggle)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ToggleWishlistResponseBody> toggleWishlist({
    @Path('id') required int id,
  });

  /// products
  @GET(ApiRoutes.shopProductsCategories)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ShopCategoriesResponseBody> getProductCategories();

  /// products
  @GET(ApiRoutes.shopProductsList)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ShopProductsResponseBody> getAllProducts(
    @Queries() ShopProductsParams params,
  );

  /// products by slug
  @GET(ApiRoutes.shopProductBySlug)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ShopProductsResponseBody> getProjectBySlug({
    @Query('slug') required String slug,
  });

  /// catalog
  @GET(ApiRoutes.catalogProductsList)
  @Extra({SecurityConfigs.requireToken: true})
  Future<CatalogProductsResponseBody> getCatalogProducts();

  /// catalog brands for product
  @GET(ApiRoutes.catalogBrandsForProduct)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ProductCatalogBrandsResponseBody> getBrands({
    @Path('catalog_product_id') required int catalogProductId,
  });

  @GET(ApiRoutes.catalogBrandTypes)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ProductCatalogBrandTypesResponseBody> getBrandTypes({
    @Path('catalog_brand_id') required int catalogBrandId,
  });

  @GET(ApiRoutes.catalogGlassOptions)
  @Extra({SecurityConfigs.requireToken: true})
  Future<GlassOptionsForBrandTypeResponseBody> getGlassOptionsForBrandType({
    @Path('catalog_brand_type_id') required int catalogBrandTypeId,
  });

  @GET(ApiRoutes.catalogSealsForBrandType)
  @Extra({SecurityConfigs.requireToken: true})
  Future<SealsForBrandTypeResponseBody> getSealTypesForBrandType({
    @Path('catalog_brand_type_id') required int catalogBrandTypeId,
  });

  @GET(ApiRoutes.catalogColors)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ProductCatalogColorsResponseBody> getColors();

  @POST(ApiRoutes.catalogPricingPreveiewUnit)
  @Extra({SecurityConfigs.requireToken: true})
  Future<CatalogPreviewUnitPriceResponseBody> getPreviewUnitPrice(
    @Body() CatalogPreviewUnitPriceRequestBody body,
  );

  /// cart
  @POST(ApiRoutes.ordersPlaceShop)
  @Extra({SecurityConfigs.requireToken: true})
  Future<PlaceOrderShopResponseBody> placeOrderShop(
    @Body() PlaceOrderShopRequsetBody body,
  );

  @POST(ApiRoutes.ordersPlaceMixed)
  @Extra({SecurityConfigs.requireToken: true})
  Future<PlaceOrderMixedResponseBody> placeOrderMixed(
    @Body() PlaceOrderMixedRequestBody body,
  );

  @GET(ApiRoutes.orderGet)
  @Extra({SecurityConfigs.requireToken: true})
  Future<GetOrderResponseBody> getOrder({@Path('id') required int id});

  @GET(ApiRoutes.ordersList)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ListOrdersResponseBody> listOrders({@Query('page') required int page});

  @GET(ApiRoutes.invoiceGet)
  @Extra({SecurityConfigs.requireToken: true})
  Future<GetInvoiceResponseBody> getInvoice({@Path('id') required int id});

  @GET(ApiRoutes.invoicesList)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ListInvoicesResponseBody> listInvoices({
    @Query('page') required int page,
  });

  /// shipping addresses
  @GET(ApiRoutes.addressesList)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ListShippingAddressesResponseBody> getAllShipingAddresses();

  @POST(ApiRoutes.addressesAdd)
  @Extra({SecurityConfigs.requireToken: true})
  Future<AddShippingAddressResponseBody> addShippingAddress(
    @Body() AddShippingAddressRequestBody body,
  );

  @PATCH(ApiRoutes.addressesUpdate)
  @Extra({SecurityConfigs.requireToken: true})
  Future<UpdateShippingAddressResponseBody> updateShippingAddress(
    @Path('address_id') int id,
    @Body() UpdateShippingAddressRequestBody body,
  );

  @POST(ApiRoutes.addressesSetDefault)
  @Extra({SecurityConfigs.requireToken: true})
  Future<SetDefaultShippingAddressResponseBody> setDefaultShippingAddress(
    @Path('address_id') int id,
  );

  @DELETE(ApiRoutes.addressesDelete)
  @Extra({SecurityConfigs.requireToken: true})
  Future<DeleteShippingAddressResponseBody> deleteShippingAddress(
    @Path('address_id') int id,
  );

  /// Social Links
  @GET(ApiRoutes.settingsSocialLinks)
  @Extra({SecurityConfigs.requireToken: false})
  Future<SocialLinksResponseBody> getSocialLinks();

  /// Catalog Tree
  @GET(ApiRoutes.catalogTree)
  @Extra({SecurityConfigs.requireToken: true})
  Future<SectorsPricesResponseBody> getCatalogSectorsPrices();

  /// Catalog Brand Accessories
  @GET(ApiRoutes.catalogBrandAccessories)
  @Extra({SecurityConfigs.requireToken: true})
  Future<CatalogBrandAccessoriesResponseBody> getCatalogBrandAccessories({
    @Path('catalog_brand_id') required int catalogBrandId,
  });
}
