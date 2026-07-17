// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_day_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceDayRowModel _$AttendanceDayRowModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceDayRowModel(
  operatorId: (json['operator_id'] as num).toInt(),
  attendanceDate: DateTime.parse(json['attendance_date'] as String),
  inAt: json['in_at'] == null ? null : DateTime.parse(json['in_at'] as String),
  outAt: json['out_at'] == null
      ? null
      : DateTime.parse(json['out_at'] as String),
  shiftRoleId: (json['shift_role_id'] as num?)?.toInt(),
  shiftRoleName: json['shift_role_name'] as String?,
  otRoleId: (json['ot_role_id'] as num?)?.toInt(),
  otRoleName: json['ot_role_name'] as String?,
  shiftMinutes: (json['shift_minutes'] as num?)?.toInt(),
  otMinutes: (json['ot_minutes'] as num?)?.toInt(),
  isAbsent: json['is_absent'] as bool?,
  salaryAmount: (json['salary_amount'] as num?)?.toDouble(),
  overtimeAmount: (json['overtime_amount'] as num?)?.toDouble(),
  takeHomeAmount: (json['take_home_amount'] as num?)?.toDouble(),
  calculationStatus: json['calculation_status'] as String?,
  existingAdjustmentReason: json['existing_adjustment_reason'] as String?,
);

Map<String, dynamic> _$AttendanceDayRowModelToJson(
  _AttendanceDayRowModel instance,
) => <String, dynamic>{
  'operator_id': instance.operatorId,
  'attendance_date': instance.attendanceDate.toIso8601String(),
  'in_at': instance.inAt?.toIso8601String(),
  'out_at': instance.outAt?.toIso8601String(),
  'shift_role_id': instance.shiftRoleId,
  'shift_role_name': instance.shiftRoleName,
  'ot_role_id': instance.otRoleId,
  'ot_role_name': instance.otRoleName,
  'shift_minutes': instance.shiftMinutes,
  'ot_minutes': instance.otMinutes,
  'is_absent': instance.isAbsent,
  'salary_amount': instance.salaryAmount,
  'overtime_amount': instance.overtimeAmount,
  'take_home_amount': instance.takeHomeAmount,
  'calculation_status': instance.calculationStatus,
  'existing_adjustment_reason': instance.existingAdjustmentReason,
};
