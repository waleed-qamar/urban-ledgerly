import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/features/attendance_review/presentation/providers/attendance_edit_state_provider.dart';

import '../../../domain/entities/attendance_day_row.dart';

class ReasonCell extends ConsumerWidget {
  final int operatorId;
  final AttendanceDayRow row;

  const ReasonCell({super.key, required this.operatorId, required this.row});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(attendanceEditDraftsProvider(operatorId))[row.date];
    final isRowDirty = draft != null;
    final currentReason = draft?.reason ?? row.existingAdjustmentReason ?? '';

    final isMissingReason = isRowDirty && currentReason.trim().isEmpty;

    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isRowDirty
            ? Theme.of(context).colorScheme.tertiaryContainer
            : null,
        border: isMissingReason
            ? Border.all(color: Colors.red, width: 2)
            : null,
      ),
      child: TextFormField(
        initialValue: currentReason,
        decoration: InputDecoration(
          hintText: isMissingReason ? 'Reason required' : 'Reason...',
          border: InputBorder.none,
          isDense: true,
        ),
        onChanged: (val) {
          ref
              .read(attendanceEditDraftsProvider(operatorId).notifier)
              .setReason(row.date, val);
        },
      ),
    );
  }
}
