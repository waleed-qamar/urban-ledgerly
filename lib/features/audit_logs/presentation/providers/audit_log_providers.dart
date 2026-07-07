import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasource/audit_log_remote_datasource.dart';
import '../../data/repositories/audit_log_repository_impl.dart';
import '../../domain/entities/audit_log_entity.dart';
import '../../domain/entities/audit_log_filter.dart';
import '../../domain/repositories/audit_log_repository.dart';

part 'audit_log_providers.g.dart';

const _pageSize = 20;

// ---------------------------------------------------------------------------
// DI wiring — if Ledgerly already exposes a `supabaseClientProvider`, drop
// this one and have auditLogRemoteDataSource read that instead.
// ---------------------------------------------------------------------------

@riverpod
AuditLogRemoteDataSource auditLogRemoteDataSource(Ref ref) {
  return AuditLogRemoteDataSourceImpl(Supabase.instance.client);
}

@riverpod
AuditLogRepository auditLogRepository(Ref ref) {
  return AuditLogRepositoryImpl(ref.watch(auditLogRemoteDataSourceProvider));
}

// ---------------------------------------------------------------------------
// Filter dropdown options (tables + actors), loaded once and cached.
// ---------------------------------------------------------------------------

@riverpod
Future<({List<String> tables, List<AuditLogActor> actors})>
auditLogFilterOptions(Ref ref) async {
  final repo = ref.watch(auditLogRepositoryProvider);

  final tablesResult = await repo.getDistinctTables();
  final actorsResult = await repo.getDistinctActors();

  return (
    tables: tablesResult.getOrElse((_) => const []),
    actors: actorsResult.getOrElse((_) => const []),
  );
}

// ---------------------------------------------------------------------------
// Active filter state — table / action / actor / date range.
// ---------------------------------------------------------------------------

@riverpod
class AuditLogFilterController extends _$AuditLogFilterController {
  @override
  AuditLogFilter build() => const AuditLogFilter();

  void setTable(String? table) => state = state.copyWith(tableName: table);

  void setAction(String? action) => state = state.copyWith(action: action);

  void setActor(String? userId) => state = state.copyWith(changedBy: userId);

  void setDateRange(DateTime? from, DateTime? to) =>
      state = state.copyWith(fromDate: from, toDate: to);

  void clear() => state = const AuditLogFilter();
}

// ---------------------------------------------------------------------------
// Paginated log list, scoped to the current filter.
// ---------------------------------------------------------------------------

class AuditLogPage {
  final List<AuditLogEntity> logs;
  final bool hasMore;
  final bool isLoadingMore;

  const AuditLogPage({
    required this.logs,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  AuditLogPage copyWith({
    List<AuditLogEntity>? logs,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return AuditLogPage(
      logs: logs ?? this.logs,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Rebuilds (and resets to page 0) automatically whenever the filter
/// controller changes, because it `watch`es it below.
@riverpod
class AuditLogListController extends _$AuditLogListController {
  int _page = 0;

  @override
  Future<AuditLogPage> build() async {
    _page = 0;
    final filter = ref.watch(auditLogFilterControllerProvider);
    final repo = ref.watch(auditLogRepositoryProvider);

    final result = await repo.getAuditLogs(
      filter: filter,
      page: _page,
      pageSize: _pageSize,
    );

    return result.match(
      (failure) => throw failure,
      (logs) => AuditLogPage(logs: logs, hasMore: logs.length == _pageSize),
    );
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final filter = ref.read(auditLogFilterControllerProvider);
    final repo = ref.read(auditLogRepositoryProvider);
    final nextPage = _page + 1;

    final result = await repo.getAuditLogs(
      filter: filter,
      page: nextPage,
      pageSize: _pageSize,
    );

    result.match((failure) => state = AsyncError(failure, StackTrace.current), (
      logs,
    ) {
      _page = nextPage;
      state = AsyncData(
        current.copyWith(
          logs: [...current.logs, ...logs],
          hasMore: logs.length == _pageSize,
          isLoadingMore: false,
        ),
      );
    });
  }

  Future<void> refresh() async {
    _page = 0;
    ref.invalidateSelf();
    await future;
  }
}
