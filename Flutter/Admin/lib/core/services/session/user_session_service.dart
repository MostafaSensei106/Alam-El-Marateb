import 'package:injectable/injectable.dart';

import '../../constants/pref_keys.dart';
import '../../di/di.dart' as di;
import '../../router/app_auth_notifier.dart';
import '../shared_prefs/storage_facade.dart';

abstract interface class BaseUserSessionService {
  /// Saves the current user session data.
  /// If [rememberMe] is `false`, the session should persist only for the
  /// app process lifetime (In-Memory).
  Future<void> saveUserSession({
    required String token,
    required bool rememberMe,
  });

  /// Synchronously or asynchronously retrieves the cached access token.
  /// Returns `null` if the user is unauthenticated or session expired.
  Future<String?> getToken();

  /// Returns `true` if a valid user session exists and is not expired.
  Future<bool> isAuthenticated();

  /// Returns whether the user opted for "Remember Me" during login.
  Future<bool> isRememberMeEnabled();

  /// Clears user credentials and invalidates the session (e.g. on Logout / 401 Unauthorized).
  Future<bool> clearUserSession();

  /// Drops the service's reference to the in-memory token.
  ///
  /// Exposure reduction, NOT a guaranteed heap wipe: Dart strings are
  /// immutable and managed by the GC, so no code can ensure every copy
  /// has left physical memory. What this guarantees is that the service
  /// no longer retains the token through this field.
  void wipeInMemoryToken();

  /// Lifecycle hook for app backgrounding.
  ///
  /// Drops the RAM token only when the session is persisted on disk
  /// ("Remember Me"), so the next [getToken] transparently re-hydrates
  /// from secure storage. For memory-only sessions (`rememberMe == false`)
  /// wiping would equal a silent logout, so the token is kept — such
  /// sessions live in RAM by explicit contract (see [saveUserSession]).
  Future<void> onAppBackgrounded();
}

@LazySingleton(as: BaseUserSessionService)
final class UserSessionService implements BaseUserSessionService {
  UserSessionService(this._storageFacade);

  final StorageFacade _storageFacade;

  // Hot RAM Cache
  String? _inMemoryToken;

  // Single-flight Hydration Guard
  bool _isHydrated = false;
  Future<void>? _hydrationFuture;

  @override
  Future<String?> getToken() async {
    // 1. Fast path: return immediately if RAM is already hydrated (whether token is String or null)
    if (_isHydrated) return _inMemoryToken;

    // 2. Single-flight lock: deduplicate concurrent startup/cold calls
    await (_hydrationFuture ??= _hydrateToken());

    return _inMemoryToken;
  }

  Future<void> _hydrateToken() async {
    try {
      final isRemembered = await isRememberMeEnabled();

      if (isRemembered) {
        _inMemoryToken = await _storageFacade.getData<String>(
          key: PrefKeys.userToken,
        );
      }
      _isHydrated = true;
    } finally {
      _hydrationFuture = null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> isRememberMeEnabled() async {
    return await _storageFacade.getData<bool>(key: PrefKeys.isRememberMe) ??
        false;
  }

  @override
  Future<void> saveUserSession({
    required String token,
    required bool rememberMe,
  }) async {
    // Update active memory state immediately
    _inMemoryToken = token;
    _isHydrated = true;

    if (rememberMe) {
      await Future.wait([
        _storageFacade.setData<bool>(key: PrefKeys.isRememberMe, value: true),
        _storageFacade.setData<String>(key: PrefKeys.userToken, value: token),
      ]);
    } else {
      await Future.wait([
        _storageFacade.removeData(key: PrefKeys.userToken),
        _storageFacade.setData<bool>(key: PrefKeys.isRememberMe, value: false),
      ]);
    }

    AppAuthNotifier.instance.notifyAuthChanged(true);
  }

  @override
  Future<bool> clearUserSession() async {
    wipeInMemoryToken();
    _isHydrated = true; // Prevents re-reading disk after logout

    await di.resetUserSession();

    final results = await Future.wait([
      _storageFacade.removeData(key: PrefKeys.userToken),
      _storageFacade.setData<bool>(key: PrefKeys.isRememberMe, value: false),
    ]);

    final isSuccess = results.every((result) => result);

    AppAuthNotifier.instance.notifyAuthChanged(false);

    return isSuccess;
  }

  @override
  void wipeInMemoryToken() {
    _inMemoryToken = null;
  }

  @override
  Future<void> onAppBackgrounded() async {
    // Memory-only sessions cannot re-hydrate; wiping them would silently
    // log the user out, so only persisted sessions drop their RAM copy.
    if (!await isRememberMeEnabled()) return;
    wipeInMemoryToken();
    _isHydrated = false;
    _hydrationFuture = null;
  }
}
