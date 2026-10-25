import 'dart:io';

import 'package:alam_el_marateb_admin/core/constants/http_messages.dart';
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
  }) => Response<dynamic>(
    requestOptions: options(url),
    statusCode: status,
    data: data,
  );

  DioException badResponse(int status, Object? data) =>
      dio(DioExceptionType.badResponse, response: response(status, data));

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
        final result = classify(
          socket('Failed host lookup', -2),
          deviceOnline: false,
          uri: loginUrl,
        );

        expect(result.type, ErrorType.offline);
        expect(result.model.message, HttpMessages.noInternet);
      },
    );

    test('a failed request while online is never blamed on the user', () {
      final result = classify(socket('Connection refused', 111), uri: loginUrl);

      expect(result.type, isNot(ErrorType.offline));
      expect(result.model.message, isNot(HttpMessages.noInternet));
    });
  });

  group('mixed content', () {
    test('an https page calling a plain http server is mixed content', () {
      final result = classify(
        null,
        pageSecure: true,
        uri: 'http://192.168.1.16:8080/api/v1/auth/login',
      );

      expect(result.type, ErrorType.mixedContentBlocked);
      expect(result.model.message, HttpMessages.mixedContentBlocked);
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
      expect(result.model.message, HttpMessages.corsBlocked);
      // The message must name the server as a possible cause, not just the
      // browser: a server that is down produces the same browser error.
      expect(result.model.message, contains('server'));
      expect(result.model.message, contains('browser'));
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
      final result = classify(
        null,
        origin: pageOrigin,
        uri: loginUrl,
        message: 'The connection errored: onError callback was called.',
      );

      expect(result.type, ErrorType.serverUnreachable);
      expect(result.model.message, HttpMessages.serverUnreachable);
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
      expect(result.model.message, isNot(HttpMessages.noInternet));
    });
  });

  group('SocketException error codes', () {
    const dnsCodes = [-2, -5, 11001];
    const refusedCodes = [111, 61, 10061];
    const unreachableCodes = [113, 51, 10051, 101, 65, 110, 60, 10060];

    for (final code in dnsCodes) {
      test('code $code is a DNS failure', () {
        final result = classify(socket('Failed host lookup', code));
        expect(result.type, ErrorType.dnsFailure);
        expect(result.model.message, HttpMessages.dnsFailure);
      });
    }

    for (final code in refusedCodes) {
      test('code $code is a refused connection', () {
        final result = classify(socket('Connection refused', code));
        expect(result.type, ErrorType.connectionRefused);
        expect(result.model.message, HttpMessages.connectionRefused);
      });
    }

    for (final code in unreachableCodes) {
      test('code $code is an unreachable server', () {
        final result = classify(socket('Host unreachable', code));
        expect(result.type, ErrorType.serverUnreachable);
        expect(result.model.message, HttpMessages.serverUnreachable);
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
      final result = classify(socket('Operation not permitted', 1));

      expect(result.type, ErrorType.network);
      expect(result.model.message, HttpMessages.connectionFailed);
    });
  });

  group('TLS failures', () {
    test('HandshakeException is a certificate failure', () {
      final result = classify(const HandshakeException('handshake failed'));
      expect(result.type, ErrorType.certificate);
      expect(result.model.message, HttpMessages.badCertificate);
    });

    test('TlsException is a certificate failure', () {
      final result = classify(const TlsException('tls failure'));
      expect(result.type, ErrorType.certificate);
    });
  });

  group('DioException types', () {
    test('connectionTimeout', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.connectionTimeout),
      );
      expect(failure.errorType, ErrorType.connectionTimeout);
      expect(failure.apiErrorModel.message, HttpMessages.connectionTimeout);
    });

    test('receiveTimeout', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.receiveTimeout),
      );
      expect(failure.errorType, ErrorType.receiveTimeout);
      expect(failure.apiErrorModel.message, HttpMessages.receiveTimeout);
    });

    test('sendTimeout', () {
      final failure = APIErrorHandler.handle(dio(DioExceptionType.sendTimeout));
      expect(failure.errorType, ErrorType.sendTimeout);
      expect(failure.apiErrorModel.message, HttpMessages.sendTimeout);
    });

    test('transformTimeout', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.transformTimeout),
      );
      expect(failure.errorType, ErrorType.timeout);
      expect(failure.apiErrorModel.message, HttpMessages.gatewayTimeout);
    });

    test('cancel', () {
      final failure = APIErrorHandler.handle(dio(DioExceptionType.cancel));
      expect(failure.errorType, ErrorType.cancelled);
      expect(failure.apiErrorModel.message, HttpMessages.requestCancelled);
    });

    test('cancel keeps the status code when a response exists', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.cancel, response: response(499, null)),
      );
      expect(failure.errorType, ErrorType.cancelled);
      expect(failure.statusCode, 499);
    });

    test('badCertificate', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.badCertificate),
      );
      expect(failure.errorType, ErrorType.certificate);
      expect(failure.apiErrorModel.message, HttpMessages.badCertificate);
    });

    test('connectionError with a native socket cause is classified', () {
      final failure = APIErrorHandler.handle(
        dio(
          DioExceptionType.connectionError,
          error: socket('Connection refused', 111),
        ),
      );
      expect(failure.errorType, ErrorType.connectionRefused);
    });

    test('unknown with a socket cause is classified', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.unknown, error: socket('Failed host lookup', -2)),
      );
      expect(failure.errorType, ErrorType.dnsFailure);
    });

    test('unknown with a response keeps the response classification', () {
      final failure = APIErrorHandler.handle(
        dio(DioExceptionType.unknown, response: response(503, null)),
      );
      expect(failure.errorType, ErrorType.serverError);
      expect(failure.statusCode, 503);
    });

    test('unknown with no cause and no response stays unknown', () {
      final failure = APIErrorHandler.handle(dio(DioExceptionType.unknown));
      expect(failure.errorType, ErrorType.unknown);
      expect(failure.apiErrorModel.message, HttpMessages.unknownError);
    });

    test('badResponse without a response falls back to unknown', () {
      final failure = APIErrorHandler.handle(dio(DioExceptionType.badResponse));
      expect(failure.errorType, ErrorType.unknown);
    });
  });

  group('top-level exceptions', () {
    test('SocketException is classified without going through Dio', () {
      final failure = APIErrorHandler.handle(socket('Connection refused', 111));
      expect(failure.errorType, ErrorType.connectionRefused);
    });

    test('HandshakeException is a certificate failure', () {
      final failure = APIErrorHandler.handle(
        const HandshakeException('bad cert'),
      );
      expect(failure.errorType, ErrorType.certificate);
    });

    test('TlsException is a certificate failure', () {
      final failure = APIErrorHandler.handle(const TlsException('bad tls'));
      expect(failure.errorType, ErrorType.certificate);
    });

    test('FormatException is a serialization failure', () {
      final failure = APIErrorHandler.handle(const FormatException('bad json'));
      expect(failure.errorType, ErrorType.serialization);
      expect(failure.apiErrorModel.message, HttpMessages.serializationError);
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
    });

    test('an unrecognised exception is unknown', () {
      final failure = APIErrorHandler.handle(Exception('boom'));
      expect(failure.errorType, ErrorType.unknown);
      expect(failure.apiErrorModel.message, HttpMessages.unknownError);
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

    test('a placeholder message is replaced by the HTTP status message', () {
      final failure = APIErrorHandler.handle(
        badResponse(401, {'message': 'An unexpected error occurred.'}),
      );

      expect(failure.apiErrorModel.message, HttpMessages.unauthorized);
    });

    test('an empty message is replaced by the HTTP status message', () {
      final failure = APIErrorHandler.handle(
        badResponse(401, {'message': '   '}),
      );

      expect(failure.apiErrorModel.message, HttpMessages.unauthorized);
    });

    test('the generic unknown message is treated as a placeholder', () {
      final failure = APIErrorHandler.handle(
        badResponse(403, {'message': HttpMessages.unknownError}),
      );

      expect(failure.apiErrorModel.message, HttpMessages.forbidden);
    });

    test('field errors survive a placeholder message', () {
      final failure = APIErrorHandler.handle(
        badResponse(422, {
          'message': 'An unexpected error occurred.',
          'errors': ['email is required'],
        }),
      );

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, HttpMessages.unprocessableEntity);
      expect(failure.apiErrorModel.errors, ['email is required']);
    });

    test('a non-string message falls back instead of throwing', () {
      final failure = APIErrorHandler.handle(badResponse(400, {'message': 42}));

      expect(failure.errorType, ErrorType.clientError);
      expect(failure.apiErrorModel.message, HttpMessages.badRequest);
    });

    const statusCases = {
      400: (ErrorType.clientError, HttpMessages.badRequest),
      401: (ErrorType.clientError, HttpMessages.unauthorized),
      403: (ErrorType.clientError, HttpMessages.forbidden),
      404: (ErrorType.clientError, HttpMessages.notFound),
      409: (ErrorType.clientError, HttpMessages.conflict),
      429: (ErrorType.clientError, HttpMessages.tooManyRequests),
      500: (ErrorType.serverError, HttpMessages.internalServerError),
      501: (ErrorType.serverError, HttpMessages.notImplemented),
      502: (ErrorType.serverError, HttpMessages.badGateway),
      503: (ErrorType.serverError, HttpMessages.serviceUnavailable),
      504: (ErrorType.serverError, HttpMessages.gatewayTimeout),
      499: (ErrorType.clientError, HttpMessages.badRequest),
      599: (ErrorType.serverError, HttpMessages.internalServerError),
    };

    statusCases.forEach((status, expected) {
      test('HTTP $status maps to ${expected.$1.name}', () {
        final failure = APIErrorHandler.handle(badResponse(status, null));

        expect(failure.errorType, expected.$1);
        expect(failure.statusCode, status);
        expect(failure.apiErrorModel.message, expected.$2);
      });
    });

    test('a short plain-text gateway message is preserved', () {
      final failure = APIErrorHandler.handle(
        badResponse(502, 'upstream connect error'),
      );

      expect(failure.errorType, ErrorType.serverError);
      expect(failure.apiErrorModel.message, 'upstream connect error');
    });

    test('a long plain-text body is replaced by the status message', () {
      final failure = APIErrorHandler.handle(badResponse(500, 'x' * 301));

      expect(failure.apiErrorModel.message, HttpMessages.internalServerError);
    });

    test('an HTML gateway body is never surfaced', () {
      final failure = APIErrorHandler.handle(
        badResponse(502, '<html><body>Bad gateway</body></html>'),
      );

      expect(failure.apiErrorModel.message, HttpMessages.badGateway);
    });

    test('an unexpected JSON shape is replaced by the status message', () {
      final failure = APIErrorHandler.handle(badResponse(500, ['boom']));

      expect(failure.apiErrorModel.message, HttpMessages.internalServerError);
    });

    test('a response with no status code maps to unknown', () {
      final failure = APIErrorHandler.handle(
        dio(
          DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: options(loginUrl)),
        ),
      );

      expect(failure.errorType, ErrorType.unknown);
      expect(failure.apiErrorModel.message, HttpMessages.unknownError);
    });
  });
}
