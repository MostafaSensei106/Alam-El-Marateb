import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

import '../constants/security_configs.dart';
import '../services/security/audit/base_audit_logger.dart';
import '../services/security/audit/security_event.dart';

/// Certificate pinning interceptor.
///
/// Uses primary + backup pins so cert rotation never bricks the app.
/// Keep [SecurityConfigs.backupSHAFingerprints] populated BEFORE enabling
/// [SecurityConfigs.enableCertificatePinning]. The audit event carries only
/// the pin count  never the pins themselves.
Interceptor createCertificatePinningInterceptor({BaseAuditLogger? audit}) {
  final pins = SecurityConfigs.allSHAFingerprints;
  audit?.audit(CertPinningEnabled(pins.length));
  return CertificatePinningInterceptor(allowedSHAFingerprints: pins);
}
