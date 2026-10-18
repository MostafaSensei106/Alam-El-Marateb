import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/validation_regex.dart';
import '../security/audit/base_audit_logger.dart';
import '../security/audit/security_event.dart';
import 'base_url_launcher_services.dart';

/// Hardened external-intent launcher.
///
/// Security boundaries:
/// - `http/https` only for websites; `mailto:` recipients strictly validated;
///   phone numbers normalized to E.164-ish digits before `tel:`.
/// - Length-bounded email subject/body to block intent-injection.
/// - Every launch emits a typed [SecurityEvent] (host only — never the full
///   URL, which may carry tokens in query params).
@LazySingleton(as: BaseUrlLauncherServices)
final class UrlLauncherService implements BaseUrlLauncherServices {
  UrlLauncherService(this._audit);

  final BaseAuditLogger _audit;

  @override
  Future<void> launchWebsite({required String url}) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw ArgumentError('Invalid URL format.');
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      _audit.audit(ExternalUrlBlocked(uri.host, 'unsupported_scheme'));
      throw ArgumentError(
        'Only http and https schemes are allowed for launching websites.',
      );
    }
    // NOTE: no trusted-domain allowlist — social/whatsapp links are
    // legitimately external. SSRF protection lives at the download boundary
    // (AttachmentHandler) which writes to disk.
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch website.');
    }
    _audit.audit(ExternalUrlLaunched(uri.host));
  }

  @override
  Future<void> launchEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final recipient = to.trim();
    if (!ValidationRegex.emailRegExp.hasMatch(recipient)) {
      throw ArgumentError('Invalid email address.');
    }
    final safeSubject = _truncate(subject.trim(), 200);
    final safeBody = _truncate(body.trim(), 2000);
    final query = [
      'subject=${Uri.encodeComponent(safeSubject)}',
      'body=${Uri.encodeComponent(safeBody)}',
    ].join('&');

    final uri = Uri(scheme: 'mailto', path: recipient, query: query);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch email client.');
    }
    _audit.audit(const EmailClientLaunched());
  }

  @override
  Future<void> callPhone(String phoneNumber) async {
    final sanitized = phoneNumber.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (!ValidationRegex.phoneRegExp.hasMatch(sanitized)) {
      throw ArgumentError('Invalid phone number.');
    }
    final uri = Uri(scheme: 'tel', path: sanitized);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch dialer.');
    }
    _audit.audit(const DialerLaunched());
  }

  String _truncate(String value, int max) =>
      value.length <= max ? value : value.substring(0, max);
}
