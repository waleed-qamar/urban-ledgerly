import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/attendance_day_row.dart';
import '../../providers/attendance_edit_state_provider.dart';

class EditableDurationCell extends ConsumerWidget {
  final int operatorId;
  final AttendanceDayRow row;

  const EditableDurationCell({
    super.key,
    required this.operatorId,
    required this.row,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(attendanceEditDraftsProvider(operatorId))[row.date];
    final isDirty = draft?.adjustedOtMinutes != null;
    final effectiveOt = draft?.adjustedOtMinutes ?? row.otMinutes;

    final hours = effectiveOt ~/ 60;
    final mins = effectiveOt % 60;
    final durationStr = '${hours}h ${mins}m';

    return InkWell(
      onTap: () async {
        // A simple dialog to input minutes for duration
        // In a real app, this might be a custom duration picker.
        int? newMinutes = await showDialog<int>(
          context: context,
          builder: (context) {
            final controller = TextEditingController(
              text: effectiveOt.toString(),
            );
            return AlertDialog(
              title: const Text('Edit Overtime Minutes'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(suffixText: 'mins'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(int.tryParse(controller.text)),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );

        if (newMinutes != null) {
          ref
              .read(attendanceEditDraftsProvider(operatorId).notifier)
              .setOtMinutes(row.date, newMinutes);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: isDirty ? Theme.of(context).colorScheme.tertiaryContainer : null,
        child: Text(
          durationStr,
          style: TextStyle(
            fontWeight: isDirty ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
