import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../../dashboard/models/admin_models.dart';

/// Admin identity API layer: branches, roles, staff users.
class IdentityApi {
  IdentityApi(this._dio);

  final Dio _dio;

  static const String branchesPath = '/api/v1/identity/branches';
  static const String rolesPath = '/api/v1/identity/access/roles';
  static const String usersPath = '/api/v1/identity/access/users';

  static String userRolesPath(String userId) =>
      '/api/v1/identity/access/users/$userId/roles';

  Future<List<ManagedUser>> users() => ApiExecutor.call(
    () => _dio.get<dynamic>(usersPath),
    (json) => (json as List)
        .map((e) => ManagedUser.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<ManagedUser> createUser({
    required String fullName,
    required String phone,
    required String password,
    List<String> roles = const <String>[],
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(usersPath, data: <String, dynamic>{
      'fullName': fullName,
      'phone': phone,
      'password': password,
      'roles': roles,
    }),
    (json) => ManagedUser.fromJson(json as Map<String, dynamic>),
  );

  Future<void> setRoles({
    required String userId,
    required List<String> roles,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(userRolesPath(userId), data: <String, dynamic>{
      'roles': roles,
    }),
    (_) {},
  );
}
