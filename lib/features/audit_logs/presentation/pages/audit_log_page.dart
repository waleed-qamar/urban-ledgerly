import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ledgerly/core/theme/app_colors.dart';

import '../providers/audit_log_providers.dart';
import '../widgets/audit_log_filter_sheet.dart';
import '../widgets/audit_log_tile.dart';

class AuditLogPage extends ConsumerStatefulWidget {
  const AuditLogPage({super.key});

  @override
  ConsumerState<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends ConsumerState<AuditLogPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(auditLogListControllerProvider.notifier).loadMore();
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const AuditLogFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(auditLogListControllerProvider);
    final activeFilterCount = ref.watch(
      auditLogFilterControllerProvider.select((f) => f.activeCount),
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Audit Logs'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: activeFilterCount > 0,
              backgroundColor: AppColors.dotActive,
              label: Text('$activeFilterCount'),
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: logsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.errorText,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  'Couldn\'t load audit logs.\n$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textGrey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () =>
                      ref.invalidate(auditLogListControllerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (page) {
          if (page.logs.isEmpty) {
            return const Center(
              child: Text(
                'No activity matches these filters yet.',
                style: TextStyle(color: AppColors.textGrey),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () =>
                ref.read(auditLogListControllerProvider.notifier).refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: page.logs.length + (page.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= page.logs.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }
                return AuditLogTile(log: page.logs[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
