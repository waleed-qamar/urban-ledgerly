import 'package:freezed_annotation/freezed_annotation.dart';

part 'operator_entity.freezed.dart';
part 'operator_entity.g.dart';

@freezed
abstract class OperatorEntity with _$OperatorEntity {
  const factory OperatorEntity({
    required int id,
    required String name,
    required String phone,
    String? cnic,
    @JsonKey(name: 'joining_date') required DateTime joiningDate,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // @JsonKey(name: 'work_group_id') int? workGroupId,
    // @JsonKey(name: 'default_wage_role_id') int? defaultWageRoleId,
    // @JsonKey(name: 'overtime_enabled') @Default(true) bool overtimeEnabled,
    // // Rate fields — stored directly on operators for salary, and via operator_role_rates for hourly
    // @JsonKey(name: 'monthly_salary') double? monthlySalary,
    // @JsonKey(name: 'device_employee_code') String? deviceEmployeeCode,
    // @JsonKey(includeFromJson: false, includeToJson: false) @Default({}) Map<int, double> hourlyRates,
  }) = _OperatorEntity;

  factory OperatorEntity.fromJson(Map<String, dynamic> json) =>
      _$OperatorEntityFromJson(json);
}
