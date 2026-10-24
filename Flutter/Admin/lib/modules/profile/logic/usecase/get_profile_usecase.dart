import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/auth_profile_repository.dart';
import '../entity/profile_entity.dart';

@injectable
final class GetProfileUsecase implements UseCaseBase<ProfileEntity, NoParams> {
  const GetProfileUsecase(this._repo);

  final AuthProfileRepository _repo;

  @override
  Future<Result<ProfileEntity, Failures>> call(NoParams params) =>
      _repo.getProfile();
}
