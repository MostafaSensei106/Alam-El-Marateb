import 'dart:convert';

import 'package:alam_el_marateb_network/network.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

/// Captures the outgoing request and returns a canned envelope.
class _FakeAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode({
        'success': true,
        'message': 'ok',
        'data': {'ping': true},
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('DioClientKeyInterceptor', () {
    test('attaches client gate headers to every request', () async {
      final dio = Dio()..httpClientAdapter = _FakeAdapter();
      dio.interceptors.add(
        const DioClientKeyInterceptor(
          clientName: 'customer-app',
          clientKey: 'dev-local-key',
        ),
      );

      await dio.get('https://example.com/api/v1/auth/me');
      final headers =
          (dio.httpClientAdapter as _FakeAdapter).lastRequest!.headers;
      expect(headers['X-Api-Client'], 'customer-app');
      expect(headers['X-Api-Key'], 'dev-local-key');
    });
  });

  group('APIErrorHandler envelope', () {
    test('maps backend failure envelope to ApiFailure', () {
      final failure = APIErrorHandler.handle(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 401,
            data: {
              'success': false,
              'message': 'بيانات الدخول غير صحيحة',
              'errors': ['INVALID_CREDENTIALS'],
            },
          ),
        ),
      );
      expect(failure, isA<ApiFailure>());
      expect(failure.errorType, ErrorType.clientError);
      expect(failure.statusCode, 401);
      // Human backend message, not the machine code.
      expect(failure.message, 'بيانات الدخول غير صحيحة');
      expect(failure.apiErrorModel.errors, ['INVALID_CREDENTIALS']);
    });

    test('maps 401 envelope without body to unauthorized message', () {
      final failure = APIErrorHandler.handle(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me'),
            statusCode: 401,
            data: null,
          ),
        ),
      );
      expect(failure, isA<ApiFailure>());
      expect(failure.errorType, ErrorType.clientError);
    });
  });
}
