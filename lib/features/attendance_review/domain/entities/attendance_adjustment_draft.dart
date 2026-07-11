import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_adjustment_draft.freezed.dart';

@freezed
abstract class AttendanceAdjustmentDraft with _$AttendanceAdjustmentDraft {
  const factory AttendanceAdjustmentDraft({
    required int operatorId,
    required DateTime date,
    DateTime? adjustedOutAt,
    int? adjustedOtMinutes,
    int? shiftRoleId,
    int? otRoleId,
    required String reason,
  }) = _AttendanceAdjustmentDraft;
}
