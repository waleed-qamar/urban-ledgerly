import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_review_providers.dart';
import '../providers/attendance_edit_state_provider.dart';
import 'editable_cells/editable_time_cell.dart';
import 'editable_cells/editable_duration_cell.dart';
import 'editable_cells/editable_role_dropdown_cell.dart';
import 'editable_cells/reason_cell.dart';

class AttendanceTable extends ConsumerWidget {
  const AttendanceTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(attendanceReviewFilterProvider);
    if (filter.operatorId == null) {
      return const Center(child: Text('Select an employee to view attendance.'));
    }

    final rowsAsync = ref.watch(attendanceDayRowsProvider(
      operatorId: filter.operatorId!,
      from: filter.from,
      to: filter.to,
    ));

    return Column(
      children: [
        _buildToolbar(context, ref, filter.operatorId!),
        Expanded(
          child: rowsAsync.when(
            data: (rows) {
              if (rows.isEmpty) {
                return const Center(child: Text('No attendance records for this period.'));
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('In')),
                      DataColumn(label: Text('Out')),
                      DataColumn(label: Text('Shift Role')),
                      DataColumn(label: Text('OT Hrs')),
                      DataColumn(label: Text('OT Role')),
                      DataColumn(label: Text('Reason')),
                      DataColumn(label: Text('Take Home')),
                    ],
                    rows: rows.map((row) {
                      final draft = ref.watch(attendanceEditDraftsProvider(filter.operatorId!))[row.date];
                      final isRowDirty = draft != null;
                      
                      return DataRow(
                        color: isRowDirty 
                            ? MaterialStateProperty.all(Theme.of(context).colorScheme.surfaceVariant)
                            : null,
                        cells: [
                          DataCell(Text(DateFormat('E, MMM d').format(row.date))),
                          DataCell(Text(row.inAt != null ? TimeOfDay.fromDateTime(row.inAt!).format(context) : '--:--')),
                          DataCell(EditableTimeCell(operatorId: filter.operatorId!, row: row)),
                          // We mock workGroupId = 1 here for the dropdown. In reality, get from operator info
                          DataCell(EditableRoleDropdownCell(operatorId: filter.operatorId!, row: row, isOvertime: false, workGroupId: 1)),
                          DataCell(EditableDurationCell(operatorId: filter.operatorId!, row: row)),
                          DataCell(EditableRoleDropdownCell(operatorId: filter.operatorId!, row: row, isOvertime: true, workGroupId: 1)),
                          DataCell(ReasonCell(operatorId: filter.operatorId!, row: row)),
                          DataCell(Text('\$${row.takeHomeAmount.toStringAsFixed(2)}')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref, int operatorId) {
    final drafts = ref.watch(attendanceEditDraftsProvider(operatorId));
    final saveState = ref.watch(saveAttendanceAdjustmentsProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (drafts.isNotEmpty) ...[
            Text('${drafts.length} unsaved changes', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                ref.read(attendanceEditDraftsProvider(operatorId).notifier).clearAll();
              },
              child: const Text('Discard All'),
            ),
            const SizedBox(width: 8),
          ],
          ElevatedButton.icon(
            onPressed: drafts.isEmpty || saveState is AsyncLoading ? null : () async {
              await ref.read(saveAttendanceAdjustmentsProvider.notifier).save(operatorId);
              final updatedState = ref.read(saveAttendanceAdjustmentsProvider);
              if (updatedState is AsyncError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Save failed: ${updatedState.error}')),
                );
              } else if (updatedState is AsyncData) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved successfully')),
                );
              }
            },
            icon: saveState is AsyncLoading 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
