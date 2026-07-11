import 'package:freezed_annotation/freezed_annotation.dart';

part 'operator_wage_rate.freezed.dart';

@freezed
abstract class OperatorWageRate with _$OperatorWageRate {
  const factory OperatorWageRate({
    required int id,
    required int operatorId,
    required int wageRoleId,
    double? dailyWage,
    double? monthlySalary,
    double? overtimeRatePerHour,
    required DateTime effectiveFrom,
    required bool isActive,
  }) = _OperatorWageRate;
}
