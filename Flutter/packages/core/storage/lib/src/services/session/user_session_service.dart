import 'package:injectable/injectable.dart';

import '../../constants/pref_keys.dart';
import '../../di/di.dart';
import '../../router/app_auth_notifier.dart';
import '../shared_prefs/base_pref_storage_service.dart';

abstract interface class BaseUserSessionService {
  Future<void> saveUserSession({required String token, bool rememberMe = true});

  Future<void> clearUserSession();

  Future<bool> isAuthenticated();
}

@LazySingleton(as: BaseUserSessionService)
final class UserSessionService implements BaseUserSessionService {
  const UserSessionService(this._prefStorageService);

  final BasePrefStorageService _prefStorageService;

  @override
  Future<bool> isAuthenticated() async {
    final rememberMe =
        await _prefStorageService.getData<bool>(key: PrefKeys.isRememberMe) ??
        false;

    if (!rememberMe) {
      return false;
    }

    final token = await _prefStorageService.getData<String>(
      key: PrefKeys.userToken,
    );

    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveUserSession({
    required String token,
    bool rememberMe = true,
  }) async {
    await Future.wait([
      _prefStorageService.setData(key: PrefKeys.userToken, value: token),
      _prefStorageService.setData(
        key: PrefKeys.isRememberMe,
        value: rememberMe,
      ),
    ]);

    AppAuthNotifier.instance.notifyAuthChanged(true);
  }

  @override
  Future<void> clearUserSession() async {
    await resetUserSession();

    await Future.wait([
      _prefStorageService.removeData(key: PrefKeys.userToken),
      _prefStorageService.removeData(key: PrefKeys.isRememberMe),
    ]);

    AppAuthNotifier.instance.notifyAuthChanged(false);
  }
}
