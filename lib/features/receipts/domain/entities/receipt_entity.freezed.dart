// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptEntity {

 int? get id; int get clientId; String? get receiptNumber; double get totalAmount; String get paymentMethod; String? get accountNo; String? get remarks; DateTime get receivedDate; DateTime? get createdAt; List<ReceiptAllocationEntity> get allocations;
/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptEntityCopyWith<ReceiptEntity> get copyWith => _$ReceiptEntityCopyWithImpl<ReceiptEntity>(this as ReceiptEntity, _$identity);

  /// Serializes this ReceiptEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.accountNo, accountNo) || other.accountNo == accountNo)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.receivedDate, receivedDate) || other.receivedDate == receivedDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.allocations, allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,receiptNumber,totalAmount,paymentMethod,accountNo,remarks,receivedDate,createdAt,const DeepCollectionEquality().hash(allocations));

@override
String toString() {
  return 'ReceiptEntity(id: $id, clientId: $clientId, receiptNumber: $receiptNumber, totalAmount: $totalAmount, paymentMethod: $paymentMethod, accountNo: $accountNo, remarks: $remarks, receivedDate: $receivedDate, createdAt: $createdAt, allocations: $allocations)';
}


}

/// @nodoc
abstract mixin class $ReceiptEntityCopyWith<$Res>  {
  factory $ReceiptEntityCopyWith(ReceiptEntity value, $Res Function(ReceiptEntity) _then) = _$ReceiptEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int clientId, String? receiptNumber, double totalAmount, String paymentMethod, String? accountNo, String? remarks, DateTime receivedDate, DateTime? createdAt, List<ReceiptAllocationEntity> allocations
});




}
/// @nodoc
class _$ReceiptEntityCopyWithImpl<$Res>
    implements $ReceiptEntityCopyWith<$Res> {
  _$ReceiptEntityCopyWithImpl(this._self, this._then);

  final ReceiptEntity _self;
  final $Res Function(ReceiptEntity) _then;

/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? clientId = null,Object? receiptNumber = freezed,Object? totalAmount = null,Object? paymentMethod = null,Object? accountNo = freezed,Object? remarks = freezed,Object? receivedDate = null,Object? createdAt = freezed,Object? allocations = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as int,receiptNumber: freezed == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,accountNo: freezed == accountNo ? _self.accountNo : accountNo // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,receivedDate: null == receivedDate ? _self.receivedDate : receivedDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,allocations: null == allocations ? _self.allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<ReceiptAllocationEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptEntity].
extension ReceiptEntityPatterns on ReceiptEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int clientId,  String? receiptNumber,  double totalAmount,  String paymentMethod,  String? accountNo,  String? remarks,  DateTime receivedDate,  DateTime? createdAt,  List<ReceiptAllocationEntity> allocations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
return $default(_that.id,_that.clientId,_that.receiptNumber,_that.totalAmount,_that.paymentMethod,_that.accountNo,_that.remarks,_that.receivedDate,_that.createdAt,_that.allocations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int clientId,  String? receiptNumber,  double totalAmount,  String paymentMethod,  String? accountNo,  String? remarks,  DateTime receivedDate,  DateTime? createdAt,  List<ReceiptAllocationEntity> allocations)  $default,) {final _that = this;
switch (_that) {
case _ReceiptEntity():
return $default(_that.id,_that.clientId,_that.receiptNumber,_that.totalAmount,_that.paymentMethod,_that.accountNo,_that.remarks,_that.receivedDate,_that.createdAt,_that.allocations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int clientId,  String? receiptNumber,  double totalAmount,  String paymentMethod,  String? accountNo,  String? remarks,  DateTime receivedDate,  DateTime? createdAt,  List<ReceiptAllocationEntity> allocations)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
return $default(_that.id,_that.clientId,_that.receiptNumber,_that.totalAmount,_that.paymentMethod,_that.accountNo,_that.remarks,_that.receivedDate,_that.createdAt,_that.allocations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptEntity implements ReceiptEntity {
  const _ReceiptEntity({this.id, required this.clientId, this.receiptNumber, required this.totalAmount, required this.paymentMethod, this.accountNo, this.remarks, required this.receivedDate, this.createdAt, final  List<ReceiptAllocationEntity> allocations = const []}): _allocations = allocations;
  factory _ReceiptEntity.fromJson(Map<String, dynamic> json) => _$ReceiptEntityFromJson(json);

@override final  int? id;
@override final  int clientId;
@override final  String? receiptNumber;
@override final  double totalAmount;
@override final  String paymentMethod;
@override final  String? accountNo;
@override final  String? remarks;
@override final  DateTime receivedDate;
@override final  DateTime? createdAt;
 final  List<ReceiptAllocationEntity> _allocations;
@override@JsonKey() List<ReceiptAllocationEntity> get allocations {
  if (_allocations is EqualUnmodifiableListView) return _allocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allocations);
}


/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptEntityCopyWith<_ReceiptEntity> get copyWith => __$ReceiptEntityCopyWithImpl<_ReceiptEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.accountNo, accountNo) || other.accountNo == accountNo)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.receivedDate, receivedDate) || other.receivedDate == receivedDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._allocations, _allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,receiptNumber,totalAmount,paymentMethod,accountNo,remarks,receivedDate,createdAt,const DeepCollectionEquality().hash(_allocations));

@override
String toString() {
  return 'ReceiptEntity(id: $id, clientId: $clientId, receiptNumber: $receiptNumber, totalAmount: $totalAmount, paymentMethod: $paymentMethod, accountNo: $accountNo, remarks: $remarks, receivedDate: $receivedDate, createdAt: $createdAt, allocations: $allocations)';
}


}

/// @nodoc
abstract mixin class _$ReceiptEntityCopyWith<$Res> implements $ReceiptEntityCopyWith<$Res> {
  factory _$ReceiptEntityCopyWith(_ReceiptEntity value, $Res Function(_ReceiptEntity) _then) = __$ReceiptEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int clientId, String? receiptNumber, double totalAmount, String paymentMethod, String? accountNo, String? remarks, DateTime receivedDate, DateTime? createdAt, List<ReceiptAllocationEntity> allocations
});




}
/// @nodoc
class __$ReceiptEntityCopyWithImpl<$Res>
    implements _$ReceiptEntityCopyWith<$Res> {
  __$ReceiptEntityCopyWithImpl(this._self, this._then);

  final _ReceiptEntity _self;
  final $Res Function(_ReceiptEntity) _then;

/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? clientId = null,Object? receiptNumber = freezed,Object? totalAmount = null,Object? paymentMethod = null,Object? accountNo = freezed,Object? remarks = freezed,Object? receivedDate = null,Object? createdAt = freezed,Object? allocations = null,}) {
  return _then(_ReceiptEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as int,receiptNumber: freezed == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,accountNo: freezed == accountNo ? _self.accountNo : accountNo // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,receivedDate: null == receivedDate ? _self.receivedDate : receivedDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,allocations: null == allocations ? _self._allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<ReceiptAllocationEntity>,
  ));
}


}

// dart format on
