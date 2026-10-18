// ignore_for_file: dead_code, discarded_futures

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc_signals/bloc_signals.dart';
import 'package:bloc_signals_hydrate/bloc_signals_hydrate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/pref_keys.dart';
import '../../di/di.dart' as di;
import '../../services/notifications/base_notification_service.dart';
import '../bloc/bloc_observer.dart';
import 'hydrated_boot.dart';

/// The entry point of the application.
final class SysInit {
  const SysInit._();

  /// Non-sensitive boot diagnostics, reported to Crashlytics once Firebase
  /// is up (see [initializeDeferredServices]). Never contains secrets —
  /// only [HydratedBootDecision] names.
  static String? _pendingStorageIssue;

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

    HydratedBloc.storage = await _buildHydratedStorage(appDocPath);

    final dioCacheDir = Directory('$appDocPath/dio_cache');
    if (!await dioCacheDir.exists()) {
      await dioCacheDir.create(recursive: true);
    }

    await di.configureDependencies(cacheStoragePath: dioCacheDir.path);

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Install fatal handlers early so crashes during deferred startup are
    // captured. Firebase boots in [initializeDeferredServices], so each
    // handler forwards to Crashlytics only once it is actually available —
    // touching `FirebaseCrashlytics.instance` before `initializeApp`
    // throws instead of reporting.
    if (kReleaseMode) {
      FlutterError.onError = (FlutterErrorDetails errorDetails) {
        // if (Firebase.apps.isNotEmpty) {
        //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // } else {
        FlutterError.presentError(errorDetails);
        // }
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        // if (Firebase.apps.isNotEmpty) {
        //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // }
        return true;
      };
    }
  }

  /// Defers non-critical startup work until after the app is already visible.
  /// Firebase/Crashlytics and notifications are initialized here rather than
  /// as part of critical startup.
  static Future<void> initializeDeferredServices() async {
    try {
      // if (Firebase.apps.isEmpty) {
      //   await Firebase.initializeApp(
      //     options: DefaultFirebaseOptions.currentPlatform,
      //   );
      // }

      // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      //   kReleaseMode,
      // );

      // await FirebaseCrashlytics.instance.setCustomKey(
      //   'environment',
      //   kReleaseMode ? 'production' : 'development',
      // );

      // await FirebaseCrashlytics.instance.setCustomKey(
      //   'build_type',
      //   kReleaseMode ? 'release' : 'debug',
      // );

      // final storageIssue = _pendingStorageIssue;
      // _pendingStorageIssue = null;
      // if (storageIssue != null) {
      //   await FirebaseCrashlytics.instance.setCustomKey(
      //     'hydrated_boot',
      //     storageIssue,
      //   );
      // }

      await di.getIt<BaseNotificationService>().initialize();
    } catch (error, stackTrace) {
      // Startup must never crash the app, but a silent swallow hides real
      // init failures — report when Crashlytics is available.
      // if (kReleaseMode && Firebase.apps.isNotEmpty) {
      //   unawaited(
      //     FirebaseCrashlytics.instance.recordError(
      //       error,
      //       stackTrace,
      //       reason: 'Deferred startup initialization failed',
      //     ),
      //   );
      // }
    }
  }

  /// Loads (or generates) the AES key for HydratedBloc. The 32-byte key
  /// lives in secure storage (Keychain/Keystore).
  ///
  /// Returns a record of the cipher (null when secure storage is
  /// unavailable) and whether a *usable* key pre-existed this boot.
  /// `keyExisted == false` with box files on disk means the legacy
  /// plaintext install.
  static Future<({HydratedAesCipher? cipher, bool keyExisted})>
  _hydratedKey() async {
    try {
      const storage = FlutterSecureStorage();
      final stored = await storage.read(
        key: PrefKeys.hydratedStorageEncryptionKey,
      );
      if (stored != null) {
        final bytes = base64Decode(stored);
        if (bytes.length == 32) {
          return (cipher: HydratedAesCipher(bytes), keyExisted: true);
        }
      }
      final key = List<int>.generate(32, (_) => Random.secure().nextInt(256));
      await storage.write(
        key: PrefKeys.hydratedStorageEncryptionKey,
        value: base64Encode(key),
      );
      return (cipher: HydratedAesCipher(key), keyExisted: false);
    } catch (_) {
      return (cipher: null, keyExisted: false);
    }
  }

  /// Builds Hydrated storage with an explicit, fail-closed boot matrix
  /// (see [resolveHydratedBoot]).
  ///
  /// - No cipher → persistence disabled ([DisabledStorage]), never plaintext.
  /// - Legacy plaintext box → quarantined (renamed, recoverable), fresh
  ///   encrypted box built. Cached cubits re-fetch; the auth token lives in
  ///   secure storage and is unaffected.
  /// - Encrypted box unreadable with a pre-existing key → quarantined for
  ///   forensics and persistence disabled. Never deleted, never plaintext.
  static Future<Storage> _buildHydratedStorage(String appDocPath) async {
    final files = HydratedBoxFiles(Directory(appDocPath));
    final (:cipher, :keyExisted) = await _hydratedKey();
    final boxExists = files.boxExists;

    final plan = resolveHydratedBoot(
      cipherAvailable: cipher != null,
      keyExisted: keyExisted,
      boxExists: boxExists,
    );

    switch (plan) {
      case HydratedBootDecision.persistenceDisabled:
        _pendingStorageIssue = plan.name;
        return const DisabledStorage();
      case HydratedBootDecision.freshEncrypted:
        if (!boxExists) {
          return HydratedStorage.build(
            storageDirectory: HydratedStorageDirectory(appDocPath),
            encryptionCipher: cipher,
          );
        }
        // Key pre-existed and a box is present: the open itself decides.
        try {
          return await HydratedStorage.build(
            storageDirectory: HydratedStorageDirectory(appDocPath),
            encryptionCipher: cipher,
          );
        } catch (_) {
          await files.quarantine();
          _pendingStorageIssue = HydratedBootDecision.quarantineAndDisable.name;
          return const DisabledStorage();
        }
      case HydratedBootDecision.migrateLegacy:
        await files.quarantine();
        _pendingStorageIssue = plan.name;
        return HydratedStorage.build(
          storageDirectory: HydratedStorageDirectory(appDocPath),
          encryptionCipher: cipher,
        );
      case HydratedBootDecision.quarantineAndDisable:
        await files.quarantine();
        _pendingStorageIssue = plan.name;
        return const DisabledStorage();
    }
  }
}
