// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dps_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Machine {

 int get id; String get name;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Machine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MachineCopyWith<Machine> get copyWith => _$MachineCopyWithImpl<Machine>(this as Machine, _$identity);

  /// Serializes this Machine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Machine&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,createdAt);

@override
String toString() {
  return 'Machine(id: $id, name: $name, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MachineCopyWith<$Res>  {
  factory $MachineCopyWith(Machine value, $Res Function(Machine) _then) = _$MachineCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$MachineCopyWithImpl<$Res>
    implements $MachineCopyWith<$Res> {
  _$MachineCopyWithImpl(this._self, this._then);

  final Machine _self;
  final $Res Function(Machine) _then;

/// Create a copy of Machine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Machine].
extension MachinePatterns on Machine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Machine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Machine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Machine value)  $default,){
final _that = this;
switch (_that) {
case _Machine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Machine value)?  $default,){
final _that = this;
switch (_that) {
case _Machine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Machine() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Machine():
return $default(_that.id,_that.name,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Machine() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Machine implements Machine {
  const _Machine({required this.id, required this.name, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') this.createdAt});
  factory _Machine.fromJson(Map<String, dynamic> json) => _$MachineFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Machine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MachineCopyWith<_Machine> get copyWith => __$MachineCopyWithImpl<_Machine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MachineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Machine&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,createdAt);

@override
String toString() {
  return 'Machine(id: $id, name: $name, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MachineCopyWith<$Res> implements $MachineCopyWith<$Res> {
  factory _$MachineCopyWith(_Machine value, $Res Function(_Machine) _then) = __$MachineCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$MachineCopyWithImpl<$Res>
    implements _$MachineCopyWith<$Res> {
  __$MachineCopyWithImpl(this._self, this._then);

  final _Machine _self;
  final $Res Function(_Machine) _then;

/// Create a copy of Machine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_Machine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DpsReport {

 int? get id;@JsonKey(name: 'report_date') DateTime get reportDate; String get status; String? get notes;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of DpsReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DpsReportCopyWith<DpsReport> get copyWith => _$DpsReportCopyWithImpl<DpsReport>(this as DpsReport, _$identity);

  /// Serializes this DpsReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DpsReport&&(identical(other.id, id) || other.id == id)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportDate,status,notes,createdAt);

@override
String toString() {
  return 'DpsReport(id: $id, reportDate: $reportDate, status: $status, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DpsReportCopyWith<$Res>  {
  factory $DpsReportCopyWith(DpsReport value, $Res Function(DpsReport) _then) = _$DpsReportCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'report_date') DateTime reportDate, String status, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$DpsReportCopyWithImpl<$Res>
    implements $DpsReportCopyWith<$Res> {
  _$DpsReportCopyWithImpl(this._self, this._then);

  final DpsReport _self;
  final $Res Function(DpsReport) _then;

/// Create a copy of DpsReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? reportDate = null,Object? status = null,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportDate: null == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DpsReport].
extension DpsReportPatterns on DpsReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DpsReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DpsReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DpsReport value)  $default,){
final _that = this;
switch (_that) {
case _DpsReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DpsReport value)?  $default,){
final _that = this;
switch (_that) {
case _DpsReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_date')  DateTime reportDate,  String status,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DpsReport() when $default != null:
return $default(_that.id,_that.reportDate,_that.status,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_date')  DateTime reportDate,  String status,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DpsReport():
return $default(_that.id,_that.reportDate,_that.status,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'report_date')  DateTime reportDate,  String status,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DpsReport() when $default != null:
return $default(_that.id,_that.reportDate,_that.status,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DpsReport implements DpsReport {
  const _DpsReport({this.id, @JsonKey(name: 'report_date') required this.reportDate, this.status = 'draft', this.notes, @JsonKey(name: 'created_at') this.createdAt});
  factory _DpsReport.fromJson(Map<String, dynamic> json) => _$DpsReportFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'report_date') final  DateTime reportDate;
@override@JsonKey() final  String status;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of DpsReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DpsReportCopyWith<_DpsReport> get copyWith => __$DpsReportCopyWithImpl<_DpsReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DpsReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DpsReport&&(identical(other.id, id) || other.id == id)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportDate,status,notes,createdAt);

@override
String toString() {
  return 'DpsReport(id: $id, reportDate: $reportDate, status: $status, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DpsReportCopyWith<$Res> implements $DpsReportCopyWith<$Res> {
  factory _$DpsReportCopyWith(_DpsReport value, $Res Function(_DpsReport) _then) = __$DpsReportCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'report_date') DateTime reportDate, String status, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$DpsReportCopyWithImpl<$Res>
    implements _$DpsReportCopyWith<$Res> {
  __$DpsReportCopyWithImpl(this._self, this._then);

  final _DpsReport _self;
  final $Res Function(_DpsReport) _then;

/// Create a copy of DpsReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? reportDate = null,Object? status = null,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_DpsReport(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportDate: null == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DpsProductionLog {

 int? get id;@JsonKey(name: 'report_id') int? get reportId;@JsonKey(name: 'machine_id') int get machineId;@JsonKey(name: 'product_id') int get productId; double get quantity;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of DpsProductionLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DpsProductionLogCopyWith<DpsProductionLog> get copyWith => _$DpsProductionLogCopyWithImpl<DpsProductionLog>(this as DpsProductionLog, _$identity);

  /// Serializes this DpsProductionLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DpsProductionLog&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.machineId, machineId) || other.machineId == machineId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,machineId,productId,quantity,createdAt);

@override
String toString() {
  return 'DpsProductionLog(id: $id, reportId: $reportId, machineId: $machineId, productId: $productId, quantity: $quantity, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DpsProductionLogCopyWith<$Res>  {
  factory $DpsProductionLogCopyWith(DpsProductionLog value, $Res Function(DpsProductionLog) _then) = _$DpsProductionLogCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'report_id') int? reportId,@JsonKey(name: 'machine_id') int machineId,@JsonKey(name: 'product_id') int productId, double quantity,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$DpsProductionLogCopyWithImpl<$Res>
    implements $DpsProductionLogCopyWith<$Res> {
  _$DpsProductionLogCopyWithImpl(this._self, this._then);

  final DpsProductionLog _self;
  final $Res Function(DpsProductionLog) _then;

/// Create a copy of DpsProductionLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? reportId = freezed,Object? machineId = null,Object? productId = null,Object? quantity = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int?,machineId: null == machineId ? _self.machineId : machineId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DpsProductionLog].
extension DpsProductionLogPatterns on DpsProductionLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DpsProductionLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DpsProductionLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DpsProductionLog value)  $default,){
final _that = this;
switch (_that) {
case _DpsProductionLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DpsProductionLog value)?  $default,){
final _that = this;
switch (_that) {
case _DpsProductionLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'machine_id')  int machineId, @JsonKey(name: 'product_id')  int productId,  double quantity, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DpsProductionLog() when $default != null:
return $default(_that.id,_that.reportId,_that.machineId,_that.productId,_that.quantity,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'machine_id')  int machineId, @JsonKey(name: 'product_id')  int productId,  double quantity, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DpsProductionLog():
return $default(_that.id,_that.reportId,_that.machineId,_that.productId,_that.quantity,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'machine_id')  int machineId, @JsonKey(name: 'product_id')  int productId,  double quantity, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DpsProductionLog() when $default != null:
return $default(_that.id,_that.reportId,_that.machineId,_that.productId,_that.quantity,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DpsProductionLog implements DpsProductionLog {
  const _DpsProductionLog({this.id, @JsonKey(name: 'report_id') this.reportId, @JsonKey(name: 'machine_id') required this.machineId, @JsonKey(name: 'product_id') required this.productId, required this.quantity, @JsonKey(name: 'created_at') this.createdAt});
  factory _DpsProductionLog.fromJson(Map<String, dynamic> json) => _$DpsProductionLogFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'report_id') final  int? reportId;
@override@JsonKey(name: 'machine_id') final  int machineId;
@override@JsonKey(name: 'product_id') final  int productId;
@override final  double quantity;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of DpsProductionLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DpsProductionLogCopyWith<_DpsProductionLog> get copyWith => __$DpsProductionLogCopyWithImpl<_DpsProductionLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DpsProductionLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DpsProductionLog&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.machineId, machineId) || other.machineId == machineId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,machineId,productId,quantity,createdAt);

@override
String toString() {
  return 'DpsProductionLog(id: $id, reportId: $reportId, machineId: $machineId, productId: $productId, quantity: $quantity, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DpsProductionLogCopyWith<$Res> implements $DpsProductionLogCopyWith<$Res> {
  factory _$DpsProductionLogCopyWith(_DpsProductionLog value, $Res Function(_DpsProductionLog) _then) = __$DpsProductionLogCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'report_id') int? reportId,@JsonKey(name: 'machine_id') int machineId,@JsonKey(name: 'product_id') int productId, double quantity,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$DpsProductionLogCopyWithImpl<$Res>
    implements _$DpsProductionLogCopyWith<$Res> {
  __$DpsProductionLogCopyWithImpl(this._self, this._then);

  final _DpsProductionLog _self;
  final $Res Function(_DpsProductionLog) _then;

/// Create a copy of DpsProductionLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? reportId = freezed,Object? machineId = null,Object? productId = null,Object? quantity = null,Object? createdAt = freezed,}) {
  return _then(_DpsProductionLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int?,machineId: null == machineId ? _self.machineId : machineId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DpsConsumptionLog {

 int? get id;@JsonKey(name: 'report_id') int? get reportId;@JsonKey(name: 'raw_material_id') int get rawMaterialId; double get quantity;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of DpsConsumptionLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DpsConsumptionLogCopyWith<DpsConsumptionLog> get copyWith => _$DpsConsumptionLogCopyWithImpl<DpsConsumptionLog>(this as DpsConsumptionLog, _$identity);

  /// Serializes this DpsConsumptionLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DpsConsumptionLog&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.rawMaterialId, rawMaterialId) || other.rawMaterialId == rawMaterialId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,rawMaterialId,quantity,createdAt);

@override
String toString() {
  return 'DpsConsumptionLog(id: $id, reportId: $reportId, rawMaterialId: $rawMaterialId, quantity: $quantity, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DpsConsumptionLogCopyWith<$Res>  {
  factory $DpsConsumptionLogCopyWith(DpsConsumptionLog value, $Res Function(DpsConsumptionLog) _then) = _$DpsConsumptionLogCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'report_id') int? reportId,@JsonKey(name: 'raw_material_id') int rawMaterialId, double quantity,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$DpsConsumptionLogCopyWithImpl<$Res>
    implements $DpsConsumptionLogCopyWith<$Res> {
  _$DpsConsumptionLogCopyWithImpl(this._self, this._then);

  final DpsConsumptionLog _self;
  final $Res Function(DpsConsumptionLog) _then;

/// Create a copy of DpsConsumptionLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? reportId = freezed,Object? rawMaterialId = null,Object? quantity = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int?,rawMaterialId: null == rawMaterialId ? _self.rawMaterialId : rawMaterialId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DpsConsumptionLog].
extension DpsConsumptionLogPatterns on DpsConsumptionLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DpsConsumptionLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DpsConsumptionLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DpsConsumptionLog value)  $default,){
final _that = this;
switch (_that) {
case _DpsConsumptionLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DpsConsumptionLog value)?  $default,){
final _that = this;
switch (_that) {
case _DpsConsumptionLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'raw_material_id')  int rawMaterialId,  double quantity, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DpsConsumptionLog() when $default != null:
return $default(_that.id,_that.reportId,_that.rawMaterialId,_that.quantity,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'raw_material_id')  int rawMaterialId,  double quantity, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DpsConsumptionLog():
return $default(_that.id,_that.reportId,_that.rawMaterialId,_that.quantity,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'raw_material_id')  int rawMaterialId,  double quantity, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DpsConsumptionLog() when $default != null:
return $default(_that.id,_that.reportId,_that.rawMaterialId,_that.quantity,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DpsConsumptionLog implements DpsConsumptionLog {
  const _DpsConsumptionLog({this.id, @JsonKey(name: 'report_id') this.reportId, @JsonKey(name: 'raw_material_id') required this.rawMaterialId, required this.quantity, @JsonKey(name: 'created_at') this.createdAt});
  factory _DpsConsumptionLog.fromJson(Map<String, dynamic> json) => _$DpsConsumptionLogFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'report_id') final  int? reportId;
@override@JsonKey(name: 'raw_material_id') final  int rawMaterialId;
@override final  double quantity;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of DpsConsumptionLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DpsConsumptionLogCopyWith<_DpsConsumptionLog> get copyWith => __$DpsConsumptionLogCopyWithImpl<_DpsConsumptionLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DpsConsumptionLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DpsConsumptionLog&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.rawMaterialId, rawMaterialId) || other.rawMaterialId == rawMaterialId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,rawMaterialId,quantity,createdAt);

@override
String toString() {
  return 'DpsConsumptionLog(id: $id, reportId: $reportId, rawMaterialId: $rawMaterialId, quantity: $quantity, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DpsConsumptionLogCopyWith<$Res> implements $DpsConsumptionLogCopyWith<$Res> {
  factory _$DpsConsumptionLogCopyWith(_DpsConsumptionLog value, $Res Function(_DpsConsumptionLog) _then) = __$DpsConsumptionLogCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'report_id') int? reportId,@JsonKey(name: 'raw_material_id') int rawMaterialId, double quantity,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$DpsConsumptionLogCopyWithImpl<$Res>
    implements _$DpsConsumptionLogCopyWith<$Res> {
  __$DpsConsumptionLogCopyWithImpl(this._self, this._then);

  final _DpsConsumptionLog _self;
  final $Res Function(_DpsConsumptionLog) _then;

/// Create a copy of DpsConsumptionLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? reportId = freezed,Object? rawMaterialId = null,Object? quantity = null,Object? createdAt = freezed,}) {
  return _then(_DpsConsumptionLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int?,rawMaterialId: null == rawMaterialId ? _self.rawMaterialId : rawMaterialId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DpsDamageLog {

 int? get id;@JsonKey(name: 'report_id') int? get reportId;@JsonKey(name: 'machine_id') int get machineId;@JsonKey(name: 'item_type') String get itemType;// 'product' or 'raw_material'
@JsonKey(name: 'item_id') int get itemId; double get quantity; String? get reason;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of DpsDamageLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DpsDamageLogCopyWith<DpsDamageLog> get copyWith => _$DpsDamageLogCopyWithImpl<DpsDamageLog>(this as DpsDamageLog, _$identity);

  /// Serializes this DpsDamageLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DpsDamageLog&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.machineId, machineId) || other.machineId == machineId)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,machineId,itemType,itemId,quantity,reason,createdAt);

@override
String toString() {
  return 'DpsDamageLog(id: $id, reportId: $reportId, machineId: $machineId, itemType: $itemType, itemId: $itemId, quantity: $quantity, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DpsDamageLogCopyWith<$Res>  {
  factory $DpsDamageLogCopyWith(DpsDamageLog value, $Res Function(DpsDamageLog) _then) = _$DpsDamageLogCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'report_id') int? reportId,@JsonKey(name: 'machine_id') int machineId,@JsonKey(name: 'item_type') String itemType,@JsonKey(name: 'item_id') int itemId, double quantity, String? reason,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$DpsDamageLogCopyWithImpl<$Res>
    implements $DpsDamageLogCopyWith<$Res> {
  _$DpsDamageLogCopyWithImpl(this._self, this._then);

  final DpsDamageLog _self;
  final $Res Function(DpsDamageLog) _then;

/// Create a copy of DpsDamageLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? reportId = freezed,Object? machineId = null,Object? itemType = null,Object? itemId = null,Object? quantity = null,Object? reason = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int?,machineId: null == machineId ? _self.machineId : machineId // ignore: cast_nullable_to_non_nullable
as int,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DpsDamageLog].
extension DpsDamageLogPatterns on DpsDamageLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DpsDamageLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DpsDamageLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DpsDamageLog value)  $default,){
final _that = this;
switch (_that) {
case _DpsDamageLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DpsDamageLog value)?  $default,){
final _that = this;
switch (_that) {
case _DpsDamageLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'machine_id')  int machineId, @JsonKey(name: 'item_type')  String itemType, @JsonKey(name: 'item_id')  int itemId,  double quantity,  String? reason, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DpsDamageLog() when $default != null:
return $default(_that.id,_that.reportId,_that.machineId,_that.itemType,_that.itemId,_that.quantity,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'machine_id')  int machineId, @JsonKey(name: 'item_type')  String itemType, @JsonKey(name: 'item_id')  int itemId,  double quantity,  String? reason, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DpsDamageLog():
return $default(_that.id,_that.reportId,_that.machineId,_that.itemType,_that.itemId,_that.quantity,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'report_id')  int? reportId, @JsonKey(name: 'machine_id')  int machineId, @JsonKey(name: 'item_type')  String itemType, @JsonKey(name: 'item_id')  int itemId,  double quantity,  String? reason, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DpsDamageLog() when $default != null:
return $default(_that.id,_that.reportId,_that.machineId,_that.itemType,_that.itemId,_that.quantity,_that.reason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DpsDamageLog implements DpsDamageLog {
  const _DpsDamageLog({this.id, @JsonKey(name: 'report_id') this.reportId, @JsonKey(name: 'machine_id') required this.machineId, @JsonKey(name: 'item_type') required this.itemType, @JsonKey(name: 'item_id') required this.itemId, required this.quantity, this.reason, @JsonKey(name: 'created_at') this.createdAt});
  factory _DpsDamageLog.fromJson(Map<String, dynamic> json) => _$DpsDamageLogFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'report_id') final  int? reportId;
@override@JsonKey(name: 'machine_id') final  int machineId;
@override@JsonKey(name: 'item_type') final  String itemType;
// 'product' or 'raw_material'
@override@JsonKey(name: 'item_id') final  int itemId;
@override final  double quantity;
@override final  String? reason;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of DpsDamageLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DpsDamageLogCopyWith<_DpsDamageLog> get copyWith => __$DpsDamageLogCopyWithImpl<_DpsDamageLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DpsDamageLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DpsDamageLog&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.machineId, machineId) || other.machineId == machineId)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,machineId,itemType,itemId,quantity,reason,createdAt);

@override
String toString() {
  return 'DpsDamageLog(id: $id, reportId: $reportId, machineId: $machineId, itemType: $itemType, itemId: $itemId, quantity: $quantity, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DpsDamageLogCopyWith<$Res> implements $DpsDamageLogCopyWith<$Res> {
  factory _$DpsDamageLogCopyWith(_DpsDamageLog value, $Res Function(_DpsDamageLog) _then) = __$DpsDamageLogCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'report_id') int? reportId,@JsonKey(name: 'machine_id') int machineId,@JsonKey(name: 'item_type') String itemType,@JsonKey(name: 'item_id') int itemId, double quantity, String? reason,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$DpsDamageLogCopyWithImpl<$Res>
    implements _$DpsDamageLogCopyWith<$Res> {
  __$DpsDamageLogCopyWithImpl(this._self, this._then);

  final _DpsDamageLog _self;
  final $Res Function(_DpsDamageLog) _then;

/// Create a copy of DpsDamageLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? reportId = freezed,Object? machineId = null,Object? itemType = null,Object? itemId = null,Object? quantity = null,Object? reason = freezed,Object? createdAt = freezed,}) {
  return _then(_DpsDamageLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int?,machineId: null == machineId ? _self.machineId : machineId // ignore: cast_nullable_to_non_nullable
as int,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
