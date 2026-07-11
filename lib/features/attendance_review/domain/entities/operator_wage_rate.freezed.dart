// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operator_wage_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OperatorWageRate {

 int get id; int get operatorId; int get wageRoleId; double? get dailyWage; double? get monthlySalary; double? get overtimeRatePerHour; DateTime get effectiveFrom; bool get isActive;
/// Create a copy of OperatorWageRate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperatorWageRateCopyWith<OperatorWageRate> get copyWith => _$OperatorWageRateCopyWithImpl<OperatorWageRate>(this as OperatorWageRate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OperatorWageRate&&(identical(other.id, id) || other.id == id)&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.wageRoleId, wageRoleId) || other.wageRoleId == wageRoleId)&&(identical(other.dailyWage, dailyWage) || other.dailyWage == dailyWage)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.overtimeRatePerHour, overtimeRatePerHour) || other.overtimeRatePerHour == overtimeRatePerHour)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,operatorId,wageRoleId,dailyWage,monthlySalary,overtimeRatePerHour,effectiveFrom,isActive);

@override
String toString() {
  return 'OperatorWageRate(id: $id, operatorId: $operatorId, wageRoleId: $wageRoleId, dailyWage: $dailyWage, monthlySalary: $monthlySalary, overtimeRatePerHour: $overtimeRatePerHour, effectiveFrom: $effectiveFrom, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $OperatorWageRateCopyWith<$Res>  {
  factory $OperatorWageRateCopyWith(OperatorWageRate value, $Res Function(OperatorWageRate) _then) = _$OperatorWageRateCopyWithImpl;
@useResult
$Res call({
 int id, int operatorId, int wageRoleId, double? dailyWage, double? monthlySalary, double? overtimeRatePerHour, DateTime effectiveFrom, bool isActive
});




}
/// @nodoc
class _$OperatorWageRateCopyWithImpl<$Res>
    implements $OperatorWageRateCopyWith<$Res> {
  _$OperatorWageRateCopyWithImpl(this._self, this._then);

  final OperatorWageRate _self;
  final $Res Function(OperatorWageRate) _then;

/// Create a copy of OperatorWageRate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? operatorId = null,Object? wageRoleId = null,Object? dailyWage = freezed,Object? monthlySalary = freezed,Object? overtimeRatePerHour = freezed,Object? effectiveFrom = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,wageRoleId: null == wageRoleId ? _self.wageRoleId : wageRoleId // ignore: cast_nullable_to_non_nullable
as int,dailyWage: freezed == dailyWage ? _self.dailyWage : dailyWage // ignore: cast_nullable_to_non_nullable
as double?,monthlySalary: freezed == monthlySalary ? _self.monthlySalary : monthlySalary // ignore: cast_nullable_to_non_nullable
as double?,overtimeRatePerHour: freezed == overtimeRatePerHour ? _self.overtimeRatePerHour : overtimeRatePerHour // ignore: cast_nullable_to_non_nullable
as double?,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OperatorWageRate].
extension OperatorWageRatePatterns on OperatorWageRate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OperatorWageRate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OperatorWageRate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OperatorWageRate value)  $default,){
final _that = this;
switch (_that) {
case _OperatorWageRate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OperatorWageRate value)?  $default,){
final _that = this;
switch (_that) {
case _OperatorWageRate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int operatorId,  int wageRoleId,  double? dailyWage,  double? monthlySalary,  double? overtimeRatePerHour,  DateTime effectiveFrom,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OperatorWageRate() when $default != null:
return $default(_that.id,_that.operatorId,_that.wageRoleId,_that.dailyWage,_that.monthlySalary,_that.overtimeRatePerHour,_that.effectiveFrom,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int operatorId,  int wageRoleId,  double? dailyWage,  double? monthlySalary,  double? overtimeRatePerHour,  DateTime effectiveFrom,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _OperatorWageRate():
return $default(_that.id,_that.operatorId,_that.wageRoleId,_that.dailyWage,_that.monthlySalary,_that.overtimeRatePerHour,_that.effectiveFrom,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int operatorId,  int wageRoleId,  double? dailyWage,  double? monthlySalary,  double? overtimeRatePerHour,  DateTime effectiveFrom,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _OperatorWageRate() when $default != null:
return $default(_that.id,_that.operatorId,_that.wageRoleId,_that.dailyWage,_that.monthlySalary,_that.overtimeRatePerHour,_that.effectiveFrom,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _OperatorWageRate implements OperatorWageRate {
  const _OperatorWageRate({required this.id, required this.operatorId, required this.wageRoleId, this.dailyWage, this.monthlySalary, this.overtimeRatePerHour, required this.effectiveFrom, required this.isActive});
  

@override final  int id;
@override final  int operatorId;
@override final  int wageRoleId;
@override final  double? dailyWage;
@override final  double? monthlySalary;
@override final  double? overtimeRatePerHour;
@override final  DateTime effectiveFrom;
@override final  bool isActive;

/// Create a copy of OperatorWageRate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperatorWageRateCopyWith<_OperatorWageRate> get copyWith => __$OperatorWageRateCopyWithImpl<_OperatorWageRate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperatorWageRate&&(identical(other.id, id) || other.id == id)&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.wageRoleId, wageRoleId) || other.wageRoleId == wageRoleId)&&(identical(other.dailyWage, dailyWage) || other.dailyWage == dailyWage)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.overtimeRatePerHour, overtimeRatePerHour) || other.overtimeRatePerHour == overtimeRatePerHour)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,operatorId,wageRoleId,dailyWage,monthlySalary,overtimeRatePerHour,effectiveFrom,isActive);

@override
String toString() {
  return 'OperatorWageRate(id: $id, operatorId: $operatorId, wageRoleId: $wageRoleId, dailyWage: $dailyWage, monthlySalary: $monthlySalary, overtimeRatePerHour: $overtimeRatePerHour, effectiveFrom: $effectiveFrom, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$OperatorWageRateCopyWith<$Res> implements $OperatorWageRateCopyWith<$Res> {
  factory _$OperatorWageRateCopyWith(_OperatorWageRate value, $Res Function(_OperatorWageRate) _then) = __$OperatorWageRateCopyWithImpl;
@override @useResult
$Res call({
 int id, int operatorId, int wageRoleId, double? dailyWage, double? monthlySalary, double? overtimeRatePerHour, DateTime effectiveFrom, bool isActive
});




}
/// @nodoc
class __$OperatorWageRateCopyWithImpl<$Res>
    implements _$OperatorWageRateCopyWith<$Res> {
  __$OperatorWageRateCopyWithImpl(this._self, this._then);

  final _OperatorWageRate _self;
  final $Res Function(_OperatorWageRate) _then;

/// Create a copy of OperatorWageRate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? operatorId = null,Object? wageRoleId = null,Object? dailyWage = freezed,Object? monthlySalary = freezed,Object? overtimeRatePerHour = freezed,Object? effectiveFrom = null,Object? isActive = null,}) {
  return _then(_OperatorWageRate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as int,wageRoleId: null == wageRoleId ? _self.wageRoleId : wageRoleId // ignore: cast_nullable_to_non_nullable
as int,dailyWage: freezed == dailyWage ? _self.dailyWage : dailyWage // ignore: cast_nullable_to_non_nullable
as double?,monthlySalary: freezed == monthlySalary ? _self.monthlySalary : monthlySalary // ignore: cast_nullable_to_non_nullable
as double?,overtimeRatePerHour: freezed == overtimeRatePerHour ? _self.overtimeRatePerHour : overtimeRatePerHour // ignore: cast_nullable_to_non_nullable
as double?,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
