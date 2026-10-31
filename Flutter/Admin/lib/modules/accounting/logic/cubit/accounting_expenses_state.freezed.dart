// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_expenses_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingExpensesState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingExpensesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingExpensesState()';
}


}

/// @nodoc
class $AccountingExpensesStateCopyWith<$Res>  {
$AccountingExpensesStateCopyWith(AccountingExpensesState _, $Res Function(AccountingExpensesState) __);
}


/// Adds pattern-matching-related methods to [AccountingExpensesState].
extension AccountingExpensesStatePatterns on AccountingExpensesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountingExpensesInitial value)?  initial,TResult Function( AccountingExpensesLoading value)?  loading,TResult Function( AccountingExpensesSuccess value)?  success,TResult Function( AccountingExpensesFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountingExpensesInitial() when initial != null:
return initial(_that);case AccountingExpensesLoading() when loading != null:
return loading(_that);case AccountingExpensesSuccess() when success != null:
return success(_that);case AccountingExpensesFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountingExpensesInitial value)  initial,required TResult Function( AccountingExpensesLoading value)  loading,required TResult Function( AccountingExpensesSuccess value)  success,required TResult Function( AccountingExpensesFailure value)  failure,}){
final _that = this;
switch (_that) {
case AccountingExpensesInitial():
return initial(_that);case AccountingExpensesLoading():
return loading(_that);case AccountingExpensesSuccess():
return success(_that);case AccountingExpensesFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountingExpensesInitial value)?  initial,TResult? Function( AccountingExpensesLoading value)?  loading,TResult? Function( AccountingExpensesSuccess value)?  success,TResult? Function( AccountingExpensesFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AccountingExpensesInitial() when initial != null:
return initial(_that);case AccountingExpensesLoading() when loading != null:
return loading(_that);case AccountingExpensesSuccess() when success != null:
return success(_that);case AccountingExpensesFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AccountingExpenseEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountingExpensesInitial() when initial != null:
return initial();case AccountingExpensesLoading() when loading != null:
return loading();case AccountingExpensesSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingExpensesFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AccountingExpenseEntity> items,  bool isSaving,  String? errorMessage)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AccountingExpensesInitial():
return initial();case AccountingExpensesLoading():
return loading();case AccountingExpensesSuccess():
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingExpensesFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AccountingExpenseEntity> items,  bool isSaving,  String? errorMessage)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AccountingExpensesInitial() when initial != null:
return initial();case AccountingExpensesLoading() when loading != null:
return loading();case AccountingExpensesSuccess() when success != null:
return success(_that.items,_that.isSaving,_that.errorMessage);case AccountingExpensesFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AccountingExpensesInitial implements AccountingExpensesState {
  const AccountingExpensesInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingExpensesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingExpensesState.initial()';
}


}




/// @nodoc


class AccountingExpensesLoading implements AccountingExpensesState {
  const AccountingExpensesLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingExpensesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingExpensesState.loading()';
}


}




/// @nodoc


class AccountingExpensesSuccess implements AccountingExpensesState {
  const AccountingExpensesSuccess({required  List<AccountingExpenseEntity> items, this.isSaving = false, this.errorMessage}): _items = items;
  

 final  List<AccountingExpenseEntity> _items;
 List<AccountingExpenseEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool isSaving;
 final  String? errorMessage;

/// Create a copy of AccountingExpensesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingExpensesSuccessCopyWith<AccountingExpensesSuccess> get copyWith => _$AccountingExpensesSuccessCopyWithImpl<AccountingExpensesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingExpensesSuccess&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isSaving,errorMessage);
}

@override
String toString() {
    return 'AccountingExpensesState.success(items: $items, isSaving: $isSaving, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AccountingExpensesSuccessCopyWith<$Res> implements $AccountingExpensesStateCopyWith<$Res> {
  factory $AccountingExpensesSuccessCopyWith(AccountingExpensesSuccess value, $Res Function(AccountingExpensesSuccess) _then) = _$AccountingExpensesSuccessCopyWithImpl;
@useResult
$Res call({
 List<AccountingExpenseEntity> items, bool isSaving, String? errorMessage
});




}
/// @nodoc
class _$AccountingExpensesSuccessCopyWithImpl<$Res>
    implements $AccountingExpensesSuccessCopyWith<$Res> {
  _$AccountingExpensesSuccessCopyWithImpl(this._self, this._then);

  final AccountingExpensesSuccess _self;
  final $Res Function(AccountingExpensesSuccess) _then;

/// Create a copy of AccountingExpensesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isSaving = null,Object? errorMessage = freezed,}) {
  return _then(AccountingExpensesSuccess(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AccountingExpenseEntity>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AccountingExpensesFailure implements AccountingExpensesState {
  const AccountingExpensesFailure({required this.message});
  

 final  String message;

/// Create a copy of AccountingExpensesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingExpensesFailureCopyWith<AccountingExpensesFailure> get copyWith => _$AccountingExpensesFailureCopyWithImpl<AccountingExpensesFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingExpensesFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AccountingExpensesState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountingExpensesFailureCopyWith<$Res> implements $AccountingExpensesStateCopyWith<$Res> {
  factory $AccountingExpensesFailureCopyWith(AccountingExpensesFailure value, $Res Function(AccountingExpensesFailure) _then) = _$AccountingExpensesFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountingExpensesFailureCopyWithImpl<$Res>
    implements $AccountingExpensesFailureCopyWith<$Res> {
  _$AccountingExpensesFailureCopyWithImpl(this._self, this._then);

  final AccountingExpensesFailure _self;
  final $Res Function(AccountingExpensesFailure) _then;

/// Create a copy of AccountingExpensesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountingExpensesFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
