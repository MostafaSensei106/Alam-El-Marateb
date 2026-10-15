import 'package:alam_el_marateb_result/result.dart';
import 'package:alam_el_marateb_auth/alam_el_marateb_auth.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.loginResult, this.authenticated = false});

  final Result<User, Failure>? loginResult;
  bool authenticated;
  int logoutCalls = 0;
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<Result<User, Failure>> login({
    required String phone,
    required String password,
  }) async {
    final result =
        loginResult ?? const Result.failure(error: UnknownFailure('unstubbed'));
    if (result is Success<User, Failure>) {
      authenticated = true;
      _currentUser = result.data;
    }
    return result;
  }

  @override
  Future<Result<void, Failure>> logout() async {
    logoutCalls++;
    authenticated = false;
    _currentUser = null;
    return const Result.success(data: null);
  }

  @override
  Future<Result<void, Failure>> refreshSession() async {
    return const Result.success(data: null);
  }

  @override
  Future<Result<User, Failure>> getCurrentUser() async {
    final user = _currentUser;
    if (user == null) {
      return const Result.failure(error: UnknownFailure('no user'));
    }
    return Result.success(data: user);
  }

  @override
  Future<bool> isAuthenticated() async => authenticated;
}

const _user = User(
  id: '1',
  name: 'Ahmed',
  phone: '01012345678',
  roles: ['ROLE_CUSTOMER'],
);

void main() {
  group('AuthCubit', () {
    test('full sign-in flow', () async {
      final repo = _FakeAuthRepository(
        loginResult: const Result.success(data: _user),
      );
      final cubit = AuthCubit(LoginUseCase(repo), LogoutUseCase(repo));

      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.signIn(phone: '01012345678', password: 'secret123');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      // NOTE: signal streams replay the current value first (unlike
      // bloc's Cubit stream), so `_Initial` leads.
      expect(states.map((s) => s.runtimeType.toString()), [
        '_Initial',
        '_Submitting',
        '_Authenticated',
      ]);
      await cubit.close();
    });

    test('emits failed with backend message', () async {
      final repo = _FakeAuthRepository(
        loginResult: const Result.failure(
          error: NetworkFailure('wrong credentials'),
        ),
      );
      final cubit = AuthCubit(LoginUseCase(repo), LogoutUseCase(repo));

      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.signIn(phone: 'x', password: 'y');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states.length, 3);
      final failed = states.last;
      expect(
        failed.maybeWhen(failed: (m) => m, orElse: () => ''),
        'wrong credentials',
      );
      await cubit.close();
    });

    test('signOut returns to unauthenticated', () async {
      final repo = _FakeAuthRepository(authenticated: true);
      final cubit = AuthCubit(LoginUseCase(repo), LogoutUseCase(repo));
      await cubit.signOut();
      expect(repo.logoutCalls, 1);
      expect(
        cubit.stateValue.maybeWhen(
          unauthenticated: () => true,
          orElse: () => false,
        ),
        isTrue,
      );
      await cubit.close();
    });
  });

  group('TokenPair', () {
    test('parses access/refresh tokens from data envelope', () {
      final pair = TokenPair.fromJson({
        'data': {'accessToken': 'a.b.c', 'refreshToken': 'r', 'userId': 'u-1'},
      });
      expect(pair.accessToken, 'a.b.c');
      expect(pair.refreshToken, 'r');
      expect(pair.userId, 'u-1');
      expect(pair.isComplete, isTrue);
    });

    test('incomplete when access token missing', () {
      final pair = TokenPair.fromJson({
        'data': {'accessToken': '', 'refreshToken': 'r', 'userId': 'u'},
      });
      expect(pair.isComplete, isFalse);
    });
  });

  group('UserModel', () {
    test('parses AuthUserView envelope', () {
      final model = UserModel.fromJson({
        'data': {
          'id': 'u-1',
          'fullName': 'Mona',
          'phoneNumber': '01099999999',
          'email': 'm@m.com',
          'roles': ['ROLE_CUSTOMER'],
          'isActive': true,
        },
      });
      expect(model.fullName, 'Mona');
      expect(model.roles, ['ROLE_CUSTOMER']);
      final entity = model.toEntity();
      expect(entity.name, 'Mona');
      expect(entity.phone, '01099999999');
    });
  });

  group('LoginRequest', () {
    test('serializes phone and password', () {
      const req = LoginRequest(phone: '010', password: 'pw');
      expect(req.toJson(), {'phone': '010', 'password': 'pw'});
    });
  });

  group('AppRoles', () {
    test('each app set is non-empty and disjoint where expected', () {
      expect(AppRoles.customerApp, contains(AppRoles.customer));
      expect(AppRoles.staffApp, contains(AppRoles.branchManager));
      expect(AppRoles.adminApp, [AppRoles.superAdmin]);
      expect(
        AppRoles.customerApp.toSet().intersection(AppRoles.adminApp.toSet()),
        contains(AppRoles.superAdmin),
      );
    });
  });
}
