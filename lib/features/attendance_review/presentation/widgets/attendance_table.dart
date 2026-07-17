import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_review_providers.dart';
import '../providers/attendance_edit_state_provider.dart';
import '../../domain/entities/attendance_day_row.dart';
import 'editable_cells/editable_in_time_cell.dart';
import 'editable_cells/editable_time_cell.dart';
import 'editable_cells/editable_duration_cell.dart';
import 'editable_cells/editable_role_dropdown_cell.dart';
import 'editable_cells/reason_cell.dart';

class AttendanceTable extends ConsumerWidget {
  const AttendanceTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(attendanceReviewFilterProvider);

    if (filter.operatorId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Select an operator from the sidebar to view attendance.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Resolve the operator's work_group_id from the loaded list
    final operatorsAsync = ref.watch(attendanceOperatorsProvider);
    final workGroupId = operatorsAsync.whenOrNull(
      data: (ops) =>
          ops.where((o) => o.id == filter.operatorId).firstOrNull?.workGroupId,
    );

    final rowsAsync = ref.watch(
      attendanceDayRowsProvider(
        operatorId: filter.operatorId!,
        from: filter.from,
        to: filter.to,
      ),
    );

    return Column(
      children: [
        _buildToolbar(context, ref, filter.operatorId!, filter.from, filter.to),
        Expanded(
          child: rowsAsync.when(
            data: (rows) {
              if (rows.isEmpty) {
                return const Center(
                  child: Text('No attendance records for this period.'),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainerLow,
                    ),
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('In')),
                      DataColumn(label: Text('Out')),
                      DataColumn(label: Text('Shift Role')),
                      DataColumn(label: Text('Shift Hrs'), numeric: true),
                      DataColumn(label: Text('OT Role')),
                      DataColumn(label: Text('OT Hrs'), numeric: true),
                      DataColumn(label: Text('Reason')),
                      DataColumn(label: Text('Wage'), numeric: true),
                      DataColumn(label: Text('OT Pay'), numeric: true),
                      DataColumn(label: Text('Take Home'), numeric: true),
                    ],
                    rows: [
                      // Data rows
                      ...rows.map((row) {
                        final draft = ref.watch(
                          attendanceEditDraftsProvider(filter.operatorId!),
                        )[row.date];
                        final isRowDirty = draft != null;
                        final rowColor = _rowColor(context, row, isRowDirty);
                        final livePay = ref.watch(liveAttendanceCalculationProvider(filter.operatorId!, row));

                        return DataRow(
                          color: WidgetStateProperty.all(rowColor),
                          cells: [
                            DataCell(
                              Text(
                                DateFormat('E, MMM d').format(row.date),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(_StatusBadge(row.calculationStatus)),
                            DataCell(
                              EditableInTimeCell(
                                operatorId: filter.operatorId!,
                                row: row,
                              ),
                            ),
                            DataCell(
                              EditableTimeCell(
                                operatorId: filter.operatorId!,
                                row: row,
                              ),
                            ),
                            DataCell(
                              EditableRoleDropdownCell(
                                operatorId: filter.operatorId!,
                                row: row,
                                isOvertime: false,
                                workGroupId: workGroupId ?? 0,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${livePay.normalHrs.floor()}h ${((livePay.normalHrs - livePay.normalHrs.floor()) * 60).round()}m',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            DataCell(
                              EditableRoleDropdownCell(
                                operatorId: filter.operatorId!,
                                row: row,
                                isOvertime: true,
                                workGroupId: workGroupId ?? 0,
                              ),
                            ),
                            DataCell(
                              EditableDurationCell(
                                operatorId: filter.operatorId!,
                                row: row,
                              ),
                            ),
                            DataCell(
                              ReasonCell(
                                operatorId: filter.operatorId!,
                                row: row,
                              ),
                            ),
                            DataCell(
                              Text(
                                row.isAbsent
                                    ? '—'
                                    : 'Rs ${livePay.wagePay.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            DataCell(
                              Text(
                                livePay.otPay > 0
                                    ? 'Rs ${livePay.otPay.toStringAsFixed(0)}'
                                    : '—',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            DataCell(
                              Text(
                                'Rs ${livePay.takeHome.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      // Summary footer row
                      _buildSummaryRow(context, ref, filter.operatorId!, rows),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text('Error loading rows: $err')),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Toolbar
  // ---------------------------------------------------------------------------

  Widget _buildToolbar(
    BuildContext context,
    WidgetRef ref,
    int operatorId,
    DateTime from,
    DateTime to,
  ) {
    final drafts = ref.watch(attendanceEditDraftsProvider(operatorId));
    final saveState = ref.watch(saveAttendanceAdjustmentsProvider);
    final finalizeState = ref.watch(finalizeAttendancePeriodProvider);
    final isLoading =
        saveState is AsyncLoading || finalizeState is AsyncLoading;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (saveState is AsyncError)
            _ErrorBanner(message: 'Save failed: ${saveState.error}'),
          if (finalizeState is AsyncError)
            _ErrorBanner(message: 'Finalize failed: ${finalizeState.error}'),
          const Spacer(),
          if (drafts.isNotEmpty) ...[
            Text(
              '${drafts.length} unsaved change${drafts.length == 1 ? '' : 's'}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => ref
                        .read(attendanceEditDraftsProvider(operatorId).notifier)
                        .clearAll(),
              child: const Text('Discard All'),
            ),
            const SizedBox(width: 8),
          ],

          // Save & auto-recalculate
          ElevatedButton.icon(
            onPressed: drafts.isEmpty || isLoading
                ? null
                : () async {
                    await ref
                        .read(saveAttendanceAdjustmentsProvider.notifier)
                        .save(operatorId);
                    final updatedState = ref.read(
                      saveAttendanceAdjustmentsProvider,
                    );
                    if (context.mounted) {
                      if (updatedState is AsyncError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Save failed: ${updatedState.error}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (updatedState is AsyncData) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saved & recalculated ✓'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
            icon: isLoading && drafts.isNotEmpty
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save, size: 16),
            label: const Text('Save'),
          ),

          const SizedBox(width: 8),

          // Finalize week (lock)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.deepOrange,
              side: const BorderSide(color: Colors.deepOrange),
            ),
            onPressed: isLoading
                ? null
                : () async {
                    final confirm = await _showFinalizeDialog(
                      context,
                      from,
                      to,
                    );
                    if (confirm != true) return;
                    await ref
                        .read(finalizeAttendancePeriodProvider.notifier)
                        .finalize(from: from, to: to);
                    final updatedState = ref.read(
                      finalizeAttendancePeriodProvider,
                    );
                    if (context.mounted) {
                      if (updatedState is AsyncError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Finalize failed: ${updatedState.error}',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (updatedState is AsyncData) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Period finalized & locked ✓'),
                            backgroundColor: Colors.deepOrange,
                          ),
                        );
                      }
                    }
                  },
            icon: isLoading && drafts.isEmpty
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.lock_outline, size: 16),
            label: const Text('Finalize'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Summary footer row
  // ---------------------------------------------------------------------------

  DataRow _buildSummaryRow(BuildContext context, WidgetRef ref, int operatorId, List<AttendanceDayRow> rows) {
    double totalShiftHrs = 0;
    double totalOtHrs = 0;
    double totalWage = 0;
    double totalOtPay = 0;
    double totalTakeHome = 0;
    int absentDays = 0;

    for (final row in rows) {
      if (row.isAbsent) absentDays++;
      final livePay = ref.watch(liveAttendanceCalculationProvider(operatorId, row));
      totalShiftHrs += livePay.normalHrs;
      totalOtHrs += livePay.otHrs;
      totalWage += livePay.wagePay;
      totalOtPay += livePay.otPay;
      totalTakeHome += livePay.takeHome;
    }

    final labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
      fontSize: 13,
    );

    return DataRow(
      color: WidgetStateProperty.all(
        Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
      ),
      cells: [
        DataCell(Text('TOTAL', style: labelStyle)),
        DataCell(Text('Absent: $absentDays', style: labelStyle)),
        DataCell(const Text('')),
        DataCell(const Text('')),
        DataCell(const Text('')),
        DataCell(Text('${totalShiftHrs.toStringAsFixed(1)}h shift', style: labelStyle)),
        DataCell(const Text('')),
        DataCell(Text('${totalOtHrs.toStringAsFixed(1)}h OT', style: labelStyle)),
        DataCell(const Text('')),
        DataCell(Text('Rs ${totalWage.toStringAsFixed(0)}', style: labelStyle)),
        DataCell(Text('Rs ${totalOtPay.toStringAsFixed(0)}', style: labelStyle)),
        DataCell(Text('Rs ${totalTakeHome.toStringAsFixed(0)}', style: labelStyle.copyWith(fontSize: 14))),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Color _rowColor(BuildContext context, AttendanceDayRow row, bool isDirty) {
    if (isDirty) {
      return Theme.of(context).colorScheme.surfaceContainerHigh;
    }
    switch (row.calculationStatus) {
      case CalculationStatus.needsReview:
        return Colors.red.shade50;
      case CalculationStatus.estimated:
        return Colors.amber.shade50;
      case CalculationStatus.finalized:
        return Colors.grey.shade100;
      case CalculationStatus.managerApproved:
        return Colors.green.shade50;
      case CalculationStatus.draft:
        return Colors.transparent;
    }
  }

  Future<bool?> _showFinalizeDialog(
    BuildContext context,
    DateTime from,
    DateTime to,
  ) {
    final fmt = DateFormat('MMM d, yyyy');
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalize & Lock Period'),
        content: Text(
          'Lock ${fmt.format(from)} – ${fmt.format(to)}?\n\n'
          'This will prevent any future recalculation for these dates. '
          'Only do this after printing / paying the wages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Finalize'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status badge widget
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final CalculationStatus status;

  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      CalculationStatus.needsReview => ('Needs Review', Colors.red),
      CalculationStatus.estimated => ('Estimated', Colors.amber.shade700),
      CalculationStatus.managerApproved => ('Approved', Colors.green.shade700),
      CalculationStatus.finalized => ('Finalized', Colors.grey.shade600),
      CalculationStatus.draft => ('Draft', Colors.grey.shade500),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error banner (toolbar inline)
// ---------------------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
      ),
    );
  }
}
