// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_tax_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingTaxReportEntity {

 DateTime get from; DateTime get to; num get revenueInclusive; num get vatPortion; num get purchasesInclusive; num get inputVat; num get netVatPayable;
/// Create a copy of AccountingTaxReportEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingTaxReportEntityCopyWith<AccountingTaxReportEntity> get copyWith => _$AccountingTaxReportEntityCopyWithImpl<AccountingTaxReportEntity>(this as AccountingTaxReportEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingTaxReportEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingTaxReportEntity&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.revenueInclusive, _this.revenueInclusive) || other.revenueInclusive == _this.revenueInclusive)&&(identical(other.vatPortion, _this.vatPortion) || other.vatPortion == _this.vatPortion)&&(identical(other.purchasesInclusive, _this.purchasesInclusive) || other.purchasesInclusive == _this.purchasesInclusive)&&(identical(other.inputVat, _this.inputVat) || other.inputVat == _this.inputVat)&&(identical(other.netVatPayable, _this.netVatPayable) || other.netVatPayable == _this.netVatPayable));
}


@override
int get hashCode {
  final _this = this as AccountingTaxReportEntity;
  return Object.hash(runtimeType,_this.from,_this.to,_this.revenueInclusive,_this.vatPortion,_this.purchasesInclusive,_this.inputVat,_this.netVatPayable);
}

@override
String toString() {
  final _this = this as AccountingTaxReportEntity;
  return 'AccountingTaxReportEntity(from: ${_this.from}, to: ${_this.to}, revenueInclusive: ${_this.revenueInclusive}, vatPortion: ${_this.vatPortion}, purchasesInclusive: ${_this.purchasesInclusive}, inputVat: ${_this.inputVat}, netVatPayable: ${_this.netVatPayable})';
}


}

/// @nodoc
abstract mixin class $AccountingTaxReportEntityCopyWith<$Res>  {
  factory $AccountingTaxReportEntityCopyWith(AccountingTaxReportEntity value, $Res Function(AccountingTaxReportEntity) _then) = _$AccountingTaxReportEntityCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to, num revenueInclusive, num vatPortion, num purchasesInclusive, num inputVat, num netVatPayable
});




}
/// @nodoc
class _$AccountingTaxReportEntityCopyWithImpl<$Res>
    implements $AccountingTaxReportEntityCopyWith<$Res> {
  _$AccountingTaxReportEntityCopyWithImpl(this._self, this._then);

  final AccountingTaxReportEntity _self;
  final $Res Function(AccountingTaxReportEntity) _then;

/// Create a copy of AccountingTaxReportEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? revenueInclusive = null,Object? vatPortion = null,Object? purchasesInclusive = null,Object? inputVat = null,Object? netVatPayable = null,}) {
  return _then(AccountingTaxReportEntity(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,revenueInclusive: null == revenueInclusive ? _self.revenueInclusive : revenueInclusive // ignore: cast_nullable_to_non_nullable
as num,vatPortion: null == vatPortion ? _self.vatPortion : vatPortion // ignore: cast_nullable_to_non_nullable
as num,purchasesInclusive: null == purchasesInclusive ? _self.purchasesInclusive : purchasesInclusive // ignore: cast_nullable_to_non_nullable
as num,inputVat: null == inputVat ? _self.inputVat : inputVat // ignore: cast_nullable_to_non_nullable
as num,netVatPayable: null == netVatPayable ? _self.netVatPayable : netVatPayable // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingTaxReportEntity].
extension AccountingTaxReportEntityPatterns on AccountingTaxReportEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingTaxReportEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingTaxReportEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingTaxReportEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingTaxReportEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingTaxReportEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingTaxReportEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  num revenueInclusive,  num vatPortion,  num purchasesInclusive,  num inputVat,  num netVatPayable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingTaxReportEntity() when $default != null:
return $default(_that.from,_that.to,_that.revenueInclusive,_that.vatPortion,_that.purchasesInclusive,_that.inputVat,_that.netVatPayable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  num revenueInclusive,  num vatPortion,  num purchasesInclusive,  num inputVat,  num netVatPayable)  $default,) {final _that = this;
switch (_that) {
case _AccountingTaxReportEntity():
return $default(_that.from,_that.to,_that.revenueInclusive,_that.vatPortion,_that.purchasesInclusive,_that.inputVat,_that.netVatPayable);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to,  num revenueInclusive,  num vatPortion,  num purchasesInclusive,  num inputVat,  num netVatPayable)?  $default,) {final _that = this;
switch (_that) {
case _AccountingTaxReportEntity() when $default != null:
return $default(_that.from,_that.to,_that.revenueInclusive,_that.vatPortion,_that.purchasesInclusive,_that.inputVat,_that.netVatPayable);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingTaxReportEntity implements AccountingTaxReportEntity {
  const _AccountingTaxReportEntity({required this.from, required this.to, required this.revenueInclusive, required this.vatPortion, required this.purchasesInclusive, required this.inputVat, required this.netVatPayable});
  

@override final  DateTime from;
@override final  DateTime to;
@override final  num revenueInclusive;
@override final  num vatPortion;
@override final  num purchasesInclusive;
@override final  num inputVat;
@override final  num netVatPayable;

/// Create a copy of AccountingTaxReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingTaxReportEntityCopyWith<_AccountingTaxReportEntity> get copyWith => __$AccountingTaxReportEntityCopyWithImpl<_AccountingTaxReportEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingTaxReportEntity&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.revenueInclusive, revenueInclusive) || other.revenueInclusive == revenueInclusive)&&(identical(other.vatPortion, vatPortion) || other.vatPortion == vatPortion)&&(identical(other.purchasesInclusive, purchasesInclusive) || other.purchasesInclusive == purchasesInclusive)&&(identical(other.inputVat, inputVat) || other.inputVat == inputVat)&&(identical(other.netVatPayable, netVatPayable) || other.netVatPayable == netVatPayable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,from,to,revenueInclusive,vatPortion,purchasesInclusive,inputVat,netVatPayable);
}

@override
String toString() {
    return 'AccountingTaxReportEntity(from: $from, to: $to, revenueInclusive: $revenueInclusive, vatPortion: $vatPortion, purchasesInclusive: $purchasesInclusive, inputVat: $inputVat, netVatPayable: $netVatPayable)';
}


}

/// @nodoc
abstract mixin class _$AccountingTaxReportEntityCopyWith<$Res> implements $AccountingTaxReportEntityCopyWith<$Res> {
  factory _$AccountingTaxReportEntityCopyWith(_AccountingTaxReportEntity value, $Res Function(_AccountingTaxReportEntity) _then) = __$AccountingTaxReportEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to, num revenueInclusive, num vatPortion, num purchasesInclusive, num inputVat, num netVatPayable
});




}
/// @nodoc
class __$AccountingTaxReportEntityCopyWithImpl<$Res>
    implements _$AccountingTaxReportEntityCopyWith<$Res> {
  __$AccountingTaxReportEntityCopyWithImpl(this._self, this._then);

  final _AccountingTaxReportEntity _self;
  final $Res Function(_AccountingTaxReportEntity) _then;

/// Create a copy of AccountingTaxReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? revenueInclusive = null,Object? vatPortion = null,Object? purchasesInclusive = null,Object? inputVat = null,Object? netVatPayable = null,}) {
  return _then(_AccountingTaxReportEntity(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,revenueInclusive: null == revenueInclusive ? _self.revenueInclusive : revenueInclusive // ignore: cast_nullable_to_non_nullable
as num,vatPortion: null == vatPortion ? _self.vatPortion : vatPortion // ignore: cast_nullable_to_non_nullable
as num,purchasesInclusive: null == purchasesInclusive ? _self.purchasesInclusive : purchasesInclusive // ignore: cast_nullable_to_non_nullable
as num,inputVat: null == inputVat ? _self.inputVat : inputVat // ignore: cast_nullable_to_non_nullable
as num,netVatPayable: null == netVatPayable ? _self.netVatPayable : netVatPayable // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
