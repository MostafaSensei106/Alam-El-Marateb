import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

abstract interface class BaseShareService {
  Future<void> shareUrl({
    required String url,
    String? subject,
    Rect? sharePosition,
  });

  Future<void> shareFile({
    required XFile file,
    String? subject,
    Rect? sharePosition,
  });

  Future<void> shareText({
    required String text,
    String? subject,
    Rect? sharePosition,
  });
}
