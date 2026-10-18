// ignore_for_file: discarded_futures

part of '../app_router.dart';

@TypedStatefulShellRoute<MainRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    // Home
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRoute>(path: AppRouter.home),
      ],
    ),
    //  Estimator
    TypedStatefulShellBranch<EstimatorBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<EstimatorRoute>(path: AppRouter.estimator),
      ],
    ),

    // Products
    TypedStatefulShellBranch<ProductsBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProductsRoute>(path: AppRouter.products),
      ],
    ),

    //Cart
    TypedStatefulShellBranch<CartBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CartRoute>(path: AppRouter.cart),
      ],
    ),

    // Settings
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SettingsRoute>(path: AppRouter.settings),
      ],
    ),
  ],
)
final class MainRoute extends StatefulShellRouteData {
  const MainRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainPage(navigationShell: navigationShell);
  }

  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CupertinoPage(key: state.pageKey, child: child);
  }
}

final class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

final class HomeRoute extends NativeRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (_) => getIt<BannerCubit>()..getHomeBanners(),
    child: const HomePage(),
  );
}

final class EstimatorBranchData extends StatefulShellBranchData {
  const EstimatorBranchData();
}

final class EstimatorRoute extends NativeRouteData with $EstimatorRoute {
  const EstimatorRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EstimatorPage();
}

final class ProductsBranchData extends StatefulShellBranchData {
  const ProductsBranchData();
}

final class ProductsRoute extends NativeRouteData with $ProductsRoute {
  const ProductsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProudctsPage();
}

final class CartBranchData extends StatefulShellBranchData {
  const CartBranchData();
}

final class CartRoute extends NativeRouteData with $CartRoute {
  const CartRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider.value(
    // Shared cart draft singleton: value (never closed by the route).
    value: getIt<CartCubit>(),
    child: const CartPage(),
  );
}

final class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

final class SettingsRoute extends NativeRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (_) => getIt<AutoLoginCubit>(),
    child: const SettingsPage(),
  );
}

@TypedGoRoute<ProductDetailsRoute>(path: AppRouter.product)
final class ProductDetailsRoute extends NativeRouteData
    with $ProductDetailsRoute {
  const ProductDetailsRoute({required this.$extra});

  final ProductItem $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: getIt<WishlistCubit>()),

      BlocProvider.value(value: getIt<CartCubit>()),
    ],
    child: ProductDetailsPage(product: $extra),
  );
}
