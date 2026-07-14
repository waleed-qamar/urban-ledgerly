// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceItemEntity {

 int? get id; int? get invoiceId; int? get orderItemId; int? get productId; int? get setId; bool get isSet; int get quantity; double get unitPrice; double get totalPrice; String? get description; String get unitType;
/// Create a copy of InvoiceItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceItemEntityCopyWith<InvoiceItemEntity> get copyWith => _$InvoiceItemEntityCopyWithImpl<InvoiceItemEntity>(this as InvoiceItemEntity, _$identity);

  /// Serializes this InvoiceItemEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.setId, setId) || other.setId == setId)&&(identical(other.isSet, isSet) || other.isSet == isSet)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.description, description) || other.description == description)&&(identical(other.unitType, unitType) || other.unitType == unitType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceId,orderItemId,productId,setId,isSet,quantity,unitPrice,totalPrice,description,unitType);

@override
String toString() {
  return 'InvoiceItemEntity(id: $id, invoiceId: $invoiceId, orderItemId: $orderItemId, productId: $productId, setId: $setId, isSet: $isSet, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, description: $description, unitType: $unitType)';
}


}

/// @nodoc
abstract mixin class $InvoiceItemEntityCopyWith<$Res>  {
  factory $InvoiceItemEntityCopyWith(InvoiceItemEntity value, $Res Function(InvoiceItemEntity) _then) = _$InvoiceItemEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int? invoiceId, int? orderItemId, int? productId, int? setId, bool isSet, int quantity, double unitPrice, double totalPrice, String? description, String unitType
});




}
/// @nodoc
class _$InvoiceItemEntityCopyWithImpl<$Res>
    implements $InvoiceItemEntityCopyWith<$Res> {
  _$InvoiceItemEntityCopyWithImpl(this._self, this._then);

  final InvoiceItemEntity _self;
  final $Res Function(InvoiceItemEntity) _then;

/// Create a copy of InvoiceItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? invoiceId = freezed,Object? orderItemId = freezed,Object? productId = freezed,Object? setId = freezed,Object? isSet = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,Object? description = freezed,Object? unitType = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as int?,orderItemId: freezed == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,setId: freezed == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as int?,isSet: null == isSet ? _self.isSet : isSet // ignore: cast_nullable_to_non_nullable
as bool,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceItemEntity].
extension InvoiceItemEntityPatterns on InvoiceItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? invoiceId,  int? orderItemId,  int? productId,  int? setId,  bool isSet,  int quantity,  double unitPrice,  double totalPrice,  String? description,  String unitType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceItemEntity() when $default != null:
return $default(_that.id,_that.invoiceId,_that.orderItemId,_that.productId,_that.setId,_that.isSet,_that.quantity,_that.unitPrice,_that.totalPrice,_that.description,_that.unitType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? invoiceId,  int? orderItemId,  int? productId,  int? setId,  bool isSet,  int quantity,  double unitPrice,  double totalPrice,  String? description,  String unitType)  $default,) {final _that = this;
switch (_that) {
case _InvoiceItemEntity():
return $default(_that.id,_that.invoiceId,_that.orderItemId,_that.productId,_that.setId,_that.isSet,_that.quantity,_that.unitPrice,_that.totalPrice,_that.description,_that.unitType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? invoiceId,  int? orderItemId,  int? productId,  int? setId,  bool isSet,  int quantity,  double unitPrice,  double totalPrice,  String? description,  String unitType)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceItemEntity() when $default != null:
return $default(_that.id,_that.invoiceId,_that.orderItemId,_that.productId,_that.setId,_that.isSet,_that.quantity,_that.unitPrice,_that.totalPrice,_that.description,_that.unitType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceItemEntity implements InvoiceItemEntity {
  const _InvoiceItemEntity({this.id, this.invoiceId, this.orderItemId, this.productId, this.setId, this.isSet = false, required this.quantity, required this.unitPrice, required this.totalPrice, this.description, this.unitType = 'Each'});
  factory _InvoiceItemEntity.fromJson(Map<String, dynamic> json) => _$InvoiceItemEntityFromJson(json);

@override final  int? id;
@override final  int? invoiceId;
@override final  int? orderItemId;
@override final  int? productId;
@override final  int? setId;
@override@JsonKey() final  bool isSet;
@override final  int quantity;
@override final  double unitPrice;
@override final  double totalPrice;
@override final  String? description;
@override@JsonKey() final  String unitType;

/// Create a copy of InvoiceItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceItemEntityCopyWith<_InvoiceItemEntity> get copyWith => __$InvoiceItemEntityCopyWithImpl<_InvoiceItemEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceItemEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.setId, setId) || other.setId == setId)&&(identical(other.isSet, isSet) || other.isSet == isSet)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.description, description) || other.description == description)&&(identical(other.unitType, unitType) || other.unitType == unitType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceId,orderItemId,productId,setId,isSet,quantity,unitPrice,totalPrice,description,unitType);

@override
String toString() {
  return 'InvoiceItemEntity(id: $id, invoiceId: $invoiceId, orderItemId: $orderItemId, productId: $productId, setId: $setId, isSet: $isSet, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, description: $description, unitType: $unitType)';
}


}

/// @nodoc
abstract mixin class _$InvoiceItemEntityCopyWith<$Res> implements $InvoiceItemEntityCopyWith<$Res> {
  factory _$InvoiceItemEntityCopyWith(_InvoiceItemEntity value, $Res Function(_InvoiceItemEntity) _then) = __$InvoiceItemEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? invoiceId, int? orderItemId, int? productId, int? setId, bool isSet, int quantity, double unitPrice, double totalPrice, String? description, String unitType
});




}
/// @nodoc
class __$InvoiceItemEntityCopyWithImpl<$Res>
    implements _$InvoiceItemEntityCopyWith<$Res> {
  __$InvoiceItemEntityCopyWithImpl(this._self, this._then);

  final _InvoiceItemEntity _self;
  final $Res Function(_InvoiceItemEntity) _then;

/// Create a copy of InvoiceItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? invoiceId = freezed,Object? orderItemId = freezed,Object? productId = freezed,Object? setId = freezed,Object? isSet = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,Object? description = freezed,Object? unitType = null,}) {
  return _then(_InvoiceItemEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as int?,orderItemId: freezed == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,setId: freezed == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as int?,isSet: null == isSet ? _self.isSet : isSet // ignore: cast_nullable_to_non_nullable
as bool,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
