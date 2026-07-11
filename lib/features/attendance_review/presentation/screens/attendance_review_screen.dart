import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_review_providers.dart';
import '../providers/attendance_edit_state_provider.dart';
import '../widgets/attendance_table.dart';
import '../widgets/date_range_filter_bar.dart';
import '../widgets/employee_sidebar.dart';

class AttendanceReviewScreen extends ConsumerWidget {
  const AttendanceReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, orderedIds would be fetched from the actual list of operators.
    // For now we mock the same IDs as the sidebar.
    final orderedIds = [1, 2, 3];

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Review & Adjustment')),
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
              _navigatePrevious(context, ref, orderedIds),
          const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
              _navigateNext(context, ref, orderedIds),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              const DateRangeFilterBar(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    EmployeeSidebar(),
                    Expanded(child: AttendanceTable()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigatePrevious(
    BuildContext context,
    WidgetRef ref,
    List<int> orderedIds,
  ) async {
    final filter = ref.read(attendanceReviewFilterProvider);
    if (filter.operatorId != null) {
      final drafts = ref.read(attendanceEditDraftsProvider(filter.operatorId!));
      if (drafts.isNotEmpty) {
        final discard = await _showDiscardDialog(context);
        if (discard != true) return;
        ref
            .read(attendanceEditDraftsProvider(filter.operatorId!).notifier)
            .clearAll();
      }
    }
    ref
        .read(attendanceReviewFilterProvider.notifier)
        .selectPreviousOperator(orderedIds);
  }

  void _navigateNext(
    BuildContext context,
    WidgetRef ref,
    List<int> orderedIds,
  ) async {
    final filter = ref.read(attendanceReviewFilterProvider);
    if (filter.operatorId != null) {
      final drafts = ref.read(attendanceEditDraftsProvider(filter.operatorId!));
      if (drafts.isNotEmpty) {
        final discard = await _showDiscardDialog(context);
        if (discard != true) return;
        ref
            .read(attendanceEditDraftsProvider(filter.operatorId!).notifier)
            .clearAll();
      }
    }
    ref
        .read(attendanceReviewFilterProvider.notifier)
        .selectNextOperator(orderedIds);
  }

  Future<bool?> _showDiscardDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Discard them to navigate?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
