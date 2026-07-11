import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/attendance_day_row.dart';

part 'attendance_day_row_model.freezed.dart';
part 'attendance_day_row_model.g.dart';

@freezed
abstract class AttendanceDayRowModel with _$AttendanceDayRowModel {
  const factory AttendanceDayRowModel({
    required int operatorId,
    required DateTime attendanceDate,
    DateTime? inAt,
    DateTime? outAt,
    int? shiftRoleId,
    String? shiftRoleName,
    int? otRoleId,
    String? otRoleName,
    int? shiftMinutes,
    int? otMinutes,
    bool? isAbsent,
    double? salaryAmount,
    double? overtimeAmount,
    double? takeHomeAmount,
    String? calculationStatus,
    String? existingAdjustmentReason,
  }) = _AttendanceDayRowModel;

  factory AttendanceDayRowModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDayRowModelFromJson(json);

  const AttendanceDayRowModel._();

  AttendanceDayRow toEntity() {
    return AttendanceDayRow(
      operatorId: operatorId,
      date: attendanceDate,
      inAt: inAt,
      outAt: outAt,
      shiftRoleId: shiftRoleId ?? 0,
      shiftRoleName: shiftRoleName ?? '',
      otRoleId: otRoleId,
      otRoleName: otRoleName,
      shiftMinutes: shiftMinutes ?? 0,
      otMinutes: otMinutes ?? 0,
      isAbsent: isAbsent ?? false,
      salaryAmount: salaryAmount ?? 0.0,
      overtimeAmount: overtimeAmount ?? 0.0,
      takeHomeAmount: takeHomeAmount ?? 0.0,
      calculationStatus: _parseStatus(calculationStatus),
      existingAdjustmentReason: existingAdjustmentReason,
    );
  }

  CalculationStatus _parseStatus(String? status) {
    switch (status) {
      case 'estimated':
        return CalculationStatus.estimated;
      case 'manager_approved':
        return CalculationStatus.managerApproved;
      case 'finalized':
        return CalculationStatus.finalized;
      case 'needs_review':
        return CalculationStatus.needsReview;
      case 'draft':
      default:
        return CalculationStatus.draft;
    }
  }
}
