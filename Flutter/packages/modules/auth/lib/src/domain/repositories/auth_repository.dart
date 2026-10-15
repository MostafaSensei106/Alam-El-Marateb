import 'package:alam_el_marateb_result/result.dart';

import 'package:auth/src/domain/entities/user.dart';

/// Domain port for authentication. Implemented in `data/`, consumed by
/// use-cases and cubits — the presentation layer never sees Dio or json.
abstract interface class AuthRepository {
  Future<Result<User, Failure>> login({
    required String identifier,
    required String password,
  });

  Future<Result<void, Failure>> logout();

  Future<bool> isAuthenticated();
}
