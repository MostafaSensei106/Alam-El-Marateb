// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_expense_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingExpenseEntity {

 String get id; ExpenseCategory get category; num get amount; DateTime get createdAt; String? get branchId; String? get approvedBy; String? get receiptPhoto;
/// Create a copy of AccountingExpenseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingExpenseEntityCopyWith<AccountingExpenseEntity> get copyWith => _$AccountingExpenseEntityCopyWithImpl<AccountingExpenseEntity>(this as AccountingExpenseEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountingExpenseEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingExpenseEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.approvedBy, _this.approvedBy) || other.approvedBy == _this.approvedBy)&&(identical(other.receiptPhoto, _this.receiptPhoto) || other.receiptPhoto == _this.receiptPhoto));
}


@override
int get hashCode {
  final _this = this as AccountingExpenseEntity;
  return Object.hash(runtimeType,_this.id,_this.category,_this.amount,_this.createdAt,_this.branchId,_this.approvedBy,_this.receiptPhoto);
}

@override
String toString() {
  final _this = this as AccountingExpenseEntity;
  return 'AccountingExpenseEntity(id: ${_this.id}, category: ${_this.category}, amount: ${_this.amount}, createdAt: ${_this.createdAt}, branchId: ${_this.branchId}, approvedBy: ${_this.approvedBy}, receiptPhoto: ${_this.receiptPhoto})';
}


}

/// @nodoc
abstract mixin class $AccountingExpenseEntityCopyWith<$Res>  {
  factory $AccountingExpenseEntityCopyWith(AccountingExpenseEntity value, $Res Function(AccountingExpenseEntity) _then) = _$AccountingExpenseEntityCopyWithImpl;
@useResult
$Res call({
 String id, ExpenseCategory category, num amount, DateTime createdAt, String? branchId, String? approvedBy, String? receiptPhoto
});




}
/// @nodoc
class _$AccountingExpenseEntityCopyWithImpl<$Res>
    implements $AccountingExpenseEntityCopyWith<$Res> {
  _$AccountingExpenseEntityCopyWithImpl(this._self, this._then);

  final AccountingExpenseEntity _self;
  final $Res Function(AccountingExpenseEntity) _then;

/// Create a copy of AccountingExpenseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? amount = null,Object? createdAt = null,Object? branchId = freezed,Object? approvedBy = freezed,Object? receiptPhoto = freezed,}) {
  return _then(AccountingExpenseEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,receiptPhoto: freezed == receiptPhoto ? _self.receiptPhoto : receiptPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingExpenseEntity].
extension AccountingExpenseEntityPatterns on AccountingExpenseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingExpenseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingExpenseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingExpenseEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountingExpenseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingExpenseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingExpenseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ExpenseCategory category,  num amount,  DateTime createdAt,  String? branchId,  String? approvedBy,  String? receiptPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingExpenseEntity() when $default != null:
return $default(_that.id,_that.category,_that.amount,_that.createdAt,_that.branchId,_that.approvedBy,_that.receiptPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ExpenseCategory category,  num amount,  DateTime createdAt,  String? branchId,  String? approvedBy,  String? receiptPhoto)  $default,) {final _that = this;
switch (_that) {
case _AccountingExpenseEntity():
return $default(_that.id,_that.category,_that.amount,_that.createdAt,_that.branchId,_that.approvedBy,_that.receiptPhoto);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ExpenseCategory category,  num amount,  DateTime createdAt,  String? branchId,  String? approvedBy,  String? receiptPhoto)?  $default,) {final _that = this;
switch (_that) {
case _AccountingExpenseEntity() when $default != null:
return $default(_that.id,_that.category,_that.amount,_that.createdAt,_that.branchId,_that.approvedBy,_that.receiptPhoto);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingExpenseEntity extends AccountingExpenseEntity {
  const _AccountingExpenseEntity({required this.id, required this.category, required this.amount, required this.createdAt, this.branchId, this.approvedBy, this.receiptPhoto}): super._();
  

@override final  String id;
@override final  ExpenseCategory category;
@override final  num amount;
@override final  DateTime createdAt;
@override final  String? branchId;
@override final  String? approvedBy;
@override final  String? receiptPhoto;

/// Create a copy of AccountingExpenseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingExpenseEntityCopyWith<_AccountingExpenseEntity> get copyWith => __$AccountingExpenseEntityCopyWithImpl<_AccountingExpenseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingExpenseEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.receiptPhoto, receiptPhoto) || other.receiptPhoto == receiptPhoto));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,category,amount,createdAt,branchId,approvedBy,receiptPhoto);
}

@override
String toString() {
    return 'AccountingExpenseEntity(id: $id, category: $category, amount: $amount, createdAt: $createdAt, branchId: $branchId, approvedBy: $approvedBy, receiptPhoto: $receiptPhoto)';
}


}

/// @nodoc
abstract mixin class _$AccountingExpenseEntityCopyWith<$Res> implements $AccountingExpenseEntityCopyWith<$Res> {
  factory _$AccountingExpenseEntityCopyWith(_AccountingExpenseEntity value, $Res Function(_AccountingExpenseEntity) _then) = __$AccountingExpenseEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, ExpenseCategory category, num amount, DateTime createdAt, String? branchId, String? approvedBy, String? receiptPhoto
});




}
/// @nodoc
class __$AccountingExpenseEntityCopyWithImpl<$Res>
    implements _$AccountingExpenseEntityCopyWith<$Res> {
  __$AccountingExpenseEntityCopyWithImpl(this._self, this._then);

  final _AccountingExpenseEntity _self;
  final $Res Function(_AccountingExpenseEntity) _then;

/// Create a copy of AccountingExpenseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? amount = null,Object? createdAt = null,Object? branchId = freezed,Object? approvedBy = freezed,Object? receiptPhoto = freezed,}) {
  return _then(_AccountingExpenseEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,receiptPhoto: freezed == receiptPhoto ? _self.receiptPhoto : receiptPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
