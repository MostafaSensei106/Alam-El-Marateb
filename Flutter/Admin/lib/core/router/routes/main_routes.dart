part of '../app_router.dart';

/// Route الخاصة بفتح الـ Main Shell من الـ AppRouter.
sealed class MainRoute extends AppRoute {
  const MainRoute();
}

final class MainRouteEntry extends MainRoute {
  const MainRouteEntry();

  @override
  List<Object?> get props => [];
}

/// Home branch
sealed class HomeRoute extends KaiselRoute {
  const HomeRoute();
}

final class HomeRoot extends HomeRoute {
  const HomeRoot();

  @override
  List<Object?> get props => [];
}

/// Settings branch
sealed class SettingsRoute extends KaiselRoute {
  const SettingsRoute();
}

final class SettingsRoot extends SettingsRoute {
  const SettingsRoot();

  @override
  List<Object?> get props => [];
}
