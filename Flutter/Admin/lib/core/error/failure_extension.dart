import 'package:flutter/widgets.dart';

import '../extensions/extensions.dart';
import '../networking/error_type.dart';
import 'failures.dart';

extension FailureLocalizer on Failures {
  String getLocalizedMessage(BuildContext context) {
    final l = context.localeKeys;

    return switch (this) {
      ApiFailure(errorType: final type, apiErrorModel: final model) =>
        switch (type) {
          ErrorType.offline => l.httpNoInternet,
          ErrorType.network => l.httpConnectionFailed,
          ErrorType.timeout => l.httpGatewayTimeout,
          ErrorType.cancelled => l.httpRequestCancelled,
          ErrorType.certificate => l.httpBadCertificate,
          ErrorType.serverError => l.httpInternalServerError,
          // For client errors (e.g. 400, 422), we prefer the backend custom message.
          ErrorType.clientError => model.message,
          ErrorType.serialization => l.httpUnknownError,
          ErrorType.unknown => l.httpUnknownError,
          ErrorType.dnsFailure => l.httpDnsFailure,
          ErrorType.connectionRefused => l.httpConnectionRefused,
          ErrorType.serverUnreachable => l.httpServerUnreachable,
          ErrorType.corsBlocked => l.httpCorsBlocked,
          ErrorType.mixedContentBlocked => l.httpMixedContentBlocked,
          ErrorType.connectionTimeout => l.httpConnectionTimeout,
          ErrorType.receiveTimeout => l.httpReceiveTimeout,
          ErrorType.sendTimeout => l.httpSendTimeout,
        },
      ServerFailure() => l.httpInternalServerError,
      CacheFailure() => 'Cache Error', // Or add l.cacheError
      CooldownFailure(message: final msg) => msg,
      NetworkFailure() => l.httpConnectionFailed,
      UnknownFailure(message: final msg) => msg,
      TimeoutFailure() => l.httpGatewayTimeout,
      OfflineFailure() => l.httpNoInternet,
      LocalStorageFailure(message: final msg) => msg,
    };
  }
}
