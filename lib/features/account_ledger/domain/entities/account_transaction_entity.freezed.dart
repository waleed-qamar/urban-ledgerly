// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountTransactionEntity {

 int get id; int get accountId; double get amount; String get transactionType;// 'credit' or 'debit'
 String get referenceType;// 'receipt', 'disbursement', 'transfer', 'expense', etc.
 int? get referenceId; String? get description; DateTime get transactionDate; bool get isReconciled; DateTime? get reconciledAt; String? get externalReference; int? get transferId; DateTime? get createdAt; double get runningBalance;
/// Create a copy of AccountTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountTransactionEntityCopyWith<AccountTransactionEntity> get copyWith => _$AccountTransactionEntityCopyWithImpl<AccountTransactionEntity>(this as AccountTransactionEntity, _$identity);

  /// Serializes this AccountTransactionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountTransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.isReconciled, isReconciled) || other.isReconciled == isReconciled)&&(identical(other.reconciledAt, reconciledAt) || other.reconciledAt == reconciledAt)&&(identical(other.externalReference, externalReference) || other.externalReference == externalReference)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,amount,transactionType,referenceType,referenceId,description,transactionDate,isReconciled,reconciledAt,externalReference,transferId,createdAt,runningBalance);

@override
String toString() {
  return 'AccountTransactionEntity(id: $id, accountId: $accountId, amount: $amount, transactionType: $transactionType, referenceType: $referenceType, referenceId: $referenceId, description: $description, transactionDate: $transactionDate, isReconciled: $isReconciled, reconciledAt: $reconciledAt, externalReference: $externalReference, transferId: $transferId, createdAt: $createdAt, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class $AccountTransactionEntityCopyWith<$Res>  {
  factory $AccountTransactionEntityCopyWith(AccountTransactionEntity value, $Res Function(AccountTransactionEntity) _then) = _$AccountTransactionEntityCopyWithImpl;
@useResult
$Res call({
 int id, int accountId, double amount, String transactionType, String referenceType, int? referenceId, String? description, DateTime transactionDate, bool isReconciled, DateTime? reconciledAt, String? externalReference, int? transferId, DateTime? createdAt, double runningBalance
});




}
/// @nodoc
class _$AccountTransactionEntityCopyWithImpl<$Res>
    implements $AccountTransactionEntityCopyWith<$Res> {
  _$AccountTransactionEntityCopyWithImpl(this._self, this._then);

  final AccountTransactionEntity _self;
  final $Res Function(AccountTransactionEntity) _then;

/// Create a copy of AccountTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? amount = null,Object? transactionType = null,Object? referenceType = null,Object? referenceId = freezed,Object? description = freezed,Object? transactionDate = null,Object? isReconciled = null,Object? reconciledAt = freezed,Object? externalReference = freezed,Object? transferId = freezed,Object? createdAt = freezed,Object? runningBalance = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,isReconciled: null == isReconciled ? _self.isReconciled : isReconciled // ignore: cast_nullable_to_non_nullable
as bool,reconciledAt: freezed == reconciledAt ? _self.reconciledAt : reconciledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,externalReference: freezed == externalReference ? _self.externalReference : externalReference // ignore: cast_nullable_to_non_nullable
as String?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountTransactionEntity].
extension AccountTransactionEntityPatterns on AccountTransactionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountTransactionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountTransactionEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountTransactionEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountTransactionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int accountId,  double amount,  String transactionType,  String referenceType,  int? referenceId,  String? description,  DateTime transactionDate,  bool isReconciled,  DateTime? reconciledAt,  String? externalReference,  int? transferId,  DateTime? createdAt,  double runningBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountTransactionEntity() when $default != null:
return $default(_that.id,_that.accountId,_that.amount,_that.transactionType,_that.referenceType,_that.referenceId,_that.description,_that.transactionDate,_that.isReconciled,_that.reconciledAt,_that.externalReference,_that.transferId,_that.createdAt,_that.runningBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int accountId,  double amount,  String transactionType,  String referenceType,  int? referenceId,  String? description,  DateTime transactionDate,  bool isReconciled,  DateTime? reconciledAt,  String? externalReference,  int? transferId,  DateTime? createdAt,  double runningBalance)  $default,) {final _that = this;
switch (_that) {
case _AccountTransactionEntity():
return $default(_that.id,_that.accountId,_that.amount,_that.transactionType,_that.referenceType,_that.referenceId,_that.description,_that.transactionDate,_that.isReconciled,_that.reconciledAt,_that.externalReference,_that.transferId,_that.createdAt,_that.runningBalance);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int accountId,  double amount,  String transactionType,  String referenceType,  int? referenceId,  String? description,  DateTime transactionDate,  bool isReconciled,  DateTime? reconciledAt,  String? externalReference,  int? transferId,  DateTime? createdAt,  double runningBalance)?  $default,) {final _that = this;
switch (_that) {
case _AccountTransactionEntity() when $default != null:
return $default(_that.id,_that.accountId,_that.amount,_that.transactionType,_that.referenceType,_that.referenceId,_that.description,_that.transactionDate,_that.isReconciled,_that.reconciledAt,_that.externalReference,_that.transferId,_that.createdAt,_that.runningBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountTransactionEntity implements AccountTransactionEntity {
  const _AccountTransactionEntity({required this.id, required this.accountId, required this.amount, required this.transactionType, required this.referenceType, this.referenceId, this.description, required this.transactionDate, this.isReconciled = false, this.reconciledAt, this.externalReference, this.transferId, this.createdAt, this.runningBalance = 0.0});
  factory _AccountTransactionEntity.fromJson(Map<String, dynamic> json) => _$AccountTransactionEntityFromJson(json);

@override final  int id;
@override final  int accountId;
@override final  double amount;
@override final  String transactionType;
// 'credit' or 'debit'
@override final  String referenceType;
// 'receipt', 'disbursement', 'transfer', 'expense', etc.
@override final  int? referenceId;
@override final  String? description;
@override final  DateTime transactionDate;
@override@JsonKey() final  bool isReconciled;
@override final  DateTime? reconciledAt;
@override final  String? externalReference;
@override final  int? transferId;
@override final  DateTime? createdAt;
@override@JsonKey() final  double runningBalance;

/// Create a copy of AccountTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountTransactionEntityCopyWith<_AccountTransactionEntity> get copyWith => __$AccountTransactionEntityCopyWithImpl<_AccountTransactionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountTransactionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountTransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.isReconciled, isReconciled) || other.isReconciled == isReconciled)&&(identical(other.reconciledAt, reconciledAt) || other.reconciledAt == reconciledAt)&&(identical(other.externalReference, externalReference) || other.externalReference == externalReference)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,amount,transactionType,referenceType,referenceId,description,transactionDate,isReconciled,reconciledAt,externalReference,transferId,createdAt,runningBalance);

@override
String toString() {
  return 'AccountTransactionEntity(id: $id, accountId: $accountId, amount: $amount, transactionType: $transactionType, referenceType: $referenceType, referenceId: $referenceId, description: $description, transactionDate: $transactionDate, isReconciled: $isReconciled, reconciledAt: $reconciledAt, externalReference: $externalReference, transferId: $transferId, createdAt: $createdAt, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class _$AccountTransactionEntityCopyWith<$Res> implements $AccountTransactionEntityCopyWith<$Res> {
  factory _$AccountTransactionEntityCopyWith(_AccountTransactionEntity value, $Res Function(_AccountTransactionEntity) _then) = __$AccountTransactionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int accountId, double amount, String transactionType, String referenceType, int? referenceId, String? description, DateTime transactionDate, bool isReconciled, DateTime? reconciledAt, String? externalReference, int? transferId, DateTime? createdAt, double runningBalance
});




}
/// @nodoc
class __$AccountTransactionEntityCopyWithImpl<$Res>
    implements _$AccountTransactionEntityCopyWith<$Res> {
  __$AccountTransactionEntityCopyWithImpl(this._self, this._then);

  final _AccountTransactionEntity _self;
  final $Res Function(_AccountTransactionEntity) _then;

/// Create a copy of AccountTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? amount = null,Object? transactionType = null,Object? referenceType = null,Object? referenceId = freezed,Object? description = freezed,Object? transactionDate = null,Object? isReconciled = null,Object? reconciledAt = freezed,Object? externalReference = freezed,Object? transferId = freezed,Object? createdAt = freezed,Object? runningBalance = null,}) {
  return _then(_AccountTransactionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,isReconciled: null == isReconciled ? _self.isReconciled : isReconciled // ignore: cast_nullable_to_non_nullable
as bool,reconciledAt: freezed == reconciledAt ? _self.reconciledAt : reconciledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,externalReference: freezed == externalReference ? _self.externalReference : externalReference // ignore: cast_nullable_to_non_nullable
as String?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
