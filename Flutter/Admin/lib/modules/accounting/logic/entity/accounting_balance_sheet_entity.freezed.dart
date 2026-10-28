// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_balance_sheet_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingBalanceSheetEntity {

 DateTime get asOf; num get assets; num get liabilities; num get equity;
/// Create a copy of AccountingBalanceSheetEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingBalanceSheetEntityCopyWith<AccountingBalanceSheetEntity> get copyWith => _$AccountingBalanceSheetEntityCopyWithImpl<AccountingBalanceSheetEntity>(this as AccountingBalanceSheetEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingBalanceSheetEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingBalanceSheetEntity&&(identical(other.asOf, _this.asOf) || other.asOf == _this.asOf)&&(identical(other.assets, _this.assets) || other.assets == _this.assets)&&(identical(other.liabilities, _this.liabilities) || other.liabilities == _this.liabilities)&&(identical(other.equity, _this.equity) || other.equity == _this.equity));
}


@override
int get hashCode {
  final _this = this as AccountingBalanceSheetEntity;
  return Object.hash(runtimeType,_this.asOf,_this.assets,_this.liabilities,_this.equity);
}

@override
String toString() {
  final _this = this as AccountingBalanceSheetEntity;
  return 'AccountingBalanceSheetEntity(asOf: ${_this.asOf}, assets: ${_this.assets}, liabilities: ${_this.liabilities}, equity: ${_this.equity})';
}


}

/// @nodoc
abstract mixin class $AccountingBalanceSheetEntityCopyWith<$Res>  {
  factory $AccountingBalanceSheetEntityCopyWith(AccountingBalanceSheetEntity value, $Res Function(AccountingBalanceSheetEntity) _then) = _$AccountingBalanceSheetEntityCopyWithImpl;
@useResult
$Res call({
 DateTime asOf, num assets, num liabilities, num equity
});




}
/// @nodoc
class _$AccountingBalanceSheetEntityCopyWithImpl<$Res>
    implements $AccountingBalanceSheetEntityCopyWith<$Res> {
  _$AccountingBalanceSheetEntityCopyWithImpl(this._self, this._then);

  final AccountingBalanceSheetEntity _self;
  final $Res Function(AccountingBalanceSheetEntity) _then;

/// Create a copy of AccountingBalanceSheetEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asOf = null,Object? assets = null,Object? liabilities = null,Object? equity = null,}) {
  return _then(AccountingBalanceSheetEntity(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as num,liabilities: null == liabilities ? _self.liabilities : liabilities // ignore: cast_nullable_to_non_nullable
as num,equity: null == equity ? _self.equity : equity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingBalanceSheetEntity].
extension AccountingBalanceSheetEntityPatterns on AccountingBalanceSheetEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingBalanceSheetEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingBalanceSheetEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingBalanceSheetEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingBalanceSheetEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingBalanceSheetEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingBalanceSheetEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime asOf,  num assets,  num liabilities,  num equity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingBalanceSheetEntity() when $default != null:
return $default(_that.asOf,_that.assets,_that.liabilities,_that.equity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime asOf,  num assets,  num liabilities,  num equity)  $default,) {final _that = this;
switch (_that) {
case _AccountingBalanceSheetEntity():
return $default(_that.asOf,_that.assets,_that.liabilities,_that.equity);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime asOf,  num assets,  num liabilities,  num equity)?  $default,) {final _that = this;
switch (_that) {
case _AccountingBalanceSheetEntity() when $default != null:
return $default(_that.asOf,_that.assets,_that.liabilities,_that.equity);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingBalanceSheetEntity extends AccountingBalanceSheetEntity {
  const _AccountingBalanceSheetEntity({required this.asOf, required this.assets, required this.liabilities, required this.equity}): super._();
  

@override final  DateTime asOf;
@override final  num assets;
@override final  num liabilities;
@override final  num equity;

/// Create a copy of AccountingBalanceSheetEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingBalanceSheetEntityCopyWith<_AccountingBalanceSheetEntity> get copyWith => __$AccountingBalanceSheetEntityCopyWithImpl<_AccountingBalanceSheetEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingBalanceSheetEntity&&(identical(other.asOf, asOf) || other.asOf == asOf)&&(identical(other.assets, assets) || other.assets == assets)&&(identical(other.liabilities, liabilities) || other.liabilities == liabilities)&&(identical(other.equity, equity) || other.equity == equity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,asOf,assets,liabilities,equity);
}

@override
String toString() {
    return 'AccountingBalanceSheetEntity(asOf: $asOf, assets: $assets, liabilities: $liabilities, equity: $equity)';
}


}

/// @nodoc
abstract mixin class _$AccountingBalanceSheetEntityCopyWith<$Res> implements $AccountingBalanceSheetEntityCopyWith<$Res> {
  factory _$AccountingBalanceSheetEntityCopyWith(_AccountingBalanceSheetEntity value, $Res Function(_AccountingBalanceSheetEntity) _then) = __$AccountingBalanceSheetEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime asOf, num assets, num liabilities, num equity
});




}
/// @nodoc
class __$AccountingBalanceSheetEntityCopyWithImpl<$Res>
    implements _$AccountingBalanceSheetEntityCopyWith<$Res> {
  __$AccountingBalanceSheetEntityCopyWithImpl(this._self, this._then);

  final _AccountingBalanceSheetEntity _self;
  final $Res Function(_AccountingBalanceSheetEntity) _then;

/// Create a copy of AccountingBalanceSheetEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asOf = null,Object? assets = null,Object? liabilities = null,Object? equity = null,}) {
  return _then(_AccountingBalanceSheetEntity(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as num,liabilities: null == liabilities ? _self.liabilities : liabilities // ignore: cast_nullable_to_non_nullable
as num,equity: null == equity ? _self.equity : equity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
