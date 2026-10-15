import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

/// Creates a certificate-pinning interceptor from an explicit pin list.
///
/// Decoupled by design: the caller passes [shaFingerprints] (usually from
/// `SecurityConfigs.allowedSHAFingerprints`) and an optional [onEnabled]
/// audit hook — so this package never depends on app security services.
/// The audit hook receives only the pin COUNT, never the pins themselves.
///
/// Keep a backup pin populated BEFORE enabling pinning in production:
/// outdated pins break connections when certificates rotate.
Interceptor createCertificatePinningInterceptor({
  required List<String> shaFingerprints,
  void Function(int pinCount)? onEnabled,
}) {
  onEnabled?.call(shaFingerprints.length);
  return CertificatePinningInterceptor(
    allowedSHAFingerprints: shaFingerprints,
  );
}
