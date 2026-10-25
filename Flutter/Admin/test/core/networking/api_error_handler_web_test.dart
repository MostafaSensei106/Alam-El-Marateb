@TestOn('browser')
library;

import 'package:alam_el_marateb_admin/core/networking/api_error_handler.dart';
import 'package:alam_el_marateb_admin/core/networking/error_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Browser-only assertions: the raw adapter text must reach the UI untouched,
/// and a failed request must never be blamed on the user's connection.
void main() {
  RequestOptions options(String url) => RequestOptions(path: url);

  DioException connectionError(String url, String message) => DioException(
    requestOptions: options(url),
    type: DioExceptionType.connectionError,
    message: message,
  );

  DioException badResponse(
    int statusCode,
    Object? data, {
    String? statusMessage,
  }) {
    final url = '$Uri.base/api/v1/auth/login';
    return DioException(
      requestOptions: options(url),
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: options(url),
        statusCode: statusCode,
        statusMessage: statusMessage,
        data: data,
      ),
    );
  }

  const loginUrl = 'http://192.168.1.16:8080/api/v1/auth/login';

  const browserMessage =
      'The connection errored: The XMLHttpRequest onError callback was called. '
      'This typically indicates an error on the network layer. '
      'If you are running the app on a browser, this may be due to CORS.';

  group('connectionError on web', () {
    test('cross-origin + CORS hint is classified as corsBlocked', () {
      final failure = APIErrorHandler.handle(
        connectionError(loginUrl, browserMessage),
      );

      expect(failure.errorType, ErrorType.corsBlocked);
      // The adapter's own wording is what the user sees.
      expect(failure.apiErrorModel.message, browserMessage);
    });

    test('cross-origin without a CORS hint is not blamed on CORS', () {
      const message =
          'The connection errored: The XMLHttpRequest onError callback was called.';
      final failure = APIErrorHandler.handle(
        connectionError(loginUrl, message),
      );

      expect(failure.errorType, ErrorType.serverUnreachable);
      expect(failure.apiErrorModel.message, message);
    });

    test('same-origin with a CORS hint is not blamed on CORS', () {
      // The test page itself is served from this origin.
      final origin = Uri.base.origin;
      final failure = APIErrorHandler.handle(
        connectionError('$origin/api/v1/auth/login', browserMessage),
      );

      expect(failure.errorType, ErrorType.serverUnreachable);
      expect(failure.apiErrorModel.message, browserMessage);
    });

    test('a failed request never reports "no internet" while online', () {
      final failure = APIErrorHandler.handle(
        connectionError(loginUrl, browserMessage),
      );

      expect(failure.errorType, isNot(ErrorType.offline));
      expect(failure.apiErrorModel.message, browserMessage);
    });
  });

  group('badResponse', () {
    test('placeholder backend message falls back to the HTTP status code', () {
      final failure = APIErrorHandler.handle(
        badResponse(401, {'message': 'An unexpected error occurred.'}),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, 'HTTP 401');
    });

    test('meaningful backend message is preserved without an errors array', () {
      final failure = APIErrorHandler.handle(
        badResponse(401, {'message': 'Invalid credentials'}),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, 'Invalid credentials');
      expect(failure.apiErrorModel.errors, isEmpty);
    });

    test('meaningful backend message and field errors are both preserved', () {
      final failure = APIErrorHandler.handle(
        badResponse(422, {
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
        badResponse(422, {
          'message': 'An unexpected error occurred.',
          'errors': ['email is required'],
        }),
      );

      expect(failure.apiErrorModel.message, 'HTTP 422');
      expect(failure.apiErrorModel.errors, ['email is required']);
    });

    test('empty body falls back to the raw status line', () {
      final failure = APIErrorHandler.handle(
        badResponse(503, null, statusMessage: 'Service Unavailable'),
      );

      expect(failure.errorType, ErrorType.serverError);
      expect(failure.apiErrorModel.message, 'Service Unavailable');
    });

    test('empty body with no status line falls back to the status code', () {
      final failure = APIErrorHandler.handle(badResponse(503, null));

      expect(failure.errorType, ErrorType.serverError);
      expect(failure.apiErrorModel.message, 'HTTP 503');
    });

    test('gateway HTML body is never surfaced', () {
      final failure = APIErrorHandler.handle(
        badResponse(502, '<html><body>Bad gateway</body></html>'),
      );

      expect(failure.apiErrorModel.message, 'HTTP 502');
    });
  });
}
