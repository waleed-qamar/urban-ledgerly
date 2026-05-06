// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmployeeEntity {

 int get id; String get name; String get phone; String? get cnic; DateTime get joiningDate; bool get isActive; String? get role; String? get userId; DateTime? get createdAt;
/// Create a copy of EmployeeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeEntityCopyWith<EmployeeEntity> get copyWith => _$EmployeeEntityCopyWithImpl<EmployeeEntity>(this as EmployeeEntity, _$identity);

  /// Serializes this EmployeeEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cnic, cnic) || other.cnic == cnic)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.role, role) || other.role == role)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,cnic,joiningDate,isActive,role,userId,createdAt);

@override
String toString() {
  return 'EmployeeEntity(id: $id, name: $name, phone: $phone, cnic: $cnic, joiningDate: $joiningDate, isActive: $isActive, role: $role, userId: $userId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EmployeeEntityCopyWith<$Res>  {
  factory $EmployeeEntityCopyWith(EmployeeEntity value, $Res Function(EmployeeEntity) _then) = _$EmployeeEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String phone, String? cnic, DateTime joiningDate, bool isActive, String? role, String? userId, DateTime? createdAt
});




}
/// @nodoc
class _$EmployeeEntityCopyWithImpl<$Res>
    implements $EmployeeEntityCopyWith<$Res> {
  _$EmployeeEntityCopyWithImpl(this._self, this._then);

  final EmployeeEntity _self;
  final $Res Function(EmployeeEntity) _then;

/// Create a copy of EmployeeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? cnic = freezed,Object? joiningDate = null,Object? isActive = null,Object? role = freezed,Object? userId = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cnic: freezed == cnic ? _self.cnic : cnic // ignore: cast_nullable_to_non_nullable
as String?,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeEntity].
extension EmployeeEntityPatterns on EmployeeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeEntity value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String phone,  String? cnic,  DateTime joiningDate,  bool isActive,  String? role,  String? userId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.isActive,_that.role,_that.userId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String phone,  String? cnic,  DateTime joiningDate,  bool isActive,  String? role,  String? userId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _EmployeeEntity():
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.isActive,_that.role,_that.userId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String phone,  String? cnic,  DateTime joiningDate,  bool isActive,  String? role,  String? userId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.isActive,_that.role,_that.userId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeEntity implements EmployeeEntity {
  const _EmployeeEntity({required this.id, required this.name, required this.phone, this.cnic, required this.joiningDate, required this.isActive, this.role, this.userId, this.createdAt});
  factory _EmployeeEntity.fromJson(Map<String, dynamic> json) => _$EmployeeEntityFromJson(json);

@override final  int id;
@override final  String name;
@override final  String phone;
@override final  String? cnic;
@override final  DateTime joiningDate;
@override final  bool isActive;
@override final  String? role;
@override final  String? userId;
@override final  DateTime? createdAt;

/// Create a copy of EmployeeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeEntityCopyWith<_EmployeeEntity> get copyWith => __$EmployeeEntityCopyWithImpl<_EmployeeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cnic, cnic) || other.cnic == cnic)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.role, role) || other.role == role)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,cnic,joiningDate,isActive,role,userId,createdAt);

@override
String toString() {
  return 'EmployeeEntity(id: $id, name: $name, phone: $phone, cnic: $cnic, joiningDate: $joiningDate, isActive: $isActive, role: $role, userId: $userId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EmployeeEntityCopyWith<$Res> implements $EmployeeEntityCopyWith<$Res> {
  factory _$EmployeeEntityCopyWith(_EmployeeEntity value, $Res Function(_EmployeeEntity) _then) = __$EmployeeEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String phone, String? cnic, DateTime joiningDate, bool isActive, String? role, String? userId, DateTime? createdAt
});




}
/// @nodoc
class __$EmployeeEntityCopyWithImpl<$Res>
    implements _$EmployeeEntityCopyWith<$Res> {
  __$EmployeeEntityCopyWithImpl(this._self, this._then);

  final _EmployeeEntity _self;
  final $Res Function(_EmployeeEntity) _then;

/// Create a copy of EmployeeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? cnic = freezed,Object? joiningDate = null,Object? isActive = null,Object? role = freezed,Object? userId = freezed,Object? createdAt = freezed,}) {
  return _then(_EmployeeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cnic: freezed == cnic ? _self.cnic : cnic // ignore: cast_nullable_to_non_nullable
as String?,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
