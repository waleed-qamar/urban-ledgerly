import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/attendance_adjustment_draft.dart';
import '../../domain/failures/attendance_review_failure.dart';
import 'attendance_review_providers.dart';

part 'attendance_edit_state_provider.g.dart';

@riverpod
class AttendanceEditDrafts extends _$AttendanceEditDrafts {
  @override
  Map<DateTime, AttendanceAdjustmentDraft> build(int operatorId) => {};

  void setOutTime(DateTime date, TimeOfDay time) {
    final draft = state[date] ?? _emptyDraft(date);
    final adjustedOutAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    state = {...state, date: draft.copyWith(adjustedOutAt: adjustedOutAt)};
  }

  void setOtMinutes(DateTime date, int minutes) {
    final draft = state[date] ?? _emptyDraft(date);
    state = {...state, date: draft.copyWith(adjustedOtMinutes: minutes)};
  }

  void setShiftRole(DateTime date, int roleId) {
    final draft = state[date] ?? _emptyDraft(date);
    state = {...state, date: draft.copyWith(shiftRoleId: roleId)};
  }

  void setOtRole(DateTime date, int roleId) {
    final draft = state[date] ?? _emptyDraft(date);
    state = {...state, date: draft.copyWith(otRoleId: roleId)};
  }

  void setReason(DateTime date, String reason) {
    final draft = state[date] ?? _emptyDraft(date);
    state = {...state, date: draft.copyWith(reason: reason)};
  }

  void discard(DateTime date) {
    final newState = Map<DateTime, AttendanceAdjustmentDraft>.from(state);
    newState.remove(date);
    state = newState;
  }

  void clearAll() {
    state = {};
  }

  AttendanceAdjustmentDraft _emptyDraft(DateTime date) {
    return AttendanceAdjustmentDraft(
      operatorId: operatorId,
      date: date,
      reason: '',
    );
  }
}

@riverpod
bool isOtRoleCellEnabled(
  Ref ref, {
  required int operatorId,
  required DateTime date,
  required int loadedOtMinutes,
}) {
  final draft = ref.watch(attendanceEditDraftsProvider(operatorId))[date];
  final effectiveOt = draft?.adjustedOtMinutes ?? loadedOtMinutes;
  return effectiveOt > 0;
}

@riverpod
class SaveAttendanceAdjustments extends _$SaveAttendanceAdjustments {
  @override
  FutureOr<void> build() {}

  Future<void> save(int operatorId) async {
    final drafts = ref
        .read(attendanceEditDraftsProvider(operatorId))
        .values
        .toList();

    // guard: every draft MUST have a non-empty reason
    if (drafts.any((d) => d.reason.trim().isEmpty)) {
      state = AsyncError(
        const AttendanceReviewFailure.missingReason(),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    final repo = ref.read(attendanceReviewRepositoryProvider);
    final result = await repo.saveAdjustments(drafts);

    state = result.fold((f) => AsyncError(f, StackTrace.current), (_) {
      ref.read(attendanceEditDraftsProvider(operatorId).notifier).clearAll();
      // Invalidate day rows and summary to refetch
      ref.invalidate(attendanceDayRowsProvider);
      ref.invalidate(payrollPeriodSummaryProvider);
      return const AsyncData(null);
    });
  }
}
