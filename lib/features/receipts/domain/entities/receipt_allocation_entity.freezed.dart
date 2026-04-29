// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_allocation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptAllocationEntity {

 int? get id; int? get receiptId; int get invoiceId; double get amount; DateTime? get createdAt;
/// Create a copy of ReceiptAllocationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptAllocationEntityCopyWith<ReceiptAllocationEntity> get copyWith => _$ReceiptAllocationEntityCopyWithImpl<ReceiptAllocationEntity>(this as ReceiptAllocationEntity, _$identity);

  /// Serializes this ReceiptAllocationEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptAllocationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,receiptId,invoiceId,amount,createdAt);

@override
String toString() {
  return 'ReceiptAllocationEntity(id: $id, receiptId: $receiptId, invoiceId: $invoiceId, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReceiptAllocationEntityCopyWith<$Res>  {
  factory $ReceiptAllocationEntityCopyWith(ReceiptAllocationEntity value, $Res Function(ReceiptAllocationEntity) _then) = _$ReceiptAllocationEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int? receiptId, int invoiceId, double amount, DateTime? createdAt
});




}
/// @nodoc
class _$ReceiptAllocationEntityCopyWithImpl<$Res>
    implements $ReceiptAllocationEntityCopyWith<$Res> {
  _$ReceiptAllocationEntityCopyWithImpl(this._self, this._then);

  final ReceiptAllocationEntity _self;
  final $Res Function(ReceiptAllocationEntity) _then;

/// Create a copy of ReceiptAllocationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? receiptId = freezed,Object? invoiceId = null,Object? amount = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as int?,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptAllocationEntity].
extension ReceiptAllocationEntityPatterns on ReceiptAllocationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptAllocationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptAllocationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptAllocationEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptAllocationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptAllocationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptAllocationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? receiptId,  int invoiceId,  double amount,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptAllocationEntity() when $default != null:
return $default(_that.id,_that.receiptId,_that.invoiceId,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? receiptId,  int invoiceId,  double amount,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReceiptAllocationEntity():
return $default(_that.id,_that.receiptId,_that.invoiceId,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? receiptId,  int invoiceId,  double amount,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptAllocationEntity() when $default != null:
return $default(_that.id,_that.receiptId,_that.invoiceId,_that.amount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptAllocationEntity implements ReceiptAllocationEntity {
  const _ReceiptAllocationEntity({this.id, this.receiptId, required this.invoiceId, required this.amount, this.createdAt});
  factory _ReceiptAllocationEntity.fromJson(Map<String, dynamic> json) => _$ReceiptAllocationEntityFromJson(json);

@override final  int? id;
@override final  int? receiptId;
@override final  int invoiceId;
@override final  double amount;
@override final  DateTime? createdAt;

/// Create a copy of ReceiptAllocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptAllocationEntityCopyWith<_ReceiptAllocationEntity> get copyWith => __$ReceiptAllocationEntityCopyWithImpl<_ReceiptAllocationEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptAllocationEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptAllocationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,receiptId,invoiceId,amount,createdAt);

@override
String toString() {
  return 'ReceiptAllocationEntity(id: $id, receiptId: $receiptId, invoiceId: $invoiceId, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReceiptAllocationEntityCopyWith<$Res> implements $ReceiptAllocationEntityCopyWith<$Res> {
  factory _$ReceiptAllocationEntityCopyWith(_ReceiptAllocationEntity value, $Res Function(_ReceiptAllocationEntity) _then) = __$ReceiptAllocationEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? receiptId, int invoiceId, double amount, DateTime? createdAt
});




}
/// @nodoc
class __$ReceiptAllocationEntityCopyWithImpl<$Res>
    implements _$ReceiptAllocationEntityCopyWith<$Res> {
  __$ReceiptAllocationEntityCopyWithImpl(this._self, this._then);

  final _ReceiptAllocationEntity _self;
  final $Res Function(_ReceiptAllocationEntity) _then;

/// Create a copy of ReceiptAllocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? receiptId = freezed,Object? invoiceId = null,Object? amount = null,Object? createdAt = freezed,}) {
  return _then(_ReceiptAllocationEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as int?,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
