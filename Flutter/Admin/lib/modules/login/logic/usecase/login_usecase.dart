import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/login_repository.dart';
import '../entity/user_entity.dart';

final class LoginParams {
  const LoginParams({
    required this.phone,
    required this.password,
    required this.rememberMe,
  });

  final String phone;
  final String password;
  final bool rememberMe;
}

@injectable
final class LoginUsecase implements UseCaseBase<UserEntity, LoginParams> {
  const LoginUsecase({required this._repo});

  final LoginRepository _repo;

  @override
  Future<Result<UserEntity, Failures>> call(LoginParams params) => _repo.login(
    phone: params.phone,
    password: params.password,
    rememberMe: params.rememberMe,
  );
}
