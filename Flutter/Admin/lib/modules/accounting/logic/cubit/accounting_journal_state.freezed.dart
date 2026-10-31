// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_journal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingJournalState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingJournalState()';
}


}

/// @nodoc
class $AccountingJournalStateCopyWith<$Res>  {
$AccountingJournalStateCopyWith(AccountingJournalState _, $Res Function(AccountingJournalState) __);
}


/// Adds pattern-matching-related methods to [AccountingJournalState].
extension AccountingJournalStatePatterns on AccountingJournalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountingJournalInitial value)?  initial,TResult Function( AccountingJournalLoading value)?  loading,TResult Function( AccountingJournalSuccess value)?  success,TResult Function( AccountingJournalFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountingJournalInitial() when initial != null:
return initial(_that);case AccountingJournalLoading() when loading != null:
return loading(_that);case AccountingJournalSuccess() when success != null:
return success(_that);case AccountingJournalFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountingJournalInitial value)  initial,required TResult Function( AccountingJournalLoading value)  loading,required TResult Function( AccountingJournalSuccess value)  success,required TResult Function( AccountingJournalFailure value)  failure,}){
final _that = this;
switch (_that) {
case AccountingJournalInitial():
return initial(_that);case AccountingJournalLoading():
return loading(_that);case AccountingJournalSuccess():
return success(_that);case AccountingJournalFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountingJournalInitial value)?  initial,TResult? Function( AccountingJournalLoading value)?  loading,TResult? Function( AccountingJournalSuccess value)?  success,TResult? Function( AccountingJournalFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AccountingJournalInitial() when initial != null:
return initial(_that);case AccountingJournalLoading() when loading != null:
return loading(_that);case AccountingJournalSuccess() when success != null:
return success(_that);case AccountingJournalFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AccountingJournalEntryEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountingJournalInitial() when initial != null:
return initial();case AccountingJournalLoading() when loading != null:
return loading();case AccountingJournalSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingJournalFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AccountingJournalEntryEntity> items,  bool isSaving,  String? errorMessage)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AccountingJournalInitial():
return initial();case AccountingJournalLoading():
return loading();case AccountingJournalSuccess():
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingJournalFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AccountingJournalEntryEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AccountingJournalInitial() when initial != null:
return initial();case AccountingJournalLoading() when loading != null:
return loading();case AccountingJournalSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingJournalFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AccountingJournalInitial implements AccountingJournalState {
  const AccountingJournalInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingJournalState.initial()';
}


}




/// @nodoc


class AccountingJournalLoading implements AccountingJournalState {
  const AccountingJournalLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingJournalState.loading()';
}


}




/// @nodoc


class AccountingJournalSuccess implements AccountingJournalState {
  const AccountingJournalSuccess({required  List<AccountingJournalEntryEntity> items, this.isSaving = false, this.errorMessage}): _items = items;
  

 final  List<AccountingJournalEntryEntity> _items;
 List<AccountingJournalEntryEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool isSaving;
 final  String? errorMessage;

/// Create a copy of AccountingJournalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingJournalSuccessCopyWith<AccountingJournalSuccess> get copyWith => _$AccountingJournalSuccessCopyWithImpl<AccountingJournalSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalSuccess&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isSaving,errorMessage);
}

@override
String toString() {
    return 'AccountingJournalState.success(items: $items, isSaving: $isSaving, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AccountingJournalSuccessCopyWith<$Res> implements $AccountingJournalStateCopyWith<$Res> {
  factory $AccountingJournalSuccessCopyWith(AccountingJournalSuccess value, $Res Function(AccountingJournalSuccess) _then) = _$AccountingJournalSuccessCopyWithImpl;
@useResult
$Res call({
 List<AccountingJournalEntryEntity> items, bool isSaving, String? errorMessage
});




}
/// @nodoc
class _$AccountingJournalSuccessCopyWithImpl<$Res>
    implements $AccountingJournalSuccessCopyWith<$Res> {
  _$AccountingJournalSuccessCopyWithImpl(this._self, this._then);

  final AccountingJournalSuccess _self;
  final $Res Function(AccountingJournalSuccess) _then;

/// Create a copy of AccountingJournalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isSaving = null,Object? errorMessage = freezed,}) {
  return _then(AccountingJournalSuccess(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AccountingJournalEntryEntity>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AccountingJournalFailure implements AccountingJournalState {
  const AccountingJournalFailure({required this.message});
  

 final  String message;

/// Create a copy of AccountingJournalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingJournalFailureCopyWith<AccountingJournalFailure> get copyWith => _$AccountingJournalFailureCopyWithImpl<AccountingJournalFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AccountingJournalState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountingJournalFailureCopyWith<$Res> implements $AccountingJournalStateCopyWith<$Res> {
  factory $AccountingJournalFailureCopyWith(AccountingJournalFailure value, $Res Function(AccountingJournalFailure) _then) = _$AccountingJournalFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountingJournalFailureCopyWithImpl<$Res>
    implements $AccountingJournalFailureCopyWith<$Res> {
  _$AccountingJournalFailureCopyWithImpl(this._self, this._then);

  final AccountingJournalFailure _self;
  final $Res Function(AccountingJournalFailure) _then;

/// Create a copy of AccountingJournalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountingJournalFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
