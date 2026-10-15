import 'package:alam_el_marateb_result/result.dart';
import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.loginResult, this.authenticated = false});

  final Result<User, Failure>? loginResult;
  bool authenticated;
  int logoutCalls = 0;

  @override
  Future<Result<User, Failure>> login({
    required String identifier,
    required String password,
  }) async =>
      loginResult ??
      const Result.failure(error: UnknownFailure('unstubbed'));

  @override
  Future<Result<void, Failure>> logout() async {
    logoutCalls++;
    authenticated = false;
    return const Result.success(data: null);
  }

  @override
  Future<bool> isAuthenticated() async => authenticated;
}

const _user = User(id: '1', name: 'Ahmed', phone: '01012345678');

void main() {
  group('AuthCubit', () {
    test('full sign-in flow', () async {
      final repo = _FakeAuthRepository(
        loginResult: const Result.success(data: _user),
      );
      final cubit = AuthCubit(LoginUseCase(repo), LogoutUseCase(repo));

      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.signIn(identifier: '01012345678', password: 'secret123');
      await sub.cancel();

      expect(states.map((s) => s.runtimeType.toString()), [
        '_Submitting',
        '_Authenticated',
      ]);
      final authed = states.last as dynamic;
      expect((authed as dynamic).user.name, 'Ahmed');
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
      await cubit.signIn(identifier: 'x', password: 'y');
      await sub.cancel();

      expect(states.length, 2);
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
        cubit.state.maybeWhen(
          unauthenticated: () => true,
          orElse: () => false,
        ),
        isTrue,
      );
      await cubit.close();
    });
  });

  group('UserModel', () {
    test('parses bare object with token', () {
      final model = UserModel.fromJson({
        'id': 7,
        'name': 'Mona',
        'token': 'abc',
      });
      expect(model.id, '7');
      expect(model.token, 'abc');
    });

    test('parses data envelope with access_token', () {
      final model = UserModel.fromJson({
        'data': {
          'user': {'id': '9', 'name': 'Omar'},
          'access_token': 'xyz',
        },
      });
      expect(model.id, '9');
      expect(model.token, 'xyz');
    });

    test('token null when absent', () {
      final model = UserModel.fromJson({'id': '1', 'name': 'N'});
      expect(model.token, isNull);
    });
  });

  group('LoginRequest', () {
    test('serializes identifier and password', () {
      const req = LoginRequest(identifier: '010', password: 'pw');
      expect(req.toJson(), {'identifier': '010', 'password': 'pw'});
    });
  });
}
