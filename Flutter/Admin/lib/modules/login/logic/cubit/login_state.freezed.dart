// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 LoginFormState get formState;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.formState, _this.formState) || other.formState == _this.formState));
}


@override
int get hashCode {
  final _this = this as LoginState;
  return Object.hash(runtimeType,_this.formState);
}

@override
String toString() {
  final _this = this as LoginState;
  return 'LoginState(formState: ${_this.formState})';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 LoginFormState formState
});


$LoginFormStateCopyWith<$Res> get formState;

}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formState = null,}) {
  return _then(_self.copyWith(
formState: null == formState ? _self.formState : formState // ignore: cast_nullable_to_non_nullable
as LoginFormState,
  ));
}
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<$Res> get formState {
  
  return $LoginFormStateCopyWith<$Res>(_self.formState, (value) {
    return _then(_self.copyWith(formState: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( Success value)?  success,TResult Function( Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Success() when success != null:
return success(_that);case Failure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( Success value)  success,required TResult Function( Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case Loading():
return loading(_that);case Success():
return success(_that);case Failure():
return failure(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( Success value)?  success,TResult? Function( Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Success() when success != null:
return success(_that);case Failure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LoginFormState formState)?  initial,TResult Function( LoginFormState formState)?  loading,TResult Function( LoginFormState formState,  UserEntity data)?  success,TResult Function( LoginFormState formState,  String error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.formState);case Loading() when loading != null:
return loading(_that.formState);case Success() when success != null:
return success(_that.formState,_that.data);case Failure() when failure != null:
return failure(_that.formState,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LoginFormState formState)  initial,required TResult Function( LoginFormState formState)  loading,required TResult Function( LoginFormState formState,  UserEntity data)  success,required TResult Function( LoginFormState formState,  String error)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.formState);case Loading():
return loading(_that.formState);case Success():
return success(_that.formState,_that.data);case Failure():
return failure(_that.formState,_that.error);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LoginFormState formState)?  initial,TResult? Function( LoginFormState formState)?  loading,TResult? Function( LoginFormState formState,  UserEntity data)?  success,TResult? Function( LoginFormState formState,  String error)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.formState);case Loading() when loading != null:
return loading(_that.formState);case Success() when success != null:
return success(_that.formState,_that.data);case Failure() when failure != null:
return failure(_that.formState,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements LoginState {
  const _Initial(this.formState);
  

@override final  LoginFormState formState;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.formState, formState) || other.formState == formState));
}


@override
int get hashCode {
    return Object.hash(runtimeType,formState);
}

@override
String toString() {
    return 'LoginState.initial(formState: $formState)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 LoginFormState formState
});


@override $LoginFormStateCopyWith<$Res> get formState;

}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formState = null,}) {
  return _then(_Initial(
null == formState ? _self.formState : formState // ignore: cast_nullable_to_non_nullable
as LoginFormState,
  ));
}

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<$Res> get formState {
  
  return $LoginFormStateCopyWith<$Res>(_self.formState, (value) {
    return _then(_self.copyWith(formState: value));
  });
}
}

/// @nodoc


class Loading implements LoginState {
  const Loading(this.formState);
  

@override final  LoginFormState formState;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadingCopyWith<Loading> get copyWith => _$LoadingCopyWithImpl<Loading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading&&(identical(other.formState, formState) || other.formState == formState));
}


@override
int get hashCode {
    return Object.hash(runtimeType,formState);
}

@override
String toString() {
    return 'LoginState.loading(formState: $formState)';
}


}

/// @nodoc
abstract mixin class $LoadingCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $LoadingCopyWith(Loading value, $Res Function(Loading) _then) = _$LoadingCopyWithImpl;
@override @useResult
$Res call({
 LoginFormState formState
});


@override $LoginFormStateCopyWith<$Res> get formState;

}
/// @nodoc
class _$LoadingCopyWithImpl<$Res>
    implements $LoadingCopyWith<$Res> {
  _$LoadingCopyWithImpl(this._self, this._then);

  final Loading _self;
  final $Res Function(Loading) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formState = null,}) {
  return _then(Loading(
null == formState ? _self.formState : formState // ignore: cast_nullable_to_non_nullable
as LoginFormState,
  ));
}

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<$Res> get formState {
  
  return $LoginFormStateCopyWith<$Res>(_self.formState, (value) {
    return _then(_self.copyWith(formState: value));
  });
}
}

/// @nodoc


class Success implements LoginState {
  const Success(this.formState, {required this.data});
  

@override final  LoginFormState formState;
 final  UserEntity data;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<Success> get copyWith => _$SuccessCopyWithImpl<Success>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Success&&(identical(other.formState, formState) || other.formState == formState)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,formState,data);
}

@override
String toString() {
    return 'LoginState.success(formState: $formState, data: $data)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) _then) = _$SuccessCopyWithImpl;
@override @useResult
$Res call({
 LoginFormState formState, UserEntity data
});


@override $LoginFormStateCopyWith<$Res> get formState;$UserEntityCopyWith<$Res> get data;

}
/// @nodoc
class _$SuccessCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success _self;
  final $Res Function(Success) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formState = null,Object? data = null,}) {
  return _then(Success(
null == formState ? _self.formState : formState // ignore: cast_nullable_to_non_nullable
as LoginFormState,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<$Res> get formState {
  
  return $LoginFormStateCopyWith<$Res>(_self.formState, (value) {
    return _then(_self.copyWith(formState: value));
  });
}/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res> get data {
  
  return $UserEntityCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class Failure implements LoginState {
  const Failure(this.formState, {required this.error});
  

@override final  LoginFormState formState;
 final  String error;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.formState, formState) || other.formState == formState)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,formState,error);
}

@override
String toString() {
    return 'LoginState.failure(formState: $formState, error: $error)';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@override @useResult
$Res call({
 LoginFormState formState, String error
});


@override $LoginFormStateCopyWith<$Res> get formState;

}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formState = null,Object? error = null,}) {
  return _then(Failure(
null == formState ? _self.formState : formState // ignore: cast_nullable_to_non_nullable
as LoginFormState,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<$Res> get formState {
  
  return $LoginFormStateCopyWith<$Res>(_self.formState, (value) {
    return _then(_self.copyWith(formState: value));
  });
}
}

/// @nodoc
mixin _$LoginFormState {

 LoginPhoneValidator get phone; LoginPasswordValidator get password; bool get rememberMe; bool get isValid;
/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<LoginFormState> get copyWith => _$LoginFormStateCopyWithImpl<LoginFormState>(this as LoginFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginFormState&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.rememberMe, _this.rememberMe) || other.rememberMe == _this.rememberMe)&&(identical(other.isValid, _this.isValid) || other.isValid == _this.isValid));
}


@override
int get hashCode {
  final _this = this as LoginFormState;
  return Object.hash(runtimeType,_this.phone,_this.password,_this.rememberMe,_this.isValid);
}

@override
String toString() {
  final _this = this as LoginFormState;
  return 'LoginFormState(phone: ${_this.phone}, password: ${_this.password}, rememberMe: ${_this.rememberMe}, isValid: ${_this.isValid})';
}


}

/// @nodoc
abstract mixin class $LoginFormStateCopyWith<$Res>  {
  factory $LoginFormStateCopyWith(LoginFormState value, $Res Function(LoginFormState) _then) = _$LoginFormStateCopyWithImpl;
@useResult
$Res call({
 LoginPhoneValidator phone, LoginPasswordValidator password, bool rememberMe, bool isValid
});




}
/// @nodoc
class _$LoginFormStateCopyWithImpl<$Res>
    implements $LoginFormStateCopyWith<$Res> {
  _$LoginFormStateCopyWithImpl(this._self, this._then);

  final LoginFormState _self;
  final $Res Function(LoginFormState) _then;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? password = null,Object? rememberMe = null,Object? isValid = null,}) {
  return _then(LoginFormState(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as LoginPhoneValidator,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as LoginPasswordValidator,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginFormState].
extension LoginFormStatePatterns on LoginFormState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginFormState value)  $default,){
final _that = this;
switch (_that) {
case _LoginFormState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginFormState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoginPhoneValidator phone,  LoginPasswordValidator password,  bool rememberMe,  bool isValid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that.phone,_that.password,_that.rememberMe,_that.isValid);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoginPhoneValidator phone,  LoginPasswordValidator password,  bool rememberMe,  bool isValid)  $default,) {final _that = this;
switch (_that) {
case _LoginFormState():
return $default(_that.phone,_that.password,_that.rememberMe,_that.isValid);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoginPhoneValidator phone,  LoginPasswordValidator password,  bool rememberMe,  bool isValid)?  $default,) {final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that.phone,_that.password,_that.rememberMe,_that.isValid);case _:
  return null;

}
}

}

/// @nodoc


class _LoginFormState implements LoginFormState {
  const _LoginFormState({this.phone = const LoginPhoneValidator.pure(), this.password = const LoginPasswordValidator.pure(), this.rememberMe = false, this.isValid = false});
  

@override@JsonKey() final  LoginPhoneValidator phone;
@override@JsonKey() final  LoginPasswordValidator password;
@override@JsonKey() final  bool rememberMe;
@override@JsonKey() final  bool isValid;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginFormStateCopyWith<_LoginFormState> get copyWith => __$LoginFormStateCopyWithImpl<_LoginFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginFormState&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.isValid, isValid) || other.isValid == isValid));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phone,password,rememberMe,isValid);
}

@override
String toString() {
    return 'LoginFormState(phone: $phone, password: $password, rememberMe: $rememberMe, isValid: $isValid)';
}


}

/// @nodoc
abstract mixin class _$LoginFormStateCopyWith<$Res> implements $LoginFormStateCopyWith<$Res> {
  factory _$LoginFormStateCopyWith(_LoginFormState value, $Res Function(_LoginFormState) _then) = __$LoginFormStateCopyWithImpl;
@override @useResult
$Res call({
 LoginPhoneValidator phone, LoginPasswordValidator password, bool rememberMe, bool isValid
});




}
/// @nodoc
class __$LoginFormStateCopyWithImpl<$Res>
    implements _$LoginFormStateCopyWith<$Res> {
  __$LoginFormStateCopyWithImpl(this._self, this._then);

  final _LoginFormState _self;
  final $Res Function(_LoginFormState) _then;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? password = null,Object? rememberMe = null,Object? isValid = null,}) {
  return _then(_LoginFormState(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as LoginPhoneValidator,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as LoginPasswordValidator,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
