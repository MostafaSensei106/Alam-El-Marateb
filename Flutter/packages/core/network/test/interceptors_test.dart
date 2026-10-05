import 'dart:convert';

import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

/// In-memory HTTP stub: one scripted response per call, in order.
class _ScriptAdapter implements HttpClientAdapter {
  _ScriptAdapter(this._respond);

  final ResponseBody Function(RequestOptions options) _respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async => _respond(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Map<String, dynamic> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );

NetworkConfig _config() => const NetworkConfig(
  baseUrl: 'http://localhost:8080',
  clientId: 'postman',
  clientKey: 'postman-dev-key',
);

void main() {
  group('ClientKeyInterceptor', () {
    test('attaches client headers to every request', () async {
      late RequestOptions seen;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
      dio.interceptors.add(ClientKeyInterceptor(_config()));
      dio.httpClientAdapter = _ScriptAdapter((options) {
        seen = options;
        return _json(200, <String, dynamic>{'success': true, 'message': 'ok'});
      });
      await dio.get<dynamic>('/x');
      expect(seen.headers['X-Api-Client'], 'postman');
      expect(seen.headers['X-Api-Key'], 'postman-dev-key');
    });
  });

  group('LocaleInterceptor', () {
    test('sends X-Lang from provider', () async {
      late RequestOptions seen;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
      dio.interceptors.add(LocaleInterceptor(languageProvider: () => 'en'));
      final adapter = _ScriptAdapter((options) {
        seen = options;
        return _json(200, <String, dynamic>{'success': true, 'message': 'ok'});
      });
      dio.httpClientAdapter = adapter;
      await dio.get<dynamic>('/x');
      expect(seen.headers['X-Lang'], 'en');
    });
  });

  group('AuthTokenInterceptor', () {
    test('attaches bearer token', () async {
      final storage = InMemoryTokenStorage();
      await storage.saveTokens(accessToken: 'abc', refreshToken: 'ref');
      late RequestOptions seen;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
      dio.interceptors.add(
        AuthTokenInterceptor(
          storage: storage,
          onRefresh: (_) async => null,
          onSessionExpired: () async {},
          retryClient: () => dio,
        ),
      );
      final adapter = _ScriptAdapter((options) {
        seen = options;
        return _json(200, <String, dynamic>{'success': true, 'message': 'ok'});
      });
      dio.httpClientAdapter = adapter;
      await dio.get<dynamic>('/x');
      expect(seen.headers['Authorization'], 'Bearer abc');
    });

    test('skips auth when extra[authRequired] is false', () async {
      final storage = InMemoryTokenStorage();
      await storage.saveTokens(accessToken: 'abc', refreshToken: 'ref');
      late RequestOptions seen;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
      dio.interceptors.add(
        AuthTokenInterceptor(
          storage: storage,
          onRefresh: (_) async => null,
          onSessionExpired: () async {},
          retryClient: () => dio,
        ),
      );
      final adapter = _ScriptAdapter((options) {
        seen = options;
        return _json(200, <String, dynamic>{'success': true, 'message': 'ok'});
      });
      dio.httpClientAdapter = adapter;
      await dio.get<dynamic>(
        '/auth/login',
        options: Options(extra: <String, dynamic>{'authRequired': false}),
      );
      expect(seen.headers.containsKey('Authorization'), isFalse);
    });

    test('refreshes once on TOKEN_EXPIRED and retries', () async {
      final storage = InMemoryTokenStorage();
      await storage.saveTokens(accessToken: 'old', refreshToken: 'ref');
      var refreshCalls = 0;
      var expiredCalls = 0;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
      dio.interceptors.add(
        AuthTokenInterceptor(
          storage: storage,
          onRefresh: (_) async {
            refreshCalls++;
            await storage.saveTokens(accessToken: 'new', refreshToken: 'ref2');
            return 'new';
          },
          onSessionExpired: () async {
            expiredCalls++;
          },
          retryClient: () => dio,
        ),
      );
      var n = 0;
      dio.httpClientAdapter = _ScriptAdapter((_) {
        n++;
        if (n == 1) {
          return _json(401, <String, dynamic>{
            'success': false,
            'message': 'expired',
            'errors': ['TOKEN_EXPIRED'],
          });
        }
        return _json(200, <String, dynamic>{
          'success': true,
          'message': 'ok',
          'data': 'retried',
        });
      });
      final res = await dio.get<dynamic>('/protected');
      expect(res.statusCode, 200);
      expect(refreshCalls, 1);
      expect(expiredCalls, 0);
      expect(await storage.getAccessToken(), 'new');
    });

    test('clears session on TOKEN_INVALID', () async {
      final storage = InMemoryTokenStorage();
      await storage.saveTokens(accessToken: 'old', refreshToken: 'ref');
      var expiredCalls = 0;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
      dio.interceptors.add(
        AuthTokenInterceptor(
          storage: storage,
          onRefresh: (_) async => null,
          onSessionExpired: () async {
            expiredCalls++;
          },
          retryClient: () => dio,
        ),
      );
      dio.httpClientAdapter = _ScriptAdapter(
        (_) => _json(401, <String, dynamic>{
          'success': false,
          'message': 'invalid',
          'errors': ['TOKEN_INVALID'],
        }),
      );
      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );
      expect(await storage.getAccessToken(), isNull);
      expect(expiredCalls, 1);
    });
  });

  group('DioFactory', () {
    test('builds client with interceptors in order', () {
      final dio = DioFactory.create(
        config: _config(),
        tokenStorage: InMemoryTokenStorage(),
        onRefresh: (_) async => null,
        onSessionExpired: () async {},
        networkInfo: _FakeNetworkInfo(),
        languageProvider: () => 'ar',
      );
      expect(dio.options.baseUrl, 'http://localhost:8080');
      final kinds = dio.interceptors.map((i) => i.runtimeType).toList();
      final order = <Type>[
        ClientKeyInterceptor,
        LocaleInterceptor,
        AuthTokenInterceptor,
        ConnectivityRetryInterceptor,
      ];
      var cursor = -1;
      for (final type in order) {
        final next = kinds.indexWhere((k) => k == type, cursor + 1);
        expect(next, isNot(-1), reason: '$type missing in order');
        cursor = next;
      }
    });
  });
}

class _FakeNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}
