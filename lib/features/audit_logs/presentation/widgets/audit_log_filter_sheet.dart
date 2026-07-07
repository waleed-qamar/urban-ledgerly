import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:ledgerly/core/theme/app_colors.dart';

import '../../domain/entities/audit_log_filter.dart';
import '../providers/audit_log_providers.dart';

const _actionOptions = [
  ('INSERT', 'Created'),
  ('UPDATE', 'Updated'),
  ('DELETE', 'Deleted'),
];

/// Call via:
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => const AuditLogFilterSheet(),
/// );
class AuditLogFilterSheet extends ConsumerStatefulWidget {
  const AuditLogFilterSheet({super.key});

  @override
  ConsumerState<AuditLogFilterSheet> createState() =>
      _AuditLogFilterSheetState();
}

class _AuditLogFilterSheetState extends ConsumerState<AuditLogFilterSheet> {
  late AuditLogFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(auditLogFilterControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final optionsAsync = ref.watch(auditLogFilterOptionsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Audit Logs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () =>
                    setState(() => _draft = const AuditLogFilter()),
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          optionsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            error: (e, _) => Text('Could not load filter options: $e'),
            data: (options) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Table'),
                _dropdown<String?>(
                  value: _draft.tableName,
                  hint: 'All tables',
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All tables'),
                    ),
                    ...options.tables.map(
                      (t) => DropdownMenuItem(value: t, child: Text(t)),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _draft = _draft.copyWith(tableName: v)),
                ),
                const SizedBox(height: 16),
                _label('Action'),
                _dropdown<String?>(
                  value: _draft.action,
                  hint: 'All actions',
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All actions'),
                    ),
                    ..._actionOptions.map(
                      (a) => DropdownMenuItem(value: a.$1, child: Text(a.$2)),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _draft = _draft.copyWith(action: v)),
                ),
                const SizedBox(height: 16),
                _label('Changed by'),
                _dropdown<String?>(
                  value: _draft.changedBy,
                  hint: 'Anyone',
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Anyone')),
                    ...options.actors.map(
                      (a) => DropdownMenuItem(
                        value: a.userId,
                        child: Text(a.name),
                      ),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _draft = _draft.copyWith(changedBy: v)),
                ),
                const SizedBox(height: 16),
                _label('Date range'),
                _dateRangeButton(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                ref.read(auditLogFilterControllerProvider.notifier)
                  ..setTable(_draft.tableName)
                  ..setAction(_draft.action)
                  ..setActor(_draft.changedBy)
                  ..setDateRange(_draft.fromDate, _draft.toDate);
                Navigator.of(context).pop();
              },
              child: const Text('Apply filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textGrey,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _dropdown<T>({
    required T value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required void Function(T) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          items: items,
          onChanged: (v) => onChanged(v as T),
        ),
      ),
    );
  }

  Widget _dateRangeButton() {
    final format = DateFormat('MMM d, yyyy');
    final label = (_draft.fromDate == null && _draft.toDate == null)
        ? 'Any time'
        : '${_draft.fromDate != null ? format.format(_draft.fromDate!) : '…'} '
              '– ${_draft.toDate != null ? format.format(_draft.toDate!) : '…'}';

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textBlack87,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: AppColors.dividerColor),
      ),
      icon: const Icon(Icons.calendar_today_outlined, size: 16),
      label: Text(label),
      onPressed: () async {
        final now = DateTime.now();
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year - 3),
          lastDate: now,
          initialDateRange: _draft.fromDate != null && _draft.toDate != null
              ? DateTimeRange(start: _draft.fromDate!, end: _draft.toDate!)
              : null,
        );
        if (picked != null) {
          setState(
            () => _draft = _draft.copyWith(
              fromDate: picked.start,
              // include the full end day
              toDate: DateTime(
                picked.end.year,
                picked.end.month,
                picked.end.day,
                23,
                59,
                59,
              ),
            ),
          );
        }
      },
    );
  }
}
