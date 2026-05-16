// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupplierEntity {

 int? get id; String get name; String get address; String? get strnNo; String? get ntn; String? get contactInfo;
/// Create a copy of SupplierEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierEntityCopyWith<SupplierEntity> get copyWith => _$SupplierEntityCopyWithImpl<SupplierEntity>(this as SupplierEntity, _$identity);

  /// Serializes this SupplierEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplierEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.strnNo, strnNo) || other.strnNo == strnNo)&&(identical(other.ntn, ntn) || other.ntn == ntn)&&(identical(other.contactInfo, contactInfo) || other.contactInfo == contactInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,strnNo,ntn,contactInfo);

@override
String toString() {
  return 'SupplierEntity(id: $id, name: $name, address: $address, strnNo: $strnNo, ntn: $ntn, contactInfo: $contactInfo)';
}


}

/// @nodoc
abstract mixin class $SupplierEntityCopyWith<$Res>  {
  factory $SupplierEntityCopyWith(SupplierEntity value, $Res Function(SupplierEntity) _then) = _$SupplierEntityCopyWithImpl;
@useResult
$Res call({
 int? id, String name, String address, String? strnNo, String? ntn, String? contactInfo
});




}
/// @nodoc
class _$SupplierEntityCopyWithImpl<$Res>
    implements $SupplierEntityCopyWith<$Res> {
  _$SupplierEntityCopyWithImpl(this._self, this._then);

  final SupplierEntity _self;
  final $Res Function(SupplierEntity) _then;

/// Create a copy of SupplierEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? address = null,Object? strnNo = freezed,Object? ntn = freezed,Object? contactInfo = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,strnNo: freezed == strnNo ? _self.strnNo : strnNo // ignore: cast_nullable_to_non_nullable
as String?,ntn: freezed == ntn ? _self.ntn : ntn // ignore: cast_nullable_to_non_nullable
as String?,contactInfo: freezed == contactInfo ? _self.contactInfo : contactInfo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupplierEntity].
extension SupplierEntityPatterns on SupplierEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplierEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplierEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplierEntity value)  $default,){
final _that = this;
switch (_that) {
case _SupplierEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplierEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SupplierEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  String address,  String? strnNo,  String? ntn,  String? contactInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplierEntity() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.strnNo,_that.ntn,_that.contactInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  String address,  String? strnNo,  String? ntn,  String? contactInfo)  $default,) {final _that = this;
switch (_that) {
case _SupplierEntity():
return $default(_that.id,_that.name,_that.address,_that.strnNo,_that.ntn,_that.contactInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  String address,  String? strnNo,  String? ntn,  String? contactInfo)?  $default,) {final _that = this;
switch (_that) {
case _SupplierEntity() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.strnNo,_that.ntn,_that.contactInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupplierEntity implements SupplierEntity {
  const _SupplierEntity({this.id, required this.name, required this.address, this.strnNo, this.ntn, this.contactInfo});
  factory _SupplierEntity.fromJson(Map<String, dynamic> json) => _$SupplierEntityFromJson(json);

@override final  int? id;
@override final  String name;
@override final  String address;
@override final  String? strnNo;
@override final  String? ntn;
@override final  String? contactInfo;

/// Create a copy of SupplierEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierEntityCopyWith<_SupplierEntity> get copyWith => __$SupplierEntityCopyWithImpl<_SupplierEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplierEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.strnNo, strnNo) || other.strnNo == strnNo)&&(identical(other.ntn, ntn) || other.ntn == ntn)&&(identical(other.contactInfo, contactInfo) || other.contactInfo == contactInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,strnNo,ntn,contactInfo);

@override
String toString() {
  return 'SupplierEntity(id: $id, name: $name, address: $address, strnNo: $strnNo, ntn: $ntn, contactInfo: $contactInfo)';
}


}

/// @nodoc
abstract mixin class _$SupplierEntityCopyWith<$Res> implements $SupplierEntityCopyWith<$Res> {
  factory _$SupplierEntityCopyWith(_SupplierEntity value, $Res Function(_SupplierEntity) _then) = __$SupplierEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, String address, String? strnNo, String? ntn, String? contactInfo
});




}
/// @nodoc
class __$SupplierEntityCopyWithImpl<$Res>
    implements _$SupplierEntityCopyWith<$Res> {
  __$SupplierEntityCopyWithImpl(this._self, this._then);

  final _SupplierEntity _self;
  final $Res Function(_SupplierEntity) _then;

/// Create a copy of SupplierEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? address = null,Object? strnNo = freezed,Object? ntn = freezed,Object? contactInfo = freezed,}) {
  return _then(_SupplierEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,strnNo: freezed == strnNo ? _self.strnNo : strnNo // ignore: cast_nullable_to_non_nullable
as String?,ntn: freezed == ntn ? _self.ntn : ntn // ignore: cast_nullable_to_non_nullable
as String?,contactInfo: freezed == contactInfo ? _self.contactInfo : contactInfo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
