import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/attendance_day_row.dart';
import '../../domain/entities/payroll_period_summary.dart';
import '../../domain/entities/wage_role.dart';
import '../../domain/repositories/attendance_review_repository.dart';
import '../../data/datasources/attendance_review_supabase_datasource.dart';
import '../../data/repositories/attendance_review_repository_impl.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';
import 'package:ledgerly/features/employee/presentation/provider/operator_providers.dart';
import 'package:ledgerly/features/attendance_review/presentation/providers/attendance_edit_state_provider.dart';
import 'package:flutter/material.dart';

part 'attendance_review_providers.g.dart';

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

@riverpod
AttendanceReviewSupabaseDatasource attendanceReviewDatasource(Ref ref) {
  return AttendanceReviewSupabaseDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
AttendanceReviewRepository attendanceReviewRepository(Ref ref) {
  return AttendanceReviewRepositoryImpl(
    ref.watch(attendanceReviewDatasourceProvider),
  );
}

// ---------------------------------------------------------------------------
// Real operators list (replaces the hard-coded mock in EmployeeSidebar)
// ---------------------------------------------------------------------------

@riverpod
Future<List<OperatorEntity>> attendanceOperators(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final response = await client
      .from('operators')
      .select(
        'id, name, phone, cnic, joining_date, is_active, created_at, work_group_id, default_wage_role_id, overtime_enabled, operator_role_rates(wage_role_id, hourly_rate)',
      )
      .eq('is_active', true)
      .order('name');
  return (response as List<dynamic>).map((json) {
    final rates = <int, double>{};
    final ratesList = json['operator_role_rates'] as List<dynamic>?;
    if (ratesList != null) {
      for (final rate in ratesList) {
        rates[rate['wage_role_id'] as int] = (rate['hourly_rate'] as num)
            .toDouble();
      }
    }
    final entity = OperatorEntity.fromJson(json as Map<String, dynamic>);
    return entity.copyWith(hourlyRates: rates);
  }).toList();
}

// ---------------------------------------------------------------------------
// Filter state
// ---------------------------------------------------------------------------

/// Returns the Monday of the week containing [date].
DateTime _weekStart(DateTime date) {
  final daysFromMonday = (date.weekday - 1) % 7;
  return DateTime(date.year, date.month, date.day - daysFromMonday);
}

class AttendanceReviewFilterState {
  final int? operatorId;
  final DateTime from;
  final DateTime to;

  AttendanceReviewFilterState({
    this.operatorId,
    required this.from,
    required this.to,
  });

  factory AttendanceReviewFilterState.initial() {
    final monday = _weekStart(DateTime.now());
    return AttendanceReviewFilterState(
      from: monday,
      to: monday.add(const Duration(days: 6)),
    );
  }

  AttendanceReviewFilterState copyWith({
    int? operatorId,
    bool clearOperator = false,
    DateTime? from,
    DateTime? to,
  }) {
    return AttendanceReviewFilterState(
      operatorId: clearOperator ? null : (operatorId ?? this.operatorId),
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}

@Riverpod(keepAlive: true)
class AttendanceReviewFilter extends _$AttendanceReviewFilter {
  @override
  AttendanceReviewFilterState build() => AttendanceReviewFilterState.initial();

  void selectOperator(int operatorId) =>
      state = state.copyWith(operatorId: operatorId);

  void setDateRange(DateTime from, DateTime to) =>
      state = state.copyWith(from: from, to: to);

  void setCurrentWeek() {
    final monday = _weekStart(DateTime.now());
    state = state.copyWith(
      from: monday,
      to: monday.add(const Duration(days: 6)),
    );
  }

  void setLastWeek() {
    final lastMonday = _weekStart(
      DateTime.now(),
    ).subtract(const Duration(days: 7));
    state = state.copyWith(
      from: lastMonday,
      to: lastMonday.add(const Duration(days: 6)),
    );
  }

  void selectNextOperator(List<int> orderedIds) {
    if (state.operatorId == null) return;
    final index = orderedIds.indexOf(state.operatorId!);
    if (index >= 0 && index < orderedIds.length - 1) {
      state = state.copyWith(operatorId: orderedIds[index + 1]);
    }
  }

  void selectPreviousOperator(List<int> orderedIds) {
    if (state.operatorId == null) return;
    final index = orderedIds.indexOf(state.operatorId!);
    if (index > 0) {
      state = state.copyWith(operatorId: orderedIds[index - 1]);
    }
  }
}

// ---------------------------------------------------------------------------
// Attendance day rows
// ---------------------------------------------------------------------------

@riverpod
Future<List<AttendanceDayRow>> attendanceDayRows(
  Ref ref, {
  required int operatorId,
  required DateTime from,
  required DateTime to,
}) async {
  final repo = ref.watch(attendanceReviewRepositoryProvider);
  final result = await repo.getDayRows(
    operatorId: operatorId,
    from: from,
    to: to,
  );
  return result.fold((f) => throw f, (rows) => rows);
}

@riverpod
Future<List<WageRole>> wageRolesForWorkGroup(Ref ref, int workGroupId) async {
  final repo = ref.watch(attendanceReviewRepositoryProvider);
  final result = await repo.getWageRolesForWorkGroup(workGroupId);
  return result.fold((f) => throw f, (roles) => roles);
}

@riverpod
Future<bool> hasWageRateForRole(
  Ref ref, {
  required int operatorId,
  required int wageRoleId,
  required DateTime asOfDate,
}) async {
  final repo = ref.watch(attendanceReviewRepositoryProvider);
  final result = await repo.getWageRate(
    operatorId: operatorId,
    wageRoleId: wageRoleId,
    asOfDate: asOfDate,
  );
  return result.fold((_) => false, (rate) => rate != null);
}

@riverpod
Future<PayrollPeriodSummary> payrollPeriodSummary(
  Ref ref, {
  required int operatorId,
  required DateTime from,
  required DateTime to,
}) async {
  final repo = ref.watch(attendanceReviewRepositoryProvider);
  final result = await repo.getPeriodSummary(
    operatorId: operatorId,
    from: from,
    to: to,
  );
  return result.fold((f) => throw f, (summary) => summary);
}

// ---------------------------------------------------------------------------
// Finalize period (lock a printed/paid week)
// ---------------------------------------------------------------------------

@riverpod
class FinalizeAttendancePeriod extends _$FinalizeAttendancePeriod {
  @override
  FutureOr<void> build() {}

  Future<void> finalize({required DateTime from, required DateTime to}) async {
    state = const AsyncLoading();
    final repo = ref.read(attendanceReviewRepositoryProvider);
    final result = await repo.finalizeWeek(from: from, to: to);
    state = result.fold((f) => AsyncError(f, StackTrace.current), (_) {
      ref.invalidate(attendanceDayRowsProvider);
      return const AsyncData(null);
    });
  }
}

// ---------------------------------------------------------------------------
// Live Calculation
// ---------------------------------------------------------------------------

class CalculatedPay {
  final double normalHrs;
  final double otHrs;
  final double wagePay;
  final double otPay;
  final double takeHome;

  CalculatedPay({
    required this.normalHrs,
    required this.otHrs,
    required this.wagePay,
    required this.otPay,
    required this.takeHome,
  });

  factory CalculatedPay.fallback(AttendanceDayRow row) {
    return CalculatedPay(
      normalHrs: row.shiftMinutes / 60.0,
      otHrs: row.otMinutes / 60.0,
      wagePay: row.salaryAmount,
      otPay: row.overtimeAmount,
      takeHome: row.takeHomeAmount,
    );
  }
}

@riverpod
CalculatedPay liveAttendanceCalculation(
  Ref ref,
  int operatorId,
  AttendanceDayRow row,
) {
  // 1. Get draft
  final drafts = ref.watch(attendanceEditDraftsProvider(operatorId));
  final draft = drafts[row.date];

  // 2. Get operator details
  final operatorsAsync = ref.watch(attendanceOperatorsProvider);
  final op = operatorsAsync.value?.where((o) => o.id == operatorId).firstOrNull;
  if (op == null) return CalculatedPay.fallback(row);

  // 3. Get work group shifts
  final workGroupsAsync = ref.watch(getAllWorkGroupsProvider);
  Map<String, dynamic>? wg;
  if (workGroupsAsync.value != null) {
    for (final w in workGroupsAsync.value!) {
      if (w['id'] == op.workGroupId) {
        wg = w;
        break;
      }
    }
  }

  // If no punch overrides, fallback if not absent
  final effectiveIn = draft?.adjustedInAt ?? row.inAt;
  final effectiveOut = draft?.adjustedOutAt ?? row.outAt;

  if (effectiveIn == null || effectiveOut == null) {
    return CalculatedPay(
      normalHrs: 0,
      otHrs: 0,
      wagePay: 0,
      otPay: 0,
      takeHome: 0,
    );
  }

  // Calculate intersection logic exactly like DB
  double normalHrs = 0;
  double otHrs = 0;

  if (wg != null &&
      wg['default_shift_start'] != null &&
      wg['default_shift_end'] != null) {
    final t1 = TimeOfDay(
      hour: int.parse(wg['default_shift_start'].split(':')[0]),
      minute: int.parse(wg['default_shift_start'].split(':')[1]),
    );
    final t2 = TimeOfDay(
      hour: int.parse(wg['default_shift_end'].split(':')[0]),
      minute: int.parse(wg['default_shift_end'].split(':')[1]),
    );

    DateTime shiftStart = DateTime(
      row.date.year,
      row.date.month,
      row.date.day,
      t1.hour,
      t1.minute,
    );
    DateTime shiftEnd = DateTime(
      row.date.year,
      row.date.month,
      row.date.day,
      t2.hour,
      t2.minute,
    );

    if (shiftEnd.isBefore(shiftStart)) {
      shiftEnd = shiftEnd.add(const Duration(days: 1));
    }

    final normalStart = effectiveIn.isAfter(shiftStart)
        ? effectiveIn
        : shiftStart;
    final normalEnd = effectiveOut.isBefore(shiftEnd) ? effectiveOut : shiftEnd;

    if (normalEnd.isAfter(normalStart)) {
      normalHrs = normalEnd.difference(normalStart).inMinutes / 60.0;
    }

    final workedMinutes = effectiveOut.difference(effectiveIn).inMinutes;
    otHrs = (workedMinutes / 60.0) - normalHrs;
    if (otHrs < 0) otHrs = 0;
  } else {
    // No work group, default to full time worked as normal
    normalHrs = effectiveOut.difference(effectiveIn).inMinutes / 60.0;
  }

  // Wages
  final shiftRoleId = draft?.shiftRoleId ?? row.shiftRoleId ?? op.defaultWageRoleId;
  final otRoleId = draft?.otRoleId ?? row.otRoleId ?? op.defaultWageRoleId;

  final shiftRate = shiftRoleId != null
      ? (op.hourlyRates[shiftRoleId] ?? 0.0)
      : 0.0;
  final otRate = otRoleId != null ? (op.hourlyRates[otRoleId] ?? 0.0) : 0.0;

  final wagePay = normalHrs * shiftRate;
  // Note: For simplicity, assuming wg 'overtime_enabled' is not available here unless we fetch it. We will rely on operator's overtimeEnabled.
  final otPay = op.overtimeEnabled ? (otHrs * otRate) : 0.0;

  return CalculatedPay(
    normalHrs: normalHrs,
    otHrs: otHrs,
    wagePay: wagePay,
    otPay: otPay,
    takeHome: wagePay + otPay,
  );
}
