import 'dart:io';

import 'package:alam_el_marateb_admin/core/networking/api_error_handler.dart';
import 'package:alam_el_marateb_admin/core/networking/api_error_model/api_error_model.dart';
import 'package:alam_el_marateb_admin/core/networking/error_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Covers every failure branch the mapper can produce.
///
/// Transport classification is exercised through the pure
/// [ApiFailureMapper.classifyTransport] so web-only signals (offline, mixed
/// content, CORS) can be asserted on the Dart VM instead of only in a browser.
///
/// The message assertions are deliberately about the *raw* text: the mapper
/// classifies failures for internal decisions but never rewrites what the user
/// sees.
void main() {
  const loginUrl = 'http://192.168.1.16:8080/api/v1/auth/login';
  const pageOrigin = 'https://admin.example.com';

  RequestOptions options(String url) => RequestOptions(path: url);

  DioException dio(
    DioExceptionType type, {
    String url = loginUrl,
    Object? error,
    Response<dynamic>? response,
    String? message,
  }) => DioException(
    requestOptions: options(url),
    type: type,
    error: error,
    response: response,
    message: message,
  );

  Response<dynamic> response(
    int status,
    Object? data, {
    String url = loginUrl,
    String? statusMessage,
  }) => Response<dynamic>(
    requestOptions: options(url),
    statusCode: status,
    statusMessage: statusMessage,
    data: data,
  );

  DioException badResponse(
    int status,
    Object? data, {
    String? statusMessage,
  }) => dio(
    DioExceptionType.badResponse,
    response: response(status, data, statusMessage: statusMessage),
  );

  SocketException socket(String message, [int? code]) => SocketException(
    message,
    osError: code == null ? null : OSError('os error', code),
  );

  ({ApiErrorModel model, ErrorType type, int? status}) classify(
    Object? cause, {
    bool deviceOnline = true,
    bool pageSecure = false,
    String? origin,
    String? uri,
    String? message,
  }) {
    final result = ApiFailureMapper.classifyTransport(
      cause,
      deviceOnline: deviceOnline,
      pageSecure: pageSecure,
      pageOrigin: origin,
      uri: uri == null ? null : Uri.parse(uri),
      dioMessage: message,
    );
    return (model: result.$1, type: result.$2, status: result.$3);
  }

  group('offline', () {
    test(
      'is reported only when the platform proved there is no connection',
      () {
        final cause = socket('Failed host lookup', -2);
        final result = classify(
          cause,
          deviceOnline: false,
          uri: loginUrl,
        );

        expect(result.type, ErrorType.offline);
        // Even in a proven-offline state the raw exception is what is shown.
        expect(result.model.message, cause.toString());
      },
    );

    test('a failed request while online is never blamed on the user', () {
      final cause = socket('Connection refused', 111);
      final result = classify(cause, uri: loginUrl);

      expect(result.type, isNot(ErrorType.offline));
      expect(result.model.message, cause.toString());
    });
  });

  group('mixed content', () {
    test('an https page calling a plain http server is mixed content', () {
      final result = classify(
        null,
        pageSecure: true,
        uri: 'http://192.168.1.16:8080/api/v1/auth/login',
        message: 'Mixed Content: The page was loaded over HTTPS.',
      );

      expect(result.type, ErrorType.mixedContentBlocked);
      expect(
        result.model.message,
        'Mixed Content: The page was loaded over HTTPS.',
      );
    });

    test('an https page calling https is not mixed content', () {
      final result = classify(
        null,
        pageSecure: true,
        uri: 'https://192.168.1.16:8443/api/v1/auth/login',
      );

      expect(result.type, isNot(ErrorType.mixedContentBlocked));
    });

    test('an http page calling http is not mixed content', () {
      final result = classify(null, uri: loginUrl);

      expect(result.type, isNot(ErrorType.mixedContentBlocked));
    });

    for (final host in [
      'localhost',
      'app.localhost',
      '127.0.0.1',
      '[::1]',
      '0.0.0.0',
    ]) {
      test('http://$host is trustworthy and not mixed content', () {
        final result = classify(
          null,
          pageSecure: true,
          uri: 'http://$host:8080/api',
        );

        expect(result.type, isNot(ErrorType.mixedContentBlocked));
        expect(result.type, ErrorType.serverUnreachable);
      });
    }
  });

  group('CORS ambiguity on web', () {
    const corsMessage =
        'The connection errored: The XMLHttpRequest onError callback was '
        'called. If you are running the app on a browser, this may be due to '
        'CORS.';

    test('cross-origin failure with a CORS hint is flagged as ambiguous', () {
      final result = classify(
        null,
        origin: pageOrigin,
        uri: loginUrl,
        message: corsMessage,
      );

      expect(result.type, ErrorType.corsBlocked);
      expect(result.model.message, corsMessage);
    });

    test('the adapter "preflight" wording is also recognised', () {
      final result = classify(
        null,
        origin: pageOrigin,
        uri: loginUrl,
        message: 'The preflight request did not succeed.',
      );

      expect(result.type, ErrorType.corsBlocked);
    });

    test('cross-origin failure without a CORS hint is a server problem', () {
      const message = 'The connection errored: onError callback was called.';
      final result = classify(
        null,
        origin: pageOrigin,
        uri: loginUrl,
        message: message,
      );

      expect(result.type, ErrorType.serverUnreachable);
      expect(result.model.message, message);
    });

    test('same-origin failure is never blamed on CORS', () {
      final result = classify(
        null,
        origin: pageOrigin,
        uri: '$pageOrigin/api/v1/auth/login',
        message: corsMessage,
      );

      expect(result.type, ErrorType.serverUnreachable);
    });

    test('an explicit default port still counts as the same origin', () {
      final result = classify(
        null,
        origin: pageOrigin,
        uri: 'https://admin.example.com:443/api/v1/auth/login',
        message: corsMessage,
      );

      expect(result.type, ErrorType.serverUnreachable);
    });

    test('a different port is cross-origin', () {
      final result = classify(
        null,
        origin: pageOrigin,
        uri: 'https://admin.example.com:8443/api',
        message: corsMessage,
      );

      expect(result.type, ErrorType.corsBlocked);
    });

    test('a different scheme is cross-origin', () {
      final result = classify(
        null,
        origin: pageOrigin,
        uri: 'http://admin.example.com/api',
        message: corsMessage,
      );

      expect(result.type, ErrorType.corsBlocked);
    });

    test('native requests (no page origin) are never blamed on CORS', () {
      final result = classify(
        null,
        uri: 'https://api.example.com/api',
        message: corsMessage,
      );

      expect(result.type, ErrorType.serverUnreachable);
    });

    test('cross-origin failures never report "no internet"', () {
      final result = classify(
        null,
        origin: pageOrigin,
        uri: loginUrl,
        message: corsMessage,
      );

      expect(result.type, isNot(ErrorType.offline));
      expect(result.model.message, corsMessage);
    });
  });

  group('SocketException error codes', () {
    const dnsCodes = [-2, -5, 11001];
    const refusedCodes = [111, 61, 10061];
    const unreachableCodes = [113, 51, 10051, 101, 65, 110, 60, 10060];

    for (final code in dnsCodes) {
      test('code $code is a DNS failure', () {
        final cause = socket('Failed host lookup', code);
        final result = classify(cause);
        expect(result.type, ErrorType.dnsFailure);
        expect(result.model.message, cause.toString());
      });
    }

    for (final code in refusedCodes) {
      test('code $code is a refused connection', () {
        final cause = socket('Connection refused', code);
        final result = classify(cause);
        expect(result.type, ErrorType.connectionRefused);
        expect(result.model.message, cause.toString());
      });
    }

    for (final code in unreachableCodes) {
      test('code $code is an unreachable server', () {
        final cause = socket('Host unreachable', code);
        final result = classify(cause);
        expect(result.type, ErrorType.serverUnreachable);
        expect(result.model.message, cause.toString());
      });
    }

    const textCases = {
      'Failed host lookup: api.example.com': ErrorType.dnsFailure,
      'Name or service not known': ErrorType.dnsFailure,
      'nodename nor servname provided, or not known': ErrorType.dnsFailure,
      'Temporary failure in name resolution': ErrorType.dnsFailure,
      'No address associated with hostname': ErrorType.dnsFailure,
      'Connection timed out': ErrorType.connectionTimeout,
      'Connection refused': ErrorType.connectionRefused,
      'Network is unreachable': ErrorType.serverUnreachable,
      'Network is down': ErrorType.serverUnreachable,
    };

    textCases.forEach((message, expected) {
      test('"$message" maps to ${expected.name}', () {
        expect(classify(socket(message)).type, expected);
      });
    });

    test('an unclassified socket error stays generic', () {
      final cause = socket('Operation not permitted', 1);
      final result = classify(cause);

      expect(result.type, ErrorType.network);
      expect(result.model.message, cause.toString());
    });
  });

  group('TLS failures', () {
    test('HandshakeException is a certificate failure', () {
      const cause = HandshakeException('handshake failed');
      final result = classify(cause);
      expect(result.type, ErrorType.certificate);
      expect(result.model.message, cause.toString());
    });

    test('TlsException is a certificate failure', () {
      const cause = TlsException('tls failure');
      final result = classify(cause);
      expect(result.type, ErrorType.certificate);
      expect(result.model.message, cause.toString());
    });
  });

  group('DioException types', () {
    test('connectionTimeout', () {
      final error = dio(DioExceptionType.connectionTimeout);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.connectionTimeout);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('receiveTimeout', () {
      final error = dio(DioExceptionType.receiveTimeout);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.receiveTimeout);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('sendTimeout', () {
      final error = dio(DioExceptionType.sendTimeout);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.sendTimeout);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('transformTimeout', () {
      final error = dio(DioExceptionType.transformTimeout);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.timeout);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('cancel', () {
      final error = dio(DioExceptionType.cancel);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.cancelled);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('cancel keeps the status code when a response exists', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.cancel, response: response(499, null)),
      );
      expect(failure.errorType, ErrorType.cancelled);
      expect(failure.statusCode, 499);
    });

    test('badCertificate', () {
      final error = dio(DioExceptionType.badCertificate);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.certificate);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('connectionError with a native socket cause is classified', () {
      final cause = socket('Connection refused', 111);
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.connectionError, error: cause),
      );
      expect(failure.errorType, ErrorType.connectionRefused);
      expect(failure.apiErrorModel.message, cause.toString());
    });

    test('the connection error message is shown exactly as it occurred', () {
      const message =
          'The connection errored: No route to host This indicates an error '
          'which most likely cannot be solved by the library.';
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.connectionError, message: message),
      );

      expect(failure.errorType, ErrorType.serverUnreachable);
      expect(failure.apiErrorModel.message, message);
    });

    test('unknown with a socket cause is classified', () {
      final cause = socket('Failed host lookup', -2);
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.unknown, error: cause),
      );
      expect(failure.errorType, ErrorType.dnsFailure);
      expect(failure.apiErrorModel.message, cause.toString());
    });

    test('unknown with a response keeps the response classification', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.unknown, response: response(503, null)),
      );
      expect(failure.errorType, ErrorType.serverError);
      expect(failure.statusCode, 503);
      expect(failure.apiErrorModel.message, 'HTTP 503');
    });

    test('unknown with no cause and no response stays unknown', () {
      final error = dio(DioExceptionType.unknown);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.unknown);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('badResponse without a response falls back to unknown', () {
      final error = dio(DioExceptionType.badResponse);
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.unknown);
      expect(failure.apiErrorModel.message, error.toString());
    });
  });

  group('top-level exceptions', () {
    test('SocketException is classified without going through Dio', () {
      final cause = socket('Connection refused', 111);
      final failure = APIErrorHandler.handle(cause);
      expect(failure.errorType, ErrorType.connectionRefused);
      expect(failure.apiErrorModel.message, cause.toString());
    });

    test('HandshakeException is a certificate failure', () {
      const cause = HandshakeException('bad cert');
      final failure = APIErrorHandler.handle(cause);
      expect(failure.errorType, ErrorType.certificate);
      expect(failure.apiErrorModel.message, cause.toString());
    });

    test('TlsException is a certificate failure', () {
      const cause = TlsException('bad tls');
      final failure = APIErrorHandler.handle(cause);
      expect(failure.errorType, ErrorType.certificate);
      expect(failure.apiErrorModel.message, cause.toString());
    });

    test('FormatException is a serialization failure', () {
      const error = FormatException('bad json');
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.serialization);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('TypeError is a serialization failure', () {
      TypeError? captured;
      try {
        // A dynamic invocation bypasses the static type check.
        (<int>[] as dynamic).add('not an int');
      } on TypeError catch (error) {
        captured = error;
      }

      final failure = APIErrorHandler.handle(
        captured ?? StateError('TypeError was not thrown'),
      );

      expect(captured, isNotNull);
      expect(failure.errorType, ErrorType.serialization);
      expect(failure.apiErrorModel.message, captured.toString());
    });

    test('an unrecognised exception is unknown', () {
      final error = Exception('boom');
      final failure = APIErrorHandler.handle(error);
      expect(failure.errorType, ErrorType.unknown);
      expect(failure.apiErrorModel.message, error.toString());
    });

    test('the original error and stack trace are retained', () {
      final error = StateError('boom');
      final stack = StackTrace.current;
      final failure = APIErrorHandler.handle(error, stackTrace: stack);

      expect(failure.originalError, same(error));
      expect(failure.stackTrace, same(stack));
    });
  });

  group('HTTP responses', () {
    test('a meaningful backend message is preserved with its field errors', () {
      final failure = APIErrorHandler.handle(
        badResponse(400, {
          'message': 'Invalid credentials',
          'errors': ['email is required'],
        }),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.statusCode, 400);
      expect(failure.apiErrorModel.message, 'Invalid credentials');
      expect(failure.apiErrorModel.errors, ['email is required']);
    });

    test('field errors default to an empty list when absent', () {
      final failure = APIErrorHandler.handle(
        badResponse(401, {'message': 'Invalid credentials'}),
      );

      expect(failure.apiErrorModel.errors, isEmpty);
    });

    test('a backend message wins over the raw status line', () {
      final failure = APIErrorHandler.handle(
        badResponse(
          400,
          {'message': 'Invalid credentials'},
          statusMessage: 'Bad Request',
        ),
      );

      expect(failure.apiErrorModel.message, 'Invalid credentials');
    });

    test('a placeholder message falls back to the HTTP status code', () {
      final failure = APIErrorHandler.handle(
        badResponse(401, {'message': 'An unexpected error occurred.'}),
      );

      expect(failure.apiErrorModel.message, 'HTTP 401');
    });

    test('an empty message falls back to the HTTP status code', () {
      final failure = APIErrorHandler.handle(
        badResponse(401, {'message': '   '}),
      );

      expect(failure.apiErrorModel.message, 'HTTP 401');
    });

    test('a generic-looking backend message is preserved verbatim', () {
      const message = 'An unexpected error occurred. Please try again.';
      final failure = APIErrorHandler.handle(
        badResponse(403, {'message': message}),
      );

      expect(failure.apiErrorModel.message, message);
    });

    test('field errors survive a placeholder message', () {
      final failure = APIErrorHandler.handle(
        badResponse(422, {
          'message': 'An unexpected error occurred.',
          'errors': ['email is required'],
        }),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, 'HTTP 422');
      expect(failure.apiErrorModel.errors, ['email is required']);
    });

    test('a non-string message falls back instead of throwing', () {
      final failure = APIErrorHandler.handle(badResponse(400, {'message': 42}));

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, 'HTTP 400');
    });

    const statusCases = {
      400: ErrorType.clientError,
      401: ErrorType.clientError,
      403: ErrorType.clientError,
      404: ErrorType.clientError,
      409: ErrorType.clientError,
      429: ErrorType.clientError,
      500: ErrorType.serverError,
      501: ErrorType.serverError,
      502: ErrorType.serverError,
      503: ErrorType.serverError,
      504: ErrorType.serverError,
      499: ErrorType.clientError,
      599: ErrorType.serverError,
    };

    statusCases.forEach((status, expected) {
      test('HTTP $status maps to ${expected.name}', () {
        final failure = APIErrorHandler.handle(badResponse(status, null));

        expect(failure.errorType, expected);
        expect(failure.statusCode, status);
        expect(failure.apiErrorModel.message, 'HTTP $status');
      });
    });

    test('the raw server status line is shown when the body is empty', () {
      final failure = APIErrorHandler.handle(
        badResponse(503, null, statusMessage: 'Service Unavailable'),
      );

      expect(failure.errorType, ErrorType.serverError);
      expect(failure.apiErrorModel.message, 'Service Unavailable');
    });

    test('a short plain-text gateway message is preserved', () {
      final failure = APIErrorHandler.handle(
        badResponse(502, 'upstream connect error'),
      );

      expect(failure.errorType, ErrorType.serverError);
      expect(failure.apiErrorModel.message, 'upstream connect error');
    });

    test('a long plain-text body is replaced by the status line', () {
      final failure = APIErrorHandler.handle(badResponse(500, 'x' * 301));

      expect(failure.apiErrorModel.message, 'HTTP 500');
    });

    test('an HTML gateway body is never surfaced', () {
      final failure = APIErrorHandler.handle(
        badResponse(502, '<html><body>Bad gateway</body></html>'),
      );

      expect(failure.apiErrorModel.message, 'HTTP 502');
    });

    test('an unexpected JSON shape is replaced by the status line', () {
      final failure = APIErrorHandler.handle(badResponse(500, ['boom']));

      expect(failure.apiErrorModel.message, 'HTTP 500');
    });

    test('a response with no status code maps to unknown', () {
      final error = dio(
        DioExceptionType.badResponse,
        response: Response<dynamic>(requestOptions: options(loginUrl)),
      );
      final failure = APIErrorHandler.handle(error);

      expect(failure.errorType, ErrorType.unknown);
      expect(failure.apiErrorModel.message, error.toString());
    });
  });
}
