// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientEntity {

 int get id; String get clientName; String get contactNumber; String get clientAddress; String get department; DateTime get createdAt;
@JsonKey(name: 'is_active', defaultValue: true) bool get isActive;
/// Create a copy of ClientEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientEntityCopyWith<ClientEntity> get copyWith => _$ClientEntityCopyWithImpl<ClientEntity>(this as ClientEntity, _$identity);

  /// Serializes this ClientEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.contactNumber, contactNumber) || other.contactNumber == contactNumber)&&(identical(other.clientAddress, clientAddress) || other.clientAddress == clientAddress)&&(identical(other.department, department) || other.department == department)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientName,contactNumber,clientAddress,department,createdAt,isActive);

@override
String toString() {
  return 'ClientEntity(id: $id, clientName: $clientName, contactNumber: $contactNumber, clientAddress: $clientAddress, department: $department, createdAt: $createdAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ClientEntityCopyWith<$Res>  {
  factory $ClientEntityCopyWith(ClientEntity value, $Res Function(ClientEntity) _then) = _$ClientEntityCopyWithImpl;
@useResult
$Res call({
 int id, String clientName, String contactNumber, String clientAddress, String department, DateTime createdAt,@JsonKey(name: 'is_active', defaultValue: true) bool isActive
});




}
/// @nodoc
class _$ClientEntityCopyWithImpl<$Res>
    implements $ClientEntityCopyWith<$Res> {
  _$ClientEntityCopyWithImpl(this._self, this._then);

  final ClientEntity _self;
  final $Res Function(ClientEntity) _then;

/// Create a copy of ClientEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientName = null,Object? contactNumber = null,Object? clientAddress = null,Object? department = null,Object? createdAt = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,contactNumber: null == contactNumber ? _self.contactNumber : contactNumber // ignore: cast_nullable_to_non_nullable
as String,clientAddress: null == clientAddress ? _self.clientAddress : clientAddress // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientEntity].
extension ClientEntityPatterns on ClientEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientEntity value)  $default,){
final _that = this;
switch (_that) {
case _ClientEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ClientEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String clientName,  String contactNumber,  String clientAddress,  String department,  DateTime createdAt, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientEntity() when $default != null:
return $default(_that.id,_that.clientName,_that.contactNumber,_that.clientAddress,_that.department,_that.createdAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String clientName,  String contactNumber,  String clientAddress,  String department,  DateTime createdAt, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ClientEntity():
return $default(_that.id,_that.clientName,_that.contactNumber,_that.clientAddress,_that.department,_that.createdAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String clientName,  String contactNumber,  String clientAddress,  String department,  DateTime createdAt, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ClientEntity() when $default != null:
return $default(_that.id,_that.clientName,_that.contactNumber,_that.clientAddress,_that.department,_that.createdAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientEntity implements ClientEntity {
   _ClientEntity({required this.id, required this.clientName, required this.contactNumber, required this.clientAddress, required this.department, required this.createdAt, @JsonKey(name: 'is_active', defaultValue: true) required this.isActive});
  factory _ClientEntity.fromJson(Map<String, dynamic> json) => _$ClientEntityFromJson(json);

@override final  int id;
@override final  String clientName;
@override final  String contactNumber;
@override final  String clientAddress;
@override final  String department;
@override final  DateTime createdAt;
@override@JsonKey(name: 'is_active', defaultValue: true) final  bool isActive;

/// Create a copy of ClientEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientEntityCopyWith<_ClientEntity> get copyWith => __$ClientEntityCopyWithImpl<_ClientEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.contactNumber, contactNumber) || other.contactNumber == contactNumber)&&(identical(other.clientAddress, clientAddress) || other.clientAddress == clientAddress)&&(identical(other.department, department) || other.department == department)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientName,contactNumber,clientAddress,department,createdAt,isActive);

@override
String toString() {
  return 'ClientEntity(id: $id, clientName: $clientName, contactNumber: $contactNumber, clientAddress: $clientAddress, department: $department, createdAt: $createdAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ClientEntityCopyWith<$Res> implements $ClientEntityCopyWith<$Res> {
  factory _$ClientEntityCopyWith(_ClientEntity value, $Res Function(_ClientEntity) _then) = __$ClientEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String clientName, String contactNumber, String clientAddress, String department, DateTime createdAt,@JsonKey(name: 'is_active', defaultValue: true) bool isActive
});




}
/// @nodoc
class __$ClientEntityCopyWithImpl<$Res>
    implements _$ClientEntityCopyWith<$Res> {
  __$ClientEntityCopyWithImpl(this._self, this._then);

  final _ClientEntity _self;
  final $Res Function(_ClientEntity) _then;

/// Create a copy of ClientEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientName = null,Object? contactNumber = null,Object? clientAddress = null,Object? department = null,Object? createdAt = null,Object? isActive = null,}) {
  return _then(_ClientEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,contactNumber: null == contactNumber ? _self.contactNumber : contactNumber // ignore: cast_nullable_to_non_nullable
as String,clientAddress: null == clientAddress ? _self.clientAddress : clientAddress // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
