import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_router/router.dart';
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
