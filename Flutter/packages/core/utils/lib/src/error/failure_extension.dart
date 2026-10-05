import 'package:core_network/core_network.dart';
import 'package:flutter/widgets.dart';

import '../extensions/extensions.dart';

extension FailureLocalizer on Failures {
  String getLocalizedMessage(BuildContext context) {
    final l = context.localeKeys;

    return switch (this) {
      ApiFailure(errorType: final type, apiErrorModel: final model) =>
        switch (type) {
          ErrorType.offline => l.httpNoInternet,
          ErrorType.network => l.httpNoInternet,
          ErrorType.timeout => l.httpGatewayTimeout,
          ErrorType.cancelled => l.httpRequestCancelled,
          ErrorType.certificate => l.httpBadCertificate,
          ErrorType.unauthorized => l.httpUnauthorized,
          ErrorType.forbidden => l.httpForbidden,
          ErrorType.serverError => l.httpInternalServerError,
          // For client errors (e.g. 400, 422), we prefer the backend custom message.
          ErrorType.clientError => model.message,
          ErrorType.unknown => l.httpUnknownError,
        },
      AuthFailure(code: final code) => switch (code) {
        'TOKEN_EXPIRED' => l.sessionExpired,
        _ => l.httpUnauthorized,
      },
      ClientRejectedFailure(message: final msg) => msg,
      ServerFailure() => l.httpInternalServerError,
      CacheFailure() => 'Cache Error', // Or add l.cacheError
      CooldownFailure(message: final msg) => msg,
      NetworkFailure() => l.httpNoInternet,
      UnknownFailure(message: final msg) => msg,
      TimeoutFailure() => l.httpGatewayTimeout,
      OfflineFailure() => l.httpNoInternet,
      LocalStorageFailure(message: final msg) => msg,
    };
  }
}
