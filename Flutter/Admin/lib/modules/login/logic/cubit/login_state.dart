import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/validator/login/login_validators.dart';
import '../entity/user_entity.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial(LoginFormState formState) = _Initial;
  const factory LoginState.loading(LoginFormState formState) = Loading;
  const factory LoginState.success(
    LoginFormState formState, {
    required UserEntity data,
  }) = Success;
  const factory LoginState.failure(
    LoginFormState formState, {
    required String error,
  }) = Failure;
}

@freezed
abstract class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default(LoginPhoneValidator.pure()) LoginPhoneValidator phone,
    @Default(LoginPasswordValidator.pure()) LoginPasswordValidator password,
    @Default(false) bool rememberMe,
    @Default(false) bool isValid,
  }) = _LoginFormState;
}
