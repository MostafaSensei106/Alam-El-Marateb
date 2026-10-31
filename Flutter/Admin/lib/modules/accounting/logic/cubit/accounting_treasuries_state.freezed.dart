// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_treasuries_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingTreasuriesState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTreasuriesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingTreasuriesState()';
}


}

/// @nodoc
class $AccountingTreasuriesStateCopyWith<$Res>  {
$AccountingTreasuriesStateCopyWith(AccountingTreasuriesState _, $Res Function(AccountingTreasuriesState) __);
}


/// Adds pattern-matching-related methods to [AccountingTreasuriesState].
extension AccountingTreasuriesStatePatterns on AccountingTreasuriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountingTreasuriesInitial value)?  initial,TResult Function( AccountingTreasuriesLoading value)?  loading,TResult Function( AccountingTreasuriesSuccess value)?  success,TResult Function( AccountingTreasuriesFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountingTreasuriesInitial() when initial != null:
return initial(_that);case AccountingTreasuriesLoading() when loading != null:
return loading(_that);case AccountingTreasuriesSuccess() when success != null:
return success(_that);case AccountingTreasuriesFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountingTreasuriesInitial value)  initial,required TResult Function( AccountingTreasuriesLoading value)  loading,required TResult Function( AccountingTreasuriesSuccess value)  success,required TResult Function( AccountingTreasuriesFailure value)  failure,}){
final _that = this;
switch (_that) {
case AccountingTreasuriesInitial():
return initial(_that);case AccountingTreasuriesLoading():
return loading(_that);case AccountingTreasuriesSuccess():
return success(_that);case AccountingTreasuriesFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountingTreasuriesInitial value)?  initial,TResult? Function( AccountingTreasuriesLoading value)?  loading,TResult? Function( AccountingTreasuriesSuccess value)?  success,TResult? Function( AccountingTreasuriesFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AccountingTreasuriesInitial() when initial != null:
return initial(_that);case AccountingTreasuriesLoading() when loading != null:
return loading(_that);case AccountingTreasuriesSuccess() when success != null:
return success(_that);case AccountingTreasuriesFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AccountingTreasuryEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountingTreasuriesInitial() when initial != null:
return initial();case AccountingTreasuriesLoading() when loading != null:
return loading();case AccountingTreasuriesSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingTreasuriesFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AccountingTreasuryEntity> items,  bool isSaving,  String? errorMessage)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AccountingTreasuriesInitial():
return initial();case AccountingTreasuriesLoading():
return loading();case AccountingTreasuriesSuccess():
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingTreasuriesFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AccountingTreasuryEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AccountingTreasuriesInitial() when initial != null:
return initial();case AccountingTreasuriesLoading() when loading != null:
return loading();case AccountingTreasuriesSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingTreasuriesFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AccountingTreasuriesInitial implements AccountingTreasuriesState {
  const AccountingTreasuriesInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTreasuriesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingTreasuriesState.initial()';
}


}




/// @nodoc


class AccountingTreasuriesLoading implements AccountingTreasuriesState {
  const AccountingTreasuriesLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTreasuriesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingTreasuriesState.loading()';
}


}




/// @nodoc


class AccountingTreasuriesSuccess implements AccountingTreasuriesState {
  const AccountingTreasuriesSuccess({required  List<AccountingTreasuryEntity> items, this.isSaving = false, this.errorMessage}): _items = items;
  

 final  List<AccountingTreasuryEntity> _items;
 List<AccountingTreasuryEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool isSaving;
 final  String? errorMessage;

/// Create a copy of AccountingTreasuriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingTreasuriesSuccessCopyWith<AccountingTreasuriesSuccess> get copyWith => _$AccountingTreasuriesSuccessCopyWithImpl<AccountingTreasuriesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTreasuriesSuccess&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isSaving,errorMessage);
}

@override
String toString() {
    return 'AccountingTreasuriesState.success(items: $items, isSaving: $isSaving, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AccountingTreasuriesSuccessCopyWith<$Res> implements $AccountingTreasuriesStateCopyWith<$Res> {
  factory $AccountingTreasuriesSuccessCopyWith(AccountingTreasuriesSuccess value, $Res Function(AccountingTreasuriesSuccess) _then) = _$AccountingTreasuriesSuccessCopyWithImpl;
@useResult
$Res call({
 List<AccountingTreasuryEntity> items, bool isSaving, String? errorMessage
});




}
/// @nodoc
class _$AccountingTreasuriesSuccessCopyWithImpl<$Res>
    implements $AccountingTreasuriesSuccessCopyWith<$Res> {
  _$AccountingTreasuriesSuccessCopyWithImpl(this._self, this._then);

  final AccountingTreasuriesSuccess _self;
  final $Res Function(AccountingTreasuriesSuccess) _then;

/// Create a copy of AccountingTreasuriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isSaving = null,Object? errorMessage = freezed,}) {
  return _then(AccountingTreasuriesSuccess(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AccountingTreasuryEntity>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AccountingTreasuriesFailure implements AccountingTreasuriesState {
  const AccountingTreasuriesFailure({required this.message});
  

 final  String message;

/// Create a copy of AccountingTreasuriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingTreasuriesFailureCopyWith<AccountingTreasuriesFailure> get copyWith => _$AccountingTreasuriesFailureCopyWithImpl<AccountingTreasuriesFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTreasuriesFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AccountingTreasuriesState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountingTreasuriesFailureCopyWith<$Res> implements $AccountingTreasuriesStateCopyWith<$Res> {
  factory $AccountingTreasuriesFailureCopyWith(AccountingTreasuriesFailure value, $Res Function(AccountingTreasuriesFailure) _then) = _$AccountingTreasuriesFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountingTreasuriesFailureCopyWithImpl<$Res>
    implements $AccountingTreasuriesFailureCopyWith<$Res> {
  _$AccountingTreasuriesFailureCopyWithImpl(this._self, this._then);

  final AccountingTreasuriesFailure _self;
  final $Res Function(AccountingTreasuriesFailure) _then;

/// Create a copy of AccountingTreasuriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountingTreasuriesFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
