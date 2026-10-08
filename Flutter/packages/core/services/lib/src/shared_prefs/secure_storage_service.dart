import 'package:injectable/injectable.dart';
import 'package:services/src/shared_prefs/pref_storage_service_base.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@lazySingleton
class SecureStorageService implements PrefStorageServiceBase {
  const SecureStorageService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> clearAll() async {
    await _secureStorage.deleteAll();
    return true;
  }

  @override
  Future<T?> getData<T>({required String key}) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return value as T;
  }

  @override
  Future<bool> removeData({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> setData<T>({required String key, required T value}) async {
    if (value is String) {
      await _secureStorage.write(key: key, value: value);
      return true;
    } else {
      throw Exception('SecureStorageService only supports String values');
    }
  }
}
