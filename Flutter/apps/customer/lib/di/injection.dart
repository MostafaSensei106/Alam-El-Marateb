import 'package:auth/auth.dart';
import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../features/cart/api/cart_api.dart';
import '../features/catalog/api/catalog_api.dart';
import '../features/portal/api/portal_api.dart';
import '../session/auth_state.dart';

/// Customer composition root: networking + auth + shop features.
Future<void> setupInjection() async {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<Dio>()) {
    return;
  }

  getIt.registerSingleton<NetworkConfig>(
    const NetworkConfig(
      baseUrl: AppConfig.baseUrl,
      clientId: AppConfig.clientId,
      clientKey: AppConfig.clientKey,
    ),
  );

  // TODO(core_storage): replace with secure persistent storage.
  final tokenStorage = InMemoryTokenStorage();
  getIt.registerSingleton<TokenStorage>(tokenStorage);

  final authState = AuthState(
    hasSession: () async =>
        (await tokenStorage.getAccessToken())?.isNotEmpty ?? false,
  );
  getIt.registerSingleton<AuthState>(authState);

  Dio newRefreshClient() => Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: <String, dynamic>{
        ApiHeaders.apiClient: AppConfig.clientId,
        ApiHeaders.apiKey: AppConfig.clientKey,
      },
    ),
  );

  late final Dio dio;
  dio = DioFactory.create(
    config: getIt<NetworkConfig>(),
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

  getIt.registerSingleton<CatalogApi>(CatalogApi(dio));
  getIt.registerSingleton<CartApi>(CartApi(dio));
  getIt.registerSingleton<PortalApi>(PortalApi(dio));
}
