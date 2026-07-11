import 'package:freezed_annotation/freezed_annotation.dart';

part 'payroll_period_summary.freezed.dart';

@freezed
abstract class PayrollPeriodSummary with _$PayrollPeriodSummary {
  const factory PayrollPeriodSummary({
    required int operatorId,
    required String operatorName,
    required int absentDays,
    required int totalShiftMinutes,
    required int totalOtMinutes,
    required double baseSalary,
    required double overtimePay,
    required double takeHome,
  }) = _PayrollPeriodSummary;
}
