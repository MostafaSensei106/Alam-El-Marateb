// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_checks_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingChecksState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingChecksState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingChecksState()';
}


}

/// @nodoc
class $AccountingChecksStateCopyWith<$Res>  {
$AccountingChecksStateCopyWith(AccountingChecksState _, $Res Function(AccountingChecksState) __);
}


/// Adds pattern-matching-related methods to [AccountingChecksState].
extension AccountingChecksStatePatterns on AccountingChecksState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountingChecksInitial value)?  initial,TResult Function( AccountingChecksLoading value)?  loading,TResult Function( AccountingChecksSuccess value)?  success,TResult Function( AccountingChecksFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountingChecksInitial() when initial != null:
return initial(_that);case AccountingChecksLoading() when loading != null:
return loading(_that);case AccountingChecksSuccess() when success != null:
return success(_that);case AccountingChecksFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountingChecksInitial value)  initial,required TResult Function( AccountingChecksLoading value)  loading,required TResult Function( AccountingChecksSuccess value)  success,required TResult Function( AccountingChecksFailure value)  failure,}){
final _that = this;
switch (_that) {
case AccountingChecksInitial():
return initial(_that);case AccountingChecksLoading():
return loading(_that);case AccountingChecksSuccess():
return success(_that);case AccountingChecksFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountingChecksInitial value)?  initial,TResult? Function( AccountingChecksLoading value)?  loading,TResult? Function( AccountingChecksSuccess value)?  success,TResult? Function( AccountingChecksFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AccountingChecksInitial() when initial != null:
return initial(_that);case AccountingChecksLoading() when loading != null:
return loading(_that);case AccountingChecksSuccess() when success != null:
return success(_that);case AccountingChecksFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AccountingCheckEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountingChecksInitial() when initial != null:
return initial();case AccountingChecksLoading() when loading != null:
return loading();case AccountingChecksSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingChecksFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AccountingCheckEntity> items,  bool isSaving,  String? errorMessage)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AccountingChecksInitial():
return initial();case AccountingChecksLoading():
return loading();case AccountingChecksSuccess():
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingChecksFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AccountingCheckEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AccountingChecksInitial() when initial != null:
return initial();case AccountingChecksLoading() when loading != null:
return loading();case AccountingChecksSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingChecksFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AccountingChecksInitial implements AccountingChecksState {
  const AccountingChecksInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingChecksInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingChecksState.initial()';
}


}




/// @nodoc


class AccountingChecksLoading implements AccountingChecksState {
  const AccountingChecksLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingChecksLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingChecksState.loading()';
}


}




/// @nodoc


class AccountingChecksSuccess implements AccountingChecksState {
  const AccountingChecksSuccess({required  List<AccountingCheckEntity> items, this.isSaving = false, this.errorMessage}): _items = items;
  

 final  List<AccountingCheckEntity> _items;
 List<AccountingCheckEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool isSaving;
 final  String? errorMessage;

/// Create a copy of AccountingChecksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingChecksSuccessCopyWith<AccountingChecksSuccess> get copyWith => _$AccountingChecksSuccessCopyWithImpl<AccountingChecksSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingChecksSuccess&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isSaving,errorMessage);
}

@override
String toString() {
    return 'AccountingChecksState.success(items: $items, isSaving: $isSaving, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AccountingChecksSuccessCopyWith<$Res> implements $AccountingChecksStateCopyWith<$Res> {
  factory $AccountingChecksSuccessCopyWith(AccountingChecksSuccess value, $Res Function(AccountingChecksSuccess) _then) = _$AccountingChecksSuccessCopyWithImpl;
@useResult
$Res call({
 List<AccountingCheckEntity> items, bool isSaving, String? errorMessage
});




}
/// @nodoc
class _$AccountingChecksSuccessCopyWithImpl<$Res>
    implements $AccountingChecksSuccessCopyWith<$Res> {
  _$AccountingChecksSuccessCopyWithImpl(this._self, this._then);

  final AccountingChecksSuccess _self;
  final $Res Function(AccountingChecksSuccess) _then;

/// Create a copy of AccountingChecksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isSaving = null,Object? errorMessage = freezed,}) {
  return _then(AccountingChecksSuccess(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AccountingCheckEntity>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AccountingChecksFailure implements AccountingChecksState {
  const AccountingChecksFailure({required this.message});
  

 final  String message;

/// Create a copy of AccountingChecksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingChecksFailureCopyWith<AccountingChecksFailure> get copyWith => _$AccountingChecksFailureCopyWithImpl<AccountingChecksFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingChecksFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AccountingChecksState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountingChecksFailureCopyWith<$Res> implements $AccountingChecksStateCopyWith<$Res> {
  factory $AccountingChecksFailureCopyWith(AccountingChecksFailure value, $Res Function(AccountingChecksFailure) _then) = _$AccountingChecksFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountingChecksFailureCopyWithImpl<$Res>
    implements $AccountingChecksFailureCopyWith<$Res> {
  _$AccountingChecksFailureCopyWithImpl(this._self, this._then);

  final AccountingChecksFailure _self;
  final $Res Function(AccountingChecksFailure) _then;

/// Create a copy of AccountingChecksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountingChecksFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
