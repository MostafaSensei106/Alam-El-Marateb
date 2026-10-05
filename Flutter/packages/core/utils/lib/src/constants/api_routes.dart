final class ApiRoutes {
  ApiRoutes._();
  static const String apiBaseURL =
      'https://hadidi-win-back.inxhub.online/api/mobile/';

  /// Auth
  static const String authRegister = 'auth/register';
  static const String authLogin = 'auth/login';
  static const String authLogout = 'auth/logout';
  static const String authOtpRequest = 'auth/otp/request';
  static const String authOtpVerify = 'auth/otp/verify';
  static const String authRestPassword = 'auth/password/reset';
  static const String profileGetUser = 'auth/me';
  static const String authFcmToken = 'auth/fcm-token';

  /// Orders
  static const String ordersList = 'orders';
  static const String orderGet = 'orders/{id}';
  static const String ordersPlaceShop = 'orders';
  static const String ordersPlaceCatalog = 'orders';
  static const String ordersPlaceMixed = 'orders';

  /// Invoices
  static const String invoicesList = 'invoices';
  static const String invoiceGet = 'invoices/{id}';

  /// Profile
  static const String profilePatch = 'profile';
  static const String profileChangePassword = 'profile/password';
  static const String profileUploadAvatar = 'profile/avatar';

  /// addresses
  static const String addressesList = 'addresses';
  static const String addressesAdd = 'addresses';
  static const String addressesUpdate = 'addresses/{address_id}';
  static const String addressesDelete = 'addresses/{address_id}';
  static const String addressesSetDefault =
      'addresses/{address_id}/set-default';
  static const String getActiveBanners = 'banners/active';

  /// notifications
  static const String notificationsList = 'notifications';
  static const String notificationsMarkAsRead = 'notifications/{id}/read';
  static const String notificationsMarkReadAll = 'notifications/read-all';
  static const String notificationDelete = 'notifications/{notification_id}';
  static const String notificationDeleteAll = 'notifications/clear-all';

  /// Ready Products Shop
  static const String shopProductsCategories = 'shop-products/categories';
  static const String shopProductsList = 'shop-products';
  static const String shopProductBySlug = 'shop-products';

  /// favorites
  static const String favoritesList = 'favorites';
  static const String favoritesToggle = 'shop-products/{id}/favorite';

  /// catalog
  static const String catalogProductsList = 'catalog/products';
  static const String catalogBrandsForProduct =
      'catalog/products/{catalog_product_id}/brands';

  static const String catalogBrandTypes =
      'catalog/brands/{catalog_brand_id}/types';

  static const String catalogGlassOptions =
      'catalog/brand-types/{catalog_brand_type_id}/glass';

  static const String catalogSealsForBrandType =
      'catalog/brand-types/{catalog_brand_type_id}/seals';

  static const String catalogColors = 'catalog/colors';

  static const String catalogBrandAccessories =
      'catalog/brands/{catalog_brand_id}/accessories';

  /// Pricing
  static const String catalogPricingPreveiewUnit =
      'catalog/pricing/preview-unit';

  /// Social-links
  static const String settingsSocialLinks = 'settings/social-links';

  /// Catalog Tree
  static const String catalogTree = 'catalog/tree';

  /// App Settings
  static const String settingsAppInfo = 'settings/app-info';
}
