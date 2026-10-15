import 'package:alam_el_marateb_result/result.dart';

import 'package:auth/src/domain/entities/user.dart';
import 'package:auth/src/domain/repositories/auth_repository.dart';

final class LoginParams {
  const LoginParams({required this.identifier, required this.password});

  final String identifier;
  final String password;
}

final class LoginUseCase implements BaseUseCase<User, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User, Failure>> call(LoginParams params) {
    return _repository.login(
      identifier: params.identifier,
      password: params.password,
    );
  }
}
