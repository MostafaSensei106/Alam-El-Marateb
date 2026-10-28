// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_check_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingCheckEntity {

 String get id; CheckDirection get direction; num get amount; CheckStatus get status; DateTime get createdAt; DateTime? get dueDate; String? get party;
/// Create a copy of AccountingCheckEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingCheckEntityCopyWith<AccountingCheckEntity> get copyWith => _$AccountingCheckEntityCopyWithImpl<AccountingCheckEntity>(this as AccountingCheckEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingCheckEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingCheckEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.party, _this.party) || other.party == _this.party));
}


@override
int get hashCode {
  final _this = this as AccountingCheckEntity;
  return Object.hash(runtimeType,_this.id,_this.direction,_this.amount,_this.status,_this.createdAt,_this.dueDate,_this.party);
}

@override
String toString() {
  final _this = this as AccountingCheckEntity;
  return 'AccountingCheckEntity(id: ${_this.id}, direction: ${_this.direction}, amount: ${_this.amount}, status: ${_this.status}, createdAt: ${_this.createdAt}, dueDate: ${_this.dueDate}, party: ${_this.party})';
}


}

/// @nodoc
abstract mixin class $AccountingCheckEntityCopyWith<$Res>  {
  factory $AccountingCheckEntityCopyWith(AccountingCheckEntity value, $Res Function(AccountingCheckEntity) _then) = _$AccountingCheckEntityCopyWithImpl;
@useResult
$Res call({
 String id, CheckDirection direction, num amount, CheckStatus status, DateTime createdAt, DateTime? dueDate, String? party
});




}
/// @nodoc
class _$AccountingCheckEntityCopyWithImpl<$Res>
    implements $AccountingCheckEntityCopyWith<$Res> {
  _$AccountingCheckEntityCopyWithImpl(this._self, this._then);

  final AccountingCheckEntity _self;
  final $Res Function(AccountingCheckEntity) _then;

/// Create a copy of AccountingCheckEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? direction = null,Object? amount = null,Object? status = null,Object? createdAt = null,Object? dueDate = freezed,Object? party = freezed,}) {
  return _then(AccountingCheckEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as CheckDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CheckStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,party: freezed == party ? _self.party : party // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingCheckEntity].
extension AccountingCheckEntityPatterns on AccountingCheckEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingCheckEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingCheckEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingCheckEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingCheckEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingCheckEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingCheckEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CheckDirection direction,  num amount,  CheckStatus status,  DateTime createdAt,  DateTime? dueDate,  String? party)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingCheckEntity() when $default != null:
return $default(_that.id,_that.direction,_that.amount,_that.status,_that.createdAt,_that.dueDate,_that.party);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CheckDirection direction,  num amount,  CheckStatus status,  DateTime createdAt,  DateTime? dueDate,  String? party)  $default,) {final _that = this;
switch (_that) {
case _AccountingCheckEntity():
return $default(_that.id,_that.direction,_that.amount,_that.status,_that.createdAt,_that.dueDate,_that.party);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CheckDirection direction,  num amount,  CheckStatus status,  DateTime createdAt,  DateTime? dueDate,  String? party)?  $default,) {final _that = this;
switch (_that) {
case _AccountingCheckEntity() when $default != null:
return $default(_that.id,_that.direction,_that.amount,_that.status,_that.createdAt,_that.dueDate,_that.party);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingCheckEntity implements AccountingCheckEntity {
  const _AccountingCheckEntity({required this.id, required this.direction, required this.amount, required this.status, required this.createdAt, this.dueDate, this.party});
  

@override final  String id;
@override final  CheckDirection direction;
@override final  num amount;
@override final  CheckStatus status;
@override final  DateTime createdAt;
@override final  DateTime? dueDate;
@override final  String? party;

/// Create a copy of AccountingCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingCheckEntityCopyWith<_AccountingCheckEntity> get copyWith => __$AccountingCheckEntityCopyWithImpl<_AccountingCheckEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingCheckEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.party, party) || other.party == party));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,direction,amount,status,createdAt,dueDate,party);
}

@override
String toString() {
    return 'AccountingCheckEntity(id: $id, direction: $direction, amount: $amount, status: $status, createdAt: $createdAt, dueDate: $dueDate, party: $party)';
}


}

/// @nodoc
abstract mixin class _$AccountingCheckEntityCopyWith<$Res> implements $AccountingCheckEntityCopyWith<$Res> {
  factory _$AccountingCheckEntityCopyWith(_AccountingCheckEntity value, $Res Function(_AccountingCheckEntity) _then) = __$AccountingCheckEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, CheckDirection direction, num amount, CheckStatus status, DateTime createdAt, DateTime? dueDate, String? party
});




}
/// @nodoc
class __$AccountingCheckEntityCopyWithImpl<$Res>
    implements _$AccountingCheckEntityCopyWith<$Res> {
  __$AccountingCheckEntityCopyWithImpl(this._self, this._then);

  final _AccountingCheckEntity _self;
  final $Res Function(_AccountingCheckEntity) _then;

/// Create a copy of AccountingCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? direction = null,Object? amount = null,Object? status = null,Object? createdAt = null,Object? dueDate = freezed,Object? party = freezed,}) {
  return _then(_AccountingCheckEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as CheckDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CheckStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,party: freezed == party ? _self.party : party // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
