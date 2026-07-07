import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_entity.freezed.dart';
part 'audit_log_entity.g.dart';

/// Mirrors the `action` values written by the `log_audit_event()` trigger.
enum AuditAction {
  insert,
  update,
  delete,
  unknown;

  static AuditAction fromRaw(String value) {
    switch (value.toUpperCase()) {
      case 'INSERT':
        return AuditAction.insert;
      case 'UPDATE':
        return AuditAction.update;
      case 'DELETE':
        return AuditAction.delete;
      default:
        return AuditAction.unknown;
    }
  }

  String get raw {
    switch (this) {
      case AuditAction.insert:
        return 'INSERT';
      case AuditAction.update:
        return 'UPDATE';
      case AuditAction.delete:
        return 'DELETE';
      case AuditAction.unknown:
        return 'UNKNOWN';
    }
  }

  String get label {
    switch (this) {
      case AuditAction.insert:
        return 'Created';
      case AuditAction.update:
        return 'Updated';
      case AuditAction.delete:
        return 'Deleted';
      case AuditAction.unknown:
        return 'Changed';
    }
  }
}

/// Read-only representation of one row in `audit_logs`.
///
/// We only ever *read* these — the SQL trigger in `log_audit_event()` is the
/// single writer — so there's no toJson/insert path here on purpose.
@freezed
abstract class AuditLogEntity with _$AuditLogEntity {
  const AuditLogEntity._();

  const factory AuditLogEntity({
    required int id,
    @JsonKey(name: 'table_name') required String tableName,
    @JsonKey(name: 'record_id') required String recordId,
    required String action,
    @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
    @JsonKey(name: 'new_data') Map<String, dynamic>? newData,
    @JsonKey(name: 'changed_fields') Map<String, dynamic>? changedFields,
    String? description,
    @JsonKey(name: 'changed_by') String? changedBy,
    @JsonKey(name: 'changed_by_name') String? changedByName,
    @JsonKey(name: 'changed_at') required DateTime changedAt,
  }) = _AuditLogEntity;

  factory AuditLogEntity.fromJson(Map<String, dynamic> json) =>
      _$AuditLogEntityFromJson(json);

  AuditAction get actionType => AuditAction.fromRaw(action);

  /// Whoever made the change, falling back gracefully when the trigger
  /// couldn't resolve `employees.name` (e.g. system-level changes where
  /// `changed_by` is null, as seen in the seed rows).
  String get actorLabel => changedByName ?? changedBy ?? 'System';

  /// `changed_fields` as a flat list of (field, old, new) rows, ready for a
  /// diff view. Empty for INSERT/DELETE, which don't populate this column.
  List<({String field, dynamic oldValue, dynamic newValue})> get fieldDiffs {
    if (changedFields == null) return const [];
    return changedFields!.entries.map((entry) {
      final value = entry.value;
      if (value is Map) {
        return (
          field: entry.key,
          oldValue: value['old'],
          newValue: value['new'],
        );
      }
      return (field: entry.key, oldValue: null, newValue: value);
    }).toList();
  }
}
