import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../constants/api_routes.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiRoutes.apiBaseURL)
abstract class ApiService {
  /// Creates an instance of [ApiService] with the provided [Dio] client and optional [baseUrl].
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;
}
