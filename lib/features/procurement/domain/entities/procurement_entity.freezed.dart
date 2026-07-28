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

 int? get id;@JsonKey(name: 'vendor_id') int get vendorId;@JsonKey(name: 'procurement_date') String get procurementDate;@JsonKey(name: 'broker_id') int? get brokerId;@JsonKey(name: 'brokerage_price', readValue: _readDouble) double get brokeragePrice;@JsonKey(name: 'loading_charges', readValue: _readDouble) double get loadingCharges;@JsonKey(name: 'unloading_charges', readValue: _readDouble) double get unloadingCharges;@JsonKey(name: 'rent_amount', readValue: _readDouble) double get rentAmount;@JsonKey(name: 'rent_expense_head_id') int? get rentExpenseHeadId;@JsonKey(name: 'rent_expense_id') int? get rentExpenseId;@JsonKey(name: 'items_total', readValue: _readDouble) double get itemsTotal;@JsonKey(name: 'grand_total', readValue: _readDouble) double get total; String? get notes; List<ProcurementItemEntity> get items;
/// Create a copy of ProcurementEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcurementEntityCopyWith<ProcurementEntity> get copyWith => _$ProcurementEntityCopyWithImpl<ProcurementEntity>(this as ProcurementEntity, _$identity);

  /// Serializes this ProcurementEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcurementEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.procurementDate, procurementDate) || other.procurementDate == procurementDate)&&(identical(other.brokerId, brokerId) || other.brokerId == brokerId)&&(identical(other.brokeragePrice, brokeragePrice) || other.brokeragePrice == brokeragePrice)&&(identical(other.loadingCharges, loadingCharges) || other.loadingCharges == loadingCharges)&&(identical(other.unloadingCharges, unloadingCharges) || other.unloadingCharges == unloadingCharges)&&(identical(other.rentAmount, rentAmount) || other.rentAmount == rentAmount)&&(identical(other.rentExpenseHeadId, rentExpenseHeadId) || other.rentExpenseHeadId == rentExpenseHeadId)&&(identical(other.rentExpenseId, rentExpenseId) || other.rentExpenseId == rentExpenseId)&&(identical(other.itemsTotal, itemsTotal) || other.itemsTotal == itemsTotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,procurementDate,brokerId,brokeragePrice,loadingCharges,unloadingCharges,rentAmount,rentExpenseHeadId,rentExpenseId,itemsTotal,total,notes,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ProcurementEntity(id: $id, vendorId: $vendorId, procurementDate: $procurementDate, brokerId: $brokerId, brokeragePrice: $brokeragePrice, loadingCharges: $loadingCharges, unloadingCharges: $unloadingCharges, rentAmount: $rentAmount, rentExpenseHeadId: $rentExpenseHeadId, rentExpenseId: $rentExpenseId, itemsTotal: $itemsTotal, total: $total, notes: $notes, items: $items)';
}


}

/// @nodoc
abstract mixin class $ProcurementEntityCopyWith<$Res>  {
  factory $ProcurementEntityCopyWith(ProcurementEntity value, $Res Function(ProcurementEntity) _then) = _$ProcurementEntityCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'vendor_id') int vendorId,@JsonKey(name: 'procurement_date') String procurementDate,@JsonKey(name: 'broker_id') int? brokerId,@JsonKey(name: 'brokerage_price', readValue: _readDouble) double brokeragePrice,@JsonKey(name: 'loading_charges', readValue: _readDouble) double loadingCharges,@JsonKey(name: 'unloading_charges', readValue: _readDouble) double unloadingCharges,@JsonKey(name: 'rent_amount', readValue: _readDouble) double rentAmount,@JsonKey(name: 'rent_expense_head_id') int? rentExpenseHeadId,@JsonKey(name: 'rent_expense_id') int? rentExpenseId,@JsonKey(name: 'items_total', readValue: _readDouble) double itemsTotal,@JsonKey(name: 'grand_total', readValue: _readDouble) double total, String? notes, List<ProcurementItemEntity> items
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? vendorId = null,Object? procurementDate = null,Object? brokerId = freezed,Object? brokeragePrice = null,Object? loadingCharges = null,Object? unloadingCharges = null,Object? rentAmount = null,Object? rentExpenseHeadId = freezed,Object? rentExpenseId = freezed,Object? itemsTotal = null,Object? total = null,Object? notes = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as int,procurementDate: null == procurementDate ? _self.procurementDate : procurementDate // ignore: cast_nullable_to_non_nullable
as String,brokerId: freezed == brokerId ? _self.brokerId : brokerId // ignore: cast_nullable_to_non_nullable
as int?,brokeragePrice: null == brokeragePrice ? _self.brokeragePrice : brokeragePrice // ignore: cast_nullable_to_non_nullable
as double,loadingCharges: null == loadingCharges ? _self.loadingCharges : loadingCharges // ignore: cast_nullable_to_non_nullable
as double,unloadingCharges: null == unloadingCharges ? _self.unloadingCharges : unloadingCharges // ignore: cast_nullable_to_non_nullable
as double,rentAmount: null == rentAmount ? _self.rentAmount : rentAmount // ignore: cast_nullable_to_non_nullable
as double,rentExpenseHeadId: freezed == rentExpenseHeadId ? _self.rentExpenseHeadId : rentExpenseHeadId // ignore: cast_nullable_to_non_nullable
as int?,rentExpenseId: freezed == rentExpenseId ? _self.rentExpenseId : rentExpenseId // ignore: cast_nullable_to_non_nullable
as int?,itemsTotal: null == itemsTotal ? _self.itemsTotal : itemsTotal // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProcurementItemEntity>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'vendor_id')  int vendorId, @JsonKey(name: 'procurement_date')  String procurementDate, @JsonKey(name: 'broker_id')  int? brokerId, @JsonKey(name: 'brokerage_price', readValue: _readDouble)  double brokeragePrice, @JsonKey(name: 'loading_charges', readValue: _readDouble)  double loadingCharges, @JsonKey(name: 'unloading_charges', readValue: _readDouble)  double unloadingCharges, @JsonKey(name: 'rent_amount', readValue: _readDouble)  double rentAmount, @JsonKey(name: 'rent_expense_head_id')  int? rentExpenseHeadId, @JsonKey(name: 'rent_expense_id')  int? rentExpenseId, @JsonKey(name: 'items_total', readValue: _readDouble)  double itemsTotal, @JsonKey(name: 'grand_total', readValue: _readDouble)  double total,  String? notes,  List<ProcurementItemEntity> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProcurementEntity() when $default != null:
return $default(_that.id,_that.vendorId,_that.procurementDate,_that.brokerId,_that.brokeragePrice,_that.loadingCharges,_that.unloadingCharges,_that.rentAmount,_that.rentExpenseHeadId,_that.rentExpenseId,_that.itemsTotal,_that.total,_that.notes,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'vendor_id')  int vendorId, @JsonKey(name: 'procurement_date')  String procurementDate, @JsonKey(name: 'broker_id')  int? brokerId, @JsonKey(name: 'brokerage_price', readValue: _readDouble)  double brokeragePrice, @JsonKey(name: 'loading_charges', readValue: _readDouble)  double loadingCharges, @JsonKey(name: 'unloading_charges', readValue: _readDouble)  double unloadingCharges, @JsonKey(name: 'rent_amount', readValue: _readDouble)  double rentAmount, @JsonKey(name: 'rent_expense_head_id')  int? rentExpenseHeadId, @JsonKey(name: 'rent_expense_id')  int? rentExpenseId, @JsonKey(name: 'items_total', readValue: _readDouble)  double itemsTotal, @JsonKey(name: 'grand_total', readValue: _readDouble)  double total,  String? notes,  List<ProcurementItemEntity> items)  $default,) {final _that = this;
switch (_that) {
case _ProcurementEntity():
return $default(_that.id,_that.vendorId,_that.procurementDate,_that.brokerId,_that.brokeragePrice,_that.loadingCharges,_that.unloadingCharges,_that.rentAmount,_that.rentExpenseHeadId,_that.rentExpenseId,_that.itemsTotal,_that.total,_that.notes,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'vendor_id')  int vendorId, @JsonKey(name: 'procurement_date')  String procurementDate, @JsonKey(name: 'broker_id')  int? brokerId, @JsonKey(name: 'brokerage_price', readValue: _readDouble)  double brokeragePrice, @JsonKey(name: 'loading_charges', readValue: _readDouble)  double loadingCharges, @JsonKey(name: 'unloading_charges', readValue: _readDouble)  double unloadingCharges, @JsonKey(name: 'rent_amount', readValue: _readDouble)  double rentAmount, @JsonKey(name: 'rent_expense_head_id')  int? rentExpenseHeadId, @JsonKey(name: 'rent_expense_id')  int? rentExpenseId, @JsonKey(name: 'items_total', readValue: _readDouble)  double itemsTotal, @JsonKey(name: 'grand_total', readValue: _readDouble)  double total,  String? notes,  List<ProcurementItemEntity> items)?  $default,) {final _that = this;
switch (_that) {
case _ProcurementEntity() when $default != null:
return $default(_that.id,_that.vendorId,_that.procurementDate,_that.brokerId,_that.brokeragePrice,_that.loadingCharges,_that.unloadingCharges,_that.rentAmount,_that.rentExpenseHeadId,_that.rentExpenseId,_that.itemsTotal,_that.total,_that.notes,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProcurementEntity implements ProcurementEntity {
  const _ProcurementEntity({this.id, @JsonKey(name: 'vendor_id') required this.vendorId, @JsonKey(name: 'procurement_date') required this.procurementDate, @JsonKey(name: 'broker_id') this.brokerId, @JsonKey(name: 'brokerage_price', readValue: _readDouble) this.brokeragePrice = 0.0, @JsonKey(name: 'loading_charges', readValue: _readDouble) this.loadingCharges = 0.0, @JsonKey(name: 'unloading_charges', readValue: _readDouble) this.unloadingCharges = 0.0, @JsonKey(name: 'rent_amount', readValue: _readDouble) this.rentAmount = 0.0, @JsonKey(name: 'rent_expense_head_id') this.rentExpenseHeadId, @JsonKey(name: 'rent_expense_id') this.rentExpenseId, @JsonKey(name: 'items_total', readValue: _readDouble) this.itemsTotal = 0.0, @JsonKey(name: 'grand_total', readValue: _readDouble) required this.total, this.notes, required final  List<ProcurementItemEntity> items}): _items = items;
  factory _ProcurementEntity.fromJson(Map<String, dynamic> json) => _$ProcurementEntityFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'vendor_id') final  int vendorId;
@override@JsonKey(name: 'procurement_date') final  String procurementDate;
@override@JsonKey(name: 'broker_id') final  int? brokerId;
@override@JsonKey(name: 'brokerage_price', readValue: _readDouble) final  double brokeragePrice;
@override@JsonKey(name: 'loading_charges', readValue: _readDouble) final  double loadingCharges;
@override@JsonKey(name: 'unloading_charges', readValue: _readDouble) final  double unloadingCharges;
@override@JsonKey(name: 'rent_amount', readValue: _readDouble) final  double rentAmount;
@override@JsonKey(name: 'rent_expense_head_id') final  int? rentExpenseHeadId;
@override@JsonKey(name: 'rent_expense_id') final  int? rentExpenseId;
@override@JsonKey(name: 'items_total', readValue: _readDouble) final  double itemsTotal;
@override@JsonKey(name: 'grand_total', readValue: _readDouble) final  double total;
@override final  String? notes;
 final  List<ProcurementItemEntity> _items;
@override List<ProcurementItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcurementEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.procurementDate, procurementDate) || other.procurementDate == procurementDate)&&(identical(other.brokerId, brokerId) || other.brokerId == brokerId)&&(identical(other.brokeragePrice, brokeragePrice) || other.brokeragePrice == brokeragePrice)&&(identical(other.loadingCharges, loadingCharges) || other.loadingCharges == loadingCharges)&&(identical(other.unloadingCharges, unloadingCharges) || other.unloadingCharges == unloadingCharges)&&(identical(other.rentAmount, rentAmount) || other.rentAmount == rentAmount)&&(identical(other.rentExpenseHeadId, rentExpenseHeadId) || other.rentExpenseHeadId == rentExpenseHeadId)&&(identical(other.rentExpenseId, rentExpenseId) || other.rentExpenseId == rentExpenseId)&&(identical(other.itemsTotal, itemsTotal) || other.itemsTotal == itemsTotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,procurementDate,brokerId,brokeragePrice,loadingCharges,unloadingCharges,rentAmount,rentExpenseHeadId,rentExpenseId,itemsTotal,total,notes,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ProcurementEntity(id: $id, vendorId: $vendorId, procurementDate: $procurementDate, brokerId: $brokerId, brokeragePrice: $brokeragePrice, loadingCharges: $loadingCharges, unloadingCharges: $unloadingCharges, rentAmount: $rentAmount, rentExpenseHeadId: $rentExpenseHeadId, rentExpenseId: $rentExpenseId, itemsTotal: $itemsTotal, total: $total, notes: $notes, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ProcurementEntityCopyWith<$Res> implements $ProcurementEntityCopyWith<$Res> {
  factory _$ProcurementEntityCopyWith(_ProcurementEntity value, $Res Function(_ProcurementEntity) _then) = __$ProcurementEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'vendor_id') int vendorId,@JsonKey(name: 'procurement_date') String procurementDate,@JsonKey(name: 'broker_id') int? brokerId,@JsonKey(name: 'brokerage_price', readValue: _readDouble) double brokeragePrice,@JsonKey(name: 'loading_charges', readValue: _readDouble) double loadingCharges,@JsonKey(name: 'unloading_charges', readValue: _readDouble) double unloadingCharges,@JsonKey(name: 'rent_amount', readValue: _readDouble) double rentAmount,@JsonKey(name: 'rent_expense_head_id') int? rentExpenseHeadId,@JsonKey(name: 'rent_expense_id') int? rentExpenseId,@JsonKey(name: 'items_total', readValue: _readDouble) double itemsTotal,@JsonKey(name: 'grand_total', readValue: _readDouble) double total, String? notes, List<ProcurementItemEntity> items
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? vendorId = null,Object? procurementDate = null,Object? brokerId = freezed,Object? brokeragePrice = null,Object? loadingCharges = null,Object? unloadingCharges = null,Object? rentAmount = null,Object? rentExpenseHeadId = freezed,Object? rentExpenseId = freezed,Object? itemsTotal = null,Object? total = null,Object? notes = freezed,Object? items = null,}) {
  return _then(_ProcurementEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as int,procurementDate: null == procurementDate ? _self.procurementDate : procurementDate // ignore: cast_nullable_to_non_nullable
as String,brokerId: freezed == brokerId ? _self.brokerId : brokerId // ignore: cast_nullable_to_non_nullable
as int?,brokeragePrice: null == brokeragePrice ? _self.brokeragePrice : brokeragePrice // ignore: cast_nullable_to_non_nullable
as double,loadingCharges: null == loadingCharges ? _self.loadingCharges : loadingCharges // ignore: cast_nullable_to_non_nullable
as double,unloadingCharges: null == unloadingCharges ? _self.unloadingCharges : unloadingCharges // ignore: cast_nullable_to_non_nullable
as double,rentAmount: null == rentAmount ? _self.rentAmount : rentAmount // ignore: cast_nullable_to_non_nullable
as double,rentExpenseHeadId: freezed == rentExpenseHeadId ? _self.rentExpenseHeadId : rentExpenseHeadId // ignore: cast_nullable_to_non_nullable
as int?,rentExpenseId: freezed == rentExpenseId ? _self.rentExpenseId : rentExpenseId // ignore: cast_nullable_to_non_nullable
as int?,itemsTotal: null == itemsTotal ? _self.itemsTotal : itemsTotal // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProcurementItemEntity>,
  ));
}


}

// dart format on
