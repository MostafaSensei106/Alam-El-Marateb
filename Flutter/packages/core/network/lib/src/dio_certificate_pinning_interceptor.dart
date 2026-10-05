import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

import '../constants/security_configs.dart';

/// Certificate pinning interceptor.
///
/// Returns an instance of [CertificatePinningInterceptor] configured with the
/// allowed SHA fingerprints for the application.
Interceptor createCertificatePinningInterceptor() {
  return CertificatePinningInterceptor(
    allowedSHAFingerprints: SecurityConfigs.allowedSHAFingerprints,
  );
}
