import 'package:injectable/injectable.dart';

import '../../../../core/constants/types/type_def.dart';
import '../../../../core/networking/api_service/api_service.dart';
import '../../../../core/services/session/user_session_service.dart';
import '../../data/interface/login_repository.dart';
import '../entity/user_entity.dart';

@LazySingleton()
final class LoginRepositoryImpl implements LoginRepository {
  final ApiService _api;
  final UserSessionServiceBase _session;

  @override
  Future<ApiResult<UserEntity>> login({
    required String phone,
    required String password,
    required bool rememberMe,
  }) {}
}
