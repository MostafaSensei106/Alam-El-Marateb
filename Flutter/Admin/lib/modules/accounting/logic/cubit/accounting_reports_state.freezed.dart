// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_reports_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingReportsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingReportsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingReportsState()';
}


}

/// @nodoc
class $AccountingReportsStateCopyWith<$Res>  {
$AccountingReportsStateCopyWith(AccountingReportsState _, $Res Function(AccountingReportsState) __);
}


/// Adds pattern-matching-related methods to [AccountingReportsState].
extension AccountingReportsStatePatterns on AccountingReportsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Failure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( DateTime from,  DateTime to,  AccountingProfitLossEntity profitLoss,  AccountingBalanceSheetEntity balanceSheet,  AccountingTaxReportEntity taxReport)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.from,_that.to,_that.profitLoss,_that.balanceSheet,_that.taxReport);case _Failure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( DateTime from,  DateTime to,  AccountingProfitLossEntity profitLoss,  AccountingBalanceSheetEntity balanceSheet,  AccountingTaxReportEntity taxReport)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success(_that.from,_that.to,_that.profitLoss,_that.balanceSheet,_that.taxReport);case _Failure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( DateTime from,  DateTime to,  AccountingProfitLossEntity profitLoss,  AccountingBalanceSheetEntity balanceSheet,  AccountingTaxReportEntity taxReport)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.from,_that.to,_that.profitLoss,_that.balanceSheet,_that.taxReport);case _Failure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AccountingReportsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingReportsState.initial()';
}


}




/// @nodoc


class _Loading implements AccountingReportsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountingReportsState.loading()';
}


}




/// @nodoc


class _Success implements AccountingReportsState {
  const _Success({required this.from, required this.to, required this.profitLoss, required this.balanceSheet, required this.taxReport});
  

 final  DateTime from;
 final  DateTime to;
 final  AccountingProfitLossEntity profitLoss;
 final  AccountingBalanceSheetEntity balanceSheet;
 final  AccountingTaxReportEntity taxReport;

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.profitLoss, profitLoss) || other.profitLoss == profitLoss)&&(identical(other.balanceSheet, balanceSheet) || other.balanceSheet == balanceSheet)&&(identical(other.taxReport, taxReport) || other.taxReport == taxReport));
}


@override
int get hashCode {
    return Object.hash(runtimeType,from,to,profitLoss,balanceSheet,taxReport);
}

@override
String toString() {
    return 'AccountingReportsState.success(from: $from, to: $to, profitLoss: $profitLoss, balanceSheet: $balanceSheet, taxReport: $taxReport)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $AccountingReportsStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to, AccountingProfitLossEntity profitLoss, AccountingBalanceSheetEntity balanceSheet, AccountingTaxReportEntity taxReport
});


$AccountingProfitLossEntityCopyWith<$Res> get profitLoss;$AccountingBalanceSheetEntityCopyWith<$Res> get balanceSheet;$AccountingTaxReportEntityCopyWith<$Res> get taxReport;

}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? profitLoss = null,Object? balanceSheet = null,Object? taxReport = null,}) {
  return _then(_Success(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,profitLoss: null == profitLoss ? _self.profitLoss : profitLoss // ignore: cast_nullable_to_non_nullable
as AccountingProfitLossEntity,balanceSheet: null == balanceSheet ? _self.balanceSheet : balanceSheet // ignore: cast_nullable_to_non_nullable
as AccountingBalanceSheetEntity,taxReport: null == taxReport ? _self.taxReport : taxReport // ignore: cast_nullable_to_non_nullable
as AccountingTaxReportEntity,
  ));
}

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountingProfitLossEntityCopyWith<$Res> get profitLoss {
  
  return $AccountingProfitLossEntityCopyWith<$Res>(_self.profitLoss, (value) {
    return _then(_self.copyWith(profitLoss: value));
  });
}/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountingBalanceSheetEntityCopyWith<$Res> get balanceSheet {
  
  return $AccountingBalanceSheetEntityCopyWith<$Res>(_self.balanceSheet, (value) {
    return _then(_self.copyWith(balanceSheet: value));
  });
}/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountingTaxReportEntityCopyWith<$Res> get taxReport {
  
  return $AccountingTaxReportEntityCopyWith<$Res>(_self.taxReport, (value) {
    return _then(_self.copyWith(taxReport: value));
  });
}
}

/// @nodoc


class _Failure implements AccountingReportsState {
  const _Failure({required this.message});
  

 final  String message;

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AccountingReportsState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $AccountingReportsStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
