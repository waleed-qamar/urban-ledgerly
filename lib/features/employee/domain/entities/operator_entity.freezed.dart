// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operator_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OperatorEntity {

 int get id; String get name; String get phone; String? get cnic;@JsonKey(name: 'joining_date') DateTime get joiningDate;@JsonKey(name: 'default_per_day') double get defaultPerDay;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of OperatorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperatorEntityCopyWith<OperatorEntity> get copyWith => _$OperatorEntityCopyWithImpl<OperatorEntity>(this as OperatorEntity, _$identity);

  /// Serializes this OperatorEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OperatorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cnic, cnic) || other.cnic == cnic)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.defaultPerDay, defaultPerDay) || other.defaultPerDay == defaultPerDay)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,cnic,joiningDate,defaultPerDay,isActive,createdAt);

@override
String toString() {
  return 'OperatorEntity(id: $id, name: $name, phone: $phone, cnic: $cnic, joiningDate: $joiningDate, defaultPerDay: $defaultPerDay, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OperatorEntityCopyWith<$Res>  {
  factory $OperatorEntityCopyWith(OperatorEntity value, $Res Function(OperatorEntity) _then) = _$OperatorEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String phone, String? cnic,@JsonKey(name: 'joining_date') DateTime joiningDate,@JsonKey(name: 'default_per_day') double defaultPerDay,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$OperatorEntityCopyWithImpl<$Res>
    implements $OperatorEntityCopyWith<$Res> {
  _$OperatorEntityCopyWithImpl(this._self, this._then);

  final OperatorEntity _self;
  final $Res Function(OperatorEntity) _then;

/// Create a copy of OperatorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? cnic = freezed,Object? joiningDate = null,Object? defaultPerDay = null,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cnic: freezed == cnic ? _self.cnic : cnic // ignore: cast_nullable_to_non_nullable
as String?,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,defaultPerDay: null == defaultPerDay ? _self.defaultPerDay : defaultPerDay // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OperatorEntity].
extension OperatorEntityPatterns on OperatorEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OperatorEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OperatorEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OperatorEntity value)  $default,){
final _that = this;
switch (_that) {
case _OperatorEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OperatorEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OperatorEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String phone,  String? cnic, @JsonKey(name: 'joining_date')  DateTime joiningDate, @JsonKey(name: 'default_per_day')  double defaultPerDay, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OperatorEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.defaultPerDay,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String phone,  String? cnic, @JsonKey(name: 'joining_date')  DateTime joiningDate, @JsonKey(name: 'default_per_day')  double defaultPerDay, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _OperatorEntity():
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.defaultPerDay,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String phone,  String? cnic, @JsonKey(name: 'joining_date')  DateTime joiningDate, @JsonKey(name: 'default_per_day')  double defaultPerDay, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OperatorEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.defaultPerDay,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OperatorEntity implements OperatorEntity {
  const _OperatorEntity({required this.id, required this.name, required this.phone, this.cnic, @JsonKey(name: 'joining_date') required this.joiningDate, @JsonKey(name: 'default_per_day') this.defaultPerDay = 0.0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') this.createdAt});
  factory _OperatorEntity.fromJson(Map<String, dynamic> json) => _$OperatorEntityFromJson(json);

@override final  int id;
@override final  String name;
@override final  String phone;
@override final  String? cnic;
@override@JsonKey(name: 'joining_date') final  DateTime joiningDate;
@override@JsonKey(name: 'default_per_day') final  double defaultPerDay;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of OperatorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperatorEntityCopyWith<_OperatorEntity> get copyWith => __$OperatorEntityCopyWithImpl<_OperatorEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OperatorEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperatorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cnic, cnic) || other.cnic == cnic)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.defaultPerDay, defaultPerDay) || other.defaultPerDay == defaultPerDay)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,cnic,joiningDate,defaultPerDay,isActive,createdAt);

@override
String toString() {
  return 'OperatorEntity(id: $id, name: $name, phone: $phone, cnic: $cnic, joiningDate: $joiningDate, defaultPerDay: $defaultPerDay, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OperatorEntityCopyWith<$Res> implements $OperatorEntityCopyWith<$Res> {
  factory _$OperatorEntityCopyWith(_OperatorEntity value, $Res Function(_OperatorEntity) _then) = __$OperatorEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String phone, String? cnic,@JsonKey(name: 'joining_date') DateTime joiningDate,@JsonKey(name: 'default_per_day') double defaultPerDay,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$OperatorEntityCopyWithImpl<$Res>
    implements _$OperatorEntityCopyWith<$Res> {
  __$OperatorEntityCopyWithImpl(this._self, this._then);

  final _OperatorEntity _self;
  final $Res Function(_OperatorEntity) _then;

/// Create a copy of OperatorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? cnic = freezed,Object? joiningDate = null,Object? defaultPerDay = null,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_OperatorEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cnic: freezed == cnic ? _self.cnic : cnic // ignore: cast_nullable_to_non_nullable
as String?,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,defaultPerDay: null == defaultPerDay ? _self.defaultPerDay : defaultPerDay // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
