import 'package:alam_el_marateb_result/result.dart';

import 'package:auth/src/domain/entities/user.dart';

/// Domain port for authentication. Implemented in `data/`, consumed by
/// use-cases and cubits — the presentation layer never sees Dio or json.
abstract interface class AuthRepository {
  Future<Result<User, Failure>> login({
    required String phone,
    required String password,
  });

  /// Local-only logout (the backend exposes no logout endpoint).
  Future<Result<void, Failure>> logout();

  /// Re-mints the access token from the stored refresh token.
  Future<Result<void, Failure>> refreshSession();

  /// Last successfully loaded user (memory only, `null` before login).
  User? get currentUser;

  /// Loads `/me` (with one transparent refresh retry on 401).
  Future<Result<User, Failure>> getCurrentUser();

  Future<bool> isAuthenticated();
}
