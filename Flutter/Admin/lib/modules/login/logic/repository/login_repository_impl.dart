import 'package:injectable/injectable.dart';

import '../../../../core/constants/types/type_def.dart';
import '../../../../core/networking/api_executor/api_executor.dart';
import '../../../../core/networking/api_service/api_service.dart';
import '../../../../core/services/session/user_session_service.dart';
import '../../../../core/utils/result/result.dart';
import '../../data/interface/login_repository.dart';
import '../../data/models/login_request_body.dart';
import '../../data/models/login_response_data.dart';
import '../entity/user_entity.dart';

@LazySingleton(as: LoginRepository)
final class LoginRepositoryImpl implements LoginRepository {
  new({required this._api, required this._session});

  final ApiService _api;
  final UserSessionServiceBase _session;

  @override
  Future<ApiResult<UserEntity>> login({
    required String phone,
    required String password,
    required bool rememberMe,
  }) async {
    final body = LoginRequestBody(phone: phone, password: password);
    final result = await ApiExecutor.executeMapped(
      action: () => _api.login(body),
      mapper: (model) => model.data.toEntity(),
    );

    return result.when(
      success: (r) async {
        await _session.saveUserSession(token: r.token, rememberMe: rememberMe);
        return Result.success(data: r);
      },
      failure: (e) => Result.failure(error: e),
    );
  }
}
