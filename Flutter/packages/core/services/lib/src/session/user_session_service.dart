import 'package:alam_el_marateb_constants/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:services/src/session/user_session_service_base.dart';
import 'package:services/src/shared_prefs/storage_facade.dart';

@LazySingleton(as: UserSessionServiceBase)
final class UserSessionService implements UserSessionServiceBase {
  UserSessionService(this._storageFacade);

  final StorageFacade _storageFacade;

  // In-Memory cache for session-only persistence when rememberMe is false
  String? _inMemoryToken;

  @override
  Future<String?> getToken() async {
    if (_inMemoryToken != null) return _inMemoryToken;

    final isRemembered =
        await _storageFacade.getData<bool>(key: PrefKeys.isRememberMeEnabled) ??
        false;
    if (!isRemembered) return null;

    final tokenFromStorage = await _storageFacade.getData<String>(
      key: PrefKeys.userToken,
    );

    _inMemoryToken = tokenFromStorage;
    return tokenFromStorage;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> isRememberMeEnabled() async {
    final isRemembered =
        await _storageFacade.getData<bool>(key: PrefKeys.isRememberMeEnabled) ??
        false;
    return isRemembered;
  }

  @override
  Future<void> saveUserSession({
    required String token,
    required bool rememberMe,
  }) async {
    _inMemoryToken = token;
    if (rememberMe) {
      await Future.wait([
        _storageFacade.setData<bool>(
          key: PrefKeys.isRememberMeEnabled,
          value: rememberMe,
        ),
        _storageFacade.setData<String>(key: PrefKeys.userToken, value: token),
      ]);
    }
  }

  @override
  Future<bool> clearUserSession() async {
    _inMemoryToken = null;
    final results = await Future.wait([
      _storageFacade.removeData(key: PrefKeys.userToken),
      _storageFacade.removeData(key: PrefKeys.isRememberMeEnabled),
    ]);

    return results.every((result) => result);
  }
}
