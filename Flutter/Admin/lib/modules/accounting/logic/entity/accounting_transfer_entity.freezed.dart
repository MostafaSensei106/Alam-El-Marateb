// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_transfer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingTransferEntity {

 String get id; num get amount; String? get fromId; String? get toId; DateTime? get at; String? get by;
/// Create a copy of AccountingTransferEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingTransferEntityCopyWith<AccountingTransferEntity> get copyWith => _$AccountingTransferEntityCopyWithImpl<AccountingTransferEntity>(this as AccountingTransferEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingTransferEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTransferEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.fromId, _this.fromId) || other.fromId == _this.fromId)&&(identical(other.toId, _this.toId) || other.toId == _this.toId)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.by, _this.by) || other.by == _this.by));
}


@override
int get hashCode {
  final _this = this as AccountingTransferEntity;
  return Object.hash(runtimeType,_this.id,_this.amount,_this.fromId,_this.toId,_this.at,_this.by);
}

@override
String toString() {
  final _this = this as AccountingTransferEntity;
  return 'AccountingTransferEntity(id: ${_this.id}, amount: ${_this.amount}, fromId: ${_this.fromId}, toId: ${_this.toId}, at: ${_this.at}, by: ${_this.by})';
}


}

/// @nodoc
abstract mixin class $AccountingTransferEntityCopyWith<$Res>  {
  factory $AccountingTransferEntityCopyWith(AccountingTransferEntity value, $Res Function(AccountingTransferEntity) _then) = _$AccountingTransferEntityCopyWithImpl;
@useResult
$Res call({
 String id, num amount, String? fromId, String? toId, DateTime? at, String? by
});




}
/// @nodoc
class _$AccountingTransferEntityCopyWithImpl<$Res>
    implements $AccountingTransferEntityCopyWith<$Res> {
  _$AccountingTransferEntityCopyWithImpl(this._self, this._then);

  final AccountingTransferEntity _self;
  final $Res Function(AccountingTransferEntity) _then;

/// Create a copy of AccountingTransferEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? fromId = freezed,Object? toId = freezed,Object? at = freezed,Object? by = freezed,}) {
  return _then(AccountingTransferEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,fromId: freezed == fromId ? _self.fromId : fromId // ignore: cast_nullable_to_non_nullable
as String?,toId: freezed == toId ? _self.toId : toId // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingTransferEntity].
extension AccountingTransferEntityPatterns on AccountingTransferEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingTransferEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingTransferEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingTransferEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingTransferEntity():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingTransferEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingTransferEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  num amount,  String? fromId,  String? toId,  DateTime? at,  String? by)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingTransferEntity() when $default != null:
return $default(_that.id,_that.amount,_that.fromId,_that.toId,_that.at,_that.by);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  num amount,  String? fromId,  String? toId,  DateTime? at,  String? by)  $default,) {final _that = this;
switch (_that) {
case _AccountingTransferEntity():
return $default(_that.id,_that.amount,_that.fromId,_that.toId,_that.at,_that.by);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  num amount,  String? fromId,  String? toId,  DateTime? at,  String? by)?  $default,) {final _that = this;
switch (_that) {
case _AccountingTransferEntity() when $default != null:
return $default(_that.id,_that.amount,_that.fromId,_that.toId,_that.at,_that.by);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingTransferEntity implements AccountingTransferEntity {
  const _AccountingTransferEntity({required this.id, required this.amount, this.fromId, this.toId, this.at, this.by});
  

@override final  String id;
@override final  num amount;
@override final  String? fromId;
@override final  String? toId;
@override final  DateTime? at;
@override final  String? by;

/// Create a copy of AccountingTransferEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingTransferEntityCopyWith<_AccountingTransferEntity> get copyWith => __$AccountingTransferEntityCopyWithImpl<_AccountingTransferEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingTransferEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.fromId, fromId) || other.fromId == fromId)&&(identical(other.toId, toId) || other.toId == toId)&&(identical(other.at, at) || other.at == at)&&(identical(other.by, by) || other.by == by));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,amount,fromId,toId,at,by);
}

@override
String toString() {
    return 'AccountingTransferEntity(id: $id, amount: $amount, fromId: $fromId, toId: $toId, at: $at, by: $by)';
}


}

/// @nodoc
abstract mixin class _$AccountingTransferEntityCopyWith<$Res> implements $AccountingTransferEntityCopyWith<$Res> {
  factory _$AccountingTransferEntityCopyWith(_AccountingTransferEntity value, $Res Function(_AccountingTransferEntity) _then) = __$AccountingTransferEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, num amount, String? fromId, String? toId, DateTime? at, String? by
});




}
/// @nodoc
class __$AccountingTransferEntityCopyWithImpl<$Res>
    implements _$AccountingTransferEntityCopyWith<$Res> {
  __$AccountingTransferEntityCopyWithImpl(this._self, this._then);

  final _AccountingTransferEntity _self;
  final $Res Function(_AccountingTransferEntity) _then;

/// Create a copy of AccountingTransferEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? fromId = freezed,Object? toId = freezed,Object? at = freezed,Object? by = freezed,}) {
  return _then(_AccountingTransferEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,fromId: freezed == fromId ? _self.fromId : fromId // ignore: cast_nullable_to_non_nullable
as String?,toId: freezed == toId ? _self.toId : toId // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
