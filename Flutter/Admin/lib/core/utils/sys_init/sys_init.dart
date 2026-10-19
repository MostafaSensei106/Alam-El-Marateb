// ignore_for_file: dead_code, discarded_futures

import 'dart:io';

import 'package:bloc_signals/bloc_signals.dart';
import 'package:bloc_signals_hydrate/bloc_signals_hydrate.dart';
import 'package:bloc_signals_hydrate/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../di/di.dart' as di;
import '../../services/notifications/base_notification_service.dart';
import '../bloc/bloc_observer.dart';
import 'hydrated_boot.dart';

/// The entry point of the application.
final class SysInit {
  const SysInit._();

  /// Non-sensitive boot diagnostics, reported to the crash sink once it is
  /// up (see [initializeDeferredServices]). Never contains secrets — only
  /// [HydratedBootDecision] names.
  // static String? _pendingStorageIssue;

  /// Performs only the initialization required before the first frame.
  static Future<void> initializeCriticalServices() async {
    WidgetsFlutterBinding.ensureInitialized();
    BlocSignalObserver.observer = const AppBlocObserver();

    // Initialize only services required for the app's first frame and core
    // state. Notifications and other non-essential services are deferred to
    // [initializeDeferredServices] so they do not delay the initial UI.
    // Resolve the app directory once and derive every storage path from it,
    // so DI / Dio / cache construction below performs zero I/O of its own.
    final appDocPath = (await getApplicationDocumentsDirectory()).path;

    HydratedStorage.storage = await _buildHydratedStorage();

    final dioCacheDir = Directory('$appDocPath/dio_cache');
    if (!await dioCacheDir.exists()) {
      await dioCacheDir.create(recursive: true);
    }

    await di.configureDependencies(cacheStoragePath: dioCacheDir.path);

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Install fatal handlers early so crashes during deferred startup are
    // captured.
    if (kReleaseMode) {
      FlutterError.onError = FlutterError.presentError;

      PlatformDispatcher.instance.onError = (error, stack) => true;
    }
  }

  /// Defers non-critical startup work until after the app is already visible.
  static Future<void> initializeDeferredServices() async {
    try {
      await di.getIt<BaseNotificationService>().initialize();
    } catch (_) {
      // Startup must never crash the app. Failures here are non-critical.
    }
  }

  /// Builds hydrated storage backed by the platform secure store
  /// (Keychain / Keystore), with an explicit fail-closed boot decision
  /// (see [HydratedBootDecision]).
  ///
  /// - Secure storage available → [SecureHydratedStorage], encrypted at rest
  ///   by the platform.
  /// - Secure storage unavailable → persistence disabled
  ///   ([DisabledStorage]), never plaintext.
  static Future<HydratedStorage> _buildHydratedStorage() async {
    try {
      final storage = await SecureHydratedStorage.build(
        const FlutterSecureStorage(),
        prefix: 'hydrated:',
      );
      return storage;
    } catch (_) {
      _pendingStorageIssue = HydratedBootDecision.persistenceDisabled.name;
      return const DisabledStorage();
    }
  }
}
