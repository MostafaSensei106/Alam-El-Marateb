import 'package:core_utils/core_utils.dart';

import '../../constants/pref_keys.dart';
import '../shared_prefs/base_pref_storage_service.dart';
import 'session_auth_notifier.dart';

abstract interface class BaseUserSessionService {
  Future<void> saveUserSession({required String token, bool rememberMe = true});

  Future<void> clearUserSession();

  Future<bool> isAuthenticated();
}

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

    SessionAuthNotifier.instance.notifyAuthChanged(true);
  }

  @override
  Future<void> clearUserSession() async {
    await resetUserSession();

    await Future.wait([
      _prefStorageService.removeData(key: PrefKeys.userToken),
      _prefStorageService.removeData(key: PrefKeys.isRememberMe),
    ]);

    SessionAuthNotifier.instance.notifyAuthChanged(false);
  }
}
