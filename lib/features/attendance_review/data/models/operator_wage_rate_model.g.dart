// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_wage_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OperatorWageRateModel _$OperatorWageRateModelFromJson(
  Map<String, dynamic> json,
) => _OperatorWageRateModel(
  id: (json['id'] as num).toInt(),
  operatorId: (json['operator_id'] as num).toInt(),
  wageRoleId: (json['wage_role_id'] as num).toInt(),
  dailyWage: (json['daily_wage'] as num?)?.toDouble(),
  monthlySalary: (json['monthly_salary'] as num?)?.toDouble(),
  overtimeRatePerHour: (json['overtime_rate_per_hour'] as num?)?.toDouble(),
  effectiveFrom: DateTime.parse(json['effective_from'] as String),
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$OperatorWageRateModelToJson(
  _OperatorWageRateModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'operator_id': instance.operatorId,
  'wage_role_id': instance.wageRoleId,
  'daily_wage': instance.dailyWage,
  'monthly_salary': instance.monthlySalary,
  'overtime_rate_per_hour': instance.overtimeRatePerHour,
  'effective_from': instance.effectiveFrom.toIso8601String(),
  'is_active': instance.isActive,
};
