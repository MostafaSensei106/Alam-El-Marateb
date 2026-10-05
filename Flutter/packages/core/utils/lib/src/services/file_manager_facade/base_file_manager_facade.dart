import 'package:flutter/material.dart';

abstract interface class BaseFileManagerFacade {
  /// Downloads and saves a file (image or document) to the appropriate folder
  /// based on the platform and type. Displays localized toasts and dialogs,
  /// and automatically opens the file.
  Future<void> downloadAndSaveFile({
    required BuildContext context,
    required String url,
    required String orderId,
    required bool isImage,
  });
}
