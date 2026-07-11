import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/attendance_day_row.dart';
import '../../providers/attendance_edit_state_provider.dart';

class EditableTimeCell extends ConsumerWidget {
  final int operatorId;
  final AttendanceDayRow row;

  const EditableTimeCell({
    super.key,
    required this.operatorId,
    required this.row,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(attendanceEditDraftsProvider(operatorId))[row.date];
    final isDirty = draft?.adjustedOutAt != null;
    final displayTime = draft?.adjustedOutAt ?? row.outAt;

    final timeStr = displayTime != null
        ? TimeOfDay.fromDateTime(displayTime).format(context)
        : '--:--';

    return InkWell(
      onTap: () async {
        final initialTime = displayTime != null
            ? TimeOfDay.fromDateTime(displayTime)
            : const TimeOfDay(hour: 17, minute: 0);

        final selectedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (selectedTime != null) {
          ref
              .read(attendanceEditDraftsProvider(operatorId).notifier)
              .setOutTime(row.date, selectedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: isDirty ? Theme.of(context).colorScheme.tertiaryContainer : null,
        child: Text(
          timeStr,
          style: TextStyle(
            fontWeight: isDirty ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
