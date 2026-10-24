import 'package:injectable/injectable.dart';

import '../security/audit/base_audit_logger.dart';
import '../security/audit/security_event.dart';
import '../url_launcher/base_url_launcher_services.dart';
import 'base_file_opener_service.dart';

/// Opens remote files in an external viewer via the OS.
///
/// The file itself is never fetched into app memory/disk here, so no
/// trusted-domain allowlist applies (the download-to-disk path in
/// `AttachmentHandler` keeps the strict SSRF guard). Only the host is
/// audited  never query params, which may carry signed-URL tokens.
@Injectable(as: BaseFileOpenerService)
final class UrlFileOpenerService implements BaseFileOpenerService {
  const UrlFileOpenerService(this._urlLauncher, this._audit);

  final BaseUrlLauncherServices _urlLauncher;
  final BaseAuditLogger _audit;

  @override
  Future<void> openFile({required String url}) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme) {
      throw ArgumentError('Invalid file URL.');
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      _audit.audit(ExternalUrlBlocked(uri.host, 'unsupported_scheme'));
      throw ArgumentError('Only HTTP/HTTPS file URLs are allowed.');
    }
    _audit.audit(RemoteFileOpened(uri.host));
    await _urlLauncher.launchWebsite(url: url);
  }
}
