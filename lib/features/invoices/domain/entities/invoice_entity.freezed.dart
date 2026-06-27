// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceEntity {

 int? get id; int get orderId; int get clientId; int get supplierId; String get invoiceNumber; String get status; String? get po; DateTime get issueDate; double get subTotal; double get shippingCost; double get taxPercent; double get taxAmount; double get grandTotal; String get representative; double get paidAmount; double get remainingAmount; DateTime get dispatchedAt; DateTime? get createdAt; List<InvoiceItemEntity> get items;
/// Create a copy of InvoiceEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceEntityCopyWith<InvoiceEntity> get copyWith => _$InvoiceEntityCopyWithImpl<InvoiceEntity>(this as InvoiceEntity, _$identity);

  /// Serializes this InvoiceEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.po, po) || other.po == po)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.shippingCost, shippingCost) || other.shippingCost == shippingCost)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.representative, representative) || other.representative == representative)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.dispatchedAt, dispatchedAt) || other.dispatchedAt == dispatchedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,clientId,supplierId,invoiceNumber,status,po,issueDate,subTotal,shippingCost,taxPercent,taxAmount,grandTotal,representative,paidAmount,remainingAmount,dispatchedAt,createdAt,const DeepCollectionEquality().hash(items)]);

@override
String toString() {
  return 'InvoiceEntity(id: $id, orderId: $orderId, clientId: $clientId, supplierId: $supplierId, invoiceNumber: $invoiceNumber, status: $status, po: $po, issueDate: $issueDate, subTotal: $subTotal, shippingCost: $shippingCost, taxPercent: $taxPercent, taxAmount: $taxAmount, grandTotal: $grandTotal, representative: $representative, paidAmount: $paidAmount, remainingAmount: $remainingAmount, dispatchedAt: $dispatchedAt, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $InvoiceEntityCopyWith<$Res>  {
  factory $InvoiceEntityCopyWith(InvoiceEntity value, $Res Function(InvoiceEntity) _then) = _$InvoiceEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int orderId, int clientId, int supplierId, String invoiceNumber, String status, String? po, DateTime issueDate, double subTotal, double shippingCost, double taxPercent, double taxAmount, double grandTotal, String representative, double paidAmount, double remainingAmount, DateTime dispatchedAt, DateTime? createdAt, List<InvoiceItemEntity> items
});




}
/// @nodoc
class _$InvoiceEntityCopyWithImpl<$Res>
    implements $InvoiceEntityCopyWith<$Res> {
  _$InvoiceEntityCopyWithImpl(this._self, this._then);

  final InvoiceEntity _self;
  final $Res Function(InvoiceEntity) _then;

/// Create a copy of InvoiceEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orderId = null,Object? clientId = null,Object? supplierId = null,Object? invoiceNumber = null,Object? status = null,Object? po = freezed,Object? issueDate = null,Object? subTotal = null,Object? shippingCost = null,Object? taxPercent = null,Object? taxAmount = null,Object? grandTotal = null,Object? representative = null,Object? paidAmount = null,Object? remainingAmount = null,Object? dispatchedAt = null,Object? createdAt = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as int,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as int,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,po: freezed == po ? _self.po : po // ignore: cast_nullable_to_non_nullable
as String?,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,shippingCost: null == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as double,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,representative: null == representative ? _self.representative : representative // ignore: cast_nullable_to_non_nullable
as String,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,remainingAmount: null == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as double,dispatchedAt: null == dispatchedAt ? _self.dispatchedAt : dispatchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItemEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceEntity].
extension InvoiceEntityPatterns on InvoiceEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceEntity value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int orderId,  int clientId,  int supplierId,  String invoiceNumber,  String status,  String? po,  DateTime issueDate,  double subTotal,  double shippingCost,  double taxPercent,  double taxAmount,  double grandTotal,  String representative,  double paidAmount,  double remainingAmount,  DateTime dispatchedAt,  DateTime? createdAt,  List<InvoiceItemEntity> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceEntity() when $default != null:
return $default(_that.id,_that.orderId,_that.clientId,_that.supplierId,_that.invoiceNumber,_that.status,_that.po,_that.issueDate,_that.subTotal,_that.shippingCost,_that.taxPercent,_that.taxAmount,_that.grandTotal,_that.representative,_that.paidAmount,_that.remainingAmount,_that.dispatchedAt,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int orderId,  int clientId,  int supplierId,  String invoiceNumber,  String status,  String? po,  DateTime issueDate,  double subTotal,  double shippingCost,  double taxPercent,  double taxAmount,  double grandTotal,  String representative,  double paidAmount,  double remainingAmount,  DateTime dispatchedAt,  DateTime? createdAt,  List<InvoiceItemEntity> items)  $default,) {final _that = this;
switch (_that) {
case _InvoiceEntity():
return $default(_that.id,_that.orderId,_that.clientId,_that.supplierId,_that.invoiceNumber,_that.status,_that.po,_that.issueDate,_that.subTotal,_that.shippingCost,_that.taxPercent,_that.taxAmount,_that.grandTotal,_that.representative,_that.paidAmount,_that.remainingAmount,_that.dispatchedAt,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int orderId,  int clientId,  int supplierId,  String invoiceNumber,  String status,  String? po,  DateTime issueDate,  double subTotal,  double shippingCost,  double taxPercent,  double taxAmount,  double grandTotal,  String representative,  double paidAmount,  double remainingAmount,  DateTime dispatchedAt,  DateTime? createdAt,  List<InvoiceItemEntity> items)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceEntity() when $default != null:
return $default(_that.id,_that.orderId,_that.clientId,_that.supplierId,_that.invoiceNumber,_that.status,_that.po,_that.issueDate,_that.subTotal,_that.shippingCost,_that.taxPercent,_that.taxAmount,_that.grandTotal,_that.representative,_that.paidAmount,_that.remainingAmount,_that.dispatchedAt,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceEntity implements InvoiceEntity {
  const _InvoiceEntity({this.id, required this.orderId, required this.clientId, required this.supplierId, required this.invoiceNumber, required this.status, this.po, required this.issueDate, required this.subTotal, required this.shippingCost, this.taxPercent = 18.00, required this.taxAmount, required this.grandTotal, required this.representative, this.paidAmount = 0, this.remainingAmount = 0, required this.dispatchedAt, this.createdAt, final  List<InvoiceItemEntity> items = const []}): _items = items;
  factory _InvoiceEntity.fromJson(Map<String, dynamic> json) => _$InvoiceEntityFromJson(json);

@override final  int? id;
@override final  int orderId;
@override final  int clientId;
@override final  int supplierId;
@override final  String invoiceNumber;
@override final  String status;
@override final  String? po;
@override final  DateTime issueDate;
@override final  double subTotal;
@override final  double shippingCost;
@override@JsonKey() final  double taxPercent;
@override final  double taxAmount;
@override final  double grandTotal;
@override final  String representative;
@override@JsonKey() final  double paidAmount;
@override@JsonKey() final  double remainingAmount;
@override final  DateTime dispatchedAt;
@override final  DateTime? createdAt;
 final  List<InvoiceItemEntity> _items;
@override@JsonKey() List<InvoiceItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of InvoiceEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceEntityCopyWith<_InvoiceEntity> get copyWith => __$InvoiceEntityCopyWithImpl<_InvoiceEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.po, po) || other.po == po)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.shippingCost, shippingCost) || other.shippingCost == shippingCost)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.representative, representative) || other.representative == representative)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.dispatchedAt, dispatchedAt) || other.dispatchedAt == dispatchedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,clientId,supplierId,invoiceNumber,status,po,issueDate,subTotal,shippingCost,taxPercent,taxAmount,grandTotal,representative,paidAmount,remainingAmount,dispatchedAt,createdAt,const DeepCollectionEquality().hash(_items)]);

@override
String toString() {
  return 'InvoiceEntity(id: $id, orderId: $orderId, clientId: $clientId, supplierId: $supplierId, invoiceNumber: $invoiceNumber, status: $status, po: $po, issueDate: $issueDate, subTotal: $subTotal, shippingCost: $shippingCost, taxPercent: $taxPercent, taxAmount: $taxAmount, grandTotal: $grandTotal, representative: $representative, paidAmount: $paidAmount, remainingAmount: $remainingAmount, dispatchedAt: $dispatchedAt, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$InvoiceEntityCopyWith<$Res> implements $InvoiceEntityCopyWith<$Res> {
  factory _$InvoiceEntityCopyWith(_InvoiceEntity value, $Res Function(_InvoiceEntity) _then) = __$InvoiceEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int orderId, int clientId, int supplierId, String invoiceNumber, String status, String? po, DateTime issueDate, double subTotal, double shippingCost, double taxPercent, double taxAmount, double grandTotal, String representative, double paidAmount, double remainingAmount, DateTime dispatchedAt, DateTime? createdAt, List<InvoiceItemEntity> items
});




}
/// @nodoc
class __$InvoiceEntityCopyWithImpl<$Res>
    implements _$InvoiceEntityCopyWith<$Res> {
  __$InvoiceEntityCopyWithImpl(this._self, this._then);

  final _InvoiceEntity _self;
  final $Res Function(_InvoiceEntity) _then;

/// Create a copy of InvoiceEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orderId = null,Object? clientId = null,Object? supplierId = null,Object? invoiceNumber = null,Object? status = null,Object? po = freezed,Object? issueDate = null,Object? subTotal = null,Object? shippingCost = null,Object? taxPercent = null,Object? taxAmount = null,Object? grandTotal = null,Object? representative = null,Object? paidAmount = null,Object? remainingAmount = null,Object? dispatchedAt = null,Object? createdAt = freezed,Object? items = null,}) {
  return _then(_InvoiceEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as int,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as int,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,po: freezed == po ? _self.po : po // ignore: cast_nullable_to_non_nullable
as String?,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,shippingCost: null == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as double,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,representative: null == representative ? _self.representative : representative // ignore: cast_nullable_to_non_nullable
as String,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,remainingAmount: null == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as double,dispatchedAt: null == dispatchedAt ? _self.dispatchedAt : dispatchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItemEntity>,
  ));
}


}

// dart format on
