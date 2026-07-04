// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procurement_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProcurementItemEntity {

 int? get id; int? get procurementId; int get rawMaterialId; int get quantity; double get price; double get total;
/// Create a copy of ProcurementItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcurementItemEntityCopyWith<ProcurementItemEntity> get copyWith => _$ProcurementItemEntityCopyWithImpl<ProcurementItemEntity>(this as ProcurementItemEntity, _$identity);

  /// Serializes this ProcurementItemEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcurementItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.procurementId, procurementId) || other.procurementId == procurementId)&&(identical(other.rawMaterialId, rawMaterialId) || other.rawMaterialId == rawMaterialId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,procurementId,rawMaterialId,quantity,price,total);

@override
String toString() {
  return 'ProcurementItemEntity(id: $id, procurementId: $procurementId, rawMaterialId: $rawMaterialId, quantity: $quantity, price: $price, total: $total)';
}


}

/// @nodoc
abstract mixin class $ProcurementItemEntityCopyWith<$Res>  {
  factory $ProcurementItemEntityCopyWith(ProcurementItemEntity value, $Res Function(ProcurementItemEntity) _then) = _$ProcurementItemEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int? procurementId, int rawMaterialId, int quantity, double price, double total
});




}
/// @nodoc
class _$ProcurementItemEntityCopyWithImpl<$Res>
    implements $ProcurementItemEntityCopyWith<$Res> {
  _$ProcurementItemEntityCopyWithImpl(this._self, this._then);

  final ProcurementItemEntity _self;
  final $Res Function(ProcurementItemEntity) _then;

/// Create a copy of ProcurementItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? procurementId = freezed,Object? rawMaterialId = null,Object? quantity = null,Object? price = null,Object? total = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,procurementId: freezed == procurementId ? _self.procurementId : procurementId // ignore: cast_nullable_to_non_nullable
as int?,rawMaterialId: null == rawMaterialId ? _self.rawMaterialId : rawMaterialId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProcurementItemEntity].
extension ProcurementItemEntityPatterns on ProcurementItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProcurementItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProcurementItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProcurementItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProcurementItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProcurementItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProcurementItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? procurementId,  int rawMaterialId,  int quantity,  double price,  double total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProcurementItemEntity() when $default != null:
return $default(_that.id,_that.procurementId,_that.rawMaterialId,_that.quantity,_that.price,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? procurementId,  int rawMaterialId,  int quantity,  double price,  double total)  $default,) {final _that = this;
switch (_that) {
case _ProcurementItemEntity():
return $default(_that.id,_that.procurementId,_that.rawMaterialId,_that.quantity,_that.price,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? procurementId,  int rawMaterialId,  int quantity,  double price,  double total)?  $default,) {final _that = this;
switch (_that) {
case _ProcurementItemEntity() when $default != null:
return $default(_that.id,_that.procurementId,_that.rawMaterialId,_that.quantity,_that.price,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProcurementItemEntity implements ProcurementItemEntity {
  const _ProcurementItemEntity({this.id, this.procurementId, required this.rawMaterialId, required this.quantity, required this.price, required this.total});
  factory _ProcurementItemEntity.fromJson(Map<String, dynamic> json) => _$ProcurementItemEntityFromJson(json);

@override final  int? id;
@override final  int? procurementId;
@override final  int rawMaterialId;
@override final  int quantity;
@override final  double price;
@override final  double total;

/// Create a copy of ProcurementItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcurementItemEntityCopyWith<_ProcurementItemEntity> get copyWith => __$ProcurementItemEntityCopyWithImpl<_ProcurementItemEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProcurementItemEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcurementItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.procurementId, procurementId) || other.procurementId == procurementId)&&(identical(other.rawMaterialId, rawMaterialId) || other.rawMaterialId == rawMaterialId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,procurementId,rawMaterialId,quantity,price,total);

@override
String toString() {
  return 'ProcurementItemEntity(id: $id, procurementId: $procurementId, rawMaterialId: $rawMaterialId, quantity: $quantity, price: $price, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ProcurementItemEntityCopyWith<$Res> implements $ProcurementItemEntityCopyWith<$Res> {
  factory _$ProcurementItemEntityCopyWith(_ProcurementItemEntity value, $Res Function(_ProcurementItemEntity) _then) = __$ProcurementItemEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? procurementId, int rawMaterialId, int quantity, double price, double total
});




}
/// @nodoc
class __$ProcurementItemEntityCopyWithImpl<$Res>
    implements _$ProcurementItemEntityCopyWith<$Res> {
  __$ProcurementItemEntityCopyWithImpl(this._self, this._then);

  final _ProcurementItemEntity _self;
  final $Res Function(_ProcurementItemEntity) _then;

/// Create a copy of ProcurementItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? procurementId = freezed,Object? rawMaterialId = null,Object? quantity = null,Object? price = null,Object? total = null,}) {
  return _then(_ProcurementItemEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,procurementId: freezed == procurementId ? _self.procurementId : procurementId // ignore: cast_nullable_to_non_nullable
as int?,rawMaterialId: null == rawMaterialId ? _self.rawMaterialId : rawMaterialId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
