import 'package:auth/auth.dart';
import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../session/auth_state.dart';

/// Composition root: shared networking + auth data layer.
///
/// Module rule: third-party/feature dependencies live in their own
/// package — the app only wires them together. Secure [TokenStorage]
/// replaces the in-memory one when core_storage lands (Slice 1).
Future<void> setupInjection() async {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<Dio>()) {
    return;
  }

  const networkConfig = NetworkConfig(
    baseUrl: AppConfig.baseUrl,
    clientId: AppConfig.clientId,
    clientKey: AppConfig.clientKey,
  );
  getIt.registerSingleton<NetworkConfig>(networkConfig);

  // TODO(core_storage): replace with secure persistent storage.
  final tokenStorage = InMemoryTokenStorage();
  getIt.registerSingleton<TokenStorage>(tokenStorage);

  final authState = AuthState(
    hasSession: () async =>
        (await tokenStorage.getAccessToken())?.isNotEmpty ?? false,
  );
  getIt.registerSingleton<AuthState>(authState);

  // Bare client for token rotation (no auth interceptor → no loops).
  Dio newRefreshClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        headers: <String, dynamic>{
          ApiHeaders.apiClient: AppConfig.clientId,
          ApiHeaders.apiKey: AppConfig.clientKey,
        },
      ),
    );
    return dio;
  }

  late final Dio dio;
  dio = DioFactory.create(
    config: networkConfig,
    tokenStorage: tokenStorage,
    onRefresh: (refreshToken) async {
      try {
        final res = await newRefreshClient().post<Map<String, dynamic>>(
          '/api/v1/auth/refresh',
          data: <String, dynamic>{'refreshToken': refreshToken},
          options: Options(
            extra: <String, dynamic>{
              AuthTokenInterceptor.authRequiredKey: false,
            },
          ),
        );
        final data = res.data?['data'];
        final pair = data is Map<String, dynamic>
            ? TokenPair.fromJson(data)
            : null;
        if (pair == null) {
          return null;
        }
        await tokenStorage.saveTokens(
          accessToken: pair.accessToken,
          refreshToken: pair.refreshToken,
        );
        return pair.accessToken;
      } catch (_) {
        return null;
      }
    },
    onSessionExpired: () async {
      authState.setLoggedIn(false);
    },
    networkInfo: ConnectivityNetworkInfo(),
    languageProvider: () => AppConfig.defaultLanguage,
  );
  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<AuthApi>(AuthApi(dio));
  getIt.registerSingleton<BaseAuthRepository>(
    AuthRepository(api: getIt<AuthApi>(), storage: tokenStorage),
  );
}
