// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_journal_entry_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingJournalLineEntity {

 String get accountCode; String get accountName; num get debit; num get credit; String? get id;
/// Create a copy of AccountingJournalLineEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingJournalLineEntityCopyWith<AccountingJournalLineEntity> get copyWith => _$AccountingJournalLineEntityCopyWithImpl<AccountingJournalLineEntity>(this as AccountingJournalLineEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingJournalLineEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalLineEntity&&(identical(other.accountCode, _this.accountCode) || other.accountCode == _this.accountCode)&&(identical(other.accountName, _this.accountName) || other.accountName == _this.accountName)&&(identical(other.debit, _this.debit) || other.debit == _this.debit)&&(identical(other.credit, _this.credit) || other.credit == _this.credit)&&(identical(other.id, _this.id) || other.id == _this.id));
}


@override
int get hashCode {
  final _this = this as AccountingJournalLineEntity;
  return Object.hash(runtimeType,_this.accountCode,_this.accountName,_this.debit,_this.credit,_this.id);
}

@override
String toString() {
  final _this = this as AccountingJournalLineEntity;
  return 'AccountingJournalLineEntity(accountCode: ${_this.accountCode}, accountName: ${_this.accountName}, debit: ${_this.debit}, credit: ${_this.credit}, id: ${_this.id})';
}


}

/// @nodoc
abstract mixin class $AccountingJournalLineEntityCopyWith<$Res>  {
  factory $AccountingJournalLineEntityCopyWith(AccountingJournalLineEntity value, $Res Function(AccountingJournalLineEntity) _then) = _$AccountingJournalLineEntityCopyWithImpl;
@useResult
$Res call({
 String accountCode, String accountName, num debit, num credit, String? id
});




}
/// @nodoc
class _$AccountingJournalLineEntityCopyWithImpl<$Res>
    implements $AccountingJournalLineEntityCopyWith<$Res> {
  _$AccountingJournalLineEntityCopyWithImpl(this._self, this._then);

  final AccountingJournalLineEntity _self;
  final $Res Function(AccountingJournalLineEntity) _then;

/// Create a copy of AccountingJournalLineEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountCode = null,Object? accountName = null,Object? debit = null,Object? credit = null,Object? id = freezed,}) {
  return _then(AccountingJournalLineEntity(
accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as num,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as num,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingJournalLineEntity].
extension AccountingJournalLineEntityPatterns on AccountingJournalLineEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingJournalLineEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingJournalLineEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingJournalLineEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingJournalLineEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingJournalLineEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingJournalLineEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountCode,  String accountName,  num debit,  num credit,  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingJournalLineEntity() when $default != null:
return $default(_that.accountCode,_that.accountName,_that.debit,_that.credit,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountCode,  String accountName,  num debit,  num credit,  String? id)  $default,) {final _that = this;
switch (_that) {
case _AccountingJournalLineEntity():
return $default(_that.accountCode,_that.accountName,_that.debit,_that.credit,_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountCode,  String accountName,  num debit,  num credit,  String? id)?  $default,) {final _that = this;
switch (_that) {
case _AccountingJournalLineEntity() when $default != null:
return $default(_that.accountCode,_that.accountName,_that.debit,_that.credit,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingJournalLineEntity implements AccountingJournalLineEntity {
  const _AccountingJournalLineEntity({required this.accountCode, required this.accountName, required this.debit, required this.credit, this.id});
  

@override final  String accountCode;
@override final  String accountName;
@override final  num debit;
@override final  num credit;
@override final  String? id;

/// Create a copy of AccountingJournalLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingJournalLineEntityCopyWith<_AccountingJournalLineEntity> get copyWith => __$AccountingJournalLineEntityCopyWithImpl<_AccountingJournalLineEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingJournalLineEntity&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.debit, debit) || other.debit == debit)&&(identical(other.credit, credit) || other.credit == credit)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,accountCode,accountName,debit,credit,id);
}

@override
String toString() {
    return 'AccountingJournalLineEntity(accountCode: $accountCode, accountName: $accountName, debit: $debit, credit: $credit, id: $id)';
}


}

/// @nodoc
abstract mixin class _$AccountingJournalLineEntityCopyWith<$Res> implements $AccountingJournalLineEntityCopyWith<$Res> {
  factory _$AccountingJournalLineEntityCopyWith(_AccountingJournalLineEntity value, $Res Function(_AccountingJournalLineEntity) _then) = __$AccountingJournalLineEntityCopyWithImpl;
@override @useResult
$Res call({
 String accountCode, String accountName, num debit, num credit, String? id
});




}
/// @nodoc
class __$AccountingJournalLineEntityCopyWithImpl<$Res>
    implements _$AccountingJournalLineEntityCopyWith<$Res> {
  __$AccountingJournalLineEntityCopyWithImpl(this._self, this._then);

  final _AccountingJournalLineEntity _self;
  final $Res Function(_AccountingJournalLineEntity) _then;

/// Create a copy of AccountingJournalLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountCode = null,Object? accountName = null,Object? debit = null,Object? credit = null,Object? id = freezed,}) {
  return _then(_AccountingJournalLineEntity(
accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as num,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as num,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AccountingJournalEntryEntity {

 String get id; JournalSource get source; List<AccountingJournalLineEntity> get lines; num get totalDebit; num get totalCredit; String? get branchId; DateTime? get entryDate; String? get reference; String? get memo;
/// Create a copy of AccountingJournalEntryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingJournalEntryEntityCopyWith<AccountingJournalEntryEntity> get copyWith => _$AccountingJournalEntryEntityCopyWithImpl<AccountingJournalEntryEntity>(this as AccountingJournalEntryEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingJournalEntryEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalEntryEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.source, _this.source) || other.source == _this.source)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.totalDebit, _this.totalDebit) || other.totalDebit == _this.totalDebit)&&(identical(other.totalCredit, _this.totalCredit) || other.totalCredit == _this.totalCredit)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.entryDate, _this.entryDate) || other.entryDate == _this.entryDate)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.memo, _this.memo) || other.memo == _this.memo));
}


@override
int get hashCode {
  final _this = this as AccountingJournalEntryEntity;
  return Object.hash(runtimeType,_this.id,_this.source,const DeepCollectionEquality().hash(_this.lines),_this.totalDebit,_this.totalCredit,_this.branchId,_this.entryDate,_this.reference,_this.memo);
}

@override
String toString() {
  final _this = this as AccountingJournalEntryEntity;
  return 'AccountingJournalEntryEntity(id: ${_this.id}, source: ${_this.source}, lines: ${_this.lines}, totalDebit: ${_this.totalDebit}, totalCredit: ${_this.totalCredit}, branchId: ${_this.branchId}, entryDate: ${_this.entryDate}, reference: ${_this.reference}, memo: ${_this.memo})';
}


}

/// @nodoc
abstract mixin class $AccountingJournalEntryEntityCopyWith<$Res>  {
  factory $AccountingJournalEntryEntityCopyWith(AccountingJournalEntryEntity value, $Res Function(AccountingJournalEntryEntity) _then) = _$AccountingJournalEntryEntityCopyWithImpl;
@useResult
$Res call({
 String id, JournalSource source, List<AccountingJournalLineEntity> lines, num totalDebit, num totalCredit, String? branchId, DateTime? entryDate, String? reference, String? memo
});




}
/// @nodoc
class _$AccountingJournalEntryEntityCopyWithImpl<$Res>
    implements $AccountingJournalEntryEntityCopyWith<$Res> {
  _$AccountingJournalEntryEntityCopyWithImpl(this._self, this._then);

  final AccountingJournalEntryEntity _self;
  final $Res Function(AccountingJournalEntryEntity) _then;

/// Create a copy of AccountingJournalEntryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,Object? branchId = freezed,Object? entryDate = freezed,Object? reference = freezed,Object? memo = freezed,}) {
  return _then(AccountingJournalEntryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<AccountingJournalLineEntity>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as num,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as num,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,entryDate: freezed == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingJournalEntryEntity].
extension AccountingJournalEntryEntityPatterns on AccountingJournalEntryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingJournalEntryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingJournalEntryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingJournalEntryEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingJournalEntryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingJournalEntryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingJournalEntryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  JournalSource source,  List<AccountingJournalLineEntity> lines,  num totalDebit,  num totalCredit,  String? branchId,  DateTime? entryDate,  String? reference,  String? memo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingJournalEntryEntity() when $default != null:
return $default(_that.id,_that.source,_that.lines,_that.totalDebit,_that.totalCredit,_that.branchId,_that.entryDate,_that.reference,_that.memo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  JournalSource source,  List<AccountingJournalLineEntity> lines,  num totalDebit,  num totalCredit,  String? branchId,  DateTime? entryDate,  String? reference,  String? memo)  $default,) {final _that = this;
switch (_that) {
case _AccountingJournalEntryEntity():
return $default(_that.id,_that.source,_that.lines,_that.totalDebit,_that.totalCredit,_that.branchId,_that.entryDate,_that.reference,_that.memo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  JournalSource source,  List<AccountingJournalLineEntity> lines,  num totalDebit,  num totalCredit,  String? branchId,  DateTime? entryDate,  String? reference,  String? memo)?  $default,) {final _that = this;
switch (_that) {
case _AccountingJournalEntryEntity() when $default != null:
return $default(_that.id,_that.source,_that.lines,_that.totalDebit,_that.totalCredit,_that.branchId,_that.entryDate,_that.reference,_that.memo);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingJournalEntryEntity extends AccountingJournalEntryEntity {
  const _AccountingJournalEntryEntity({required this.id, required this.source, required  List<AccountingJournalLineEntity> lines, required this.totalDebit, required this.totalCredit, this.branchId, this.entryDate, this.reference, this.memo}): _lines = lines,super._();
  

@override final  String id;
@override final  JournalSource source;
 final  List<AccountingJournalLineEntity> _lines;
@override List<AccountingJournalLineEntity> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  num totalDebit;
@override final  num totalCredit;
@override final  String? branchId;
@override final  DateTime? entryDate;
@override final  String? reference;
@override final  String? memo;

/// Create a copy of AccountingJournalEntryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingJournalEntryEntityCopyWith<_AccountingJournalEntryEntity> get copyWith => __$AccountingJournalEntryEntityCopyWithImpl<_AccountingJournalEntryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingJournalEntryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.totalDebit, totalDebit) || other.totalDebit == totalDebit)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.memo, memo) || other.memo == memo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,source,const DeepCollectionEquality().hash(_lines),totalDebit,totalCredit,branchId,entryDate,reference,memo);
}

@override
String toString() {
    return 'AccountingJournalEntryEntity(id: $id, source: $source, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit, branchId: $branchId, entryDate: $entryDate, reference: $reference, memo: $memo)';
}


}

/// @nodoc
abstract mixin class _$AccountingJournalEntryEntityCopyWith<$Res> implements $AccountingJournalEntryEntityCopyWith<$Res> {
  factory _$AccountingJournalEntryEntityCopyWith(_AccountingJournalEntryEntity value, $Res Function(_AccountingJournalEntryEntity) _then) = __$AccountingJournalEntryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, JournalSource source, List<AccountingJournalLineEntity> lines, num totalDebit, num totalCredit, String? branchId, DateTime? entryDate, String? reference, String? memo
});




}
/// @nodoc
class __$AccountingJournalEntryEntityCopyWithImpl<$Res>
    implements _$AccountingJournalEntryEntityCopyWith<$Res> {
  __$AccountingJournalEntryEntityCopyWithImpl(this._self, this._then);

  final _AccountingJournalEntryEntity _self;
  final $Res Function(_AccountingJournalEntryEntity) _then;

/// Create a copy of AccountingJournalEntryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,Object? branchId = freezed,Object? entryDate = freezed,Object? reference = freezed,Object? memo = freezed,}) {
  return _then(_AccountingJournalEntryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<AccountingJournalLineEntity>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as num,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as num,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,entryDate: freezed == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AccountingJournalLineInput {

 String get accountCode; num get debit; num get credit;
/// Create a copy of AccountingJournalLineInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingJournalLineInputCopyWith<AccountingJournalLineInput> get copyWith => _$AccountingJournalLineInputCopyWithImpl<AccountingJournalLineInput>(this as AccountingJournalLineInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingJournalLineInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingJournalLineInput&&(identical(other.accountCode, _this.accountCode) || other.accountCode == _this.accountCode)&&(identical(other.debit, _this.debit) || other.debit == _this.debit)&&(identical(other.credit, _this.credit) || other.credit == _this.credit));
}


@override
int get hashCode {
  final _this = this as AccountingJournalLineInput;
  return Object.hash(runtimeType,_this.accountCode,_this.debit,_this.credit);
}

@override
String toString() {
  final _this = this as AccountingJournalLineInput;
  return 'AccountingJournalLineInput(accountCode: ${_this.accountCode}, debit: ${_this.debit}, credit: ${_this.credit})';
}


}

/// @nodoc
abstract mixin class $AccountingJournalLineInputCopyWith<$Res>  {
  factory $AccountingJournalLineInputCopyWith(AccountingJournalLineInput value, $Res Function(AccountingJournalLineInput) _then) = _$AccountingJournalLineInputCopyWithImpl;
@useResult
$Res call({
 String accountCode, num debit, num credit
});




}
/// @nodoc
class _$AccountingJournalLineInputCopyWithImpl<$Res>
    implements $AccountingJournalLineInputCopyWith<$Res> {
  _$AccountingJournalLineInputCopyWithImpl(this._self, this._then);

  final AccountingJournalLineInput _self;
  final $Res Function(AccountingJournalLineInput) _then;

/// Create a copy of AccountingJournalLineInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountCode = null,Object? debit = null,Object? credit = null,}) {
  return _then(AccountingJournalLineInput(
accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as num,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingJournalLineInput].
extension AccountingJournalLineInputPatterns on AccountingJournalLineInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingJournalLineInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingJournalLineInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingJournalLineInput value)  $default,){
final _that = this;
switch (_that) {
case _AccountingJournalLineInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingJournalLineInput value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingJournalLineInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountCode,  num debit,  num credit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingJournalLineInput() when $default != null:
return $default(_that.accountCode,_that.debit,_that.credit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountCode,  num debit,  num credit)  $default,) {final _that = this;
switch (_that) {
case _AccountingJournalLineInput():
return $default(_that.accountCode,_that.debit,_that.credit);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountCode,  num debit,  num credit)?  $default,) {final _that = this;
switch (_that) {
case _AccountingJournalLineInput() when $default != null:
return $default(_that.accountCode,_that.debit,_that.credit);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingJournalLineInput implements AccountingJournalLineInput {
  const _AccountingJournalLineInput({required this.accountCode, required this.debit, required this.credit});
  

@override final  String accountCode;
@override final  num debit;
@override final  num credit;

/// Create a copy of AccountingJournalLineInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingJournalLineInputCopyWith<_AccountingJournalLineInput> get copyWith => __$AccountingJournalLineInputCopyWithImpl<_AccountingJournalLineInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingJournalLineInput&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.debit, debit) || other.debit == debit)&&(identical(other.credit, credit) || other.credit == credit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,accountCode,debit,credit);
}

@override
String toString() {
    return 'AccountingJournalLineInput(accountCode: $accountCode, debit: $debit, credit: $credit)';
}


}

/// @nodoc
abstract mixin class _$AccountingJournalLineInputCopyWith<$Res> implements $AccountingJournalLineInputCopyWith<$Res> {
  factory _$AccountingJournalLineInputCopyWith(_AccountingJournalLineInput value, $Res Function(_AccountingJournalLineInput) _then) = __$AccountingJournalLineInputCopyWithImpl;
@override @useResult
$Res call({
 String accountCode, num debit, num credit
});




}
/// @nodoc
class __$AccountingJournalLineInputCopyWithImpl<$Res>
    implements _$AccountingJournalLineInputCopyWith<$Res> {
  __$AccountingJournalLineInputCopyWithImpl(this._self, this._then);

  final _AccountingJournalLineInput _self;
  final $Res Function(_AccountingJournalLineInput) _then;

/// Create a copy of AccountingJournalLineInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountCode = null,Object? debit = null,Object? credit = null,}) {
  return _then(_AccountingJournalLineInput(
accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as num,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
