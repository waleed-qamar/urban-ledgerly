// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLogEntity {

 int get id;@JsonKey(name: 'table_name') String get tableName;@JsonKey(name: 'record_id') String get recordId; String get action;@JsonKey(name: 'old_data') Map<String, dynamic>? get oldData;@JsonKey(name: 'new_data') Map<String, dynamic>? get newData;@JsonKey(name: 'changed_fields') Map<String, dynamic>? get changedFields; String? get description;@JsonKey(name: 'changed_by') String? get changedBy;@JsonKey(name: 'changed_by_name') String? get changedByName;@JsonKey(name: 'changed_at') DateTime get changedAt;
/// Create a copy of AuditLogEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogEntityCopyWith<AuditLogEntity> get copyWith => _$AuditLogEntityCopyWithImpl<AuditLogEntity>(this as AuditLogEntity, _$identity);

  /// Serializes this AuditLogEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other.oldData, oldData)&&const DeepCollectionEquality().equals(other.newData, newData)&&const DeepCollectionEquality().equals(other.changedFields, changedFields)&&(identical(other.description, description) || other.description == description)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.changedByName, changedByName) || other.changedByName == changedByName)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tableName,recordId,action,const DeepCollectionEquality().hash(oldData),const DeepCollectionEquality().hash(newData),const DeepCollectionEquality().hash(changedFields),description,changedBy,changedByName,changedAt);

@override
String toString() {
  return 'AuditLogEntity(id: $id, tableName: $tableName, recordId: $recordId, action: $action, oldData: $oldData, newData: $newData, changedFields: $changedFields, description: $description, changedBy: $changedBy, changedByName: $changedByName, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class $AuditLogEntityCopyWith<$Res>  {
  factory $AuditLogEntityCopyWith(AuditLogEntity value, $Res Function(AuditLogEntity) _then) = _$AuditLogEntityCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'table_name') String tableName,@JsonKey(name: 'record_id') String recordId, String action,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'changed_fields') Map<String, dynamic>? changedFields, String? description,@JsonKey(name: 'changed_by') String? changedBy,@JsonKey(name: 'changed_by_name') String? changedByName,@JsonKey(name: 'changed_at') DateTime changedAt
});




}
/// @nodoc
class _$AuditLogEntityCopyWithImpl<$Res>
    implements $AuditLogEntityCopyWith<$Res> {
  _$AuditLogEntityCopyWithImpl(this._self, this._then);

  final AuditLogEntity _self;
  final $Res Function(AuditLogEntity) _then;

/// Create a copy of AuditLogEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tableName = null,Object? recordId = null,Object? action = null,Object? oldData = freezed,Object? newData = freezed,Object? changedFields = freezed,Object? description = freezed,Object? changedBy = freezed,Object? changedByName = freezed,Object? changedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,oldData: freezed == oldData ? _self.oldData : oldData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newData: freezed == newData ? _self.newData : newData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,changedFields: freezed == changedFields ? _self.changedFields : changedFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,changedByName: freezed == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogEntity].
extension AuditLogEntityPatterns on AuditLogEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogEntity value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'table_name')  String tableName, @JsonKey(name: 'record_id')  String recordId,  String action, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'changed_fields')  Map<String, dynamic>? changedFields,  String? description, @JsonKey(name: 'changed_by')  String? changedBy, @JsonKey(name: 'changed_by_name')  String? changedByName, @JsonKey(name: 'changed_at')  DateTime changedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogEntity() when $default != null:
return $default(_that.id,_that.tableName,_that.recordId,_that.action,_that.oldData,_that.newData,_that.changedFields,_that.description,_that.changedBy,_that.changedByName,_that.changedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'table_name')  String tableName, @JsonKey(name: 'record_id')  String recordId,  String action, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'changed_fields')  Map<String, dynamic>? changedFields,  String? description, @JsonKey(name: 'changed_by')  String? changedBy, @JsonKey(name: 'changed_by_name')  String? changedByName, @JsonKey(name: 'changed_at')  DateTime changedAt)  $default,) {final _that = this;
switch (_that) {
case _AuditLogEntity():
return $default(_that.id,_that.tableName,_that.recordId,_that.action,_that.oldData,_that.newData,_that.changedFields,_that.description,_that.changedBy,_that.changedByName,_that.changedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'table_name')  String tableName, @JsonKey(name: 'record_id')  String recordId,  String action, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'changed_fields')  Map<String, dynamic>? changedFields,  String? description, @JsonKey(name: 'changed_by')  String? changedBy, @JsonKey(name: 'changed_by_name')  String? changedByName, @JsonKey(name: 'changed_at')  DateTime changedAt)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogEntity() when $default != null:
return $default(_that.id,_that.tableName,_that.recordId,_that.action,_that.oldData,_that.newData,_that.changedFields,_that.description,_that.changedBy,_that.changedByName,_that.changedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLogEntity extends AuditLogEntity {
  const _AuditLogEntity({required this.id, @JsonKey(name: 'table_name') required this.tableName, @JsonKey(name: 'record_id') required this.recordId, required this.action, @JsonKey(name: 'old_data') final  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data') final  Map<String, dynamic>? newData, @JsonKey(name: 'changed_fields') final  Map<String, dynamic>? changedFields, this.description, @JsonKey(name: 'changed_by') this.changedBy, @JsonKey(name: 'changed_by_name') this.changedByName, @JsonKey(name: 'changed_at') required this.changedAt}): _oldData = oldData,_newData = newData,_changedFields = changedFields,super._();
  factory _AuditLogEntity.fromJson(Map<String, dynamic> json) => _$AuditLogEntityFromJson(json);

@override final  int id;
@override@JsonKey(name: 'table_name') final  String tableName;
@override@JsonKey(name: 'record_id') final  String recordId;
@override final  String action;
 final  Map<String, dynamic>? _oldData;
@override@JsonKey(name: 'old_data') Map<String, dynamic>? get oldData {
  final value = _oldData;
  if (value == null) return null;
  if (_oldData is EqualUnmodifiableMapView) return _oldData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _newData;
@override@JsonKey(name: 'new_data') Map<String, dynamic>? get newData {
  final value = _newData;
  if (value == null) return null;
  if (_newData is EqualUnmodifiableMapView) return _newData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _changedFields;
@override@JsonKey(name: 'changed_fields') Map<String, dynamic>? get changedFields {
  final value = _changedFields;
  if (value == null) return null;
  if (_changedFields is EqualUnmodifiableMapView) return _changedFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? description;
@override@JsonKey(name: 'changed_by') final  String? changedBy;
@override@JsonKey(name: 'changed_by_name') final  String? changedByName;
@override@JsonKey(name: 'changed_at') final  DateTime changedAt;

/// Create a copy of AuditLogEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogEntityCopyWith<_AuditLogEntity> get copyWith => __$AuditLogEntityCopyWithImpl<_AuditLogEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other._oldData, _oldData)&&const DeepCollectionEquality().equals(other._newData, _newData)&&const DeepCollectionEquality().equals(other._changedFields, _changedFields)&&(identical(other.description, description) || other.description == description)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.changedByName, changedByName) || other.changedByName == changedByName)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tableName,recordId,action,const DeepCollectionEquality().hash(_oldData),const DeepCollectionEquality().hash(_newData),const DeepCollectionEquality().hash(_changedFields),description,changedBy,changedByName,changedAt);

@override
String toString() {
  return 'AuditLogEntity(id: $id, tableName: $tableName, recordId: $recordId, action: $action, oldData: $oldData, newData: $newData, changedFields: $changedFields, description: $description, changedBy: $changedBy, changedByName: $changedByName, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class _$AuditLogEntityCopyWith<$Res> implements $AuditLogEntityCopyWith<$Res> {
  factory _$AuditLogEntityCopyWith(_AuditLogEntity value, $Res Function(_AuditLogEntity) _then) = __$AuditLogEntityCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'table_name') String tableName,@JsonKey(name: 'record_id') String recordId, String action,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'changed_fields') Map<String, dynamic>? changedFields, String? description,@JsonKey(name: 'changed_by') String? changedBy,@JsonKey(name: 'changed_by_name') String? changedByName,@JsonKey(name: 'changed_at') DateTime changedAt
});




}
/// @nodoc
class __$AuditLogEntityCopyWithImpl<$Res>
    implements _$AuditLogEntityCopyWith<$Res> {
  __$AuditLogEntityCopyWithImpl(this._self, this._then);

  final _AuditLogEntity _self;
  final $Res Function(_AuditLogEntity) _then;

/// Create a copy of AuditLogEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tableName = null,Object? recordId = null,Object? action = null,Object? oldData = freezed,Object? newData = freezed,Object? changedFields = freezed,Object? description = freezed,Object? changedBy = freezed,Object? changedByName = freezed,Object? changedAt = null,}) {
  return _then(_AuditLogEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,oldData: freezed == oldData ? _self._oldData : oldData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newData: freezed == newData ? _self._newData : newData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,changedFields: freezed == changedFields ? _self._changedFields : changedFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,changedByName: freezed == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
