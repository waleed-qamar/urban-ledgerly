// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operator_wage_rate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OperatorWageRateModel {

 int get id;@JsonKey(name: 'operator_id') int get operatorId;@JsonKey(name: 'wage_role_id') int get wageRoleId;@JsonKey(name: 'daily_wage') double? get dailyWage;@JsonKey(name: 'monthly_salary') double? get monthlySalary;@JsonKey(name: 'overtime_rate_per_hour') double? get overtimeRatePerHour;@JsonKey(name: 'effective_from') DateTime get effectiveFrom;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of OperatorWageRateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperatorWageRateModelCopyWith<OperatorWageRateModel> get copyWith => _$OperatorWageRateModelCopyWithImpl<OperatorWageRateModel>(this as OperatorWageRateModel, _$identity);

  /// Serializes this OperatorWageRateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OperatorWageRateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.wageRoleId, wageRoleId) || other.wageRoleId == wageRoleId)&&(identical(other.dailyWage, dailyWage) || other.dailyWage == dailyWage)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.overtimeRatePerHour, overtimeRatePerHour) || other.overtimeRatePerHour == overtimeRatePerHour)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operatorId,wageRoleId,dailyWage,monthlySalary,overtimeRatePerHour,effectiveFrom,isActive);

@override
String toString() {
  return 'OperatorWageRateModel(id: $id, operatorId: $operatorId, wageRoleId: $wageRoleId, dailyWage: $dailyWage, monthlySalary: $monthlySalary, overtimeRatePerHour: $overtimeRatePerHour, effectiveFrom: $effectiveFrom, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $OperatorWageRateModelCopyWith<$Res>  {
  factory $OperatorWageRateModelCopyWith(OperatorWageRateModel value, $Res Function(OperatorWageRateModel) _then) = _$OperatorWageRateModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'operator_id') int operatorId,@JsonKey(name: 'wage_role_id') int wageRoleId,@JsonKey(name: 'daily_wage') double? dailyWage,@JsonKey(name: 'monthly_salary') double? monthlySalary,@JsonKey(name: 'overtime_rate_per_hour') double? overtimeRatePerHour,@JsonKey(name: 'effective_from') DateTime effectiveFrom,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$OperatorWageRateModelCopyWithImpl<$Res>
    implements $OperatorWageRateModelCopyWith<$Res> {
  _$OperatorWageRateModelCopyWithImpl(this._self, this._then);

  final OperatorWageRateModel _self;
  final $Res Function(OperatorWageRateModel) _then;

/// Create a copy of OperatorWageRateModel
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


/// Adds pattern-matching-related methods to [OperatorWageRateModel].
extension OperatorWageRateModelPatterns on OperatorWageRateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OperatorWageRateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OperatorWageRateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OperatorWageRateModel value)  $default,){
final _that = this;
switch (_that) {
case _OperatorWageRateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OperatorWageRateModel value)?  $default,){
final _that = this;
switch (_that) {
case _OperatorWageRateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'operator_id')  int operatorId, @JsonKey(name: 'wage_role_id')  int wageRoleId, @JsonKey(name: 'daily_wage')  double? dailyWage, @JsonKey(name: 'monthly_salary')  double? monthlySalary, @JsonKey(name: 'overtime_rate_per_hour')  double? overtimeRatePerHour, @JsonKey(name: 'effective_from')  DateTime effectiveFrom, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OperatorWageRateModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'operator_id')  int operatorId, @JsonKey(name: 'wage_role_id')  int wageRoleId, @JsonKey(name: 'daily_wage')  double? dailyWage, @JsonKey(name: 'monthly_salary')  double? monthlySalary, @JsonKey(name: 'overtime_rate_per_hour')  double? overtimeRatePerHour, @JsonKey(name: 'effective_from')  DateTime effectiveFrom, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _OperatorWageRateModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'operator_id')  int operatorId, @JsonKey(name: 'wage_role_id')  int wageRoleId, @JsonKey(name: 'daily_wage')  double? dailyWage, @JsonKey(name: 'monthly_salary')  double? monthlySalary, @JsonKey(name: 'overtime_rate_per_hour')  double? overtimeRatePerHour, @JsonKey(name: 'effective_from')  DateTime effectiveFrom, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _OperatorWageRateModel() when $default != null:
return $default(_that.id,_that.operatorId,_that.wageRoleId,_that.dailyWage,_that.monthlySalary,_that.overtimeRatePerHour,_that.effectiveFrom,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OperatorWageRateModel extends OperatorWageRateModel {
  const _OperatorWageRateModel({required this.id, @JsonKey(name: 'operator_id') required this.operatorId, @JsonKey(name: 'wage_role_id') required this.wageRoleId, @JsonKey(name: 'daily_wage') this.dailyWage, @JsonKey(name: 'monthly_salary') this.monthlySalary, @JsonKey(name: 'overtime_rate_per_hour') this.overtimeRatePerHour, @JsonKey(name: 'effective_from') required this.effectiveFrom, @JsonKey(name: 'is_active') required this.isActive}): super._();
  factory _OperatorWageRateModel.fromJson(Map<String, dynamic> json) => _$OperatorWageRateModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'operator_id') final  int operatorId;
@override@JsonKey(name: 'wage_role_id') final  int wageRoleId;
@override@JsonKey(name: 'daily_wage') final  double? dailyWage;
@override@JsonKey(name: 'monthly_salary') final  double? monthlySalary;
@override@JsonKey(name: 'overtime_rate_per_hour') final  double? overtimeRatePerHour;
@override@JsonKey(name: 'effective_from') final  DateTime effectiveFrom;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of OperatorWageRateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperatorWageRateModelCopyWith<_OperatorWageRateModel> get copyWith => __$OperatorWageRateModelCopyWithImpl<_OperatorWageRateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OperatorWageRateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperatorWageRateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.wageRoleId, wageRoleId) || other.wageRoleId == wageRoleId)&&(identical(other.dailyWage, dailyWage) || other.dailyWage == dailyWage)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.overtimeRatePerHour, overtimeRatePerHour) || other.overtimeRatePerHour == overtimeRatePerHour)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operatorId,wageRoleId,dailyWage,monthlySalary,overtimeRatePerHour,effectiveFrom,isActive);

@override
String toString() {
  return 'OperatorWageRateModel(id: $id, operatorId: $operatorId, wageRoleId: $wageRoleId, dailyWage: $dailyWage, monthlySalary: $monthlySalary, overtimeRatePerHour: $overtimeRatePerHour, effectiveFrom: $effectiveFrom, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$OperatorWageRateModelCopyWith<$Res> implements $OperatorWageRateModelCopyWith<$Res> {
  factory _$OperatorWageRateModelCopyWith(_OperatorWageRateModel value, $Res Function(_OperatorWageRateModel) _then) = __$OperatorWageRateModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'operator_id') int operatorId,@JsonKey(name: 'wage_role_id') int wageRoleId,@JsonKey(name: 'daily_wage') double? dailyWage,@JsonKey(name: 'monthly_salary') double? monthlySalary,@JsonKey(name: 'overtime_rate_per_hour') double? overtimeRatePerHour,@JsonKey(name: 'effective_from') DateTime effectiveFrom,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$OperatorWageRateModelCopyWithImpl<$Res>
    implements _$OperatorWageRateModelCopyWith<$Res> {
  __$OperatorWageRateModelCopyWithImpl(this._self, this._then);

  final _OperatorWageRateModel _self;
  final $Res Function(_OperatorWageRateModel) _then;

/// Create a copy of OperatorWageRateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? operatorId = null,Object? wageRoleId = null,Object? dailyWage = freezed,Object? monthlySalary = freezed,Object? overtimeRatePerHour = freezed,Object? effectiveFrom = null,Object? isActive = null,}) {
  return _then(_OperatorWageRateModel(
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
