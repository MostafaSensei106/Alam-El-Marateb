import 'package:injectable/injectable.dart';

import '../../../../core/constants/types/type_def.dart';
import '../../../../core/networking/api_executor/api_executor.dart';
import '../../../../core/networking/api_service/api_service.dart';
import '../../../../core/utils/result/result.dart';
import '../../data/interface/auth_profile_repository.dart';
import '../../data/models/auth_profile_response_data.dart';
import '../entity/profile_entity.dart';

@LazySingleton(as: AuthProfileRepository)
final class AuthProfileRepositoryImpl implements AuthProfileRepository {
  const AuthProfileRepositoryImpl(this._api);

  final ApiService _api;

  @override
  Future<ApiResult<ProfileEntity>> getProfile() async {
    final result = await ApiExecutor.executeMapped(
      action: () => _api.authMe(),
      mapper: (dto) => dto.data.toEntity(),
    );
    return result.when(
      success: (s) => Result.success(data: s),
      failure: (e) => Result.failure(error: e),
    );
  }
}
