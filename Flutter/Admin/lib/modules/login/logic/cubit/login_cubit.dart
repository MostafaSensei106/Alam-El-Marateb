import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../usecase/login_usecase.dart';
import 'login_state.dart';

@injectable
final class LoginCubit extends CubitSignal<LoginState> {
  LoginCubit(this._u)
    : super(
        initialState: const LoginState<LoginFormState>.initial(
          LoginFormState(),
        ),
      );

  final LoginUsecase _u;

  Future<void> login() async {
    if (state is Loading || !state.value.formState.isValid) return;

    emit(Loading(state.value.formState));

    final p = LoginParams(
      phone: state.value.formState.phone.value,
      password: state.value.formState.password.value,
      rememberMe: state.value.formState.rememberMe,
    );

    final response = await _u.call(p);

    response.when(
      success: (s) => emit(Success(state.value.formState, data: s)),
      failure: (e) => emit(Failure(state.value.formState, error: e)),
    );
  }
}
