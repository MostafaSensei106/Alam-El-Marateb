import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Logging interceptor factory.
///
/// Debug: full `PrettyDioLogger` (headers + bodies), same as Hadidi-Win.
/// Release: silent (no console leaks), unless [forceInRelease] is set.
Interceptor createLoggingInterceptor({bool forceInRelease = false}) {
  if (!kDebugMode && !forceInRelease) {
    return InterceptorsWrapper();
  }
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
  );
}
