import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/attendance_adjustment_draft.dart';
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

  void setInTime(DateTime date, TimeOfDay time) {
    final draft = state[date] ?? _emptyDraft(date);
    final adjustedInAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    state = {...state, date: draft.copyWith(adjustedInAt: adjustedInAt)};
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
        .map((d) => d.reason.trim().isEmpty ? d.copyWith(reason: 'manager updated it') : d)
        .toList();

    state = const AsyncLoading();
    final repo = ref.read(attendanceReviewRepositoryProvider);

    // Step 1: persist adjustments
    final saveResult = await repo.saveAdjustments(drafts);
    if (saveResult.isLeft()) {
      state = saveResult.fold(
        (f) => AsyncError(f, StackTrace.current),
        (_) => const AsyncData(null),
      );
      return;
    }

    // Step 2: auto-recalculate — single source of truth
    final filter = ref.read(attendanceReviewFilterProvider);
    final recalcResult = await repo.recalculate(
      from: filter.from,
      to: filter.to,
      operatorId: operatorId,
    );

    state = recalcResult.fold(
      (f) => AsyncError(f, StackTrace.current),
      (_) {
        ref.read(attendanceEditDraftsProvider(operatorId).notifier).clearAll();
        // Invalidate so UI reflects the recalculated data
        ref.invalidate(attendanceDayRowsProvider);
        ref.invalidate(payrollPeriodSummaryProvider);
        return const AsyncData(null);
      },
    );
  }
}
