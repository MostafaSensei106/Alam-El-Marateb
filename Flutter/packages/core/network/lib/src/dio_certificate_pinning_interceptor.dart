import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

import 'package:core_utils/core_utils.dart';

/// Certificate pinning interceptor.
///
/// Returns an instance of [CertificatePinningInterceptor] configured with the
/// allowed SHA fingerprints for the application.
Interceptor createCertificatePinningInterceptor() {
  return CertificatePinningInterceptor(
    allowedSHAFingerprints: SecurityConfigs.allowedSHAFingerprints,
  );
}
