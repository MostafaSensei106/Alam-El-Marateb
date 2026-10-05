import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

DioException _dioException(DioExceptionType type) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  type: type,
);

DioException _dioError(int status, Map<String, dynamic>? body) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  type: DioExceptionType.badResponse,
  response: Response<dynamic>(
    requestOptions: RequestOptions(path: '/x'),
    statusCode: status,
    data: body,
  ),
);

void main() {
  group('ApiResponse', () {
    test('parses success envelope with data', () {
      final res = ApiResponse<String>.fromJson(<String, dynamic>{
        'success': true,
        'message': 'ok',
        'data': 'hello',
      }, (json) => json.toString());
      expect(res.success, isTrue);
      expect(res.message, 'ok');
      expect(res.data, 'hello');
      expect(res.errors, isEmpty);
      expect(res.isOk, isTrue);
    });

    test('parses failure envelope with error codes', () {
      final res = ApiResponse<String>.fromJson(<String, dynamic>{
        'success': false,
        'message': 'unauthorized',
        'errors': ['TOKEN_EXPIRED'],
      }, (json) => json.toString());
      expect(res.success, isFalse);
      expect(res.data, isNull);
      expect(res.errors, ['TOKEN_EXPIRED']);
      expect(res.isOk, isFalse);
    });

    test('tolerates missing fields', () {
      final res = ApiResponse<String>.fromJson(
        <String, dynamic>{},
        (json) => '',
      );
      expect(res.success, isFalse);
      expect(res.message, isEmpty);
      expect(res.errors, isEmpty);
    });
  });

  group('ApiErrorHandler', () {
    test('401 TOKEN_EXPIRED -> AuthFailure with code', () {
      final failure = ApiErrorHandler.handle(
        _dioError(401, <String, dynamic>{
          'success': false,
          'message': 'expired',
          'errors': ['TOKEN_EXPIRED'],
        }),
      );
      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).code, 'TOKEN_EXPIRED');
    });

    test('401 CLIENT_REJECTED -> ClientRejectedFailure', () {
      final failure = ApiErrorHandler.handle(
        _dioError(401, <String, dynamic>{
          'success': false,
          'message': 'Client rejected',
          'errors': ['CLIENT_REJECTED'],
        }),
      );
      expect(failure, isA<ClientRejectedFailure>());
    });

    test('403 -> AuthFailure', () {
      final failure = ApiErrorHandler.handle(_dioError(403, null));
      expect(failure, isA<AuthFailure>());
    });

    test('500 with envelope -> ServerFailure', () {
      final failure = ApiErrorHandler.handle(
        _dioError(500, <String, dynamic>{
          'success': false,
          'message': 'boom',
          'errors': <String>[],
        }),
      );
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'boom');
    });

    test('connection error -> OfflineFailure', () {
      final failure = ApiErrorHandler.handle(
        _dioException(DioExceptionType.connectionError),
      );
      expect(failure, isA<OfflineFailure>());
    });

    test('timeouts -> TimeoutFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
      ]) {
        expect(
          ApiErrorHandler.handle(_dioException(type)),
          isA<TimeoutFailure>(),
        );
      }
    });

    test('non-dio error -> UnknownFailure', () {
      expect(ApiErrorHandler.handle('nope'), isA<UnknownFailure>());
    });
  });
}
