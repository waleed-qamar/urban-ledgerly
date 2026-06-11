// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_set_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductSetEntity {

 int? get setId; String get name; String? get description; List<ProductSetItemEntity> get products; DateTime? get createdAt;
/// Create a copy of ProductSetEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSetEntityCopyWith<ProductSetEntity> get copyWith => _$ProductSetEntityCopyWithImpl<ProductSetEntity>(this as ProductSetEntity, _$identity);

  /// Serializes this ProductSetEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSetEntity&&(identical(other.setId, setId) || other.setId == setId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setId,name,description,const DeepCollectionEquality().hash(products),createdAt);

@override
String toString() {
  return 'ProductSetEntity(setId: $setId, name: $name, description: $description, products: $products, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductSetEntityCopyWith<$Res>  {
  factory $ProductSetEntityCopyWith(ProductSetEntity value, $Res Function(ProductSetEntity) _then) = _$ProductSetEntityCopyWithImpl;
@useResult
$Res call({
 int? setId, String name, String? description, List<ProductSetItemEntity> products, DateTime? createdAt
});




}
/// @nodoc
class _$ProductSetEntityCopyWithImpl<$Res>
    implements $ProductSetEntityCopyWith<$Res> {
  _$ProductSetEntityCopyWithImpl(this._self, this._then);

  final ProductSetEntity _self;
  final $Res Function(ProductSetEntity) _then;

/// Create a copy of ProductSetEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setId = freezed,Object? name = null,Object? description = freezed,Object? products = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
setId: freezed == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductSetItemEntity>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSetEntity].
extension ProductSetEntityPatterns on ProductSetEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSetEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSetEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSetEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductSetEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSetEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSetEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? setId,  String name,  String? description,  List<ProductSetItemEntity> products,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSetEntity() when $default != null:
return $default(_that.setId,_that.name,_that.description,_that.products,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? setId,  String name,  String? description,  List<ProductSetItemEntity> products,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProductSetEntity():
return $default(_that.setId,_that.name,_that.description,_that.products,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? setId,  String name,  String? description,  List<ProductSetItemEntity> products,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductSetEntity() when $default != null:
return $default(_that.setId,_that.name,_that.description,_that.products,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSetEntity implements ProductSetEntity {
  const _ProductSetEntity({this.setId, required this.name, this.description, required final  List<ProductSetItemEntity> products, this.createdAt}): _products = products;
  factory _ProductSetEntity.fromJson(Map<String, dynamic> json) => _$ProductSetEntityFromJson(json);

@override final  int? setId;
@override final  String name;
@override final  String? description;
 final  List<ProductSetItemEntity> _products;
@override List<ProductSetItemEntity> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override final  DateTime? createdAt;

/// Create a copy of ProductSetEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSetEntityCopyWith<_ProductSetEntity> get copyWith => __$ProductSetEntityCopyWithImpl<_ProductSetEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSetEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSetEntity&&(identical(other.setId, setId) || other.setId == setId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setId,name,description,const DeepCollectionEquality().hash(_products),createdAt);

@override
String toString() {
  return 'ProductSetEntity(setId: $setId, name: $name, description: $description, products: $products, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductSetEntityCopyWith<$Res> implements $ProductSetEntityCopyWith<$Res> {
  factory _$ProductSetEntityCopyWith(_ProductSetEntity value, $Res Function(_ProductSetEntity) _then) = __$ProductSetEntityCopyWithImpl;
@override @useResult
$Res call({
 int? setId, String name, String? description, List<ProductSetItemEntity> products, DateTime? createdAt
});




}
/// @nodoc
class __$ProductSetEntityCopyWithImpl<$Res>
    implements _$ProductSetEntityCopyWith<$Res> {
  __$ProductSetEntityCopyWithImpl(this._self, this._then);

  final _ProductSetEntity _self;
  final $Res Function(_ProductSetEntity) _then;

/// Create a copy of ProductSetEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setId = freezed,Object? name = null,Object? description = freezed,Object? products = null,Object? createdAt = freezed,}) {
  return _then(_ProductSetEntity(
setId: freezed == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductSetItemEntity>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
