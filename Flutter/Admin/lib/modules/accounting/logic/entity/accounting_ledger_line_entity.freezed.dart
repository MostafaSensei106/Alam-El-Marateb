// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_ledger_line_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingLedgerLineEntity {

 JournalSource get source; String get accountCode; String get accountName; num get debit; num get credit; num get runningBalance; String? get entryId; DateTime? get entryDate; String? get reference;
/// Create a copy of AccountingLedgerLineEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingLedgerLineEntityCopyWith<AccountingLedgerLineEntity> get copyWith => _$AccountingLedgerLineEntityCopyWithImpl<AccountingLedgerLineEntity>(this as AccountingLedgerLineEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingLedgerLineEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingLedgerLineEntity&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.accountCode, _this.accountCode) || other.accountCode == _this.accountCode)&&(identical(other.accountName, _this.accountName) || other.accountName == _this.accountName)&&(identical(other.debit, _this.debit) || other.debit == _this.debit)&&(identical(other.credit, _this.credit) || other.credit == _this.credit)&&(identical(other.runningBalance, _this.runningBalance) || other.runningBalance == _this.runningBalance)&&(identical(other.entryId, _this.entryId) || other.entryId == _this.entryId)&&(identical(other.entryDate, _this.entryDate) || other.entryDate == _this.entryDate)&&(identical(other.reference, _this.reference) || other.reference == _this.reference));
}


@override
int get hashCode {
  final _this = this as AccountingLedgerLineEntity;
  return Object.hash(runtimeType,_this.source,_this.accountCode,_this.accountName,_this.debit,_this.credit,_this.runningBalance,_this.entryId,_this.entryDate,_this.reference);
}

@override
String toString() {
  final _this = this as AccountingLedgerLineEntity;
  return 'AccountingLedgerLineEntity(source: ${_this.source}, accountCode: ${_this.accountCode}, accountName: ${_this.accountName}, debit: ${_this.debit}, credit: ${_this.credit}, runningBalance: ${_this.runningBalance}, entryId: ${_this.entryId}, entryDate: ${_this.entryDate}, reference: ${_this.reference})';
}


}

/// @nodoc
abstract mixin class $AccountingLedgerLineEntityCopyWith<$Res>  {
  factory $AccountingLedgerLineEntityCopyWith(AccountingLedgerLineEntity value, $Res Function(AccountingLedgerLineEntity) _then) = _$AccountingLedgerLineEntityCopyWithImpl;
@useResult
$Res call({
 JournalSource source, String accountCode, String accountName, num debit, num credit, num runningBalance, String? entryId, DateTime? entryDate, String? reference
});




}
/// @nodoc
class _$AccountingLedgerLineEntityCopyWithImpl<$Res>
    implements $AccountingLedgerLineEntityCopyWith<$Res> {
  _$AccountingLedgerLineEntityCopyWithImpl(this._self, this._then);

  final AccountingLedgerLineEntity _self;
  final $Res Function(AccountingLedgerLineEntity) _then;

/// Create a copy of AccountingLedgerLineEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? accountCode = null,Object? accountName = null,Object? debit = null,Object? credit = null,Object? runningBalance = null,Object? entryId = freezed,Object? entryDate = freezed,Object? reference = freezed,}) {
  return _then(AccountingLedgerLineEntity(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as num,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as num,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as num,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,entryDate: freezed == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingLedgerLineEntity].
extension AccountingLedgerLineEntityPatterns on AccountingLedgerLineEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingLedgerLineEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingLedgerLineEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingLedgerLineEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingLedgerLineEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingLedgerLineEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingLedgerLineEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JournalSource source,  String accountCode,  String accountName,  num debit,  num credit,  num runningBalance,  String? entryId,  DateTime? entryDate,  String? reference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingLedgerLineEntity() when $default != null:
return $default(_that.source,_that.accountCode,_that.accountName,_that.debit,_that.credit,_that.runningBalance,_that.entryId,_that.entryDate,_that.reference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JournalSource source,  String accountCode,  String accountName,  num debit,  num credit,  num runningBalance,  String? entryId,  DateTime? entryDate,  String? reference)  $default,) {final _that = this;
switch (_that) {
case _AccountingLedgerLineEntity():
return $default(_that.source,_that.accountCode,_that.accountName,_that.debit,_that.credit,_that.runningBalance,_that.entryId,_that.entryDate,_that.reference);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JournalSource source,  String accountCode,  String accountName,  num debit,  num credit,  num runningBalance,  String? entryId,  DateTime? entryDate,  String? reference)?  $default,) {final _that = this;
switch (_that) {
case _AccountingLedgerLineEntity() when $default != null:
return $default(_that.source,_that.accountCode,_that.accountName,_that.debit,_that.credit,_that.runningBalance,_that.entryId,_that.entryDate,_that.reference);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingLedgerLineEntity implements AccountingLedgerLineEntity {
  const _AccountingLedgerLineEntity({required this.source, required this.accountCode, required this.accountName, required this.debit, required this.credit, required this.runningBalance, this.entryId, this.entryDate, this.reference});
  

@override final  JournalSource source;
@override final  String accountCode;
@override final  String accountName;
@override final  num debit;
@override final  num credit;
@override final  num runningBalance;
@override final  String? entryId;
@override final  DateTime? entryDate;
@override final  String? reference;

/// Create a copy of AccountingLedgerLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingLedgerLineEntityCopyWith<_AccountingLedgerLineEntity> get copyWith => __$AccountingLedgerLineEntityCopyWithImpl<_AccountingLedgerLineEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingLedgerLineEntity&&(identical(other.source, source) || other.source == source)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.debit, debit) || other.debit == debit)&&(identical(other.credit, credit) || other.credit == credit)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance)&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.reference, reference) || other.reference == reference));
}


@override
int get hashCode {
    return Object.hash(runtimeType,source,accountCode,accountName,debit,credit,runningBalance,entryId,entryDate,reference);
}

@override
String toString() {
    return 'AccountingLedgerLineEntity(source: $source, accountCode: $accountCode, accountName: $accountName, debit: $debit, credit: $credit, runningBalance: $runningBalance, entryId: $entryId, entryDate: $entryDate, reference: $reference)';
}


}

/// @nodoc
abstract mixin class _$AccountingLedgerLineEntityCopyWith<$Res> implements $AccountingLedgerLineEntityCopyWith<$Res> {
  factory _$AccountingLedgerLineEntityCopyWith(_AccountingLedgerLineEntity value, $Res Function(_AccountingLedgerLineEntity) _then) = __$AccountingLedgerLineEntityCopyWithImpl;
@override @useResult
$Res call({
 JournalSource source, String accountCode, String accountName, num debit, num credit, num runningBalance, String? entryId, DateTime? entryDate, String? reference
});




}
/// @nodoc
class __$AccountingLedgerLineEntityCopyWithImpl<$Res>
    implements _$AccountingLedgerLineEntityCopyWith<$Res> {
  __$AccountingLedgerLineEntityCopyWithImpl(this._self, this._then);

  final _AccountingLedgerLineEntity _self;
  final $Res Function(_AccountingLedgerLineEntity) _then;

/// Create a copy of AccountingLedgerLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? accountCode = null,Object? accountName = null,Object? debit = null,Object? credit = null,Object? runningBalance = null,Object? entryId = freezed,Object? entryDate = freezed,Object? reference = freezed,}) {
  return _then(_AccountingLedgerLineEntity(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as num,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as num,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as num,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,entryDate: freezed == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
