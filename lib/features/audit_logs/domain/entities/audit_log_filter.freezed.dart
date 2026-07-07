// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuditLogFilter {

 String? get tableName; String? get action;// raw value: INSERT / UPDATE / DELETE
 String? get changedBy;// employees.user_id (uuid) of the actor
 DateTime? get fromDate; DateTime? get toDate;
/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogFilterCopyWith<AuditLogFilter> get copyWith => _$AuditLogFilterCopyWithImpl<AuditLogFilter>(this as AuditLogFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogFilter&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.action, action) || other.action == action)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate));
}


@override
int get hashCode => Object.hash(runtimeType,tableName,action,changedBy,fromDate,toDate);

@override
String toString() {
  return 'AuditLogFilter(tableName: $tableName, action: $action, changedBy: $changedBy, fromDate: $fromDate, toDate: $toDate)';
}


}

/// @nodoc
abstract mixin class $AuditLogFilterCopyWith<$Res>  {
  factory $AuditLogFilterCopyWith(AuditLogFilter value, $Res Function(AuditLogFilter) _then) = _$AuditLogFilterCopyWithImpl;
@useResult
$Res call({
 String? tableName, String? action, String? changedBy, DateTime? fromDate, DateTime? toDate
});




}
/// @nodoc
class _$AuditLogFilterCopyWithImpl<$Res>
    implements $AuditLogFilterCopyWith<$Res> {
  _$AuditLogFilterCopyWithImpl(this._self, this._then);

  final AuditLogFilter _self;
  final $Res Function(AuditLogFilter) _then;

/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tableName = freezed,Object? action = freezed,Object? changedBy = freezed,Object? fromDate = freezed,Object? toDate = freezed,}) {
  return _then(_self.copyWith(
tableName: freezed == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogFilter].
extension AuditLogFilterPatterns on AuditLogFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogFilter value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? tableName,  String? action,  String? changedBy,  DateTime? fromDate,  DateTime? toDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
return $default(_that.tableName,_that.action,_that.changedBy,_that.fromDate,_that.toDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? tableName,  String? action,  String? changedBy,  DateTime? fromDate,  DateTime? toDate)  $default,) {final _that = this;
switch (_that) {
case _AuditLogFilter():
return $default(_that.tableName,_that.action,_that.changedBy,_that.fromDate,_that.toDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? tableName,  String? action,  String? changedBy,  DateTime? fromDate,  DateTime? toDate)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
return $default(_that.tableName,_that.action,_that.changedBy,_that.fromDate,_that.toDate);case _:
  return null;

}
}

}

/// @nodoc


class _AuditLogFilter extends AuditLogFilter {
  const _AuditLogFilter({this.tableName, this.action, this.changedBy, this.fromDate, this.toDate}): super._();
  

@override final  String? tableName;
@override final  String? action;
// raw value: INSERT / UPDATE / DELETE
@override final  String? changedBy;
// employees.user_id (uuid) of the actor
@override final  DateTime? fromDate;
@override final  DateTime? toDate;

/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogFilterCopyWith<_AuditLogFilter> get copyWith => __$AuditLogFilterCopyWithImpl<_AuditLogFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogFilter&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.action, action) || other.action == action)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate));
}


@override
int get hashCode => Object.hash(runtimeType,tableName,action,changedBy,fromDate,toDate);

@override
String toString() {
  return 'AuditLogFilter(tableName: $tableName, action: $action, changedBy: $changedBy, fromDate: $fromDate, toDate: $toDate)';
}


}

/// @nodoc
abstract mixin class _$AuditLogFilterCopyWith<$Res> implements $AuditLogFilterCopyWith<$Res> {
  factory _$AuditLogFilterCopyWith(_AuditLogFilter value, $Res Function(_AuditLogFilter) _then) = __$AuditLogFilterCopyWithImpl;
@override @useResult
$Res call({
 String? tableName, String? action, String? changedBy, DateTime? fromDate, DateTime? toDate
});




}
/// @nodoc
class __$AuditLogFilterCopyWithImpl<$Res>
    implements _$AuditLogFilterCopyWith<$Res> {
  __$AuditLogFilterCopyWithImpl(this._self, this._then);

  final _AuditLogFilter _self;
  final $Res Function(_AuditLogFilter) _then;

/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tableName = freezed,Object? action = freezed,Object? changedBy = freezed,Object? fromDate = freezed,Object? toDate = freezed,}) {
  return _then(_AuditLogFilter(
tableName: freezed == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
