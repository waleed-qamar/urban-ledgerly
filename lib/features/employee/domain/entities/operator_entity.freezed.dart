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

 int get id; String get name; String get phone; String? get cnic;@JsonKey(name: 'joining_date') DateTime get joiningDate;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'work_group_id') int? get workGroupId;@JsonKey(name: 'default_wage_role_id') int? get defaultWageRoleId;@JsonKey(name: 'overtime_enabled') bool get overtimeEnabled;// Rate fields — stored directly on operators for salary, and via operator_role_rates for hourly
@JsonKey(name: 'monthly_salary') double? get monthlySalary;@JsonKey(name: 'device_employee_code') String? get deviceEmployeeCode;@JsonKey(includeFromJson: false, includeToJson: false) Map<int, double> get hourlyRates;
/// Create a copy of OperatorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperatorEntityCopyWith<OperatorEntity> get copyWith => _$OperatorEntityCopyWithImpl<OperatorEntity>(this as OperatorEntity, _$identity);

  /// Serializes this OperatorEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OperatorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cnic, cnic) || other.cnic == cnic)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.workGroupId, workGroupId) || other.workGroupId == workGroupId)&&(identical(other.defaultWageRoleId, defaultWageRoleId) || other.defaultWageRoleId == defaultWageRoleId)&&(identical(other.overtimeEnabled, overtimeEnabled) || other.overtimeEnabled == overtimeEnabled)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.deviceEmployeeCode, deviceEmployeeCode) || other.deviceEmployeeCode == deviceEmployeeCode)&&const DeepCollectionEquality().equals(other.hourlyRates, hourlyRates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,cnic,joiningDate,isActive,createdAt,workGroupId,defaultWageRoleId,overtimeEnabled,monthlySalary,deviceEmployeeCode,const DeepCollectionEquality().hash(hourlyRates));

@override
String toString() {
  return 'OperatorEntity(id: $id, name: $name, phone: $phone, cnic: $cnic, joiningDate: $joiningDate, isActive: $isActive, createdAt: $createdAt, workGroupId: $workGroupId, defaultWageRoleId: $defaultWageRoleId, overtimeEnabled: $overtimeEnabled, monthlySalary: $monthlySalary, deviceEmployeeCode: $deviceEmployeeCode, hourlyRates: $hourlyRates)';
}


}

/// @nodoc
abstract mixin class $OperatorEntityCopyWith<$Res>  {
  factory $OperatorEntityCopyWith(OperatorEntity value, $Res Function(OperatorEntity) _then) = _$OperatorEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String phone, String? cnic,@JsonKey(name: 'joining_date') DateTime joiningDate,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'work_group_id') int? workGroupId,@JsonKey(name: 'default_wage_role_id') int? defaultWageRoleId,@JsonKey(name: 'overtime_enabled') bool overtimeEnabled,@JsonKey(name: 'monthly_salary') double? monthlySalary,@JsonKey(name: 'device_employee_code') String? deviceEmployeeCode,@JsonKey(includeFromJson: false, includeToJson: false) Map<int, double> hourlyRates
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? cnic = freezed,Object? joiningDate = null,Object? isActive = null,Object? createdAt = freezed,Object? workGroupId = freezed,Object? defaultWageRoleId = freezed,Object? overtimeEnabled = null,Object? monthlySalary = freezed,Object? deviceEmployeeCode = freezed,Object? hourlyRates = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cnic: freezed == cnic ? _self.cnic : cnic // ignore: cast_nullable_to_non_nullable
as String?,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workGroupId: freezed == workGroupId ? _self.workGroupId : workGroupId // ignore: cast_nullable_to_non_nullable
as int?,defaultWageRoleId: freezed == defaultWageRoleId ? _self.defaultWageRoleId : defaultWageRoleId // ignore: cast_nullable_to_non_nullable
as int?,overtimeEnabled: null == overtimeEnabled ? _self.overtimeEnabled : overtimeEnabled // ignore: cast_nullable_to_non_nullable
as bool,monthlySalary: freezed == monthlySalary ? _self.monthlySalary : monthlySalary // ignore: cast_nullable_to_non_nullable
as double?,deviceEmployeeCode: freezed == deviceEmployeeCode ? _self.deviceEmployeeCode : deviceEmployeeCode // ignore: cast_nullable_to_non_nullable
as String?,hourlyRates: null == hourlyRates ? _self.hourlyRates : hourlyRates // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String phone,  String? cnic, @JsonKey(name: 'joining_date')  DateTime joiningDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'work_group_id')  int? workGroupId, @JsonKey(name: 'default_wage_role_id')  int? defaultWageRoleId, @JsonKey(name: 'overtime_enabled')  bool overtimeEnabled, @JsonKey(name: 'monthly_salary')  double? monthlySalary, @JsonKey(name: 'device_employee_code')  String? deviceEmployeeCode, @JsonKey(includeFromJson: false, includeToJson: false)  Map<int, double> hourlyRates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OperatorEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.isActive,_that.createdAt,_that.workGroupId,_that.defaultWageRoleId,_that.overtimeEnabled,_that.monthlySalary,_that.deviceEmployeeCode,_that.hourlyRates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String phone,  String? cnic, @JsonKey(name: 'joining_date')  DateTime joiningDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'work_group_id')  int? workGroupId, @JsonKey(name: 'default_wage_role_id')  int? defaultWageRoleId, @JsonKey(name: 'overtime_enabled')  bool overtimeEnabled, @JsonKey(name: 'monthly_salary')  double? monthlySalary, @JsonKey(name: 'device_employee_code')  String? deviceEmployeeCode, @JsonKey(includeFromJson: false, includeToJson: false)  Map<int, double> hourlyRates)  $default,) {final _that = this;
switch (_that) {
case _OperatorEntity():
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.isActive,_that.createdAt,_that.workGroupId,_that.defaultWageRoleId,_that.overtimeEnabled,_that.monthlySalary,_that.deviceEmployeeCode,_that.hourlyRates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String phone,  String? cnic, @JsonKey(name: 'joining_date')  DateTime joiningDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'work_group_id')  int? workGroupId, @JsonKey(name: 'default_wage_role_id')  int? defaultWageRoleId, @JsonKey(name: 'overtime_enabled')  bool overtimeEnabled, @JsonKey(name: 'monthly_salary')  double? monthlySalary, @JsonKey(name: 'device_employee_code')  String? deviceEmployeeCode, @JsonKey(includeFromJson: false, includeToJson: false)  Map<int, double> hourlyRates)?  $default,) {final _that = this;
switch (_that) {
case _OperatorEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.cnic,_that.joiningDate,_that.isActive,_that.createdAt,_that.workGroupId,_that.defaultWageRoleId,_that.overtimeEnabled,_that.monthlySalary,_that.deviceEmployeeCode,_that.hourlyRates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OperatorEntity implements OperatorEntity {
  const _OperatorEntity({required this.id, required this.name, required this.phone, this.cnic, @JsonKey(name: 'joining_date') required this.joiningDate, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'work_group_id') this.workGroupId, @JsonKey(name: 'default_wage_role_id') this.defaultWageRoleId, @JsonKey(name: 'overtime_enabled') this.overtimeEnabled = true, @JsonKey(name: 'monthly_salary') this.monthlySalary, @JsonKey(name: 'device_employee_code') this.deviceEmployeeCode, @JsonKey(includeFromJson: false, includeToJson: false) final  Map<int, double> hourlyRates = const {}}): _hourlyRates = hourlyRates;
  factory _OperatorEntity.fromJson(Map<String, dynamic> json) => _$OperatorEntityFromJson(json);

@override final  int id;
@override final  String name;
@override final  String phone;
@override final  String? cnic;
@override@JsonKey(name: 'joining_date') final  DateTime joiningDate;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'work_group_id') final  int? workGroupId;
@override@JsonKey(name: 'default_wage_role_id') final  int? defaultWageRoleId;
@override@JsonKey(name: 'overtime_enabled') final  bool overtimeEnabled;
// Rate fields — stored directly on operators for salary, and via operator_role_rates for hourly
@override@JsonKey(name: 'monthly_salary') final  double? monthlySalary;
@override@JsonKey(name: 'device_employee_code') final  String? deviceEmployeeCode;
 final  Map<int, double> _hourlyRates;
@override@JsonKey(includeFromJson: false, includeToJson: false) Map<int, double> get hourlyRates {
  if (_hourlyRates is EqualUnmodifiableMapView) return _hourlyRates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_hourlyRates);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperatorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cnic, cnic) || other.cnic == cnic)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.workGroupId, workGroupId) || other.workGroupId == workGroupId)&&(identical(other.defaultWageRoleId, defaultWageRoleId) || other.defaultWageRoleId == defaultWageRoleId)&&(identical(other.overtimeEnabled, overtimeEnabled) || other.overtimeEnabled == overtimeEnabled)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.deviceEmployeeCode, deviceEmployeeCode) || other.deviceEmployeeCode == deviceEmployeeCode)&&const DeepCollectionEquality().equals(other._hourlyRates, _hourlyRates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,cnic,joiningDate,isActive,createdAt,workGroupId,defaultWageRoleId,overtimeEnabled,monthlySalary,deviceEmployeeCode,const DeepCollectionEquality().hash(_hourlyRates));

@override
String toString() {
  return 'OperatorEntity(id: $id, name: $name, phone: $phone, cnic: $cnic, joiningDate: $joiningDate, isActive: $isActive, createdAt: $createdAt, workGroupId: $workGroupId, defaultWageRoleId: $defaultWageRoleId, overtimeEnabled: $overtimeEnabled, monthlySalary: $monthlySalary, deviceEmployeeCode: $deviceEmployeeCode, hourlyRates: $hourlyRates)';
}


}

/// @nodoc
abstract mixin class _$OperatorEntityCopyWith<$Res> implements $OperatorEntityCopyWith<$Res> {
  factory _$OperatorEntityCopyWith(_OperatorEntity value, $Res Function(_OperatorEntity) _then) = __$OperatorEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String phone, String? cnic,@JsonKey(name: 'joining_date') DateTime joiningDate,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'work_group_id') int? workGroupId,@JsonKey(name: 'default_wage_role_id') int? defaultWageRoleId,@JsonKey(name: 'overtime_enabled') bool overtimeEnabled,@JsonKey(name: 'monthly_salary') double? monthlySalary,@JsonKey(name: 'device_employee_code') String? deviceEmployeeCode,@JsonKey(includeFromJson: false, includeToJson: false) Map<int, double> hourlyRates
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? cnic = freezed,Object? joiningDate = null,Object? isActive = null,Object? createdAt = freezed,Object? workGroupId = freezed,Object? defaultWageRoleId = freezed,Object? overtimeEnabled = null,Object? monthlySalary = freezed,Object? deviceEmployeeCode = freezed,Object? hourlyRates = null,}) {
  return _then(_OperatorEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cnic: freezed == cnic ? _self.cnic : cnic // ignore: cast_nullable_to_non_nullable
as String?,joiningDate: null == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workGroupId: freezed == workGroupId ? _self.workGroupId : workGroupId // ignore: cast_nullable_to_non_nullable
as int?,defaultWageRoleId: freezed == defaultWageRoleId ? _self.defaultWageRoleId : defaultWageRoleId // ignore: cast_nullable_to_non_nullable
as int?,overtimeEnabled: null == overtimeEnabled ? _self.overtimeEnabled : overtimeEnabled // ignore: cast_nullable_to_non_nullable
as bool,monthlySalary: freezed == monthlySalary ? _self.monthlySalary : monthlySalary // ignore: cast_nullable_to_non_nullable
as double?,deviceEmployeeCode: freezed == deviceEmployeeCode ? _self.deviceEmployeeCode : deviceEmployeeCode // ignore: cast_nullable_to_non_nullable
as String?,hourlyRates: null == hourlyRates ? _self._hourlyRates : hourlyRates // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}


}

// dart format on
