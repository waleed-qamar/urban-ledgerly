import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/audit_log_entity.dart';
import '../entities/audit_log_filter.dart';

/// Read-only by design — audit_logs is written exclusively by the
/// `log_audit_event()` trigger, never by the app.
abstract class AuditLogRepository {
  Future<Either<Failure, List<AuditLogEntity>>> getAuditLogs({
    required AuditLogFilter filter,
    required int page,
    required int pageSize,
  });

  /// Distinct `table_name` values, for the filter sheet's table dropdown.
  Future<Either<Failure, List<String>>> getDistinctTables();

  /// Distinct actors (id + display name), for the filter sheet's user dropdown.
  Future<Either<Failure, List<AuditLogActor>>> getDistinctActors();
}

class AuditLogActor {
  final String userId;
  final String name;

  const AuditLogActor({required this.userId, required this.name});
}
