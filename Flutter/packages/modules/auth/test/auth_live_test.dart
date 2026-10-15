import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_auth/alam_el_marateb_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Live contract test — needs the local backend on :8080 with the seeded
/// admin (phone 01000000000 / admin123). Skipped in CI by default.
void main() {
  group('live backend contract', () {
    late Dio dio;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/v1'));
      dio.interceptors.add(
        const DioClientKeyInterceptor(
          clientName: 'customer-app',
          clientKey: 'dev-local-key',
        ),
      );
    });

    test('login → TokenPair → /me with SUPER_ADMIN role', () async {
      final api = AuthApiService(dio);
      final rawLogin = await api.login({
        'phone': '01000000000',
        'password': 'admin123',
      });
      final pair = TokenPair.fromJson(
        Map<String, dynamic>.from(rawLogin as Map),
      );
      expect(pair.isComplete, isTrue);
      expect(pair.userId, isNotEmpty);

      dio.options.headers['Authorization'] = 'Bearer ${pair.accessToken}';
      final rawMe = await api.me();
      final user = UserModel.fromJson(Map<String, dynamic>.from(rawMe as Map));
      expect(user.fullName, isNotEmpty);
      expect(user.roles, contains(AppRoles.superAdmin));
    });

    test('wrong password surfaces backend message', () async {
      final api = AuthApiService(dio);
      try {
        await api.login({'phone': '01000000000', 'password': 'nope'});
        fail('expected DioException');
      } on DioException catch (e) {
        final failure = APIErrorHandler.handle(e);
        expect(failure, isA<ApiFailure>());
        expect(failure.message, isNotEmpty);
        expect(failure.message, isNot('INVALID_CREDENTIALS'));
      }
    });
  }, skip: 'needs local backend on :8080 (run manually)');
}
