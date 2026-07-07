// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_set_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductSetItemEntity {

@JsonKey(name: 'set_id') int? get setid;@JsonKey(name: 'product_id') int get productId;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of ProductSetItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSetItemEntityCopyWith<ProductSetItemEntity> get copyWith => _$ProductSetItemEntityCopyWithImpl<ProductSetItemEntity>(this as ProductSetItemEntity, _$identity);

  /// Serializes this ProductSetItemEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSetItemEntity&&(identical(other.setid, setid) || other.setid == setid)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setid,productId,createdAt);

@override
String toString() {
  return 'ProductSetItemEntity(setid: $setid, productId: $productId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductSetItemEntityCopyWith<$Res>  {
  factory $ProductSetItemEntityCopyWith(ProductSetItemEntity value, $Res Function(ProductSetItemEntity) _then) = _$ProductSetItemEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'set_id') int? setid,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ProductSetItemEntityCopyWithImpl<$Res>
    implements $ProductSetItemEntityCopyWith<$Res> {
  _$ProductSetItemEntityCopyWithImpl(this._self, this._then);

  final ProductSetItemEntity _self;
  final $Res Function(ProductSetItemEntity) _then;

/// Create a copy of ProductSetItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setid = freezed,Object? productId = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
setid: freezed == setid ? _self.setid : setid // ignore: cast_nullable_to_non_nullable
as int?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSetItemEntity].
extension ProductSetItemEntityPatterns on ProductSetItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSetItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSetItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSetItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductSetItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSetItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSetItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'set_id')  int? setid, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSetItemEntity() when $default != null:
return $default(_that.setid,_that.productId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'set_id')  int? setid, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProductSetItemEntity():
return $default(_that.setid,_that.productId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'set_id')  int? setid, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductSetItemEntity() when $default != null:
return $default(_that.setid,_that.productId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSetItemEntity implements ProductSetItemEntity {
  const _ProductSetItemEntity({@JsonKey(name: 'set_id') this.setid, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'created_at') this.createdAt});
  factory _ProductSetItemEntity.fromJson(Map<String, dynamic> json) => _$ProductSetItemEntityFromJson(json);

@override@JsonKey(name: 'set_id') final  int? setid;
@override@JsonKey(name: 'product_id') final  int productId;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of ProductSetItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSetItemEntityCopyWith<_ProductSetItemEntity> get copyWith => __$ProductSetItemEntityCopyWithImpl<_ProductSetItemEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSetItemEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSetItemEntity&&(identical(other.setid, setid) || other.setid == setid)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setid,productId,createdAt);

@override
String toString() {
  return 'ProductSetItemEntity(setid: $setid, productId: $productId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductSetItemEntityCopyWith<$Res> implements $ProductSetItemEntityCopyWith<$Res> {
  factory _$ProductSetItemEntityCopyWith(_ProductSetItemEntity value, $Res Function(_ProductSetItemEntity) _then) = __$ProductSetItemEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'set_id') int? setid,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ProductSetItemEntityCopyWithImpl<$Res>
    implements _$ProductSetItemEntityCopyWith<$Res> {
  __$ProductSetItemEntityCopyWithImpl(this._self, this._then);

  final _ProductSetItemEntity _self;
  final $Res Function(_ProductSetItemEntity) _then;

/// Create a copy of ProductSetItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setid = freezed,Object? productId = null,Object? createdAt = freezed,}) {
  return _then(_ProductSetItemEntity(
setid: freezed == setid ? _self.setid : setid // ignore: cast_nullable_to_non_nullable
as int?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
