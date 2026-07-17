import 'package:fpdart/fpdart.dart';
import '../entities/attendance_adjustment_draft.dart';
import '../entities/attendance_day_row.dart';
import '../entities/operator_wage_rate.dart';
import '../entities/payroll_period_summary.dart';
import '../entities/wage_role.dart';
import '../failures/attendance_review_failure.dart';

abstract class AttendanceReviewRepository {
  Future<Either<AttendanceReviewFailure, List<AttendanceDayRow>>> getDayRows({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<AttendanceReviewFailure, List<WageRole>>> getWageRolesForWorkGroup(
    int workGroupId,
  );

  Future<Either<AttendanceReviewFailure, OperatorWageRate?>> getWageRate({
    required int operatorId,
    required int wageRoleId,
    required DateTime asOfDate,
  });

  /// Commits ALL drafts for one employee in a single transaction.
  Future<Either<AttendanceReviewFailure, Unit>> saveAdjustments(
    List<AttendanceAdjustmentDraft> drafts,
  );

  Future<Either<AttendanceReviewFailure, PayrollPeriodSummary>> getPeriodSummary({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<AttendanceReviewFailure, Unit>> recalculate({
    required DateTime from,
    required DateTime to,
    int? operatorId,
  });

  /// Locks all calculated/estimated rows in the period — prevents future drift.
  Future<Either<AttendanceReviewFailure, Unit>> finalizeWeek({
    required DateTime from,
    required DateTime to,
  });
}

