import '../../../../core/constants/types/type_def.dart';
import '../../logic/entity/user_entity.dart';

abstract interface class LoginRepository {
  Future<ApiResult<UserEntity>> login({
    required String phone,
    required String password,
    required bool rememberMe,
  });
}
