// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_treasury_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingTreasuryEntity {

 String get id; String get name; num get balance; String? get branchId;
/// Create a copy of AccountingTreasuryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingTreasuryEntityCopyWith<AccountingTreasuryEntity> get copyWith => _$AccountingTreasuryEntityCopyWithImpl<AccountingTreasuryEntity>(this as AccountingTreasuryEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingTreasuryEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTreasuryEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId));
}


@override
int get hashCode {
  final _this = this as AccountingTreasuryEntity;
  return Object.hash(runtimeType,_this.id,_this.name,_this.balance,_this.branchId);
}

@override
String toString() {
  final _this = this as AccountingTreasuryEntity;
  return 'AccountingTreasuryEntity(id: ${_this.id}, name: ${_this.name}, balance: ${_this.balance}, branchId: ${_this.branchId})';
}


}

/// @nodoc
abstract mixin class $AccountingTreasuryEntityCopyWith<$Res>  {
  factory $AccountingTreasuryEntityCopyWith(AccountingTreasuryEntity value, $Res Function(AccountingTreasuryEntity) _then) = _$AccountingTreasuryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, num balance, String? branchId
});




}
/// @nodoc
class _$AccountingTreasuryEntityCopyWithImpl<$Res>
    implements $AccountingTreasuryEntityCopyWith<$Res> {
  _$AccountingTreasuryEntityCopyWithImpl(this._self, this._then);

  final AccountingTreasuryEntity _self;
  final $Res Function(AccountingTreasuryEntity) _then;

/// Create a copy of AccountingTreasuryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? branchId = freezed,}) {
  return _then(AccountingTreasuryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingTreasuryEntity].
extension AccountingTreasuryEntityPatterns on AccountingTreasuryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingTreasuryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingTreasuryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingTreasuryEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingTreasuryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingTreasuryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingTreasuryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  num balance,  String? branchId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingTreasuryEntity() when $default != null:
return $default(_that.id,_that.name,_that.balance,_that.branchId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  num balance,  String? branchId)  $default,) {final _that = this;
switch (_that) {
case _AccountingTreasuryEntity():
return $default(_that.id,_that.name,_that.balance,_that.branchId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  num balance,  String? branchId)?  $default,) {final _that = this;
switch (_that) {
case _AccountingTreasuryEntity() when $default != null:
return $default(_that.id,_that.name,_that.balance,_that.branchId);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingTreasuryEntity implements AccountingTreasuryEntity {
  const _AccountingTreasuryEntity({required this.id, required this.name, required this.balance, this.branchId});
  

@override final  String id;
@override final  String name;
@override final  num balance;
@override final  String? branchId;

/// Create a copy of AccountingTreasuryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingTreasuryEntityCopyWith<_AccountingTreasuryEntity> get copyWith => __$AccountingTreasuryEntityCopyWithImpl<_AccountingTreasuryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingTreasuryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.branchId, branchId) || other.branchId == branchId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,balance,branchId);
}

@override
String toString() {
    return 'AccountingTreasuryEntity(id: $id, name: $name, balance: $balance, branchId: $branchId)';
}


}

/// @nodoc
abstract mixin class _$AccountingTreasuryEntityCopyWith<$Res> implements $AccountingTreasuryEntityCopyWith<$Res> {
  factory _$AccountingTreasuryEntityCopyWith(_AccountingTreasuryEntity value, $Res Function(_AccountingTreasuryEntity) _then) = __$AccountingTreasuryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, num balance, String? branchId
});




}
/// @nodoc
class __$AccountingTreasuryEntityCopyWithImpl<$Res>
    implements _$AccountingTreasuryEntityCopyWith<$Res> {
  __$AccountingTreasuryEntityCopyWithImpl(this._self, this._then);

  final _AccountingTreasuryEntity _self;
  final $Res Function(_AccountingTreasuryEntity) _then;

/// Create a copy of AccountingTreasuryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? branchId = freezed,}) {
  return _then(_AccountingTreasuryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
