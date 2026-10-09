/// Contract for managing user authentication session and token storage.
abstract interface class UserSessionServiceBase {
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
}
