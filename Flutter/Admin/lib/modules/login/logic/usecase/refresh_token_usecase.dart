import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/login_repository.dart';
import '../entity/user_entity.dart';

@injectable
final class RefreshTokenUsecase implements UseCaseBase<UserEntity, String> {
  const RefreshTokenUsecase({required this._repo});
  final LoginRepository _repo;

  @override
  Future<Result<UserEntity, Failures>> call(String params) async {
    return _repo.refreshToken(token: params);
  }
}
