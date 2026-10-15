import 'package:alam_el_marateb_result/result.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_auth/alam_el_marateb_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApi implements AuthApiService {
  _FakeApi({required this.meJson});

  final Map<String, dynamic> meJson;

  @override
  Future<dynamic> login(Map<String, dynamic> body) async => {
    'data': {'accessToken': 'a', 'refreshToken': 'r', 'userId': 'u'},
  };

  @override
  Future<dynamic> me() async => meJson;

  @override
  Future<dynamic> refresh(Map<String, dynamic> body) async =>
      throw UnimplementedError();
}

class _MemorySession implements UserSessionServiceBase {
  String? token;
  String? refresh;
  bool cleared = false;

  @override
  Future<bool> clearUserSession() async {
    token = null;
    refresh = null;
    cleared = true;
    return true;
  }

  @override
  Future<String?> getRefreshToken() async => refresh;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<bool> isAuthenticated() async => token?.isNotEmpty ?? false;

  @override
  Future<bool> isRememberMeEnabled() async => true;

  @override
  Future<void> saveUserSession({
    required String token,
    required bool rememberMe,
    String? refreshToken,
  }) async {
    this.token = token;
    refresh = refreshToken;
  }
}

Map<String, dynamic> _me(List<String> roles) => {
  'data': {
    'id': 'u-1',
    'fullName': 'Test User',
    'phoneNumber': '01000000000',
    'roles': roles,
    'isActive': true,
  },
};

void main() {
  group('AuthRepositoryImpl role gate', () {
    test('rejects roles outside allowedRoles without persisting', () async {
      final session = _MemorySession();
      var notified = <bool>[];
      final repo = AuthRepositoryImpl(
        _FakeApi(meJson: _me(['ROLE_CUSTOMER'])),
        session,
        allowedRoles: AppRoles.staffApp,
        onAuthChanged: (v) async => notified.add(v),
      );

      final result = await repo.login(phone: '010', password: 'pw');
      expect(result.isFailure, isTrue);
      expect(session.token, isNull);
      expect(notified, isEmpty);
      expect(
        result.errorOrNull?.message,
        contains('not authorized for this app'),
      );
    });

    test('accepts intersecting roles and persists session', () async {
      final session = _MemorySession();
      var notified = <bool>[];
      final repo = AuthRepositoryImpl(
        _FakeApi(meJson: _me(['ROLE_BRANCH_MANAGER'])),
        session,
        allowedRoles: AppRoles.staffApp,
        onAuthChanged: (v) async => notified.add(v),
      );

      final result = await repo.login(phone: '010', password: 'pw');
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.roles, contains('ROLE_BRANCH_MANAGER'));
      expect(session.token, 'a');
      expect(session.refresh, 'r');
      expect(notified, [true]);
      expect(repo.currentUser?.name, 'Test User');
    });

    test('empty allowedRoles accepts any role', () async {
      final repo = AuthRepositoryImpl(
        _FakeApi(meJson: _me(['ROLE_ANYTHING'])),
        _MemorySession(),
      );
      final result = await repo.login(phone: '010', password: 'pw');
      expect(result.isSuccess, isTrue);
    });
  });
}
