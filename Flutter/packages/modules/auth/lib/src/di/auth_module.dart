import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_router/router.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:auth/src/data/datasources/auth_api_service.dart';
import 'package:auth/src/data/repositories/auth_repository_impl.dart';
import 'package:auth/src/domain/repositories/auth_repository.dart';
import 'package:auth/src/domain/usecases/login_usecase.dart';
import 'package:auth/src/domain/usecases/logout_usecase.dart';
import 'package:auth/src/presentation/cubit/auth_cubit.dart';

/// Registers the auth graph into the shared [getIt].
///
/// Called by each app AFTER [configureCoreDependencies]. The [dio] instance
/// is the app's configured client (interceptors included). Auth changes
/// broadcast on the shared [AppAuthNotifier] so every app router's redirect
/// guard reacts — tests inject their own [onAuthChanged].
Future<void> registerAuthModule({
  required Dio dio,
  Future<void> Function(bool isAuthenticated)? onAuthChanged,
}) async {
  Future<void> notify(bool value) async {
    AppAuthNotifier.instance.notifyAuthChanged(value);
  }

  getIt
    ..registerLazySingleton<AuthApiService>(
      () => AuthApiService(dio, baseUrl: ApiRoutes.baseUrl),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt(), getIt(), onAuthChanged ?? notify),
    )
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()))
    ..registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()))
    ..registerFactory<AuthCubit>(() => AuthCubit(getIt(), getIt()));
}

/// Builds the app's shared [Dio] client with the standard interceptor stack:
///
/// locale → token → retry. The 401 handler clears the local session and
/// broadcasts auth=false (the app router lands on /login); pass a custom
/// [onUnauthorized] to also show a session-expired dialog.
///
/// Idempotent per process — repeated calls (hot restart) reuse the client
/// without stacking duplicate interceptors.
Future<Dio> buildAuthenticatedDio({
  UnauthorizedHandler? onUnauthorized,
}) async {
  final dio = await DioFactory.getDio();
  final hasStack = dio.interceptors.any((i) => i is DioTokenInterceptor);
  if (!hasStack) {
    dio.interceptors.addAll([
      DioLocaleInterceptor(
        () => getIt<LocalizationCubit>().state.langCode,
      ),
      DioTokenInterceptor(
        getToken: () => getIt<UserSessionServiceBase>().getToken(),
        loginPath: '/auth/login',
        onUnauthorized:
            onUnauthorized ??
            (_) async {
              await getIt<UserSessionServiceBase>().clearUserSession();
              AppAuthNotifier.instance.notifyAuthChanged(false);
            },
      ),
      DioRetryInterceptor(dio: dio),
    ]);
  }
  return dio;
}

/// Primes [AppAuthNotifier] from the persisted session BEFORE the router
/// builds, so the first redirect lands on the right route with no flicker.
Future<void> primeAuthState() async {
  final authenticated = await getIt<AuthRepository>().isAuthenticated();
  AppAuthNotifier.instance.notifyAuthChanged(authenticated);
}
