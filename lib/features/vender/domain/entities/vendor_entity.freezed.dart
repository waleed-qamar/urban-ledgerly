// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorEntity {

 int get id; String get vendorName; String get vendorAddress; String get vendorNotes; String get companyName; String get contactNumber; DateTime get createdAt;
@JsonKey(name: 'is_active', defaultValue: true) bool get isActive;
/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<VendorEntity> get copyWith => _$VendorEntityCopyWithImpl<VendorEntity>(this as VendorEntity, _$identity);

  /// Serializes this VendorEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.vendorAddress, vendorAddress) || other.vendorAddress == vendorAddress)&&(identical(other.vendorNotes, vendorNotes) || other.vendorNotes == vendorNotes)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.contactNumber, contactNumber) || other.contactNumber == contactNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorName,vendorAddress,vendorNotes,companyName,contactNumber,createdAt,isActive);

@override
String toString() {
  return 'VendorEntity(id: $id, vendorName: $vendorName, vendorAddress: $vendorAddress, vendorNotes: $vendorNotes, companyName: $companyName, contactNumber: $contactNumber, createdAt: $createdAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $VendorEntityCopyWith<$Res>  {
  factory $VendorEntityCopyWith(VendorEntity value, $Res Function(VendorEntity) _then) = _$VendorEntityCopyWithImpl;
@useResult
$Res call({
 int id, String vendorName, String vendorAddress, String vendorNotes, String companyName, String contactNumber, DateTime createdAt,@JsonKey(name: 'is_active', defaultValue: true) bool isActive
});




}
/// @nodoc
class _$VendorEntityCopyWithImpl<$Res>
    implements $VendorEntityCopyWith<$Res> {
  _$VendorEntityCopyWithImpl(this._self, this._then);

  final VendorEntity _self;
  final $Res Function(VendorEntity) _then;

/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorName = null,Object? vendorAddress = null,Object? vendorNotes = null,Object? companyName = null,Object? contactNumber = null,Object? createdAt = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vendorName: null == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String,vendorAddress: null == vendorAddress ? _self.vendorAddress : vendorAddress // ignore: cast_nullable_to_non_nullable
as String,vendorNotes: null == vendorNotes ? _self.vendorNotes : vendorNotes // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,contactNumber: null == contactNumber ? _self.contactNumber : contactNumber // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorEntity].
extension VendorEntityPatterns on VendorEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorEntity value)  $default,){
final _that = this;
switch (_that) {
case _VendorEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String vendorName,  String vendorAddress,  String vendorNotes,  String companyName,  String contactNumber,  DateTime createdAt, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
return $default(_that.id,_that.vendorName,_that.vendorAddress,_that.vendorNotes,_that.companyName,_that.contactNumber,_that.createdAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String vendorName,  String vendorAddress,  String vendorNotes,  String companyName,  String contactNumber,  DateTime createdAt, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _VendorEntity():
return $default(_that.id,_that.vendorName,_that.vendorAddress,_that.vendorNotes,_that.companyName,_that.contactNumber,_that.createdAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String vendorName,  String vendorAddress,  String vendorNotes,  String companyName,  String contactNumber,  DateTime createdAt, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
return $default(_that.id,_that.vendorName,_that.vendorAddress,_that.vendorNotes,_that.companyName,_that.contactNumber,_that.createdAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorEntity implements VendorEntity {
   _VendorEntity({required this.id, required this.vendorName, required this.vendorAddress, required this.vendorNotes, required this.companyName, required this.contactNumber, required this.createdAt, @JsonKey(name: 'is_active', defaultValue: true) required this.isActive});
  factory _VendorEntity.fromJson(Map<String, dynamic> json) => _$VendorEntityFromJson(json);

@override final  int id;
@override final  String vendorName;
@override final  String vendorAddress;
@override final  String vendorNotes;
@override final  String companyName;
@override final  String contactNumber;
@override final  DateTime createdAt;
@override@JsonKey(name: 'is_active', defaultValue: true) final  bool isActive;

/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorEntityCopyWith<_VendorEntity> get copyWith => __$VendorEntityCopyWithImpl<_VendorEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.vendorAddress, vendorAddress) || other.vendorAddress == vendorAddress)&&(identical(other.vendorNotes, vendorNotes) || other.vendorNotes == vendorNotes)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.contactNumber, contactNumber) || other.contactNumber == contactNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorName,vendorAddress,vendorNotes,companyName,contactNumber,createdAt,isActive);

@override
String toString() {
  return 'VendorEntity(id: $id, vendorName: $vendorName, vendorAddress: $vendorAddress, vendorNotes: $vendorNotes, companyName: $companyName, contactNumber: $contactNumber, createdAt: $createdAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$VendorEntityCopyWith<$Res> implements $VendorEntityCopyWith<$Res> {
  factory _$VendorEntityCopyWith(_VendorEntity value, $Res Function(_VendorEntity) _then) = __$VendorEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String vendorName, String vendorAddress, String vendorNotes, String companyName, String contactNumber, DateTime createdAt,@JsonKey(name: 'is_active', defaultValue: true) bool isActive
});




}
/// @nodoc
class __$VendorEntityCopyWithImpl<$Res>
    implements _$VendorEntityCopyWith<$Res> {
  __$VendorEntityCopyWithImpl(this._self, this._then);

  final _VendorEntity _self;
  final $Res Function(_VendorEntity) _then;

/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorName = null,Object? vendorAddress = null,Object? vendorNotes = null,Object? companyName = null,Object? contactNumber = null,Object? createdAt = null,Object? isActive = null,}) {
  return _then(_VendorEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vendorName: null == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String,vendorAddress: null == vendorAddress ? _self.vendorAddress : vendorAddress // ignore: cast_nullable_to_non_nullable
as String,vendorNotes: null == vendorNotes ? _self.vendorNotes : vendorNotes // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,contactNumber: null == contactNumber ? _self.contactNumber : contactNumber // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
