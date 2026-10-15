import 'package:alam_el_marateb_result/result.dart';

import 'package:auth/src/domain/repositories/auth_repository.dart';

final class LogoutUseCase implements BaseUseCase<void, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void, Failure>> call(NoParams params) {
    return _repository.logout();
  }
}
