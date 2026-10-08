import 'dart:convert';

import 'package:services/src/shared_prefs/pref_storage_service_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPrefsService implements PrefStorageServiceBase {
  const SharedPrefsService(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<T?> getData<T>({required String key}) async {
    try {
      final value = _prefs.get(key);
      if (value == null) return null;

      if (value is T) return value as T;

      if (value is List && T == <String>[].runtimeType) {
        return value.cast<String>() as T;
      }

      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is T) return decoded;
        } catch (_) {
          // Not a JSON string, proceed to return null safely
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> setData<T>({required String key, required T value}) async {
    if (value is String) {
      return await _prefs.setString(key, value);
    } else if (value is int) {
      return await _prefs.setInt(key, value);
    } else if (value is bool) {
      return await _prefs.setBool(key, value);
    } else if (value is double) {
      return await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      return await _prefs.setStringList(key, value);
    } else if (value is Map || value is List) {
      return await _prefs.setString(key, jsonEncode(value));
    } else {
      throw ArgumentError(
        'Unsupported SharedPreferences type: ${value.runtimeType}',
      );
    }
  }

  @override
  Future<bool> removeData({required String key}) async {
    return await _prefs.remove(key);
  }

  @override
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
