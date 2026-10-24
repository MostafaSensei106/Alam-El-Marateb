import '../../../../core/constants/types/type_def.dart';
import '../../logic/entity/profile_entity.dart';

abstract interface class AuthProfileRepository {
  Future<ApiResult<ProfileEntity>> getProfile();
}
