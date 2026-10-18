part of '../app_router.dart';

@TypedGoRoute<LanguageRoute>(path: AppRouter.language)
final class LanguageRoute extends NativeRouteData with $LanguageRoute {
  const LanguageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LanguagePage();
}

@TypedGoRoute<DigitalWarrantyRoute>(path: AppRouter.digitalWarranty)
final class DigitalWarrantyRoute extends NativeRouteData
    with $DigitalWarrantyRoute {
  const DigitalWarrantyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DigitalWarrantyPage();
}

@TypedGoRoute<MaintenanceRequestRoute>(path: AppRouter.maintenanceRequest)
final class MaintenanceRequestRoute extends NativeRouteData
    with $MaintenanceRequestRoute {
  const MaintenanceRequestRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SectorsPricesPage();
}

@TypedGoRoute<FAQsRoute>(path: AppRouter.faq)
final class FAQsRoute extends NativeRouteData with $FAQsRoute {
  const FAQsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const FAQsPage();
}

@TypedGoRoute<HelpAndSupportRoute>(path: AppRouter.helpAndSupport)
final class HelpAndSupportRoute extends NativeRouteData
    with $HelpAndSupportRoute {
  const HelpAndSupportRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HelpAndSupportPage();
}

@TypedGoRoute<PrivacyPolicyRoute>(path: AppRouter.privacyPolicy)
final class PrivacyPolicyRoute extends NativeRouteData
    with $PrivacyPolicyRoute {
  const PrivacyPolicyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PrivacyPolicyPage();
}

@TypedGoRoute<TermsAndConditionsRoute>(path: AppRouter.termsAndConditions)
final class TermsAndConditionsRoute extends NativeRouteData
    with $TermsAndConditionsRoute {
  const TermsAndConditionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TermsAndConditionsPage();
}

@TypedGoRoute<AboutHadidiWinRoute>(path: AppRouter.aboutHadidiWin)
final class AboutHadidiWinRoute extends NativeRouteData
    with $AboutHadidiWinRoute {
  const AboutHadidiWinRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (_) => getIt<AboutAppCubit>(),
    child: const AboutAppPage(),
  );
}
