part of '../app_router.dart';

final class MainRoute extends AppRoute {
  const MainRoute();
}

sealed class TabRoute extends KaiselRoute {
  const TabRoute();
}

final class HomeRoot extends TabRoute {
  const HomeRoot();
}

final class ProfileRoot extends TabRoute {
  const ProfileRoot();
}
