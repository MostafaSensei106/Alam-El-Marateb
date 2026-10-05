// ignore_for_file: discarded_futures

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../../modules/cart/logic/cubit/cart_cubit.dart';
import '../../../modules/help_and_support/logic/cubit/social_links_cubit.dart';
import '../../../modules/home/logic/cubit/banner_cubit.dart';
import '../../../modules/invoices/logic/cubit/my_invoices_cubit.dart';
import '../../../modules/notifications/logic/cubit/notification_cubit.dart';
import '../../../modules/products/logic/cubit/shop_products_cubit.dart';
import '../../../modules/profile/logic/cubit/profile_cubit.dart';
import '../../../modules/sectors_prices/logic/cubit/sectors_prices_cubit.dart';
import '../../../modules/shiping_addresses/logic/cubit/shipping_address_cubit.dart';
import '../../../modules/track_order/logic/cubit/my_orders_cubit.dart';
import '../../../modules/wishlist/logic/cubit/wishlist_cubit.dart';
import '../../di/di.dart';

/// Centralized configuration for all modules that require offline-first caching
/// and background prefetching.
///
/// This adheres to the Open-Closed Principle (OCP) and Single Responsibility
/// Principle (SRP). If a new module needs to be prefetched, it should be
/// added here without modifying the UI layer.
final class AppCacheConfig {
  const AppCacheConfig._();
  static List<SingleChildWidget> get prefetchProviders => [
    /// Prefetches the user's profile data.
    BlocProvider(create: (_) => getIt<CartCubit>()),

    /// Prefetches the user's wishlist data.
    BlocProvider(
      create: (_) => getIt<WishlistCubit>()..loadNextPage(isRefresh: true),
      lazy: false,
    ),

    /// Prefetches the user's orders data.
    BlocProvider(
      create: (_) => getIt<ProfileCubit>()..getUserData(isRefresh: false),
      lazy: false,
    ),

    ///
    BlocProvider(
      create: (_) =>
          getIt<ShippingAddressCubit>()
            ..getAllShippingAddresses(isRefresh: false),
      lazy: false,
    ),
    BlocProvider(
      create: (_) => getIt<MyOrdersCubit>()..loadNextPage(isRefresh: true),
      lazy: false,
    ),
    BlocProvider(
      create: (_) => getIt<MyInvoicesCubit>()..loadNextPage(isRefresh: true),
      lazy: false,
    ),
    BlocProvider(
      create: (_) => getIt<BannerCubit>()..getHomeBanners(isRefresh: false),
      lazy: false,
    ),
    BlocProvider(
      create: (_) => getIt<ShopProductsCubit>()..getProducts(),
      lazy: false,
    ),
    BlocProvider(
      create: (_) =>
          getIt<SectorsPricesCubit>()..getSectorsPrices(isRefresh: false),
      lazy: false,
    ),
    BlocProvider(
      create: (_) =>
          getIt<SocialLinksCubit>()..getSocialLinks(isRefresh: false),
      lazy: false,
    ),
    BlocProvider(
      create: (_) => getIt<NotificationCubit>()..loadNextPage(isRefresh: true),
      lazy: false,
    ),
  ];
}
