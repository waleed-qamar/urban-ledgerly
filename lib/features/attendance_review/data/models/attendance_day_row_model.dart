import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/attendance_day_row.dart';

part 'attendance_day_row_model.freezed.dart';
part 'attendance_day_row_model.g.dart';

@freezed
abstract class AttendanceDayRowModel with _$AttendanceDayRowModel {
  const factory AttendanceDayRowModel({
    @JsonKey(name: 'operator_id') required int operatorId,
    @JsonKey(name: 'attendance_date') required DateTime attendanceDate,
    @JsonKey(name: 'in_at') DateTime? inAt,
    @JsonKey(name: 'out_at') DateTime? outAt,
    @JsonKey(name: 'shift_role_id') int? shiftRoleId,
    @JsonKey(name: 'shift_role_name') String? shiftRoleName,
    @JsonKey(name: 'ot_role_id') int? otRoleId,
    @JsonKey(name: 'ot_role_name') String? otRoleName,
    @JsonKey(name: 'shift_minutes') int? shiftMinutes,
    @JsonKey(name: 'ot_minutes') int? otMinutes,
    @JsonKey(name: 'is_absent') bool? isAbsent,
    @JsonKey(name: 'salary_amount') double? salaryAmount,
    @JsonKey(name: 'overtime_amount') double? overtimeAmount,
    @JsonKey(name: 'take_home_amount') double? takeHomeAmount,
    @JsonKey(name: 'calculation_status') String? calculationStatus,
    @JsonKey(name: 'existing_adjustment_reason') String? existingAdjustmentReason,
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
      case 'calculated':
        return CalculationStatus.draft;
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
