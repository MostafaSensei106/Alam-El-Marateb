import 'package:bloc_signals/bloc_signals.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/validator/login/login_validators.dart';
import '../usecase/login_usecase.dart';
import 'login_state.dart';

@injectable
final class LoginCubit extends CubitSignal<LoginState> {
  LoginCubit(this._u)
    : super(initialState: const LoginState.initial(LoginFormState()));

  final LoginUsecase _u;

  Future<void> login() async {
    if (state is Loading || !state.value.formState.isValid) return;

    emit(LoginState.loading(state.value.formState));

    final p = LoginParams(
      phone: state.value.formState.phone.value,
      password: state.value.formState.password.value,
      rememberMe: state.value.formState.rememberMe,
    );

    final response = await _u.call(p);

    response.when(
      success: (s) => emit(LoginState.success(state.value.formState, data: s)),
      failure: (e) =>
          emit(LoginState.failure(state.value.formState, error: e.message)),
    );
  }

  void onPhoneChanged(String value) {
    final phone = LoginPhoneValidator.dirty(value);
    _validateForm(phone: phone);
  }

  void onPasswordChanged(String value) {
    final password = LoginPasswordValidator.dirty(value);
    _validateForm(password: password);
  }

  void _validateForm({
    LoginPhoneValidator? phone,
    LoginPasswordValidator? password,
  }) {
    phone ??= state.value.formState.phone;
    password ??= state.value.formState.password;
    final formState = state.value.formState.copyWith(
      phone: phone,
      password: password,
      isValid: Formz.validate([phone, password]),
    );
    emit(LoginState.initial(formState));
  }

  void onRememberMeChanged(bool value) {
    emit(LoginState.initial(state.value.formState.copyWith(rememberMe: value)));
  }
}
