// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_account_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingAccountEntity {

 String get code; String get name; AccountType get type; num get balance; String? get parentCode; String? get branchId;
/// Create a copy of AccountingAccountEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingAccountEntityCopyWith<AccountingAccountEntity> get copyWith => _$AccountingAccountEntityCopyWithImpl<AccountingAccountEntity>(this as AccountingAccountEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingAccountEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingAccountEntity&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.parentCode, _this.parentCode) || other.parentCode == _this.parentCode)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId));
}


@override
int get hashCode {
  final _this = this as AccountingAccountEntity;
  return Object.hash(runtimeType,_this.code,_this.name,_this.type,_this.balance,_this.parentCode,_this.branchId);
}

@override
String toString() {
  final _this = this as AccountingAccountEntity;
  return 'AccountingAccountEntity(code: ${_this.code}, name: ${_this.name}, type: ${_this.type}, balance: ${_this.balance}, parentCode: ${_this.parentCode}, branchId: ${_this.branchId})';
}


}

/// @nodoc
abstract mixin class $AccountingAccountEntityCopyWith<$Res>  {
  factory $AccountingAccountEntityCopyWith(AccountingAccountEntity value, $Res Function(AccountingAccountEntity) _then) = _$AccountingAccountEntityCopyWithImpl;
@useResult
$Res call({
 String code, String name, AccountType type, num balance, String? parentCode, String? branchId
});




}
/// @nodoc
class _$AccountingAccountEntityCopyWithImpl<$Res>
    implements $AccountingAccountEntityCopyWith<$Res> {
  _$AccountingAccountEntityCopyWithImpl(this._self, this._then);

  final AccountingAccountEntity _self;
  final $Res Function(AccountingAccountEntity) _then;

/// Create a copy of AccountingAccountEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? type = null,Object? balance = null,Object? parentCode = freezed,Object? branchId = freezed,}) {
  return _then(AccountingAccountEntity(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num,parentCode: freezed == parentCode ? _self.parentCode : parentCode // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingAccountEntity].
extension AccountingAccountEntityPatterns on AccountingAccountEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingAccountEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingAccountEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingAccountEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingAccountEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingAccountEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingAccountEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  AccountType type,  num balance,  String? parentCode,  String? branchId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingAccountEntity() when $default != null:
return $default(_that.code,_that.name,_that.type,_that.balance,_that.parentCode,_that.branchId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  AccountType type,  num balance,  String? parentCode,  String? branchId)  $default,) {final _that = this;
switch (_that) {
case _AccountingAccountEntity():
return $default(_that.code,_that.name,_that.type,_that.balance,_that.parentCode,_that.branchId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  AccountType type,  num balance,  String? parentCode,  String? branchId)?  $default,) {final _that = this;
switch (_that) {
case _AccountingAccountEntity() when $default != null:
return $default(_that.code,_that.name,_that.type,_that.balance,_that.parentCode,_that.branchId);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingAccountEntity extends AccountingAccountEntity {
  const _AccountingAccountEntity({required this.code, required this.name, required this.type, required this.balance, this.parentCode, this.branchId}): super._();
  

@override final  String code;
@override final  String name;
@override final  AccountType type;
@override final  num balance;
@override final  String? parentCode;
@override final  String? branchId;

/// Create a copy of AccountingAccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingAccountEntityCopyWith<_AccountingAccountEntity> get copyWith => __$AccountingAccountEntityCopyWithImpl<_AccountingAccountEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingAccountEntity&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.parentCode, parentCode) || other.parentCode == parentCode)&&(identical(other.branchId, branchId) || other.branchId == branchId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,name,type,balance,parentCode,branchId);
}

@override
String toString() {
    return 'AccountingAccountEntity(code: $code, name: $name, type: $type, balance: $balance, parentCode: $parentCode, branchId: $branchId)';
}


}

/// @nodoc
abstract mixin class _$AccountingAccountEntityCopyWith<$Res> implements $AccountingAccountEntityCopyWith<$Res> {
  factory _$AccountingAccountEntityCopyWith(_AccountingAccountEntity value, $Res Function(_AccountingAccountEntity) _then) = __$AccountingAccountEntityCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, AccountType type, num balance, String? parentCode, String? branchId
});




}
/// @nodoc
class __$AccountingAccountEntityCopyWithImpl<$Res>
    implements _$AccountingAccountEntityCopyWith<$Res> {
  __$AccountingAccountEntityCopyWithImpl(this._self, this._then);

  final _AccountingAccountEntity _self;
  final $Res Function(_AccountingAccountEntity) _then;

/// Create a copy of AccountingAccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? type = null,Object? balance = null,Object? parentCode = freezed,Object? branchId = freezed,}) {
  return _then(_AccountingAccountEntity(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num,parentCode: freezed == parentCode ? _self.parentCode : parentCode // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
