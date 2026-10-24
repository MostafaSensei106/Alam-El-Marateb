import '../../constants/pref_keys.dart';
import '../../di/di.dart';
import '../../services/session/user_session_service.dart';
import '../../services/shared_prefs/base_pref_storage_service.dart';
import '../app_auth_notifier.dart';
import '../app_router.dart';

Future<AppRoute> getStartRoute() async {
  final pref = getIt<BasePrefStorageService>();

  final hasSeenOnboarding =
      await pref.getData<bool>(key: PrefKeys.hasSeenOnboarding) ?? false;

  if (!hasSeenOnboarding) {
    AppAuthNotifier.instance.notifyAuthChanged(false);
    return const LoginRoute();
  }

  final sessionService = getIt<UserSessionServiceBase>();
  final isAuthenticated = await sessionService.isAuthenticated();

  AppAuthNotifier.instance.notifyAuthChanged(isAuthenticated);

  return isAuthenticated ? const MainRouteEntry() : const LoginRoute();
}

List<AppRoute> authGuard(List<AppRoute> current, List<AppRoute> proposed) {
  if (proposed.isEmpty) return proposed;

  final target = proposed.last;
  final isAuthenticated = AppAuthNotifier.instance.isAuthenticated;

  final isAuthOnly = target is LoginRoute || target is RegisterRoute;

  if (isAuthenticated && isAuthOnly) {
    return [const MainRouteEntry()];
  }

  return proposed;
}
