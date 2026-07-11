// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_period_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PayrollPeriodSummary {

 int get operatorId; String get operatorName; int get absentDays; int get totalShiftMinutes; int get totalOtMinutes; double get baseSalary; double get overtimePay; double get takeHome;
/// Create a copy of PayrollPeriodSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollPeriodSummaryCopyWith<PayrollPeriodSummary> get copyWith => _$PayrollPeriodSummaryCopyWithImpl<PayrollPeriodSummary>(this as PayrollPeriodSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollPeriodSummary&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.absentDays, absentDays) || other.absentDays == absentDays)&&(identical(other.totalShiftMinutes, totalShiftMinutes) || other.totalShiftMinutes == totalShiftMinutes)&&(identical(other.totalOtMinutes, totalOtMinutes) || other.totalOtMinutes == totalOtMinutes)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary)&&(identical(other.overtimePay, overtimePay) || other.overtimePay == overtimePay)&&(identical(other.takeHome, takeHome) || other.takeHome == takeHome));
}


@override
int get hashCode => Object.hash(runtimeType,operatorId,operatorName,absentDays,totalShiftMinutes,totalOtMinutes,baseSalary,overtimePay,takeHome);

@override
String toString() {
  return 'PayrollPeriodSummary(operatorId: $operatorId, operatorName: $operatorName, absentDays: $absentDays, totalShiftMinutes: $totalShiftMinutes, totalOtMinutes: $totalOtMinutes, baseSalary: $baseSalary, overtimePay: $overtimePay, takeHome: $takeHome)';
}


}

/// @nodoc
abstract mixin class $PayrollPeriodSummaryCopyWith<$Res>  {
  factory $PayrollPeriodSummaryCopyWith(PayrollPeriodSummary value, $Res Function(PayrollPeriodSummary) _then) = _$PayrollPeriodSummaryCopyWithImpl;
@useResult
$Res call({
 int operatorId, String operatorName, int absentDays, int totalShiftMinutes, int totalOtMinutes, double baseSalary, double overtimePay, double takeHome
});




}
/// @nodoc
class _$PayrollPeriodSummaryCopyWithImpl<$Res>
    implements $PayrollPeriodSummaryCopyWith<$Res> {
  _$PayrollPeriodSummaryCopyWithImpl(this._self, this._then);

  final PayrollPeriodSummary _self;
  final $Res Function(PayrollPeriodSummary) _then;

/// Create a copy of PayrollPeriodSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operatorId = null,Object? operatorName = null,Object? absentDays = null,Object? totalShiftMinutes = null,Object? totalOtMinutes = null,Object? baseSalary = null,Object? overtimePay = null,Object? takeHome = null,}) {
  return _then(_self.copyWith(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,absentDays: null == absentDays ? _self.absentDays : absentDays // ignore: cast_nullable_to_non_nullable
as int,totalShiftMinutes: null == totalShiftMinutes ? _self.totalShiftMinutes : totalShiftMinutes // ignore: cast_nullable_to_non_nullable
as int,totalOtMinutes: null == totalOtMinutes ? _self.totalOtMinutes : totalOtMinutes // ignore: cast_nullable_to_non_nullable
as int,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as double,overtimePay: null == overtimePay ? _self.overtimePay : overtimePay // ignore: cast_nullable_to_non_nullable
as double,takeHome: null == takeHome ? _self.takeHome : takeHome // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollPeriodSummary].
extension PayrollPeriodSummaryPatterns on PayrollPeriodSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollPeriodSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollPeriodSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollPeriodSummary value)  $default,){
final _that = this;
switch (_that) {
case _PayrollPeriodSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollPeriodSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollPeriodSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int operatorId,  String operatorName,  int absentDays,  int totalShiftMinutes,  int totalOtMinutes,  double baseSalary,  double overtimePay,  double takeHome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollPeriodSummary() when $default != null:
return $default(_that.operatorId,_that.operatorName,_that.absentDays,_that.totalShiftMinutes,_that.totalOtMinutes,_that.baseSalary,_that.overtimePay,_that.takeHome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int operatorId,  String operatorName,  int absentDays,  int totalShiftMinutes,  int totalOtMinutes,  double baseSalary,  double overtimePay,  double takeHome)  $default,) {final _that = this;
switch (_that) {
case _PayrollPeriodSummary():
return $default(_that.operatorId,_that.operatorName,_that.absentDays,_that.totalShiftMinutes,_that.totalOtMinutes,_that.baseSalary,_that.overtimePay,_that.takeHome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int operatorId,  String operatorName,  int absentDays,  int totalShiftMinutes,  int totalOtMinutes,  double baseSalary,  double overtimePay,  double takeHome)?  $default,) {final _that = this;
switch (_that) {
case _PayrollPeriodSummary() when $default != null:
return $default(_that.operatorId,_that.operatorName,_that.absentDays,_that.totalShiftMinutes,_that.totalOtMinutes,_that.baseSalary,_that.overtimePay,_that.takeHome);case _:
  return null;

}
}

}

/// @nodoc


class _PayrollPeriodSummary implements PayrollPeriodSummary {
  const _PayrollPeriodSummary({required this.operatorId, required this.operatorName, required this.absentDays, required this.totalShiftMinutes, required this.totalOtMinutes, required this.baseSalary, required this.overtimePay, required this.takeHome});
  

@override final  int operatorId;
@override final  String operatorName;
@override final  int absentDays;
@override final  int totalShiftMinutes;
@override final  int totalOtMinutes;
@override final  double baseSalary;
@override final  double overtimePay;
@override final  double takeHome;

/// Create a copy of PayrollPeriodSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollPeriodSummaryCopyWith<_PayrollPeriodSummary> get copyWith => __$PayrollPeriodSummaryCopyWithImpl<_PayrollPeriodSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollPeriodSummary&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.absentDays, absentDays) || other.absentDays == absentDays)&&(identical(other.totalShiftMinutes, totalShiftMinutes) || other.totalShiftMinutes == totalShiftMinutes)&&(identical(other.totalOtMinutes, totalOtMinutes) || other.totalOtMinutes == totalOtMinutes)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary)&&(identical(other.overtimePay, overtimePay) || other.overtimePay == overtimePay)&&(identical(other.takeHome, takeHome) || other.takeHome == takeHome));
}


@override
int get hashCode => Object.hash(runtimeType,operatorId,operatorName,absentDays,totalShiftMinutes,totalOtMinutes,baseSalary,overtimePay,takeHome);

@override
String toString() {
  return 'PayrollPeriodSummary(operatorId: $operatorId, operatorName: $operatorName, absentDays: $absentDays, totalShiftMinutes: $totalShiftMinutes, totalOtMinutes: $totalOtMinutes, baseSalary: $baseSalary, overtimePay: $overtimePay, takeHome: $takeHome)';
}


}

/// @nodoc
abstract mixin class _$PayrollPeriodSummaryCopyWith<$Res> implements $PayrollPeriodSummaryCopyWith<$Res> {
  factory _$PayrollPeriodSummaryCopyWith(_PayrollPeriodSummary value, $Res Function(_PayrollPeriodSummary) _then) = __$PayrollPeriodSummaryCopyWithImpl;
@override @useResult
$Res call({
 int operatorId, String operatorName, int absentDays, int totalShiftMinutes, int totalOtMinutes, double baseSalary, double overtimePay, double takeHome
});




}
/// @nodoc
class __$PayrollPeriodSummaryCopyWithImpl<$Res>
    implements _$PayrollPeriodSummaryCopyWith<$Res> {
  __$PayrollPeriodSummaryCopyWithImpl(this._self, this._then);

  final _PayrollPeriodSummary _self;
  final $Res Function(_PayrollPeriodSummary) _then;

/// Create a copy of PayrollPeriodSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operatorId = null,Object? operatorName = null,Object? absentDays = null,Object? totalShiftMinutes = null,Object? totalOtMinutes = null,Object? baseSalary = null,Object? overtimePay = null,Object? takeHome = null,}) {
  return _then(_PayrollPeriodSummary(
operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,absentDays: null == absentDays ? _self.absentDays : absentDays // ignore: cast_nullable_to_non_nullable
as int,totalShiftMinutes: null == totalShiftMinutes ? _self.totalShiftMinutes : totalShiftMinutes // ignore: cast_nullable_to_non_nullable
as int,totalOtMinutes: null == totalOtMinutes ? _self.totalOtMinutes : totalOtMinutes // ignore: cast_nullable_to_non_nullable
as int,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as double,overtimePay: null == overtimePay ? _self.overtimePay : overtimePay // ignore: cast_nullable_to_non_nullable
as double,takeHome: null == takeHome ? _self.takeHome : takeHome // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
