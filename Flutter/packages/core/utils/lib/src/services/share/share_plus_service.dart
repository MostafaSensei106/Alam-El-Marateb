import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

import 'base_share_service.dart';

@LazySingleton(as: BaseShareService)
final class SharePlusService implements BaseShareService {
  SharePlusService(this._sharePlus);
  // ignore: prefer_final_fields
  SharePlus _sharePlus = SharePlus.instance;

  @override
  Future<bool> shareFile({
    required XFile file,
    String? text,
    String? subject,
    Rect? sharePosition,
  }) async {
    try {
      final params = ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: sharePosition,
        files: [file],
      );
      final res = await _sharePlus.share(params);
      return res.status == ShareResultStatus.success;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> shareText({
    required String text,
    String? subject,
    Rect? sharePosition,
  }) async {
    try {
      final params = ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: sharePosition,
      );
      await _sharePlus.share(params);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> shareUrl({
    required String url,
    String? subject,
    Rect? sharePosition,
  }) async {
    try {
      final params = ShareParams(
        text: url,
        subject: subject,
        sharePositionOrigin: sharePosition,
      );
      await _sharePlus.share(params);
    } catch (e) {
      throw Exception(e);
    }
  }
}
