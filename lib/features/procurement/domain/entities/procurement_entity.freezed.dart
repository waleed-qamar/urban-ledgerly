// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procurement_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProcurementEntity {

 int? get id; int get rawMaterialId; int get vendorId; String get procurementDate; int get quantity; double get price; double get total; String? get notes;
/// Create a copy of ProcurementEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcurementEntityCopyWith<ProcurementEntity> get copyWith => _$ProcurementEntityCopyWithImpl<ProcurementEntity>(this as ProcurementEntity, _$identity);

  /// Serializes this ProcurementEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcurementEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.rawMaterialId, rawMaterialId) || other.rawMaterialId == rawMaterialId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.procurementDate, procurementDate) || other.procurementDate == procurementDate)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.total, total) || other.total == total)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rawMaterialId,vendorId,procurementDate,quantity,price,total,notes);

@override
String toString() {
  return 'ProcurementEntity(id: $id, rawMaterialId: $rawMaterialId, vendorId: $vendorId, procurementDate: $procurementDate, quantity: $quantity, price: $price, total: $total, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ProcurementEntityCopyWith<$Res>  {
  factory $ProcurementEntityCopyWith(ProcurementEntity value, $Res Function(ProcurementEntity) _then) = _$ProcurementEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int rawMaterialId, int vendorId, String procurementDate, int quantity, double price, double total, String? notes
});




}
/// @nodoc
class _$ProcurementEntityCopyWithImpl<$Res>
    implements $ProcurementEntityCopyWith<$Res> {
  _$ProcurementEntityCopyWithImpl(this._self, this._then);

  final ProcurementEntity _self;
  final $Res Function(ProcurementEntity) _then;

/// Create a copy of ProcurementEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? rawMaterialId = null,Object? vendorId = null,Object? procurementDate = null,Object? quantity = null,Object? price = null,Object? total = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,rawMaterialId: null == rawMaterialId ? _self.rawMaterialId : rawMaterialId // ignore: cast_nullable_to_non_nullable
as int,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as int,procurementDate: null == procurementDate ? _self.procurementDate : procurementDate // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProcurementEntity].
extension ProcurementEntityPatterns on ProcurementEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProcurementEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProcurementEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProcurementEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProcurementEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProcurementEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProcurementEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int rawMaterialId,  int vendorId,  String procurementDate,  int quantity,  double price,  double total,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProcurementEntity() when $default != null:
return $default(_that.id,_that.rawMaterialId,_that.vendorId,_that.procurementDate,_that.quantity,_that.price,_that.total,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int rawMaterialId,  int vendorId,  String procurementDate,  int quantity,  double price,  double total,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ProcurementEntity():
return $default(_that.id,_that.rawMaterialId,_that.vendorId,_that.procurementDate,_that.quantity,_that.price,_that.total,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int rawMaterialId,  int vendorId,  String procurementDate,  int quantity,  double price,  double total,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ProcurementEntity() when $default != null:
return $default(_that.id,_that.rawMaterialId,_that.vendorId,_that.procurementDate,_that.quantity,_that.price,_that.total,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProcurementEntity implements ProcurementEntity {
  const _ProcurementEntity({this.id, required this.rawMaterialId, required this.vendorId, required this.procurementDate, required this.quantity, required this.price, required this.total, this.notes});
  factory _ProcurementEntity.fromJson(Map<String, dynamic> json) => _$ProcurementEntityFromJson(json);

@override final  int? id;
@override final  int rawMaterialId;
@override final  int vendorId;
@override final  String procurementDate;
@override final  int quantity;
@override final  double price;
@override final  double total;
@override final  String? notes;

/// Create a copy of ProcurementEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcurementEntityCopyWith<_ProcurementEntity> get copyWith => __$ProcurementEntityCopyWithImpl<_ProcurementEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProcurementEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcurementEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.rawMaterialId, rawMaterialId) || other.rawMaterialId == rawMaterialId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.procurementDate, procurementDate) || other.procurementDate == procurementDate)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.total, total) || other.total == total)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rawMaterialId,vendorId,procurementDate,quantity,price,total,notes);

@override
String toString() {
  return 'ProcurementEntity(id: $id, rawMaterialId: $rawMaterialId, vendorId: $vendorId, procurementDate: $procurementDate, quantity: $quantity, price: $price, total: $total, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ProcurementEntityCopyWith<$Res> implements $ProcurementEntityCopyWith<$Res> {
  factory _$ProcurementEntityCopyWith(_ProcurementEntity value, $Res Function(_ProcurementEntity) _then) = __$ProcurementEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int rawMaterialId, int vendorId, String procurementDate, int quantity, double price, double total, String? notes
});




}
/// @nodoc
class __$ProcurementEntityCopyWithImpl<$Res>
    implements _$ProcurementEntityCopyWith<$Res> {
  __$ProcurementEntityCopyWithImpl(this._self, this._then);

  final _ProcurementEntity _self;
  final $Res Function(_ProcurementEntity) _then;

/// Create a copy of ProcurementEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? rawMaterialId = null,Object? vendorId = null,Object? procurementDate = null,Object? quantity = null,Object? price = null,Object? total = null,Object? notes = freezed,}) {
  return _then(_ProcurementEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,rawMaterialId: null == rawMaterialId ? _self.rawMaterialId : rawMaterialId // ignore: cast_nullable_to_non_nullable
as int,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as int,procurementDate: null == procurementDate ? _self.procurementDate : procurementDate // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
