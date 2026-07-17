import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/attendance_day_row.dart';
import '../../providers/attendance_edit_state_provider.dart';
import '../../providers/attendance_review_providers.dart';

class EditableRoleDropdownCell extends ConsumerWidget {
  final int operatorId;
  final AttendanceDayRow row;
  final bool isOvertime;
  final int workGroupId;

  const EditableRoleDropdownCell({
    super.key,
    required this.operatorId,
    required this.row,
    required this.isOvertime,
    required this.workGroupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final draft = ref.watch(attendanceEditDraftsProvider(operatorId))[row.date];
    final selectedRoleId = isOvertime
        ? (draft?.otRoleId ?? row.otRoleId)
        : (draft?.shiftRoleId ?? row.shiftRoleId);

    final isDirty = isOvertime
        ? draft?.otRoleId != null
        : draft?.shiftRoleId != null;

    final rolesAsync = ref.watch(wageRolesForWorkGroupProvider(workGroupId));

    return rolesAsync.when(
      data: (roles) {
        return Container(
          color: isDirty
              ? Theme.of(context).colorScheme.tertiaryContainer
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: roles.any((r) => r.id == selectedRoleId)
                    ? selectedRoleId
                    : null,
                items: roles.map((role) {
                  return DropdownMenuItem<int>(
                    value: role.id,
                    child: Text(role.roleName),
                  );
                }).toList(),
                onChanged: (newRoleId) {
                  if (newRoleId != null) {
                    if (isOvertime) {
                      ref
                          .read(
                            attendanceEditDraftsProvider(operatorId).notifier,
                          )
                          .setOtRole(row.date, newRoleId);
                    } else {
                      ref
                          .read(
                            attendanceEditDraftsProvider(operatorId).notifier,
                          )
                          .setShiftRole(row.date, newRoleId);
                    }
                  }
                },
                underline: const SizedBox(),
                isDense: true,
              ),
              if (selectedRoleId != null)
                _WageRateWarningIndicator(
                  operatorId: operatorId,
                  wageRoleId: selectedRoleId,
                  date: row.date,
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, _) => const Icon(Icons.error, color: Colors.red, size: 16),
    );
  }
}

class _WageRateWarningIndicator extends ConsumerWidget {
  final int operatorId;
  final int wageRoleId;
  final DateTime date;

  const _WageRateWarningIndicator({
    required this.operatorId,
    required this.wageRoleId,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasRateAsync = ref.watch(
      hasWageRateForRoleProvider(
        operatorId: operatorId,
        wageRoleId: wageRoleId,
        asOfDate: date,
      ),
    );

    return hasRateAsync.when(
      data: (hasRate) {
        if (hasRate) return const SizedBox.shrink();
        return const Tooltip(
          message: 'No wage rate exists for this role.',
          child: Icon(Icons.warning, color: Colors.orange, size: 16),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
