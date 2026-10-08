import 'package:alam_el_marateb_constants/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:services/src/shared_prefs/pref_storage_service_base.dart';
import 'package:services/src/shared_prefs/secure_storage_service.dart';
import 'package:services/src/shared_prefs/shared_prefs_service.dart';

@LazySingleton(as: PrefStorageServiceBase)
final class StorageFacade implements PrefStorageServiceBase {
  const StorageFacade({
    required this._sharedPrefsService,
    required this._secureStorageService,
  });

  final SharedPrefsService _sharedPrefsService;
  final SecureStorageService _secureStorageService;

  static const _secureKeys = {
    PrefKeys.userToken,
    PrefKeys.firebaseMessagingToken,
  };

  PrefStorageServiceBase _getService(String key) {
    if (_secureKeys.contains(key)) {
      return _secureStorageService;
    }
    return _sharedPrefsService;
  }

  Future<void> clearSecureStorage() async {
    await _secureStorageService.clearAll();
  }

  Future<void> clearSharedPrefs() async {
    await _sharedPrefsService.clearAll();
  }

  @override
  Future<bool> clearAll() async {
    final results = await Future.wait([
      _sharedPrefsService.clearAll(),
      _secureStorageService.clearAll(),
    ]);
    return results.every((e) => e);
  }

  @override
  Future<T?> getData<T>({required String key}) async {
    return await _getService(key).getData<T>(key: key);
  }

  @override
  Future<bool> removeData({required String key}) async {
    return await _getService(key).removeData(key: key);
  }

  @override
  Future<bool> setData<T>({required String key, required T value}) async {
    return await _getService(key).setData<T>(key: key, value: value);
  }
}
