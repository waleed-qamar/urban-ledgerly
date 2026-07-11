// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_day_row_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceDayRowModel {

 int get operatorId; DateTime get attendanceDate; DateTime? get inAt; DateTime? get outAt; int? get shiftRoleId; String? get shiftRoleName; int? get otRoleId; String? get otRoleName; int? get shiftMinutes; int? get otMinutes; bool? get isAbsent; double? get salaryAmount; double? get overtimeAmount; double? get takeHomeAmount; String? get calculationStatus; String? get existingAdjustmentReason;
/// Create a copy of AttendanceDayRowModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceDayRowModelCopyWith<AttendanceDayRowModel> get copyWith => _$AttendanceDayRowModelCopyWithImpl<AttendanceDayRowModel>(this as AttendanceDayRowModel, _$identity);

  /// Serializes this AttendanceDayRowModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceDayRowModel&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.attendanceDate, attendanceDate) || other.attendanceDate == attendanceDate)&&(identical(other.inAt, inAt) || other.inAt == inAt)&&(identical(other.outAt, outAt) || other.outAt == outAt)&&(identical(other.shiftRoleId, shiftRoleId) || other.shiftRoleId == shiftRoleId)&&(identical(other.shiftRoleName, shiftRoleName) || other.shiftRoleName == shiftRoleName)&&(identical(other.otRoleId, otRoleId) || other.otRoleId == otRoleId)&&(identical(other.otRoleName, otRoleName) || other.otRoleName == otRoleName)&&(identical(other.shiftMinutes, shiftMinutes) || other.shiftMinutes == shiftMinutes)&&(identical(other.otMinutes, otMinutes) || other.otMinutes == otMinutes)&&(identical(other.isAbsent, isAbsent) || other.isAbsent == isAbsent)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.overtimeAmount, overtimeAmount) || other.overtimeAmount == overtimeAmount)&&(identical(other.takeHomeAmount, takeHomeAmount) || other.takeHomeAmount == takeHomeAmount)&&(identical(other.calculationStatus, calculationStatus) || other.calculationStatus == calculationStatus)&&(identical(other.existingAdjustmentReason, existingAdjustmentReason) || other.existingAdjustmentReason == existingAdjustmentReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operatorId,attendanceDate,inAt,outAt,shiftRoleId,shiftRoleName,otRoleId,otRoleName,shiftMinutes,otMinutes,isAbsent,salaryAmount,overtimeAmount,takeHomeAmount,calculationStatus,existingAdjustmentReason);

@override
String toString() {
  return 'AttendanceDayRowModel(operatorId: $operatorId, attendanceDate: $attendanceDate, inAt: $inAt, outAt: $outAt, shiftRoleId: $shiftRoleId, shiftRoleName: $shiftRoleName, otRoleId: $otRoleId, otRoleName: $otRoleName, shiftMinutes: $shiftMinutes, otMinutes: $otMinutes, isAbsent: $isAbsent, salaryAmount: $salaryAmount, overtimeAmount: $overtimeAmount, takeHomeAmount: $takeHomeAmount, calculationStatus: $calculationStatus, existingAdjustmentReason: $existingAdjustmentReason)';
}


}

/// @nodoc
abstract mixin class $AttendanceDayRowModelCopyWith<$Res>  {
  factory $AttendanceDayRowModelCopyWith(AttendanceDayRowModel value, $Res Function(AttendanceDayRowModel) _then) = _$AttendanceDayRowModelCopyWithImpl;
@useResult
$Res call({
 int operatorId, DateTime attendanceDate, DateTime? inAt, DateTime? outAt, int? shiftRoleId, String? shiftRoleName, int? otRoleId, String? otRoleName, int? shiftMinutes, int? otMinutes, bool? isAbsent, double? salaryAmount, double? overtimeAmount, double? takeHomeAmount, String? calculationStatus, String? existingAdjustmentReason
});




}
/// @nodoc
class _$AttendanceDayRowModelCopyWithImpl<$Res>
    implements $AttendanceDayRowModelCopyWith<$Res> {
  _$AttendanceDayRowModelCopyWithImpl(this._self, this._then);

  final AttendanceDayRowModel _self;
  final $Res Function(AttendanceDayRowModel) _then;

/// Create a copy of AttendanceDayRowModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operatorId = null,Object? attendanceDate = null,Object? inAt = freezed,Object? outAt = freezed,Object? shiftRoleId = freezed,Object? shiftRoleName = freezed,Object? otRoleId = freezed,Object? otRoleName = freezed,Object? shiftMinutes = freezed,Object? otMinutes = freezed,Object? isAbsent = freezed,Object? salaryAmount = freezed,Object? overtimeAmount = freezed,Object? takeHomeAmount = freezed,Object? calculationStatus = freezed,Object? existingAdjustmentReason = freezed,}) {
  return _then(_self.copyWith(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,attendanceDate: null == attendanceDate ? _self.attendanceDate : attendanceDate // ignore: cast_nullable_to_non_nullable
as DateTime,inAt: freezed == inAt ? _self.inAt : inAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outAt: freezed == outAt ? _self.outAt : outAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shiftRoleId: freezed == shiftRoleId ? _self.shiftRoleId : shiftRoleId // ignore: cast_nullable_to_non_nullable
as int?,shiftRoleName: freezed == shiftRoleName ? _self.shiftRoleName : shiftRoleName // ignore: cast_nullable_to_non_nullable
as String?,otRoleId: freezed == otRoleId ? _self.otRoleId : otRoleId // ignore: cast_nullable_to_non_nullable
as int?,otRoleName: freezed == otRoleName ? _self.otRoleName : otRoleName // ignore: cast_nullable_to_non_nullable
as String?,shiftMinutes: freezed == shiftMinutes ? _self.shiftMinutes : shiftMinutes // ignore: cast_nullable_to_non_nullable
as int?,otMinutes: freezed == otMinutes ? _self.otMinutes : otMinutes // ignore: cast_nullable_to_non_nullable
as int?,isAbsent: freezed == isAbsent ? _self.isAbsent : isAbsent // ignore: cast_nullable_to_non_nullable
as bool?,salaryAmount: freezed == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as double?,overtimeAmount: freezed == overtimeAmount ? _self.overtimeAmount : overtimeAmount // ignore: cast_nullable_to_non_nullable
as double?,takeHomeAmount: freezed == takeHomeAmount ? _self.takeHomeAmount : takeHomeAmount // ignore: cast_nullable_to_non_nullable
as double?,calculationStatus: freezed == calculationStatus ? _self.calculationStatus : calculationStatus // ignore: cast_nullable_to_non_nullable
as String?,existingAdjustmentReason: freezed == existingAdjustmentReason ? _self.existingAdjustmentReason : existingAdjustmentReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceDayRowModel].
extension AttendanceDayRowModelPatterns on AttendanceDayRowModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceDayRowModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceDayRowModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceDayRowModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceDayRowModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceDayRowModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceDayRowModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int operatorId,  DateTime attendanceDate,  DateTime? inAt,  DateTime? outAt,  int? shiftRoleId,  String? shiftRoleName,  int? otRoleId,  String? otRoleName,  int? shiftMinutes,  int? otMinutes,  bool? isAbsent,  double? salaryAmount,  double? overtimeAmount,  double? takeHomeAmount,  String? calculationStatus,  String? existingAdjustmentReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceDayRowModel() when $default != null:
return $default(_that.operatorId,_that.attendanceDate,_that.inAt,_that.outAt,_that.shiftRoleId,_that.shiftRoleName,_that.otRoleId,_that.otRoleName,_that.shiftMinutes,_that.otMinutes,_that.isAbsent,_that.salaryAmount,_that.overtimeAmount,_that.takeHomeAmount,_that.calculationStatus,_that.existingAdjustmentReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int operatorId,  DateTime attendanceDate,  DateTime? inAt,  DateTime? outAt,  int? shiftRoleId,  String? shiftRoleName,  int? otRoleId,  String? otRoleName,  int? shiftMinutes,  int? otMinutes,  bool? isAbsent,  double? salaryAmount,  double? overtimeAmount,  double? takeHomeAmount,  String? calculationStatus,  String? existingAdjustmentReason)  $default,) {final _that = this;
switch (_that) {
case _AttendanceDayRowModel():
return $default(_that.operatorId,_that.attendanceDate,_that.inAt,_that.outAt,_that.shiftRoleId,_that.shiftRoleName,_that.otRoleId,_that.otRoleName,_that.shiftMinutes,_that.otMinutes,_that.isAbsent,_that.salaryAmount,_that.overtimeAmount,_that.takeHomeAmount,_that.calculationStatus,_that.existingAdjustmentReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int operatorId,  DateTime attendanceDate,  DateTime? inAt,  DateTime? outAt,  int? shiftRoleId,  String? shiftRoleName,  int? otRoleId,  String? otRoleName,  int? shiftMinutes,  int? otMinutes,  bool? isAbsent,  double? salaryAmount,  double? overtimeAmount,  double? takeHomeAmount,  String? calculationStatus,  String? existingAdjustmentReason)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceDayRowModel() when $default != null:
return $default(_that.operatorId,_that.attendanceDate,_that.inAt,_that.outAt,_that.shiftRoleId,_that.shiftRoleName,_that.otRoleId,_that.otRoleName,_that.shiftMinutes,_that.otMinutes,_that.isAbsent,_that.salaryAmount,_that.overtimeAmount,_that.takeHomeAmount,_that.calculationStatus,_that.existingAdjustmentReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceDayRowModel extends AttendanceDayRowModel {
  const _AttendanceDayRowModel({required this.operatorId, required this.attendanceDate, this.inAt, this.outAt, this.shiftRoleId, this.shiftRoleName, this.otRoleId, this.otRoleName, this.shiftMinutes, this.otMinutes, this.isAbsent, this.salaryAmount, this.overtimeAmount, this.takeHomeAmount, this.calculationStatus, this.existingAdjustmentReason}): super._();
  factory _AttendanceDayRowModel.fromJson(Map<String, dynamic> json) => _$AttendanceDayRowModelFromJson(json);

@override final  int operatorId;
@override final  DateTime attendanceDate;
@override final  DateTime? inAt;
@override final  DateTime? outAt;
@override final  int? shiftRoleId;
@override final  String? shiftRoleName;
@override final  int? otRoleId;
@override final  String? otRoleName;
@override final  int? shiftMinutes;
@override final  int? otMinutes;
@override final  bool? isAbsent;
@override final  double? salaryAmount;
@override final  double? overtimeAmount;
@override final  double? takeHomeAmount;
@override final  String? calculationStatus;
@override final  String? existingAdjustmentReason;

/// Create a copy of AttendanceDayRowModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceDayRowModelCopyWith<_AttendanceDayRowModel> get copyWith => __$AttendanceDayRowModelCopyWithImpl<_AttendanceDayRowModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceDayRowModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceDayRowModel&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.attendanceDate, attendanceDate) || other.attendanceDate == attendanceDate)&&(identical(other.inAt, inAt) || other.inAt == inAt)&&(identical(other.outAt, outAt) || other.outAt == outAt)&&(identical(other.shiftRoleId, shiftRoleId) || other.shiftRoleId == shiftRoleId)&&(identical(other.shiftRoleName, shiftRoleName) || other.shiftRoleName == shiftRoleName)&&(identical(other.otRoleId, otRoleId) || other.otRoleId == otRoleId)&&(identical(other.otRoleName, otRoleName) || other.otRoleName == otRoleName)&&(identical(other.shiftMinutes, shiftMinutes) || other.shiftMinutes == shiftMinutes)&&(identical(other.otMinutes, otMinutes) || other.otMinutes == otMinutes)&&(identical(other.isAbsent, isAbsent) || other.isAbsent == isAbsent)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.overtimeAmount, overtimeAmount) || other.overtimeAmount == overtimeAmount)&&(identical(other.takeHomeAmount, takeHomeAmount) || other.takeHomeAmount == takeHomeAmount)&&(identical(other.calculationStatus, calculationStatus) || other.calculationStatus == calculationStatus)&&(identical(other.existingAdjustmentReason, existingAdjustmentReason) || other.existingAdjustmentReason == existingAdjustmentReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operatorId,attendanceDate,inAt,outAt,shiftRoleId,shiftRoleName,otRoleId,otRoleName,shiftMinutes,otMinutes,isAbsent,salaryAmount,overtimeAmount,takeHomeAmount,calculationStatus,existingAdjustmentReason);

@override
String toString() {
  return 'AttendanceDayRowModel(operatorId: $operatorId, attendanceDate: $attendanceDate, inAt: $inAt, outAt: $outAt, shiftRoleId: $shiftRoleId, shiftRoleName: $shiftRoleName, otRoleId: $otRoleId, otRoleName: $otRoleName, shiftMinutes: $shiftMinutes, otMinutes: $otMinutes, isAbsent: $isAbsent, salaryAmount: $salaryAmount, overtimeAmount: $overtimeAmount, takeHomeAmount: $takeHomeAmount, calculationStatus: $calculationStatus, existingAdjustmentReason: $existingAdjustmentReason)';
}


}

/// @nodoc
abstract mixin class _$AttendanceDayRowModelCopyWith<$Res> implements $AttendanceDayRowModelCopyWith<$Res> {
  factory _$AttendanceDayRowModelCopyWith(_AttendanceDayRowModel value, $Res Function(_AttendanceDayRowModel) _then) = __$AttendanceDayRowModelCopyWithImpl;
@override @useResult
$Res call({
 int operatorId, DateTime attendanceDate, DateTime? inAt, DateTime? outAt, int? shiftRoleId, String? shiftRoleName, int? otRoleId, String? otRoleName, int? shiftMinutes, int? otMinutes, bool? isAbsent, double? salaryAmount, double? overtimeAmount, double? takeHomeAmount, String? calculationStatus, String? existingAdjustmentReason
});




}
/// @nodoc
class __$AttendanceDayRowModelCopyWithImpl<$Res>
    implements _$AttendanceDayRowModelCopyWith<$Res> {
  __$AttendanceDayRowModelCopyWithImpl(this._self, this._then);

  final _AttendanceDayRowModel _self;
  final $Res Function(_AttendanceDayRowModel) _then;

/// Create a copy of AttendanceDayRowModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operatorId = null,Object? attendanceDate = null,Object? inAt = freezed,Object? outAt = freezed,Object? shiftRoleId = freezed,Object? shiftRoleName = freezed,Object? otRoleId = freezed,Object? otRoleName = freezed,Object? shiftMinutes = freezed,Object? otMinutes = freezed,Object? isAbsent = freezed,Object? salaryAmount = freezed,Object? overtimeAmount = freezed,Object? takeHomeAmount = freezed,Object? calculationStatus = freezed,Object? existingAdjustmentReason = freezed,}) {
  return _then(_AttendanceDayRowModel(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,attendanceDate: null == attendanceDate ? _self.attendanceDate : attendanceDate // ignore: cast_nullable_to_non_nullable
as DateTime,inAt: freezed == inAt ? _self.inAt : inAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outAt: freezed == outAt ? _self.outAt : outAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shiftRoleId: freezed == shiftRoleId ? _self.shiftRoleId : shiftRoleId // ignore: cast_nullable_to_non_nullable
as int?,shiftRoleName: freezed == shiftRoleName ? _self.shiftRoleName : shiftRoleName // ignore: cast_nullable_to_non_nullable
as String?,otRoleId: freezed == otRoleId ? _self.otRoleId : otRoleId // ignore: cast_nullable_to_non_nullable
as int?,otRoleName: freezed == otRoleName ? _self.otRoleName : otRoleName // ignore: cast_nullable_to_non_nullable
as String?,shiftMinutes: freezed == shiftMinutes ? _self.shiftMinutes : shiftMinutes // ignore: cast_nullable_to_non_nullable
as int?,otMinutes: freezed == otMinutes ? _self.otMinutes : otMinutes // ignore: cast_nullable_to_non_nullable
as int?,isAbsent: freezed == isAbsent ? _self.isAbsent : isAbsent // ignore: cast_nullable_to_non_nullable
as bool?,salaryAmount: freezed == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as double?,overtimeAmount: freezed == overtimeAmount ? _self.overtimeAmount : overtimeAmount // ignore: cast_nullable_to_non_nullable
as double?,takeHomeAmount: freezed == takeHomeAmount ? _self.takeHomeAmount : takeHomeAmount // ignore: cast_nullable_to_non_nullable
as double?,calculationStatus: freezed == calculationStatus ? _self.calculationStatus : calculationStatus // ignore: cast_nullable_to_non_nullable
as String?,existingAdjustmentReason: freezed == existingAdjustmentReason ? _self.existingAdjustmentReason : existingAdjustmentReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
