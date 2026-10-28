// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_profit_loss_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingProfitLossEntity {

 DateTime get from; DateTime get to; num get revenue; num get cogs; num get expenses; num get netProfit; num get vatPortion;
/// Create a copy of AccountingProfitLossEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingProfitLossEntityCopyWith<AccountingProfitLossEntity> get copyWith => _$AccountingProfitLossEntityCopyWithImpl<AccountingProfitLossEntity>(this as AccountingProfitLossEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingProfitLossEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingProfitLossEntity&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.cogs, _this.cogs) || other.cogs == _this.cogs)&&(identical(other.expenses, _this.expenses) || other.expenses == _this.expenses)&&(identical(other.netProfit, _this.netProfit) || other.netProfit == _this.netProfit)&&(identical(other.vatPortion, _this.vatPortion) || other.vatPortion == _this.vatPortion));
}


@override
int get hashCode {
  final _this = this as AccountingProfitLossEntity;
  return Object.hash(runtimeType,_this.from,_this.to,_this.revenue,_this.cogs,_this.expenses,_this.netProfit,_this.vatPortion);
}

@override
String toString() {
  final _this = this as AccountingProfitLossEntity;
  return 'AccountingProfitLossEntity(from: ${_this.from}, to: ${_this.to}, revenue: ${_this.revenue}, cogs: ${_this.cogs}, expenses: ${_this.expenses}, netProfit: ${_this.netProfit}, vatPortion: ${_this.vatPortion})';
}


}

/// @nodoc
abstract mixin class $AccountingProfitLossEntityCopyWith<$Res>  {
  factory $AccountingProfitLossEntityCopyWith(AccountingProfitLossEntity value, $Res Function(AccountingProfitLossEntity) _then) = _$AccountingProfitLossEntityCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to, num revenue, num cogs, num expenses, num netProfit, num vatPortion
});




}
/// @nodoc
class _$AccountingProfitLossEntityCopyWithImpl<$Res>
    implements $AccountingProfitLossEntityCopyWith<$Res> {
  _$AccountingProfitLossEntityCopyWithImpl(this._self, this._then);

  final AccountingProfitLossEntity _self;
  final $Res Function(AccountingProfitLossEntity) _then;

/// Create a copy of AccountingProfitLossEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? revenue = null,Object? cogs = null,Object? expenses = null,Object? netProfit = null,Object? vatPortion = null,}) {
  return _then(AccountingProfitLossEntity(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as num,cogs: null == cogs ? _self.cogs : cogs // ignore: cast_nullable_to_non_nullable
as num,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as num,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as num,vatPortion: null == vatPortion ? _self.vatPortion : vatPortion // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingProfitLossEntity].
extension AccountingProfitLossEntityPatterns on AccountingProfitLossEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingProfitLossEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingProfitLossEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingProfitLossEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingProfitLossEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingProfitLossEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingProfitLossEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  num revenue,  num cogs,  num expenses,  num netProfit,  num vatPortion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingProfitLossEntity() when $default != null:
return $default(_that.from,_that.to,_that.revenue,_that.cogs,_that.expenses,_that.netProfit,_that.vatPortion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  num revenue,  num cogs,  num expenses,  num netProfit,  num vatPortion)  $default,) {final _that = this;
switch (_that) {
case _AccountingProfitLossEntity():
return $default(_that.from,_that.to,_that.revenue,_that.cogs,_that.expenses,_that.netProfit,_that.vatPortion);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to,  num revenue,  num cogs,  num expenses,  num netProfit,  num vatPortion)?  $default,) {final _that = this;
switch (_that) {
case _AccountingProfitLossEntity() when $default != null:
return $default(_that.from,_that.to,_that.revenue,_that.cogs,_that.expenses,_that.netProfit,_that.vatPortion);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingProfitLossEntity extends AccountingProfitLossEntity {
  const _AccountingProfitLossEntity({required this.from, required this.to, required this.revenue, required this.cogs, required this.expenses, required this.netProfit, required this.vatPortion}): super._();
  

@override final  DateTime from;
@override final  DateTime to;
@override final  num revenue;
@override final  num cogs;
@override final  num expenses;
@override final  num netProfit;
@override final  num vatPortion;

/// Create a copy of AccountingProfitLossEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingProfitLossEntityCopyWith<_AccountingProfitLossEntity> get copyWith => __$AccountingProfitLossEntityCopyWithImpl<_AccountingProfitLossEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingProfitLossEntity&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.cogs, cogs) || other.cogs == cogs)&&(identical(other.expenses, expenses) || other.expenses == expenses)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit)&&(identical(other.vatPortion, vatPortion) || other.vatPortion == vatPortion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,from,to,revenue,cogs,expenses,netProfit,vatPortion);
}

@override
String toString() {
    return 'AccountingProfitLossEntity(from: $from, to: $to, revenue: $revenue, cogs: $cogs, expenses: $expenses, netProfit: $netProfit, vatPortion: $vatPortion)';
}


}

/// @nodoc
abstract mixin class _$AccountingProfitLossEntityCopyWith<$Res> implements $AccountingProfitLossEntityCopyWith<$Res> {
  factory _$AccountingProfitLossEntityCopyWith(_AccountingProfitLossEntity value, $Res Function(_AccountingProfitLossEntity) _then) = __$AccountingProfitLossEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to, num revenue, num cogs, num expenses, num netProfit, num vatPortion
});




}
/// @nodoc
class __$AccountingProfitLossEntityCopyWithImpl<$Res>
    implements _$AccountingProfitLossEntityCopyWith<$Res> {
  __$AccountingProfitLossEntityCopyWithImpl(this._self, this._then);

  final _AccountingProfitLossEntity _self;
  final $Res Function(_AccountingProfitLossEntity) _then;

/// Create a copy of AccountingProfitLossEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? revenue = null,Object? cogs = null,Object? expenses = null,Object? netProfit = null,Object? vatPortion = null,}) {
  return _then(_AccountingProfitLossEntity(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as num,cogs: null == cogs ? _self.cogs : cogs // ignore: cast_nullable_to_non_nullable
as num,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as num,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as num,vatPortion: null == vatPortion ? _self.vatPortion : vatPortion // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
