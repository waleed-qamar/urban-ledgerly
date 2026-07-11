import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/operator_wage_rate.dart';

part 'operator_wage_rate_model.freezed.dart';
part 'operator_wage_rate_model.g.dart';

@freezed
abstract class OperatorWageRateModel with _$OperatorWageRateModel {
  const factory OperatorWageRateModel({
    required int id,
    @JsonKey(name: 'operator_id') required int operatorId,
    @JsonKey(name: 'wage_role_id') required int wageRoleId,
    @JsonKey(name: 'daily_wage') double? dailyWage,
    @JsonKey(name: 'monthly_salary') double? monthlySalary,
    @JsonKey(name: 'overtime_rate_per_hour') double? overtimeRatePerHour,
    @JsonKey(name: 'effective_from') required DateTime effectiveFrom,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _OperatorWageRateModel;

  factory OperatorWageRateModel.fromJson(Map<String, dynamic> json) =>
      _$OperatorWageRateModelFromJson(json);

  const OperatorWageRateModel._();

  OperatorWageRate toEntity() {
    return OperatorWageRate(
      id: id,
      operatorId: operatorId,
      wageRoleId: wageRoleId,
      dailyWage: dailyWage,
      monthlySalary: monthlySalary,
      overtimeRatePerHour: overtimeRatePerHour,
      effectiveFrom: effectiveFrom,
      isActive: isActive,
    );
  }
}
