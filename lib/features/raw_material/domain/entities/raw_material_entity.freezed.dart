// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_material_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RawMaterialEntity {

 int get id; String get name; double get price; String? get description; String get unit; DateTime get createdAt;
/// Create a copy of RawMaterialEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawMaterialEntityCopyWith<RawMaterialEntity> get copyWith => _$RawMaterialEntityCopyWithImpl<RawMaterialEntity>(this as RawMaterialEntity, _$identity);

  /// Serializes this RawMaterialEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawMaterialEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,description,unit,createdAt);

@override
String toString() {
  return 'RawMaterialEntity(id: $id, name: $name, price: $price, description: $description, unit: $unit, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RawMaterialEntityCopyWith<$Res>  {
  factory $RawMaterialEntityCopyWith(RawMaterialEntity value, $Res Function(RawMaterialEntity) _then) = _$RawMaterialEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, double price, String? description, String unit, DateTime createdAt
});




}
/// @nodoc
class _$RawMaterialEntityCopyWithImpl<$Res>
    implements $RawMaterialEntityCopyWith<$Res> {
  _$RawMaterialEntityCopyWithImpl(this._self, this._then);

  final RawMaterialEntity _self;
  final $Res Function(RawMaterialEntity) _then;

/// Create a copy of RawMaterialEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? description = freezed,Object? unit = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RawMaterialEntity].
extension RawMaterialEntityPatterns on RawMaterialEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawMaterialEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawMaterialEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawMaterialEntity value)  $default,){
final _that = this;
switch (_that) {
case _RawMaterialEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawMaterialEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RawMaterialEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  double price,  String? description,  String unit,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawMaterialEntity() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.description,_that.unit,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  double price,  String? description,  String unit,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RawMaterialEntity():
return $default(_that.id,_that.name,_that.price,_that.description,_that.unit,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  double price,  String? description,  String unit,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RawMaterialEntity() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.description,_that.unit,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RawMaterialEntity implements RawMaterialEntity {
  const _RawMaterialEntity({required this.id, required this.name, required this.price, this.description, this.unit = 'kg', required this.createdAt});
  factory _RawMaterialEntity.fromJson(Map<String, dynamic> json) => _$RawMaterialEntityFromJson(json);

@override final  int id;
@override final  String name;
@override final  double price;
@override final  String? description;
@override@JsonKey() final  String unit;
@override final  DateTime createdAt;

/// Create a copy of RawMaterialEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawMaterialEntityCopyWith<_RawMaterialEntity> get copyWith => __$RawMaterialEntityCopyWithImpl<_RawMaterialEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RawMaterialEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawMaterialEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,description,unit,createdAt);

@override
String toString() {
  return 'RawMaterialEntity(id: $id, name: $name, price: $price, description: $description, unit: $unit, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RawMaterialEntityCopyWith<$Res> implements $RawMaterialEntityCopyWith<$Res> {
  factory _$RawMaterialEntityCopyWith(_RawMaterialEntity value, $Res Function(_RawMaterialEntity) _then) = __$RawMaterialEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, double price, String? description, String unit, DateTime createdAt
});




}
/// @nodoc
class __$RawMaterialEntityCopyWithImpl<$Res>
    implements _$RawMaterialEntityCopyWith<$Res> {
  __$RawMaterialEntityCopyWithImpl(this._self, this._then);

  final _RawMaterialEntity _self;
  final $Res Function(_RawMaterialEntity) _then;

/// Create a copy of RawMaterialEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? description = freezed,Object? unit = null,Object? createdAt = null,}) {
  return _then(_RawMaterialEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
