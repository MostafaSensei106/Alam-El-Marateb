part of '../app_router.dart';

@TypedGoRoute<LoginRoute>(path: AppRouter.login)
final class LoginRoute extends NativeRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

@TypedGoRoute<RegisterRoute>(path: AppRouter.register)
final class RegisterRoute extends NativeRouteData with $RegisterRoute {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterPage();
}

@TypedGoRoute<ForgetPasswordRoute>(path: AppRouter.forgotPassword)
final class ForgetPasswordRoute extends NativeRouteData
    with $ForgetPasswordRoute {
  const ForgetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgetPasswordPage();
}
