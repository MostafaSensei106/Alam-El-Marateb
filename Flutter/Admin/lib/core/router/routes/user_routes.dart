// ignore_for_file: discarded_futures

part of '../app_router.dart';

@TypedGoRoute<ProfileRoute>(path: AppRouter.userProfile)
final class ProfileRoute extends NativeRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<ProfileCubit>()..getUserData()),
      BlocProvider(create: (_) => getIt<AutoLoginCubit>()),
    ],
    child: const ProfilePage(),
  );
}

@TypedGoRoute<EditProfileRoute>(path: AppRouter.editProfile)
final class EditProfileRoute extends NativeRouteData with $EditProfileRoute {
  const EditProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (context) => getIt<ProfileCubit>()..getUserData(),
    child: const EditProfilePage(),
  );
}

@TypedGoRoute<WishlistRoute>(path: AppRouter.wishlist)
final class WishlistRoute extends NativeRouteData with $WishlistRoute {
  const WishlistRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      // Shared singleton: value (no close on dispose) + cascade initial
      // load during route build, before the screen renders.
      BlocProvider.value(
        value: getIt<WishlistCubit>()..loadNextPage(isRefresh: true),
      ),
      BlocProvider.value(value: getIt<CartCubit>()),
    ],
    child: const WishlistPage(),
  );
}

@TypedGoRoute<MyInvoicesRoute>(path: AppRouter.myInvoices)
final class MyInvoicesRoute extends NativeRouteData with $MyInvoicesRoute {
  const MyInvoicesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            getIt<MyInvoicesCubit>()..loadNextPage(isRefresh: true),
      ),
    ],
    child: const InvoicesPage(),
  );
}

@TypedGoRoute<InvoiceDetailsRoute>(path: AppRouter.invoiceDetails)
final class InvoiceDetailsRoute extends NativeRouteData
    with $InvoiceDetailsRoute {
  const InvoiceDetailsRoute({required this.invoiceId});

  final int invoiceId;

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            getIt<InvoiceDetailsCubit>()..getInvoice(invoiceId),
      ),
    ],
    child: InvoiceDetailsPage(invoiceId: invoiceId),
  );
}

@TypedGoRoute<TrackOrderRoute>(path: AppRouter.trackOrder)
final class TrackOrderRoute extends NativeRouteData with $TrackOrderRoute {
  const TrackOrderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<TrackOrderCubit>()),
      BlocProvider(
        create: (context) =>
            getIt<MyOrdersCubit>()..loadNextPage(isRefresh: true),
      ),
    ],
    child: const TrackOrderPage(),
  );
}

@TypedGoRoute<OrderDetailsRoute>(path: AppRouter.orderDetails)
final class OrderDetailsRoute extends NativeRouteData with $OrderDetailsRoute {
  const OrderDetailsRoute({required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (context) => getIt<TrackOrderCubit>()..getOrder(orderId),
    child: const OrderDetailsPage(),
  );
}

@TypedGoRoute<ShipingAddressesRoute>(path: AppRouter.shippingAddresses)
final class ShipingAddressesRoute extends NativeRouteData
    with $ShipingAddressesRoute {
  const ShipingAddressesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (context) =>
        getIt<ShippingAddressCubit>()..getAllShippingAddresses(),
    child: const ShipingAddressesPage(),
  );
}

@TypedGoRoute<AddShipingAddressRoute>(path: AppRouter.addShipingAddress)
final class AddShipingAddressRoute extends NativeRouteData
    with $AddShipingAddressRoute {
  const AddShipingAddressRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (context) => getIt<ShippingAddressCubit>(),
    child: const AddShipingAddressPage(),
  );
}

@TypedGoRoute<EditShippingAddressRoute>(path: AppRouter.editShipingAddress)
final class EditShippingAddressRoute extends NativeRouteData
    with $EditShippingAddressRoute {
  const EditShippingAddressRoute({required this.$extra});
  final ListShippingAddresseData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider.value(
    value: getIt<ShippingAddressCubit>()..loadAddressDataToForm($extra),
    child: EditShippingAddressPage(address: $extra),
  );
}

@TypedGoRoute<NotificationRoute>(path: AppRouter.notifications)
final class NotificationRoute extends NativeRouteData with $NotificationRoute {
  const NotificationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider.value(
    // Shared singleton: value (no close on dispose) + cascade initial
    // load during route build, before the screen renders.
    value: getIt<NotificationCubit>()..loadNextPage(isRefresh: true),
    child: const NotificationPage(),
  );
}

@TypedGoRoute<FullScreenImageViewerRoute>(path: AppRouter.fullScreenImageViewer)
final class FullScreenImageViewerRoute extends NativeRouteData
    with $FullScreenImageViewerRoute {
  const FullScreenImageViewerRoute({
    required this.imageUrl,
    required this.orderId,
    this.caption,
  });

  final String imageUrl;
  final String orderId;
  final String? caption;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FullScreenImageViewer(
        imageUrl: imageUrl,
        orderId: orderId,
        caption: caption,
      );
}

@TypedGoRoute<PdfViewerPageRoute>(path: AppRouter.pdfViewer)
final class PdfViewerPageRoute extends NativeRouteData
    with $PdfViewerPageRoute {
  const PdfViewerPageRoute({
    required this.pdfUrl,
    required this.orderId,
    this.caption,
  });

  final String pdfUrl;
  final String orderId;
  final String? caption;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PdfViewerPage(pdfUrl: pdfUrl, orderId: orderId, caption: caption);
}
