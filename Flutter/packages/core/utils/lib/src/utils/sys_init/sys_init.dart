// ignore_for_file: dead_code, discarded_futures

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../firebase_options.dart';
import '../../di/di.dart' as di;
import '../../services/notifications/base_notification_service.dart';
import '../bloc/bloc_observer.dart';

/// The entry point of the application.
final class SysInit {
  const SysInit._();

  /// Performs only the initialization required before the first frame.
  static Future<void> initializeCriticalServices() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = const AppBlocObserver();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path,
      ),
    );

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await di.configureDependencies();
  }

  /// Defers non-critical startup work until after the app is already visible.
  static Future<void> initializeDeferredServices() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );

      await FirebaseCrashlytics.instance.setCustomKey(
        'environment',
        kReleaseMode ? 'production' : 'development',
      );

      await FirebaseCrashlytics.instance.setCustomKey(
        'build_type',
        kReleaseMode ? 'release' : 'debug',
      );

      await di.getIt<BaseNotificationService>().initialize();

      if (kReleaseMode) {
        FlutterError.onError = (FlutterErrorDetails errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }
    } catch (_) {
      // Ignore deferred startup failures to avoid blocking app launch.
    }
  }
}
