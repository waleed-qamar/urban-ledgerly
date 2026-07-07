// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LedgerEntity {

 int get id;@JsonKey(name: 'party_type') PartyType get partyType;@JsonKey(name: 'party_id') int get partyId;@JsonKey(name: 'invoice_number') String? get invoiceNumber;@JsonKey(name: 'entry_type') EntryType get entryType; double get amount;@JsonKey(name: 'payment_method') String? get paymentMethod;@JsonKey(name: 'entry_date') DateTime get entryDate;@JsonKey(name: 'transaction_source') String? get transactionSource;@JsonKey(name: 'reference_id') String? get referenceId; String? get remarks;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of LedgerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerEntityCopyWith<LedgerEntity> get copyWith => _$LedgerEntityCopyWithImpl<LedgerEntity>(this as LedgerEntity, _$identity);

  /// Serializes this LedgerEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.partyType, partyType) || other.partyType == partyType)&&(identical(other.partyId, partyId) || other.partyId == partyId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.entryType, entryType) || other.entryType == entryType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.transactionSource, transactionSource) || other.transactionSource == transactionSource)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,partyType,partyId,invoiceNumber,entryType,amount,paymentMethod,entryDate,transactionSource,referenceId,remarks,createdAt);

@override
String toString() {
  return 'LedgerEntity(id: $id, partyType: $partyType, partyId: $partyId, invoiceNumber: $invoiceNumber, entryType: $entryType, amount: $amount, paymentMethod: $paymentMethod, entryDate: $entryDate, transactionSource: $transactionSource, referenceId: $referenceId, remarks: $remarks, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LedgerEntityCopyWith<$Res>  {
  factory $LedgerEntityCopyWith(LedgerEntity value, $Res Function(LedgerEntity) _then) = _$LedgerEntityCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'party_type') PartyType partyType,@JsonKey(name: 'party_id') int partyId,@JsonKey(name: 'invoice_number') String? invoiceNumber,@JsonKey(name: 'entry_type') EntryType entryType, double amount,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(name: 'transaction_source') String? transactionSource,@JsonKey(name: 'reference_id') String? referenceId, String? remarks,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$LedgerEntityCopyWithImpl<$Res>
    implements $LedgerEntityCopyWith<$Res> {
  _$LedgerEntityCopyWithImpl(this._self, this._then);

  final LedgerEntity _self;
  final $Res Function(LedgerEntity) _then;

/// Create a copy of LedgerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? partyType = null,Object? partyId = null,Object? invoiceNumber = freezed,Object? entryType = null,Object? amount = null,Object? paymentMethod = freezed,Object? entryDate = null,Object? transactionSource = freezed,Object? referenceId = freezed,Object? remarks = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,partyType: null == partyType ? _self.partyType : partyType // ignore: cast_nullable_to_non_nullable
as PartyType,partyId: null == partyId ? _self.partyId : partyId // ignore: cast_nullable_to_non_nullable
as int,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,entryType: null == entryType ? _self.entryType : entryType // ignore: cast_nullable_to_non_nullable
as EntryType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,transactionSource: freezed == transactionSource ? _self.transactionSource : transactionSource // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerEntity].
extension LedgerEntityPatterns on LedgerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerEntity value)  $default,){
final _that = this;
switch (_that) {
case _LedgerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'party_type')  PartyType partyType, @JsonKey(name: 'party_id')  int partyId, @JsonKey(name: 'invoice_number')  String? invoiceNumber, @JsonKey(name: 'entry_type')  EntryType entryType,  double amount, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'transaction_source')  String? transactionSource, @JsonKey(name: 'reference_id')  String? referenceId,  String? remarks, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerEntity() when $default != null:
return $default(_that.id,_that.partyType,_that.partyId,_that.invoiceNumber,_that.entryType,_that.amount,_that.paymentMethod,_that.entryDate,_that.transactionSource,_that.referenceId,_that.remarks,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'party_type')  PartyType partyType, @JsonKey(name: 'party_id')  int partyId, @JsonKey(name: 'invoice_number')  String? invoiceNumber, @JsonKey(name: 'entry_type')  EntryType entryType,  double amount, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'transaction_source')  String? transactionSource, @JsonKey(name: 'reference_id')  String? referenceId,  String? remarks, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LedgerEntity():
return $default(_that.id,_that.partyType,_that.partyId,_that.invoiceNumber,_that.entryType,_that.amount,_that.paymentMethod,_that.entryDate,_that.transactionSource,_that.referenceId,_that.remarks,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'party_type')  PartyType partyType, @JsonKey(name: 'party_id')  int partyId, @JsonKey(name: 'invoice_number')  String? invoiceNumber, @JsonKey(name: 'entry_type')  EntryType entryType,  double amount, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'transaction_source')  String? transactionSource, @JsonKey(name: 'reference_id')  String? referenceId,  String? remarks, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LedgerEntity() when $default != null:
return $default(_that.id,_that.partyType,_that.partyId,_that.invoiceNumber,_that.entryType,_that.amount,_that.paymentMethod,_that.entryDate,_that.transactionSource,_that.referenceId,_that.remarks,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerEntity implements LedgerEntity {
  const _LedgerEntity({required this.id, @JsonKey(name: 'party_type') required this.partyType, @JsonKey(name: 'party_id') required this.partyId, @JsonKey(name: 'invoice_number') this.invoiceNumber, @JsonKey(name: 'entry_type') required this.entryType, required this.amount, @JsonKey(name: 'payment_method') this.paymentMethod, @JsonKey(name: 'entry_date') required this.entryDate, @JsonKey(name: 'transaction_source') this.transactionSource, @JsonKey(name: 'reference_id') this.referenceId, this.remarks, @JsonKey(name: 'created_at') required this.createdAt});
  factory _LedgerEntity.fromJson(Map<String, dynamic> json) => _$LedgerEntityFromJson(json);

@override final  int id;
@override@JsonKey(name: 'party_type') final  PartyType partyType;
@override@JsonKey(name: 'party_id') final  int partyId;
@override@JsonKey(name: 'invoice_number') final  String? invoiceNumber;
@override@JsonKey(name: 'entry_type') final  EntryType entryType;
@override final  double amount;
@override@JsonKey(name: 'payment_method') final  String? paymentMethod;
@override@JsonKey(name: 'entry_date') final  DateTime entryDate;
@override@JsonKey(name: 'transaction_source') final  String? transactionSource;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override final  String? remarks;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of LedgerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerEntityCopyWith<_LedgerEntity> get copyWith => __$LedgerEntityCopyWithImpl<_LedgerEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.partyType, partyType) || other.partyType == partyType)&&(identical(other.partyId, partyId) || other.partyId == partyId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.entryType, entryType) || other.entryType == entryType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.transactionSource, transactionSource) || other.transactionSource == transactionSource)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,partyType,partyId,invoiceNumber,entryType,amount,paymentMethod,entryDate,transactionSource,referenceId,remarks,createdAt);

@override
String toString() {
  return 'LedgerEntity(id: $id, partyType: $partyType, partyId: $partyId, invoiceNumber: $invoiceNumber, entryType: $entryType, amount: $amount, paymentMethod: $paymentMethod, entryDate: $entryDate, transactionSource: $transactionSource, referenceId: $referenceId, remarks: $remarks, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LedgerEntityCopyWith<$Res> implements $LedgerEntityCopyWith<$Res> {
  factory _$LedgerEntityCopyWith(_LedgerEntity value, $Res Function(_LedgerEntity) _then) = __$LedgerEntityCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'party_type') PartyType partyType,@JsonKey(name: 'party_id') int partyId,@JsonKey(name: 'invoice_number') String? invoiceNumber,@JsonKey(name: 'entry_type') EntryType entryType, double amount,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(name: 'transaction_source') String? transactionSource,@JsonKey(name: 'reference_id') String? referenceId, String? remarks,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$LedgerEntityCopyWithImpl<$Res>
    implements _$LedgerEntityCopyWith<$Res> {
  __$LedgerEntityCopyWithImpl(this._self, this._then);

  final _LedgerEntity _self;
  final $Res Function(_LedgerEntity) _then;

/// Create a copy of LedgerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? partyType = null,Object? partyId = null,Object? invoiceNumber = freezed,Object? entryType = null,Object? amount = null,Object? paymentMethod = freezed,Object? entryDate = null,Object? transactionSource = freezed,Object? referenceId = freezed,Object? remarks = freezed,Object? createdAt = null,}) {
  return _then(_LedgerEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,partyType: null == partyType ? _self.partyType : partyType // ignore: cast_nullable_to_non_nullable
as PartyType,partyId: null == partyId ? _self.partyId : partyId // ignore: cast_nullable_to_non_nullable
as int,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,entryType: null == entryType ? _self.entryType : entryType // ignore: cast_nullable_to_non_nullable
as EntryType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,transactionSource: freezed == transactionSource ? _self.transactionSource : transactionSource // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
