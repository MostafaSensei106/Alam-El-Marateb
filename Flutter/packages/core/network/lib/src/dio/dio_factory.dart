import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

class DioFactory {
  static Dio? dio;

  static Future<Dio> getDio() async {
    if (dio == null) {
      dio = Dio();
      dio!.transformer = BackgroundTransformer();
      dio!.httpClientAdapter = Http2Adapter(ConnectionManager());
      dio!
        ..options.headers[ApiHeader.accept] = Headers.jsonContentType
        ..options.headers[ApiHeader.contentType] = Headers.jsonContentType
        ..options.connectTimeout = ApplicationDuration.networkTimeout
        ..options.sendTimeout = ApplicationDuration.networkTimeout
        ..options.receiveTimeout = ApplicationDuration.networkTimeout
        ..options.responseType = ResponseType.json;

      return dio!;
    }
    return dio!;
  }

  // static Future<void> addDioInterceptors() async {
  //   final cacheInterceptors = await createCacheInterceptors();
  //   dio!.interceptors.addAll([]);
  // }
}
