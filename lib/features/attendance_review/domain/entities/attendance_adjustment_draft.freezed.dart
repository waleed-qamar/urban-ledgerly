// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_adjustment_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceAdjustmentDraft {

 int get operatorId; DateTime get date; DateTime? get adjustedInAt; DateTime? get adjustedOutAt; int? get adjustedOtMinutes; int? get shiftRoleId; int? get otRoleId; String get reason;
/// Create a copy of AttendanceAdjustmentDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceAdjustmentDraftCopyWith<AttendanceAdjustmentDraft> get copyWith => _$AttendanceAdjustmentDraftCopyWithImpl<AttendanceAdjustmentDraft>(this as AttendanceAdjustmentDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceAdjustmentDraft&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.adjustedInAt, adjustedInAt) || other.adjustedInAt == adjustedInAt)&&(identical(other.adjustedOutAt, adjustedOutAt) || other.adjustedOutAt == adjustedOutAt)&&(identical(other.adjustedOtMinutes, adjustedOtMinutes) || other.adjustedOtMinutes == adjustedOtMinutes)&&(identical(other.shiftRoleId, shiftRoleId) || other.shiftRoleId == shiftRoleId)&&(identical(other.otRoleId, otRoleId) || other.otRoleId == otRoleId)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,operatorId,date,adjustedInAt,adjustedOutAt,adjustedOtMinutes,shiftRoleId,otRoleId,reason);

@override
String toString() {
  return 'AttendanceAdjustmentDraft(operatorId: $operatorId, date: $date, adjustedInAt: $adjustedInAt, adjustedOutAt: $adjustedOutAt, adjustedOtMinutes: $adjustedOtMinutes, shiftRoleId: $shiftRoleId, otRoleId: $otRoleId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AttendanceAdjustmentDraftCopyWith<$Res>  {
  factory $AttendanceAdjustmentDraftCopyWith(AttendanceAdjustmentDraft value, $Res Function(AttendanceAdjustmentDraft) _then) = _$AttendanceAdjustmentDraftCopyWithImpl;
@useResult
$Res call({
 int operatorId, DateTime date, DateTime? adjustedInAt, DateTime? adjustedOutAt, int? adjustedOtMinutes, int? shiftRoleId, int? otRoleId, String reason
});




}
/// @nodoc
class _$AttendanceAdjustmentDraftCopyWithImpl<$Res>
    implements $AttendanceAdjustmentDraftCopyWith<$Res> {
  _$AttendanceAdjustmentDraftCopyWithImpl(this._self, this._then);

  final AttendanceAdjustmentDraft _self;
  final $Res Function(AttendanceAdjustmentDraft) _then;

/// Create a copy of AttendanceAdjustmentDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operatorId = null,Object? date = null,Object? adjustedInAt = freezed,Object? adjustedOutAt = freezed,Object? adjustedOtMinutes = freezed,Object? shiftRoleId = freezed,Object? otRoleId = freezed,Object? reason = null,}) {
  return _then(_self.copyWith(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,adjustedInAt: freezed == adjustedInAt ? _self.adjustedInAt : adjustedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adjustedOutAt: freezed == adjustedOutAt ? _self.adjustedOutAt : adjustedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adjustedOtMinutes: freezed == adjustedOtMinutes ? _self.adjustedOtMinutes : adjustedOtMinutes // ignore: cast_nullable_to_non_nullable
as int?,shiftRoleId: freezed == shiftRoleId ? _self.shiftRoleId : shiftRoleId // ignore: cast_nullable_to_non_nullable
as int?,otRoleId: freezed == otRoleId ? _self.otRoleId : otRoleId // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceAdjustmentDraft].
extension AttendanceAdjustmentDraftPatterns on AttendanceAdjustmentDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceAdjustmentDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceAdjustmentDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceAdjustmentDraft value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceAdjustmentDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceAdjustmentDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceAdjustmentDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int operatorId,  DateTime date,  DateTime? adjustedInAt,  DateTime? adjustedOutAt,  int? adjustedOtMinutes,  int? shiftRoleId,  int? otRoleId,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceAdjustmentDraft() when $default != null:
return $default(_that.operatorId,_that.date,_that.adjustedInAt,_that.adjustedOutAt,_that.adjustedOtMinutes,_that.shiftRoleId,_that.otRoleId,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int operatorId,  DateTime date,  DateTime? adjustedInAt,  DateTime? adjustedOutAt,  int? adjustedOtMinutes,  int? shiftRoleId,  int? otRoleId,  String reason)  $default,) {final _that = this;
switch (_that) {
case _AttendanceAdjustmentDraft():
return $default(_that.operatorId,_that.date,_that.adjustedInAt,_that.adjustedOutAt,_that.adjustedOtMinutes,_that.shiftRoleId,_that.otRoleId,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int operatorId,  DateTime date,  DateTime? adjustedInAt,  DateTime? adjustedOutAt,  int? adjustedOtMinutes,  int? shiftRoleId,  int? otRoleId,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceAdjustmentDraft() when $default != null:
return $default(_that.operatorId,_that.date,_that.adjustedInAt,_that.adjustedOutAt,_that.adjustedOtMinutes,_that.shiftRoleId,_that.otRoleId,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceAdjustmentDraft implements AttendanceAdjustmentDraft {
  const _AttendanceAdjustmentDraft({required this.operatorId, required this.date, this.adjustedInAt, this.adjustedOutAt, this.adjustedOtMinutes, this.shiftRoleId, this.otRoleId, required this.reason});
  

@override final  int operatorId;
@override final  DateTime date;
@override final  DateTime? adjustedInAt;
@override final  DateTime? adjustedOutAt;
@override final  int? adjustedOtMinutes;
@override final  int? shiftRoleId;
@override final  int? otRoleId;
@override final  String reason;

/// Create a copy of AttendanceAdjustmentDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceAdjustmentDraftCopyWith<_AttendanceAdjustmentDraft> get copyWith => __$AttendanceAdjustmentDraftCopyWithImpl<_AttendanceAdjustmentDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceAdjustmentDraft&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.adjustedInAt, adjustedInAt) || other.adjustedInAt == adjustedInAt)&&(identical(other.adjustedOutAt, adjustedOutAt) || other.adjustedOutAt == adjustedOutAt)&&(identical(other.adjustedOtMinutes, adjustedOtMinutes) || other.adjustedOtMinutes == adjustedOtMinutes)&&(identical(other.shiftRoleId, shiftRoleId) || other.shiftRoleId == shiftRoleId)&&(identical(other.otRoleId, otRoleId) || other.otRoleId == otRoleId)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,operatorId,date,adjustedInAt,adjustedOutAt,adjustedOtMinutes,shiftRoleId,otRoleId,reason);

@override
String toString() {
  return 'AttendanceAdjustmentDraft(operatorId: $operatorId, date: $date, adjustedInAt: $adjustedInAt, adjustedOutAt: $adjustedOutAt, adjustedOtMinutes: $adjustedOtMinutes, shiftRoleId: $shiftRoleId, otRoleId: $otRoleId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$AttendanceAdjustmentDraftCopyWith<$Res> implements $AttendanceAdjustmentDraftCopyWith<$Res> {
  factory _$AttendanceAdjustmentDraftCopyWith(_AttendanceAdjustmentDraft value, $Res Function(_AttendanceAdjustmentDraft) _then) = __$AttendanceAdjustmentDraftCopyWithImpl;
@override @useResult
$Res call({
 int operatorId, DateTime date, DateTime? adjustedInAt, DateTime? adjustedOutAt, int? adjustedOtMinutes, int? shiftRoleId, int? otRoleId, String reason
});




}
/// @nodoc
class __$AttendanceAdjustmentDraftCopyWithImpl<$Res>
    implements _$AttendanceAdjustmentDraftCopyWith<$Res> {
  __$AttendanceAdjustmentDraftCopyWithImpl(this._self, this._then);

  final _AttendanceAdjustmentDraft _self;
  final $Res Function(_AttendanceAdjustmentDraft) _then;

/// Create a copy of AttendanceAdjustmentDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operatorId = null,Object? date = null,Object? adjustedInAt = freezed,Object? adjustedOutAt = freezed,Object? adjustedOtMinutes = freezed,Object? shiftRoleId = freezed,Object? otRoleId = freezed,Object? reason = null,}) {
  return _then(_AttendanceAdjustmentDraft(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,adjustedInAt: freezed == adjustedInAt ? _self.adjustedInAt : adjustedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adjustedOutAt: freezed == adjustedOutAt ? _self.adjustedOutAt : adjustedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adjustedOtMinutes: freezed == adjustedOtMinutes ? _self.adjustedOtMinutes : adjustedOtMinutes // ignore: cast_nullable_to_non_nullable
as int?,shiftRoleId: freezed == shiftRoleId ? _self.shiftRoleId : shiftRoleId // ignore: cast_nullable_to_non_nullable
as int?,otRoleId: freezed == otRoleId ? _self.otRoleId : otRoleId // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
