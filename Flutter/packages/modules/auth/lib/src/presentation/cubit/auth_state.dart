part of 'auth_cubit.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.submitting() = _Submitting;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.failed(String message) = _Failed;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
