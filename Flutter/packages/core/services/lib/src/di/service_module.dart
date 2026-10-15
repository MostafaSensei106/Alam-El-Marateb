import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Third-party instances the services graph needs.
///
/// Anything here is a *static* value (no per-app parameters). Services that
/// need runtime values are registered manually instead:
/// - [AttachmentHandlerService] needs the app's `Dio` → see
///   `registerAttachmentService()`.
/// - [FirebaseNotificationService] / [LocalNotificationService] take
///   optional callbacks → registered in `configureCoreDependencies()`.
/// Firebase itself (`Firebase.initializeApp`) stays app-owned and must run
/// before first use — these registrations are lazy, so boot order is safe.
@module
abstract class ServiceModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  SharePlus get sharePlus => SharePlus.instance;

  @lazySingleton
  FirebaseMessaging get messaging => FirebaseMessaging.instance;
}
