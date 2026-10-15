import 'package:alam_el_marateb_result/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:auth/src/domain/entities/user.dart';
import 'package:auth/src/domain/usecases/login_usecase.dart';
import 'package:auth/src/domain/usecases/logout_usecase.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

/// Shared auth cubit — provided per login/logout screen, same class in all
/// three apps. Emits typed states; error strings come from [AuthState.message]
/// (the screen resolves validator `messageId`s via its own l10n).
@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._login, this._logout) : super(const AuthState.initial());

  final LoginUseCase _login;
  final LogoutUseCase _logout;

  Future<void> signIn({required String phone, required String password}) async {
    emit(const AuthState.submitting());
    final result = await _login(
      LoginParams(phone: phone, password: password),
    );
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(AuthState.authenticated(data));
      case FailureResult(:final error):
        emit(AuthState.failed(error.message));
    }
  }

  Future<void> signOut() async {
    emit(const AuthState.submitting());
    await _logout(const NoParams());
    if (isClosed) return;
    // Repository already cleared storage + broadcast auth=false; the app
    // router's redirect reacts to the notifier and lands on /login.
    emit(const AuthState.unauthenticated());
  }
}
