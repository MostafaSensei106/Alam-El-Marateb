import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

abstract interface class BaseShareService {
  Future<void> shareUrl({
    required String url,
    String? subject,
    Rect? sharePosition,
  });

  /// Shares [file] and returns `true` when the OS reports success.
  Future<bool> shareFile({
    required XFile file,
    String? text,
    String? subject,
    Rect? sharePosition,
  });

  Future<void> shareText({
    required String text,
    String? subject,
    Rect? sharePosition,
  });
}
