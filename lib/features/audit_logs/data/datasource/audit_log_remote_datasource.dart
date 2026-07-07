import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/audit_log_entity.dart';
import '../../domain/entities/audit_log_filter.dart';
import '../../domain/repositories/audit_log_repository.dart' show AuditLogActor;

abstract class AuditLogRemoteDataSource {
  Future<List<AuditLogEntity>> getAuditLogs({
    required AuditLogFilter filter,
    required int page,
    required int pageSize,
  });

  Future<List<String>> getDistinctTables();

  Future<List<AuditLogActor>> getDistinctActors();
}

class AuditLogRemoteDataSourceImpl implements AuditLogRemoteDataSource {
  final SupabaseClient client;

  AuditLogRemoteDataSourceImpl(this.client);

  static const _table = 'audit_logs';

  @override
  Future<List<AuditLogEntity>> getAuditLogs({
    required AuditLogFilter filter,
    required int page,
    required int pageSize,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    var builder = client.from(_table).select();

    if (filter.tableName != null) {
      builder = builder.eq('table_name', filter.tableName!);
    }
    if (filter.action != null) {
      builder = builder.eq('action', filter.action!);
    }
    if (filter.changedBy != null) {
      builder = builder.eq('changed_by', filter.changedBy!);
    }
    if (filter.fromDate != null) {
      builder = builder.gte('changed_at', filter.fromDate!.toIso8601String());
    }
    if (filter.toDate != null) {
      builder = builder.lte('changed_at', filter.toDate!.toIso8601String());
    }

    final response = await builder
        .order('changed_at', ascending: false)
        .range(from, to);

    return (response as List)
        .map((row) => AuditLogEntity.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<String>> getDistinctTables() async {
    // PostgREST has no native `SELECT DISTINCT`, so we pull a recent slice
    // and dedupe client-side. If audit_logs grows large enough that this
    // gets expensive, swap it for a small Postgres view, e.g.:
    //   create view audit_log_tables as select distinct table_name from audit_logs;
    final response = await client
        .from(_table)
        .select('table_name')
        .order('changed_at', ascending: false)
        .limit(1000);

    final tables = (response as List)
        .map((row) => row['table_name'] as String)
        .toSet()
        .toList();
    tables.sort();
    return tables;
  }

  @override
  Future<List<AuditLogActor>> getDistinctActors() async {
    final response = await client
        .from(_table)
        .select('changed_by, changed_by_name')
        .not('changed_by', 'is', null)
        .order('changed_at', ascending: false)
        .limit(1000);

    final seen = <String>{};
    final actors = <AuditLogActor>[];
    for (final row in response as List) {
      final id = row['changed_by'] as String?;
      if (id == null || !seen.add(id)) continue;
      actors.add(
        AuditLogActor(
          userId: id,
          name: (row['changed_by_name'] as String?) ?? 'Unknown',
        ),
      );
    }
    actors.sort((a, b) => a.name.compareTo(b.name));
    return actors;
  }
}
