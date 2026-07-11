import 'package:fpdart/fpdart.dart';
import '../../domain/entities/attendance_adjustment_draft.dart';
import '../../domain/entities/attendance_day_row.dart';
import '../../domain/entities/operator_wage_rate.dart';
import '../../domain/entities/payroll_period_summary.dart';
import '../../domain/entities/wage_role.dart';
import '../../domain/failures/attendance_review_failure.dart';
import '../../domain/repositories/attendance_review_repository.dart';
import '../datasources/attendance_review_supabase_datasource.dart';

class AttendanceReviewRepositoryImpl implements AttendanceReviewRepository {
  final AttendanceReviewSupabaseDatasource _datasource;

  AttendanceReviewRepositoryImpl(this._datasource);

  @override
  Future<Either<AttendanceReviewFailure, List<AttendanceDayRow>>> getDayRows({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final models = await _datasource.getDayRows(
        operatorId: operatorId,
        from: from,
        to: to,
      );
      return right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(AttendanceReviewFailure.server(e.toString()));
    }
  }

  @override
  Future<Either<AttendanceReviewFailure, List<WageRole>>> getWageRolesForWorkGroup(
    int workGroupId,
  ) async {
    try {
      final models = await _datasource.getWageRolesForWorkGroup(workGroupId);
      return right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(AttendanceReviewFailure.server(e.toString()));
    }
  }

  @override
  Future<Either<AttendanceReviewFailure, OperatorWageRate?>> getWageRate({
    required int operatorId,
    required int wageRoleId,
    required DateTime asOfDate,
  }) async {
    try {
      final model = await _datasource.getWageRate(
        operatorId: operatorId,
        wageRoleId: wageRoleId,
        asOfDate: asOfDate,
      );
      return right(model?.toEntity());
    } catch (e) {
      return left(AttendanceReviewFailure.server(e.toString()));
    }
  }

  @override
  Future<Either<AttendanceReviewFailure, Unit>> saveAdjustments(
    List<AttendanceAdjustmentDraft> drafts,
  ) async {
    try {
      await _datasource.saveAdjustments(drafts);
      return right(unit);
    } catch (e) {
      return left(AttendanceReviewFailure.server(e.toString()));
    }
  }

  @override
  Future<Either<AttendanceReviewFailure, PayrollPeriodSummary>> getPeriodSummary({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final map = await _datasource.getPeriodSummary(
        operatorId: operatorId,
        from: from,
        to: to,
      );
      
      final summary = PayrollPeriodSummary(
        operatorId: map['operator_id'],
        operatorName: map['operator_name'],
        absentDays: map['absent_days'],
        totalShiftMinutes: map['total_shift_minutes'],
        totalOtMinutes: map['total_ot_minutes'],
        baseSalary: map['base_salary'],
        overtimePay: map['overtime_pay'],
        takeHome: map['take_home'],
      );
      return right(summary);
    } catch (e) {
      return left(AttendanceReviewFailure.server(e.toString()));
    }
  }
}
