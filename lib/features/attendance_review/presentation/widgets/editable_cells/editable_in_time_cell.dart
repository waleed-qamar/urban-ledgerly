import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/attendance_day_row.dart';
import '../../providers/attendance_edit_state_provider.dart';

/// Editable check-in cell.
///
/// Always shows the effective in-time (raw punch or manager override draft).
/// Becomes tappable when the day is [CalculationStatus.needsReview] and the
/// raw check-in is missing — letting a manager supply the missing punch time
/// without creating a fake biometric record.
class EditableInTimeCell extends ConsumerWidget {
  final int operatorId;
  final AttendanceDayRow row;

  const EditableInTimeCell({
    super.key,
    required this.operatorId,
    required this.row,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(attendanceEditDraftsProvider(operatorId))[row.date];
    final isDirty = draft?.adjustedInAt != null;
    final displayTime = draft?.adjustedInAt ?? row.inAt;

    final timeStr = displayTime != null
        ? TimeOfDay.fromDateTime(displayTime.toLocal()).format(context)
        : '--:--';

    final textWidget = Text(
      timeStr,
      style: TextStyle(
        fontWeight: isDirty ? FontWeight.bold : FontWeight.normal,
        color: (displayTime == null)
            ? Theme.of(context).colorScheme.error
            : null,
      ),
    );

    return InkWell(
      onTap: () async {
        final initialTime = displayTime != null
            ? TimeOfDay.fromDateTime(displayTime.toLocal())
            : const TimeOfDay(hour: 8, minute: 0);

        final selectedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (selectedTime != null) {
          ref
              .read(attendanceEditDraftsProvider(operatorId).notifier)
              .setInTime(row.date, selectedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: isDirty
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            textWidget,
            const SizedBox(width: 4),
            Icon(
              Icons.edit,
              size: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
