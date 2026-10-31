// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_transfers_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingTransfersState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTransfersState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingTransfersState()';
}


}

/// @nodoc
class $AccountingTransfersStateCopyWith<$Res>  {
$AccountingTransfersStateCopyWith(AccountingTransfersState _, $Res Function(AccountingTransfersState) __);
}


/// Adds pattern-matching-related methods to [AccountingTransfersState].
extension AccountingTransfersStatePatterns on AccountingTransfersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountingTransfersInitial value)?  initial,TResult Function( AccountingTransfersLoading value)?  loading,TResult Function( AccountingTransfersSuccess value)?  success,TResult Function( AccountingTransfersFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountingTransfersInitial() when initial != null:
return initial(_that);case AccountingTransfersLoading() when loading != null:
return loading(_that);case AccountingTransfersSuccess() when success != null:
return success(_that);case AccountingTransfersFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountingTransfersInitial value)  initial,required TResult Function( AccountingTransfersLoading value)  loading,required TResult Function( AccountingTransfersSuccess value)  success,required TResult Function( AccountingTransfersFailure value)  failure,}){
final _that = this;
switch (_that) {
case AccountingTransfersInitial():
return initial(_that);case AccountingTransfersLoading():
return loading(_that);case AccountingTransfersSuccess():
return success(_that);case AccountingTransfersFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountingTransfersInitial value)?  initial,TResult? Function( AccountingTransfersLoading value)?  loading,TResult? Function( AccountingTransfersSuccess value)?  success,TResult? Function( AccountingTransfersFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AccountingTransfersInitial() when initial != null:
return initial(_that);case AccountingTransfersLoading() when loading != null:
return loading(_that);case AccountingTransfersSuccess() when success != null:
return success(_that);case AccountingTransfersFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AccountingTransferEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountingTransfersInitial() when initial != null:
return initial();case AccountingTransfersLoading() when loading != null:
return loading();case AccountingTransfersSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingTransfersFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AccountingTransferEntity> items,  bool isSaving,  String? errorMessage)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AccountingTransfersInitial():
return initial();case AccountingTransfersLoading():
return loading();case AccountingTransfersSuccess():
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingTransfersFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AccountingTransferEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AccountingTransfersInitial() when initial != null:
return initial();case AccountingTransfersLoading() when loading != null:
return loading();case AccountingTransfersSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingTransfersFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AccountingTransfersInitial implements AccountingTransfersState {
  const AccountingTransfersInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTransfersInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingTransfersState.initial()';
}


}




/// @nodoc


class AccountingTransfersLoading implements AccountingTransfersState {
  const AccountingTransfersLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTransfersLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingTransfersState.loading()';
}


}




/// @nodoc


class AccountingTransfersSuccess implements AccountingTransfersState {
  const AccountingTransfersSuccess({required  List<AccountingTransferEntity> items, this.isSaving = false, this.errorMessage}): _items = items;
  

 final  List<AccountingTransferEntity> _items;
 List<AccountingTransferEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool isSaving;
 final  String? errorMessage;

/// Create a copy of AccountingTransfersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingTransfersSuccessCopyWith<AccountingTransfersSuccess> get copyWith => _$AccountingTransfersSuccessCopyWithImpl<AccountingTransfersSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTransfersSuccess&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isSaving,errorMessage);
}

@override
String toString() {
    return 'AccountingTransfersState.success(items: $items, isSaving: $isSaving, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AccountingTransfersSuccessCopyWith<$Res> implements $AccountingTransfersStateCopyWith<$Res> {
  factory $AccountingTransfersSuccessCopyWith(AccountingTransfersSuccess value, $Res Function(AccountingTransfersSuccess) _then) = _$AccountingTransfersSuccessCopyWithImpl;
@useResult
$Res call({
 List<AccountingTransferEntity> items, bool isSaving, String? errorMessage
});




}
/// @nodoc
class _$AccountingTransfersSuccessCopyWithImpl<$Res>
    implements $AccountingTransfersSuccessCopyWith<$Res> {
  _$AccountingTransfersSuccessCopyWithImpl(this._self, this._then);

  final AccountingTransfersSuccess _self;
  final $Res Function(AccountingTransfersSuccess) _then;

/// Create a copy of AccountingTransfersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isSaving = null,Object? errorMessage = freezed,}) {
  return _then(AccountingTransfersSuccess(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AccountingTransferEntity>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AccountingTransfersFailure implements AccountingTransfersState {
  const AccountingTransfersFailure({required this.message});
  

 final  String message;

/// Create a copy of AccountingTransfersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingTransfersFailureCopyWith<AccountingTransfersFailure> get copyWith => _$AccountingTransfersFailureCopyWithImpl<AccountingTransfersFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTransfersFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AccountingTransfersState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountingTransfersFailureCopyWith<$Res> implements $AccountingTransfersStateCopyWith<$Res> {
  factory $AccountingTransfersFailureCopyWith(AccountingTransfersFailure value, $Res Function(AccountingTransfersFailure) _then) = _$AccountingTransfersFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountingTransfersFailureCopyWithImpl<$Res>
    implements $AccountingTransfersFailureCopyWith<$Res> {
  _$AccountingTransfersFailureCopyWithImpl(this._self, this._then);

  final AccountingTransfersFailure _self;
  final $Res Function(AccountingTransfersFailure) _then;

/// Create a copy of AccountingTransfersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountingTransfersFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
