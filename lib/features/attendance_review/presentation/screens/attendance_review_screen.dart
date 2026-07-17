import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../employee/domain/entities/operator_entity.dart';
import '../../utils/attendance_export_service.dart';
import '../providers/attendance_review_providers.dart';
import '../providers/attendance_edit_state_provider.dart';
import '../widgets/attendance_table.dart';
import '../widgets/date_range_filter_bar.dart';
import '../widgets/employee_sidebar.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';

class AttendanceReviewScreen extends ConsumerWidget {
  const AttendanceReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Real ordered IDs — derived from the same provider the sidebar uses,
    // sorted by name (consistent with sidebar ordering).
    final operators = ref.watch(attendanceOperatorsProvider).value ?? [];
    final orderedIds = operators.map((o) => o.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Review & Adjustment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export Attendance',
            onPressed: () => _handleExport(context, ref, operators),
          ),
        ],
      ),
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
    if (orderedIds.isEmpty) return;
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
    if (orderedIds.isEmpty) return;
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

  Future<void> _handleExport(
    BuildContext context,
    WidgetRef ref,
    List<OperatorEntity> allOperators,
  ) async {
    final format = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Format'),
        content: const Text('Choose the format for your export.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('pdf'),
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('excel'),
            child: const Text('Excel'),
          ),
        ],
      ),
    );

    if (format == null) return;

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      final filter = ref.read(attendanceReviewFilterProvider);

      final operatorsToExport = filter.operatorId != null
          ? allOperators.where((o) => o.id == filter.operatorId).toList()
          : allOperators;

      if (operatorsToExport.isEmpty) {
        if (context.mounted) Navigator.of(context).pop();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No operators to export.')),
          );
        }
        return;
      }

      final Map<int, List<dynamic>> operatorRowsMap = {};
      final Map<int, List<CalculatedPay>> operatorCalculatedPaysMap = {};

      for (final op in operatorsToExport) {
        final rows = await ref.read(
          attendanceDayRowsProvider(
            operatorId: op.id,
            from: filter.from,
            to: filter.to,
          ).future,
        );

        operatorRowsMap[op.id] = rows;
        final pays = rows.map((r) => ref.read(liveAttendanceCalculationProvider(op.id, r))).toList();
        operatorCalculatedPaysMap[op.id] = pays;
      }

      final fileName = filter.operatorId != null
          ? 'Attendance_${operatorsToExport.first.name}_${DateFormat('yyyyMMdd').format(DateTime.now())}'
          : 'Attendance_All_${DateFormat('yyyyMMdd').format(DateTime.now())}';

      if (format == 'excel') {
        final bytes = AttendanceExportService.exportToExcel(
          operators: operatorsToExport,
          operatorRowsMap: operatorRowsMap.cast(),
          operatorCalculatedPaysMap: operatorCalculatedPaysMap,
        );
        if (bytes != null) {
          await FileSaver.instance.saveFile(
            name: '$fileName.xlsx',
            bytes: Uint8List.fromList(bytes),
            mimeType: MimeType.microsoftExcel,
          );
        }
      } else if (format == 'pdf') {
        final bytes = await AttendanceExportService.exportToPdf(
          operators: operatorsToExport,
          operatorRowsMap: operatorRowsMap.cast(),
          operatorCalculatedPaysMap: operatorCalculatedPaysMap,
          fromDate: filter.from,
          toDate: filter.to,
        );
        await FileSaver.instance.saveFile(
          name: '$fileName.pdf',
          bytes: bytes,
          mimeType: MimeType.pdf,
        );
      }

      if (context.mounted) Navigator.of(context).pop(); // pop loading dialog
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export saved successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop(); // pop loading dialog
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to export: $e')));
      }
    }
  }
}
