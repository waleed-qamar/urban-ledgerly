import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/attendance_day_row.dart';
import '../../domain/entities/payroll_period_summary.dart';
import '../../domain/entities/wage_role.dart';
import '../../domain/repositories/attendance_review_repository.dart';
import '../../data/datasources/attendance_review_supabase_datasource.dart';
import '../../data/repositories/attendance_review_repository_impl.dart';

part 'attendance_review_providers.g.dart';

// Assuming we have a global supabase provider somewhere in core,
// for now we'll inject it directly or create a local provider.
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
    final now = DateTime.now();
    return AttendanceReviewFilterState(
      from: DateTime(now.year, now.month, 1),
      to: DateTime(now.year, now.month + 1, 0),
    );
  }

  AttendanceReviewFilterState copyWith({
    int? operatorId,
    DateTime? from,
    DateTime? to,
  }) {
    return AttendanceReviewFilterState(
      operatorId: operatorId ?? this.operatorId,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}

@riverpod
class AttendanceReviewFilter extends _$AttendanceReviewFilter {
  @override
  AttendanceReviewFilterState build() => AttendanceReviewFilterState.initial();

  void selectOperator(int operatorId) =>
      state = state.copyWith(operatorId: operatorId);
  void setDateRange(DateTime from, DateTime to) =>
      state = state.copyWith(from: from, to: to);

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
