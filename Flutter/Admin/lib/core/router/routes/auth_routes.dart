// Auth Routes
part of '../app_router.dart';

final class LoginRoute extends AppRoute {
  const LoginRoute({this.redirectTarget});

  final AppRoute? redirectTarget;
  @override
  List<Object?> get props => [redirectTarget];
}

final class RegisterRoute extends AppRoute {
  const RegisterRoute();
  @override
  List<Object?> get props => [];
}

final class ResetPasswordRoute extends AppRoute {
  const ResetPasswordRoute();
  @override
  List<Object?> get props => [];
}
