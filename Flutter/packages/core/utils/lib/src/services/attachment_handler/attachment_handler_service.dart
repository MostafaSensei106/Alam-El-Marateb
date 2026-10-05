import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/api_routes.dart';
import '../../constants/security_configs.dart';
import 'base_attachment_handler_service.dart';

/// Concrete implementation that uses [Dio] for downloading and
/// [path_provider] for locating the device's storage directory.
@Injectable(as: BaseAttachmentHandlerService)
final class AttachmentHandlerService implements BaseAttachmentHandlerService {
  const AttachmentHandlerService(this._dio);

  final Dio _dio;

  // ─────────────────────────────────────────────────────────────────────────
  //  URL resolution
  // ─────────────────────────────────────────────────────────────────────────

  @override
  String resolveFullUrl(String url) {
    if (url.startsWith('http')) return url;
    final baseUri = Uri.parse(ApiRoutes.apiBaseURL);
    final origin = '${baseUri.scheme}://${baseUri.host}';
    return '$origin$url';
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Download
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<String> downloadFile({
    required String url,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    final fullUrl = resolveFullUrl(url);
    _validateUrl(fullUrl);

    final sanitizedName = _sanitizeFileName(fileName);
    _validateFileExtension(sanitizedName);

    final dir = await _downloadDirectory();
    final savePath = '${dir.path}/$sanitizedName';

    // Skip download if file already exists with content.
    final existing = File(savePath);
    if (existing.existsSync() && existing.lengthSync() > 0) {
      return savePath;
    }

    await _dio.download(
      fullUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (total > SecurityConfigs.maxDownloadSizeBytes ||
            received > SecurityConfigs.maxDownloadSizeBytes) {
          throw ArgumentError(
            'File size exceeds the maximum limit of ${SecurityConfigs.maxDownloadSizeBytes} bytes.',
          );
        }
        if (total > 0) {
          onProgress?.call(received / total);
        }
      },
    );

    return savePath;
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Validates that the URL targets an allowed domain.
  void _validateUrl(String urlString) {
    final uri = Uri.tryParse(urlString);
    if (uri == null) {
      throw ArgumentError('Invalid URL format: $urlString');
    }
    if (uri.scheme != 'https' && uri.scheme != 'http') {
      throw ArgumentError('Only HTTP/HTTPS protocols are allowed.');
    }
    final host = uri.host;
    if (!SecurityConfigs.trustedDomains.contains(host)) {
      throw ArgumentError('Access to domain $host is blocked.');
    }
  }

  /// Sanitizes the filename to prevent directory traversal and remove unsafe characters.
  String _sanitizeFileName(String name) {
    // 1. Replace path separators with underscores
    var sanitized = name.replaceAll(RegExp(r'[/\\]'), '_');

    // 2. Prevent directory traversal
    while (sanitized.contains('..')) {
      sanitized = sanitized.replaceAll('..', '_');
    }

    // 3. Keep only safe characters: alphanumeric, dots, underscores, hyphens
    sanitized = sanitized.replaceAll(RegExp(r'[^a-zA-Z0-9._\-]'), '_');

    // 4. Ensure it doesn't start with a dot or hyphen to prevent hidden/special files
    if (sanitized.startsWith('.') || sanitized.startsWith('-')) {
      sanitized = 'file_$sanitized';
    }

    // 5. Truncate name length to avoid OS filename length limit issues (keep extension if possible)
    if (sanitized.length > 100) {
      final extIndex = sanitized.lastIndexOf('.');
      if (extIndex != -1 && sanitized.length - extIndex <= 10) {
        final ext = sanitized.substring(extIndex);
        sanitized = '${sanitized.substring(0, 100 - ext.length)}$ext';
      } else {
        sanitized = sanitized.substring(0, 100);
      }
    }

    return sanitized;
  }

  /// Validates that the file extension is allowed.
  void _validateFileExtension(String fileName) {
    final extIndex = fileName.lastIndexOf('.');
    if (extIndex == -1) return; // No extension is fine
    final ext = fileName.substring(extIndex + 1).toLowerCase();
    if (!SecurityConfigs.allowedFileExtensions.contains(ext)) {
      throw ArgumentError('File extension .$ext is not allowed.');
    }
  }

  /// Returns the best available user‑accessible download directory.
  Future<Directory> _downloadDirectory() async {
    // On Android, prefer the external downloads directory.
    if (Platform.isAndroid) {
      final dirs = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      if (dirs != null && dirs.isNotEmpty) return dirs.first;
    }
    // Fallback to the app's documents directory.
    return getApplicationDocumentsDirectory();
  }
}
