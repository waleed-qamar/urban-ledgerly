import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_filter.freezed.dart';

/// All filters are optional / additive (AND-ed together). `null` means "no
/// constraint on this dimension".
@freezed
abstract class AuditLogFilter with _$AuditLogFilter {
  const AuditLogFilter._();

  const factory AuditLogFilter({
    String? tableName,
    String? action, // raw value: INSERT / UPDATE / DELETE
    String? changedBy, // employees.user_id (uuid) of the actor
    DateTime? fromDate,
    DateTime? toDate,
  }) = _AuditLogFilter;

  bool get isEmpty =>
      tableName == null &&
      action == null &&
      changedBy == null &&
      fromDate == null &&
      toDate == null;

  int get activeCount => [
    tableName,
    action,
    changedBy,
    fromDate,
    toDate,
  ].where((f) => f != null).length;
}
