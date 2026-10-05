import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:injectable/injectable.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_constants.dart';
import '../../extensions/extensions.dart';
import '../attachment_handler/base_attachment_handler_service.dart';
import 'base_file_manager_facade.dart';

@Injectable(as: BaseFileManagerFacade)
final class FileManagerFacade implements BaseFileManagerFacade {
  const FileManagerFacade(
    this._attachmentHandler, {
    this.onInfo,
    this.onError,
  });

  final BaseAttachmentHandlerService _attachmentHandler;

  /// UI feedback hooks (dialogs live in design_system — this package
  /// must not depend on widgets, so hosts inject the presentation).
  final Future<void> Function({
    required String title,
    required String body,
  })? onInfo;
  final Future<void> Function({
    required String title,
    required String error,
  })? onError;

  @override
  Future<void> downloadAndSaveFile({
    required BuildContext context,
    required String url,
    required String orderId,
    required bool isImage,
  }) async {
    final l10n = context.localeKeys;
    try {
      final fullUrl = _attachmentHandler.resolveFullUrl(url);
      final uri = Uri.parse(fullUrl);
      final rawFileName = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : (isImage
                ? FileConstants.fallbackImageName
                : FileConstants.fallbackFileName);
      final fileName = '${FileConstants.filePrefix}${orderId}_$rawFileName';

      // 1. Download to temporary/cache folder first
      final tempPath = await _attachmentHandler.downloadFile(
        url: url,
        fileName: rawFileName,
      );

      var finalPath = tempPath;

      // 2. Platform-specific saving
      if (isImage) {
        // Save images directly to Gallery on all platforms (Android & iOS)
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
        await Gal.putImage(tempPath, album: FileConstants.albumName);
        if (context.mounted) {
          await onInfo?.call(
            title: l10n.downloadFile,
            body: l10n.fileSavedToDcim(fileName),
          );
        }
        finalPath = tempPath;
      } else {
        // Document / other files saving
        late final Directory destDir;
        if (Platform.isAndroid) {
          // Scoped storage: writing to public directories no longer needs
          // READ/WRITE_EXTERNAL_STORAGE. Try the public Documents folder and
          // fall back to a user-accessible or app-specific directory.
          final tryDir = Directory(FileConstants.androidDocumentsPath);
          var success = false;
          try {
            if (!tryDir.existsSync()) {
              tryDir.createSync(recursive: true);
            }
            destDir = tryDir;
            success = true;
          } catch (_) {
            // Scoped storage permission fallback on newer Android SDKs (Android 11+)
          }
          if (!success) {
            final dirs = await getExternalStorageDirectories(
              type: StorageDirectory.downloads,
            );
            destDir = (dirs != null && dirs.isNotEmpty)
                ? dirs.first
                : await getApplicationDocumentsDirectory();
          }
        } else {
          // iOS and other platforms
          final appDir = await getApplicationDocumentsDirectory();
          destDir = Directory('${appDir.path}/${FileConstants.albumName}');
        }

        if (!destDir.existsSync()) {
          destDir.createSync(recursive: true);
        }

        final destFile = File('${destDir.path}/$fileName');
        if (!destFile.existsSync()) {
          await File(tempPath).copy(destFile.path);
          if (context.mounted) {
            await onInfo?.call(
              title: l10n.downloadFile,
              body: l10n.fileSavedToDocuments(fileName),
            );
          }
        } else {
          if (context.mounted) {
            await onInfo?.call(
              title: l10n.downloadFile,
              body: l10n.fileAlreadySaved,
            );
          }
        }
        finalPath = destFile.path;
      }

      // 3. Open the file automatically using external app
      await OpenFilex.open(finalPath);
    } catch (e) {
      if (context.mounted) {
        await onError?.call(title: l10n.error, error: '${l10n.error}: $e');
      }
    }
  }
}
