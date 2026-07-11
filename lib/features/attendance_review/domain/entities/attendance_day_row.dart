import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_day_row.freezed.dart';

enum CalculationStatus {
  draft,
  estimated,
  managerApproved,
  finalized,
  needsReview,
}

@freezed
abstract class AttendanceDayRow with _$AttendanceDayRow {
  const factory AttendanceDayRow({
    required int operatorId,
    required DateTime date,
    DateTime? inAt,
    DateTime? outAt,
    required int shiftRoleId,
    required String shiftRoleName,
    int? otRoleId,
    String? otRoleName,
    required int shiftMinutes,
    required int otMinutes,
    required bool isAbsent,
    required double salaryAmount,
    required double overtimeAmount,
    required double takeHomeAmount,
    required CalculationStatus calculationStatus,
    String? existingAdjustmentReason,
  }) = _AttendanceDayRow;
}
