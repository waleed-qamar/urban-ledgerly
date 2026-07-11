// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wage_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WageRoleModel {

 int get id;@JsonKey(name: 'work_group_id') int get workGroupId;@JsonKey(name: 'role_name') String get roleName;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of WageRoleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WageRoleModelCopyWith<WageRoleModel> get copyWith => _$WageRoleModelCopyWithImpl<WageRoleModel>(this as WageRoleModel, _$identity);

  /// Serializes this WageRoleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WageRoleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.workGroupId, workGroupId) || other.workGroupId == workGroupId)&&(identical(other.roleName, roleName) || other.roleName == roleName)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workGroupId,roleName,isActive);

@override
String toString() {
  return 'WageRoleModel(id: $id, workGroupId: $workGroupId, roleName: $roleName, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $WageRoleModelCopyWith<$Res>  {
  factory $WageRoleModelCopyWith(WageRoleModel value, $Res Function(WageRoleModel) _then) = _$WageRoleModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'work_group_id') int workGroupId,@JsonKey(name: 'role_name') String roleName,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$WageRoleModelCopyWithImpl<$Res>
    implements $WageRoleModelCopyWith<$Res> {
  _$WageRoleModelCopyWithImpl(this._self, this._then);

  final WageRoleModel _self;
  final $Res Function(WageRoleModel) _then;

/// Create a copy of WageRoleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workGroupId = null,Object? roleName = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workGroupId: null == workGroupId ? _self.workGroupId : workGroupId // ignore: cast_nullable_to_non_nullable
as int,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WageRoleModel].
extension WageRoleModelPatterns on WageRoleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WageRoleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WageRoleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WageRoleModel value)  $default,){
final _that = this;
switch (_that) {
case _WageRoleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WageRoleModel value)?  $default,){
final _that = this;
switch (_that) {
case _WageRoleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'work_group_id')  int workGroupId, @JsonKey(name: 'role_name')  String roleName, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WageRoleModel() when $default != null:
return $default(_that.id,_that.workGroupId,_that.roleName,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'work_group_id')  int workGroupId, @JsonKey(name: 'role_name')  String roleName, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _WageRoleModel():
return $default(_that.id,_that.workGroupId,_that.roleName,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'work_group_id')  int workGroupId, @JsonKey(name: 'role_name')  String roleName, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _WageRoleModel() when $default != null:
return $default(_that.id,_that.workGroupId,_that.roleName,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WageRoleModel extends WageRoleModel {
  const _WageRoleModel({required this.id, @JsonKey(name: 'work_group_id') required this.workGroupId, @JsonKey(name: 'role_name') required this.roleName, @JsonKey(name: 'is_active') required this.isActive}): super._();
  factory _WageRoleModel.fromJson(Map<String, dynamic> json) => _$WageRoleModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'work_group_id') final  int workGroupId;
@override@JsonKey(name: 'role_name') final  String roleName;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of WageRoleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WageRoleModelCopyWith<_WageRoleModel> get copyWith => __$WageRoleModelCopyWithImpl<_WageRoleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WageRoleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WageRoleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.workGroupId, workGroupId) || other.workGroupId == workGroupId)&&(identical(other.roleName, roleName) || other.roleName == roleName)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workGroupId,roleName,isActive);

@override
String toString() {
  return 'WageRoleModel(id: $id, workGroupId: $workGroupId, roleName: $roleName, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$WageRoleModelCopyWith<$Res> implements $WageRoleModelCopyWith<$Res> {
  factory _$WageRoleModelCopyWith(_WageRoleModel value, $Res Function(_WageRoleModel) _then) = __$WageRoleModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'work_group_id') int workGroupId,@JsonKey(name: 'role_name') String roleName,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$WageRoleModelCopyWithImpl<$Res>
    implements _$WageRoleModelCopyWith<$Res> {
  __$WageRoleModelCopyWithImpl(this._self, this._then);

  final _WageRoleModel _self;
  final $Res Function(_WageRoleModel) _then;

/// Create a copy of WageRoleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workGroupId = null,Object? roleName = null,Object? isActive = null,}) {
  return _then(_WageRoleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workGroupId: null == workGroupId ? _self.workGroupId : workGroupId // ignore: cast_nullable_to_non_nullable
as int,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
