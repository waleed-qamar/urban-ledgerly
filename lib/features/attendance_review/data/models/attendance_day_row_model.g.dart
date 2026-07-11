// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_day_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceDayRowModel _$AttendanceDayRowModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceDayRowModel(
  operatorId: (json['operatorId'] as num).toInt(),
  attendanceDate: DateTime.parse(json['attendanceDate'] as String),
  inAt: json['inAt'] == null ? null : DateTime.parse(json['inAt'] as String),
  outAt: json['outAt'] == null ? null : DateTime.parse(json['outAt'] as String),
  shiftRoleId: (json['shiftRoleId'] as num?)?.toInt(),
  shiftRoleName: json['shiftRoleName'] as String?,
  otRoleId: (json['otRoleId'] as num?)?.toInt(),
  otRoleName: json['otRoleName'] as String?,
  shiftMinutes: (json['shiftMinutes'] as num?)?.toInt(),
  otMinutes: (json['otMinutes'] as num?)?.toInt(),
  isAbsent: json['isAbsent'] as bool?,
  salaryAmount: (json['salaryAmount'] as num?)?.toDouble(),
  overtimeAmount: (json['overtimeAmount'] as num?)?.toDouble(),
  takeHomeAmount: (json['takeHomeAmount'] as num?)?.toDouble(),
  calculationStatus: json['calculationStatus'] as String?,
  existingAdjustmentReason: json['existingAdjustmentReason'] as String?,
);

Map<String, dynamic> _$AttendanceDayRowModelToJson(
  _AttendanceDayRowModel instance,
) => <String, dynamic>{
  'operatorId': instance.operatorId,
  'attendanceDate': instance.attendanceDate.toIso8601String(),
  'inAt': instance.inAt?.toIso8601String(),
  'outAt': instance.outAt?.toIso8601String(),
  'shiftRoleId': instance.shiftRoleId,
  'shiftRoleName': instance.shiftRoleName,
  'otRoleId': instance.otRoleId,
  'otRoleName': instance.otRoleName,
  'shiftMinutes': instance.shiftMinutes,
  'otMinutes': instance.otMinutes,
  'isAbsent': instance.isAbsent,
  'salaryAmount': instance.salaryAmount,
  'overtimeAmount': instance.overtimeAmount,
  'takeHomeAmount': instance.takeHomeAmount,
  'calculationStatus': instance.calculationStatus,
  'existingAdjustmentReason': instance.existingAdjustmentReason,
};
