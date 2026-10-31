// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_ledger_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingLedgerState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingLedgerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingLedgerState()';
}


}

/// @nodoc
class $AccountingLedgerStateCopyWith<$Res>  {
$AccountingLedgerStateCopyWith(AccountingLedgerState _, $Res Function(AccountingLedgerState) __);
}


/// Adds pattern-matching-related methods to [AccountingLedgerState].
extension AccountingLedgerStatePatterns on AccountingLedgerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountingLedgerInitial value)?  initial,TResult Function( AccountingLedgerLoading value)?  loading,TResult Function( AccountingLedgerSuccess value)?  success,TResult Function( AccountingLedgerFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountingLedgerInitial() when initial != null:
return initial(_that);case AccountingLedgerLoading() when loading != null:
return loading(_that);case AccountingLedgerSuccess() when success != null:
return success(_that);case AccountingLedgerFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountingLedgerInitial value)  initial,required TResult Function( AccountingLedgerLoading value)  loading,required TResult Function( AccountingLedgerSuccess value)  success,required TResult Function( AccountingLedgerFailure value)  failure,}){
final _that = this;
switch (_that) {
case AccountingLedgerInitial():
return initial(_that);case AccountingLedgerLoading():
return loading(_that);case AccountingLedgerSuccess():
return success(_that);case AccountingLedgerFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountingLedgerInitial value)?  initial,TResult? Function( AccountingLedgerLoading value)?  loading,TResult? Function( AccountingLedgerSuccess value)?  success,TResult? Function( AccountingLedgerFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AccountingLedgerInitial() when initial != null:
return initial(_that);case AccountingLedgerLoading() when loading != null:
return loading(_that);case AccountingLedgerSuccess() when success != null:
return success(_that);case AccountingLedgerFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AccountingLedgerLineEntity> items)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountingLedgerInitial() when initial != null:
return initial();case AccountingLedgerLoading() when loading != null:
return loading();case AccountingLedgerSuccess() when success != null:
return success(_that.items);case AccountingLedgerFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AccountingLedgerLineEntity> items)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AccountingLedgerInitial():
return initial();case AccountingLedgerLoading():
return loading();case AccountingLedgerSuccess():
return success(_that.items);case AccountingLedgerFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AccountingLedgerLineEntity> items)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AccountingLedgerInitial() when initial != null:
return initial();case AccountingLedgerLoading() when loading != null:
return loading();case AccountingLedgerSuccess() when success != null:
return success(_that.items);case AccountingLedgerFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AccountingLedgerInitial implements AccountingLedgerState {
  const AccountingLedgerInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingLedgerInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingLedgerState.initial()';
}


}




/// @nodoc


class AccountingLedgerLoading implements AccountingLedgerState {
  const AccountingLedgerLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingLedgerLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingLedgerState.loading()';
}


}




/// @nodoc


class AccountingLedgerSuccess implements AccountingLedgerState {
  const AccountingLedgerSuccess({required  List<AccountingLedgerLineEntity> items}): _items = items;
  

 final  List<AccountingLedgerLineEntity> _items;
 List<AccountingLedgerLineEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of AccountingLedgerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingLedgerSuccessCopyWith<AccountingLedgerSuccess> get copyWith => _$AccountingLedgerSuccessCopyWithImpl<AccountingLedgerSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingLedgerSuccess&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'AccountingLedgerState.success(items: $items)';
}


}

/// @nodoc
abstract mixin class $AccountingLedgerSuccessCopyWith<$Res> implements $AccountingLedgerStateCopyWith<$Res> {
  factory $AccountingLedgerSuccessCopyWith(AccountingLedgerSuccess value, $Res Function(AccountingLedgerSuccess) _then) = _$AccountingLedgerSuccessCopyWithImpl;
@useResult
$Res call({
 List<AccountingLedgerLineEntity> items
});




}
/// @nodoc
class _$AccountingLedgerSuccessCopyWithImpl<$Res>
    implements $AccountingLedgerSuccessCopyWith<$Res> {
  _$AccountingLedgerSuccessCopyWithImpl(this._self, this._then);

  final AccountingLedgerSuccess _self;
  final $Res Function(AccountingLedgerSuccess) _then;

/// Create a copy of AccountingLedgerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(AccountingLedgerSuccess(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AccountingLedgerLineEntity>,
  ));
}


}

/// @nodoc


class AccountingLedgerFailure implements AccountingLedgerState {
  const AccountingLedgerFailure({required this.message});
  

 final  String message;

/// Create a copy of AccountingLedgerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingLedgerFailureCopyWith<AccountingLedgerFailure> get copyWith => _$AccountingLedgerFailureCopyWithImpl<AccountingLedgerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingLedgerFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AccountingLedgerState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountingLedgerFailureCopyWith<$Res> implements $AccountingLedgerStateCopyWith<$Res> {
  factory $AccountingLedgerFailureCopyWith(AccountingLedgerFailure value, $Res Function(AccountingLedgerFailure) _then) = _$AccountingLedgerFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountingLedgerFailureCopyWithImpl<$Res>
    implements $AccountingLedgerFailureCopyWith<$Res> {
  _$AccountingLedgerFailureCopyWithImpl(this._self, this._then);

  final AccountingLedgerFailure _self;
  final $Res Function(AccountingLedgerFailure) _then;

/// Create a copy of AccountingLedgerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountingLedgerFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
