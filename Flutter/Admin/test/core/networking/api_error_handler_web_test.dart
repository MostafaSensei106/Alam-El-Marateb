@TestOn('browser')
library;

import 'package:alam_el_marateb_admin/core/constants/http_messages.dart';
import 'package:alam_el_marateb_admin/core/networking/api_error_handler.dart';
import 'package:alam_el_marateb_admin/core/networking/error_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RequestOptions options(String url) => RequestOptions(path: url);

  DioException connectionError(String url, String message) => DioException(
    requestOptions: options(url),
    type: DioExceptionType.connectionError,
    message: message,
  );

  const browserMessage =
      'The connection errored: The XMLHttpRequest onError callback was called. '
      'This typically indicates an error on the network layer. '
      'If you are running the app on a browser, this may be due to CORS.';

  group('connectionError on web', () {
    test('cross-origin + CORS hint is classified as corsBlocked', () {
      final failure = APIErrorHandler.handle(
        connectionError('http://192.168.1.16:8080/api/v1/auth/login', browserMessage),
      );

      expect(failure.errorType, ErrorType.corsBlocked);
      expect(failure.apiErrorModel.message, HttpMessages.corsBlocked);
    });

    test('cross-origin without a CORS hint is not blamed on CORS', () {
      final failure = APIErrorHandler.handle(
        connectionError(
          'http://192.168.1.16:8080/api/v1/auth/login',
          'The connection errored: The XMLHttpRequest onError callback was called.',
        ),
      );

      expect(failure.errorType, ErrorType.serverUnreachable);
    });

    test('same-origin with a CORS hint is not blamed on CORS', () {
      // The test page itself is served from this origin.
      final origin = Uri.base.origin;
      final failure = APIErrorHandler.handle(
        connectionError('$origin/api/v1/auth/login', browserMessage),
      );

      expect(failure.errorType, ErrorType.serverUnreachable);
    });

    test('a failed request never reports "no internet" while online', () {
      final failure = APIErrorHandler.handle(
        connectionError('http://192.168.1.16:8080/api/v1/auth/login', browserMessage),
      );

      expect(failure.errorType, isNot(ErrorType.offline));
      expect(failure.apiErrorModel.message, isNot(HttpMessages.noInternet));
    });
  });

  group('badResponse', () {
    DioException response(int statusCode, Object? data) => DioException(
      requestOptions: options('$Uri.base/api/v1/auth/login'),
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: options('$Uri.base/api/v1/auth/login'),
        statusCode: statusCode,
        data: data,
      ),
    );

    test('placeholder backend message falls back to the HTTP status message', () {
      final failure = APIErrorHandler.handle(
        response(401, {'message': 'An unexpected error occurred.'}),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, HttpMessages.unauthorized);
    });

    test('meaningful backend message is preserved without an errors array', () {
      final failure = APIErrorHandler.handle(
        response(401, {'message': 'Invalid credentials'}),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, 'Invalid credentials');
      expect(failure.apiErrorModel.errors, isEmpty);
    });

    test('meaningful backend message and field errors are both preserved', () {
      final failure = APIErrorHandler.handle(
        response(422, {
          'message': 'Validation failed',
          'errors': ['email is required', 'password is too short'],
        }),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, 'Validation failed');
      expect(failure.apiErrorModel.errors, hasLength(2));
    });

    test('field errors survive when the message is a placeholder', () {
      final failure = APIErrorHandler.handle(
        response(422, {
          'message': 'An unexpected error occurred.',
          'errors': ['email is required'],
        }),
      );

      expect(failure.apiErrorModel.message, HttpMessages.unprocessableEntity);
      expect(failure.apiErrorModel.errors, ['email is required']);
    });

    test('empty body falls back to the HTTP status message', () {
      final failure = APIErrorHandler.handle(response(503, null));

      expect(failure.errorType, ErrorType.serverError);
      expect(failure.apiErrorModel.message, HttpMessages.serviceUnavailable);
    });

    test('gateway HTML body is never surfaced', () {
      final failure = APIErrorHandler.handle(
        response(502, '<html><body>Bad gateway</body></html>'),
      );

      expect(failure.apiErrorModel.message, HttpMessages.badGateway);
    });
  });
}
