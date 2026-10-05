import 'package:auth/auth.dart';
import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

class _FakeApi implements AuthApi {
  _FakeApi({this.pair, this.failure});

  final TokenPair? pair;
  final DioException? failure;

  @override
  Future<ApiResponse<TokenPair>> login(LoginRequestBody body) async => _token();

  @override
  Future<ApiResponse<TokenPair>> register(RegisterRequestBody body) async =>
      _token();

  @override
  Future<ApiResponse<TokenPair>> refresh(RefreshRequestBody body) async =>
      _token();

  @override
  @override
  Future<ApiResponse<AuthUser>> me() async {
    if (failure != null) {
      throw failure!;
    }
    return const ApiResponse<AuthUser>(
      success: true,
      message: 'ok',
      data: AuthUser(id: 'u-1', fullName: 'T', phoneNumber: '010'),
    );
  }

  Future<ApiResponse<TokenPair>> _token() async {
    if (failure != null) {
      throw failure!;
    }
    return ApiResponse<TokenPair>(success: true, message: 'ok', data: pair);
  }
}

void main() {
  group('Auth models', () {
    test('TokenPair requires all fields', () {
      final pair = TokenPair.fromJson(<String, dynamic>{
        'accessToken': 'a',
        'refreshToken': 'r',
        'userId': 'u-1',
      });
      expect(pair.accessToken, 'a');
      expect(pair.userId, 'u-1');
    });

    test('AuthUser id is non-nullable by design', () {
      final user = AuthUser.fromJson(<String, dynamic>{
        'id': 'u-1',
        'fullName': 'Staff',
        'phoneNumber': '01000000001',
        'roles': ['ROLE_BRANCH_MANAGER'],
      });
      expect(user.id, 'u-1');
      expect(user.hasRole('ROLE_BRANCH_MANAGER'), isTrue);
      expect(user.isSuperAdmin, isFalse);
      expect(
        () => AuthUser.fromJson(<String, dynamic>{
          'fullName': 'No Id',
          'phoneNumber': '01000000002',
        }),
        throwsA(anything),
      );
    });
  });

  group('AuthRepository', () {
    test('login persists tokens', () async {
      final storage = InMemoryTokenStorage();
      const pair = TokenPair(
        accessToken: 'a',
        refreshToken: 'r',
        userId: 'u-1',
      );
      final repo = AuthRepository(
        api: _FakeApi(pair: pair),
        storage: storage,
      );
      final result = await repo.login(phone: '010', password: 'pw');
      expect(result.userId, 'u-1');
      expect(await storage.getAccessToken(), 'a');
      expect(await storage.getRefreshToken(), 'r');
    });

    test('login maps backend failure', () async {
      final repo = AuthRepository(
        api: _FakeApi(
          failure: DioException(
            requestOptions: RequestOptions(path: '/auth/login'),
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(
              requestOptions: RequestOptions(path: '/auth/login'),
              statusCode: 401,
              data: <String, dynamic>{
                'success': false,
                'message': 'bad credentials',
                'errors': ['TOKEN_INVALID'],
              },
            ),
          ),
        ),
        storage: InMemoryTokenStorage(),
      );
      await expectLater(
        repo.login(phone: '010', password: 'wrong'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
