// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_day_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceDayRow {

 int get operatorId; DateTime get date; DateTime? get inAt; DateTime? get outAt; int get shiftRoleId; String get shiftRoleName; int? get otRoleId; String? get otRoleName; int get shiftMinutes; int get otMinutes; bool get isAbsent; double get salaryAmount; double get overtimeAmount; double get takeHomeAmount; CalculationStatus get calculationStatus; String? get existingAdjustmentReason;
/// Create a copy of AttendanceDayRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceDayRowCopyWith<AttendanceDayRow> get copyWith => _$AttendanceDayRowCopyWithImpl<AttendanceDayRow>(this as AttendanceDayRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceDayRow&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.inAt, inAt) || other.inAt == inAt)&&(identical(other.outAt, outAt) || other.outAt == outAt)&&(identical(other.shiftRoleId, shiftRoleId) || other.shiftRoleId == shiftRoleId)&&(identical(other.shiftRoleName, shiftRoleName) || other.shiftRoleName == shiftRoleName)&&(identical(other.otRoleId, otRoleId) || other.otRoleId == otRoleId)&&(identical(other.otRoleName, otRoleName) || other.otRoleName == otRoleName)&&(identical(other.shiftMinutes, shiftMinutes) || other.shiftMinutes == shiftMinutes)&&(identical(other.otMinutes, otMinutes) || other.otMinutes == otMinutes)&&(identical(other.isAbsent, isAbsent) || other.isAbsent == isAbsent)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.overtimeAmount, overtimeAmount) || other.overtimeAmount == overtimeAmount)&&(identical(other.takeHomeAmount, takeHomeAmount) || other.takeHomeAmount == takeHomeAmount)&&(identical(other.calculationStatus, calculationStatus) || other.calculationStatus == calculationStatus)&&(identical(other.existingAdjustmentReason, existingAdjustmentReason) || other.existingAdjustmentReason == existingAdjustmentReason));
}


@override
int get hashCode => Object.hash(runtimeType,operatorId,date,inAt,outAt,shiftRoleId,shiftRoleName,otRoleId,otRoleName,shiftMinutes,otMinutes,isAbsent,salaryAmount,overtimeAmount,takeHomeAmount,calculationStatus,existingAdjustmentReason);

@override
String toString() {
  return 'AttendanceDayRow(operatorId: $operatorId, date: $date, inAt: $inAt, outAt: $outAt, shiftRoleId: $shiftRoleId, shiftRoleName: $shiftRoleName, otRoleId: $otRoleId, otRoleName: $otRoleName, shiftMinutes: $shiftMinutes, otMinutes: $otMinutes, isAbsent: $isAbsent, salaryAmount: $salaryAmount, overtimeAmount: $overtimeAmount, takeHomeAmount: $takeHomeAmount, calculationStatus: $calculationStatus, existingAdjustmentReason: $existingAdjustmentReason)';
}


}

/// @nodoc
abstract mixin class $AttendanceDayRowCopyWith<$Res>  {
  factory $AttendanceDayRowCopyWith(AttendanceDayRow value, $Res Function(AttendanceDayRow) _then) = _$AttendanceDayRowCopyWithImpl;
@useResult
$Res call({
 int operatorId, DateTime date, DateTime? inAt, DateTime? outAt, int shiftRoleId, String shiftRoleName, int? otRoleId, String? otRoleName, int shiftMinutes, int otMinutes, bool isAbsent, double salaryAmount, double overtimeAmount, double takeHomeAmount, CalculationStatus calculationStatus, String? existingAdjustmentReason
});




}
/// @nodoc
class _$AttendanceDayRowCopyWithImpl<$Res>
    implements $AttendanceDayRowCopyWith<$Res> {
  _$AttendanceDayRowCopyWithImpl(this._self, this._then);

  final AttendanceDayRow _self;
  final $Res Function(AttendanceDayRow) _then;

/// Create a copy of AttendanceDayRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operatorId = null,Object? date = null,Object? inAt = freezed,Object? outAt = freezed,Object? shiftRoleId = null,Object? shiftRoleName = null,Object? otRoleId = freezed,Object? otRoleName = freezed,Object? shiftMinutes = null,Object? otMinutes = null,Object? isAbsent = null,Object? salaryAmount = null,Object? overtimeAmount = null,Object? takeHomeAmount = null,Object? calculationStatus = null,Object? existingAdjustmentReason = freezed,}) {
  return _then(_self.copyWith(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,inAt: freezed == inAt ? _self.inAt : inAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outAt: freezed == outAt ? _self.outAt : outAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shiftRoleId: null == shiftRoleId ? _self.shiftRoleId : shiftRoleId // ignore: cast_nullable_to_non_nullable
as int,shiftRoleName: null == shiftRoleName ? _self.shiftRoleName : shiftRoleName // ignore: cast_nullable_to_non_nullable
as String,otRoleId: freezed == otRoleId ? _self.otRoleId : otRoleId // ignore: cast_nullable_to_non_nullable
as int?,otRoleName: freezed == otRoleName ? _self.otRoleName : otRoleName // ignore: cast_nullable_to_non_nullable
as String?,shiftMinutes: null == shiftMinutes ? _self.shiftMinutes : shiftMinutes // ignore: cast_nullable_to_non_nullable
as int,otMinutes: null == otMinutes ? _self.otMinutes : otMinutes // ignore: cast_nullable_to_non_nullable
as int,isAbsent: null == isAbsent ? _self.isAbsent : isAbsent // ignore: cast_nullable_to_non_nullable
as bool,salaryAmount: null == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as double,overtimeAmount: null == overtimeAmount ? _self.overtimeAmount : overtimeAmount // ignore: cast_nullable_to_non_nullable
as double,takeHomeAmount: null == takeHomeAmount ? _self.takeHomeAmount : takeHomeAmount // ignore: cast_nullable_to_non_nullable
as double,calculationStatus: null == calculationStatus ? _self.calculationStatus : calculationStatus // ignore: cast_nullable_to_non_nullable
as CalculationStatus,existingAdjustmentReason: freezed == existingAdjustmentReason ? _self.existingAdjustmentReason : existingAdjustmentReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceDayRow].
extension AttendanceDayRowPatterns on AttendanceDayRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceDayRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceDayRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceDayRow value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceDayRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceDayRow value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceDayRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int operatorId,  DateTime date,  DateTime? inAt,  DateTime? outAt,  int shiftRoleId,  String shiftRoleName,  int? otRoleId,  String? otRoleName,  int shiftMinutes,  int otMinutes,  bool isAbsent,  double salaryAmount,  double overtimeAmount,  double takeHomeAmount,  CalculationStatus calculationStatus,  String? existingAdjustmentReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceDayRow() when $default != null:
return $default(_that.operatorId,_that.date,_that.inAt,_that.outAt,_that.shiftRoleId,_that.shiftRoleName,_that.otRoleId,_that.otRoleName,_that.shiftMinutes,_that.otMinutes,_that.isAbsent,_that.salaryAmount,_that.overtimeAmount,_that.takeHomeAmount,_that.calculationStatus,_that.existingAdjustmentReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int operatorId,  DateTime date,  DateTime? inAt,  DateTime? outAt,  int shiftRoleId,  String shiftRoleName,  int? otRoleId,  String? otRoleName,  int shiftMinutes,  int otMinutes,  bool isAbsent,  double salaryAmount,  double overtimeAmount,  double takeHomeAmount,  CalculationStatus calculationStatus,  String? existingAdjustmentReason)  $default,) {final _that = this;
switch (_that) {
case _AttendanceDayRow():
return $default(_that.operatorId,_that.date,_that.inAt,_that.outAt,_that.shiftRoleId,_that.shiftRoleName,_that.otRoleId,_that.otRoleName,_that.shiftMinutes,_that.otMinutes,_that.isAbsent,_that.salaryAmount,_that.overtimeAmount,_that.takeHomeAmount,_that.calculationStatus,_that.existingAdjustmentReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int operatorId,  DateTime date,  DateTime? inAt,  DateTime? outAt,  int shiftRoleId,  String shiftRoleName,  int? otRoleId,  String? otRoleName,  int shiftMinutes,  int otMinutes,  bool isAbsent,  double salaryAmount,  double overtimeAmount,  double takeHomeAmount,  CalculationStatus calculationStatus,  String? existingAdjustmentReason)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceDayRow() when $default != null:
return $default(_that.operatorId,_that.date,_that.inAt,_that.outAt,_that.shiftRoleId,_that.shiftRoleName,_that.otRoleId,_that.otRoleName,_that.shiftMinutes,_that.otMinutes,_that.isAbsent,_that.salaryAmount,_that.overtimeAmount,_that.takeHomeAmount,_that.calculationStatus,_that.existingAdjustmentReason);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceDayRow implements AttendanceDayRow {
  const _AttendanceDayRow({required this.operatorId, required this.date, this.inAt, this.outAt, required this.shiftRoleId, required this.shiftRoleName, this.otRoleId, this.otRoleName, required this.shiftMinutes, required this.otMinutes, required this.isAbsent, required this.salaryAmount, required this.overtimeAmount, required this.takeHomeAmount, required this.calculationStatus, this.existingAdjustmentReason});
  

@override final  int operatorId;
@override final  DateTime date;
@override final  DateTime? inAt;
@override final  DateTime? outAt;
@override final  int shiftRoleId;
@override final  String shiftRoleName;
@override final  int? otRoleId;
@override final  String? otRoleName;
@override final  int shiftMinutes;
@override final  int otMinutes;
@override final  bool isAbsent;
@override final  double salaryAmount;
@override final  double overtimeAmount;
@override final  double takeHomeAmount;
@override final  CalculationStatus calculationStatus;
@override final  String? existingAdjustmentReason;

/// Create a copy of AttendanceDayRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceDayRowCopyWith<_AttendanceDayRow> get copyWith => __$AttendanceDayRowCopyWithImpl<_AttendanceDayRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceDayRow&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.inAt, inAt) || other.inAt == inAt)&&(identical(other.outAt, outAt) || other.outAt == outAt)&&(identical(other.shiftRoleId, shiftRoleId) || other.shiftRoleId == shiftRoleId)&&(identical(other.shiftRoleName, shiftRoleName) || other.shiftRoleName == shiftRoleName)&&(identical(other.otRoleId, otRoleId) || other.otRoleId == otRoleId)&&(identical(other.otRoleName, otRoleName) || other.otRoleName == otRoleName)&&(identical(other.shiftMinutes, shiftMinutes) || other.shiftMinutes == shiftMinutes)&&(identical(other.otMinutes, otMinutes) || other.otMinutes == otMinutes)&&(identical(other.isAbsent, isAbsent) || other.isAbsent == isAbsent)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.overtimeAmount, overtimeAmount) || other.overtimeAmount == overtimeAmount)&&(identical(other.takeHomeAmount, takeHomeAmount) || other.takeHomeAmount == takeHomeAmount)&&(identical(other.calculationStatus, calculationStatus) || other.calculationStatus == calculationStatus)&&(identical(other.existingAdjustmentReason, existingAdjustmentReason) || other.existingAdjustmentReason == existingAdjustmentReason));
}


@override
int get hashCode => Object.hash(runtimeType,operatorId,date,inAt,outAt,shiftRoleId,shiftRoleName,otRoleId,otRoleName,shiftMinutes,otMinutes,isAbsent,salaryAmount,overtimeAmount,takeHomeAmount,calculationStatus,existingAdjustmentReason);

@override
String toString() {
  return 'AttendanceDayRow(operatorId: $operatorId, date: $date, inAt: $inAt, outAt: $outAt, shiftRoleId: $shiftRoleId, shiftRoleName: $shiftRoleName, otRoleId: $otRoleId, otRoleName: $otRoleName, shiftMinutes: $shiftMinutes, otMinutes: $otMinutes, isAbsent: $isAbsent, salaryAmount: $salaryAmount, overtimeAmount: $overtimeAmount, takeHomeAmount: $takeHomeAmount, calculationStatus: $calculationStatus, existingAdjustmentReason: $existingAdjustmentReason)';
}


}

/// @nodoc
abstract mixin class _$AttendanceDayRowCopyWith<$Res> implements $AttendanceDayRowCopyWith<$Res> {
  factory _$AttendanceDayRowCopyWith(_AttendanceDayRow value, $Res Function(_AttendanceDayRow) _then) = __$AttendanceDayRowCopyWithImpl;
@override @useResult
$Res call({
 int operatorId, DateTime date, DateTime? inAt, DateTime? outAt, int shiftRoleId, String shiftRoleName, int? otRoleId, String? otRoleName, int shiftMinutes, int otMinutes, bool isAbsent, double salaryAmount, double overtimeAmount, double takeHomeAmount, CalculationStatus calculationStatus, String? existingAdjustmentReason
});




}
/// @nodoc
class __$AttendanceDayRowCopyWithImpl<$Res>
    implements _$AttendanceDayRowCopyWith<$Res> {
  __$AttendanceDayRowCopyWithImpl(this._self, this._then);

  final _AttendanceDayRow _self;
  final $Res Function(_AttendanceDayRow) _then;

/// Create a copy of AttendanceDayRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operatorId = null,Object? date = null,Object? inAt = freezed,Object? outAt = freezed,Object? shiftRoleId = null,Object? shiftRoleName = null,Object? otRoleId = freezed,Object? otRoleName = freezed,Object? shiftMinutes = null,Object? otMinutes = null,Object? isAbsent = null,Object? salaryAmount = null,Object? overtimeAmount = null,Object? takeHomeAmount = null,Object? calculationStatus = null,Object? existingAdjustmentReason = freezed,}) {
  return _then(_AttendanceDayRow(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,inAt: freezed == inAt ? _self.inAt : inAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outAt: freezed == outAt ? _self.outAt : outAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shiftRoleId: null == shiftRoleId ? _self.shiftRoleId : shiftRoleId // ignore: cast_nullable_to_non_nullable
as int,shiftRoleName: null == shiftRoleName ? _self.shiftRoleName : shiftRoleName // ignore: cast_nullable_to_non_nullable
as String,otRoleId: freezed == otRoleId ? _self.otRoleId : otRoleId // ignore: cast_nullable_to_non_nullable
as int?,otRoleName: freezed == otRoleName ? _self.otRoleName : otRoleName // ignore: cast_nullable_to_non_nullable
as String?,shiftMinutes: null == shiftMinutes ? _self.shiftMinutes : shiftMinutes // ignore: cast_nullable_to_non_nullable
as int,otMinutes: null == otMinutes ? _self.otMinutes : otMinutes // ignore: cast_nullable_to_non_nullable
as int,isAbsent: null == isAbsent ? _self.isAbsent : isAbsent // ignore: cast_nullable_to_non_nullable
as bool,salaryAmount: null == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as double,overtimeAmount: null == overtimeAmount ? _self.overtimeAmount : overtimeAmount // ignore: cast_nullable_to_non_nullable
as double,takeHomeAmount: null == takeHomeAmount ? _self.takeHomeAmount : takeHomeAmount // ignore: cast_nullable_to_non_nullable
as double,calculationStatus: null == calculationStatus ? _self.calculationStatus : calculationStatus // ignore: cast_nullable_to_non_nullable
as CalculationStatus,existingAdjustmentReason: freezed == existingAdjustmentReason ? _self.existingAdjustmentReason : existingAdjustmentReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
