import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:ledgerly/features/auth/presentation/provider/current_employee_provider.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:ledgerly/features/expense/presentation/widgets/build_ladger_item.dart';
import 'dart:typed_data';
import 'add_expense_dialog.dart';
import '../providers/expense_providers.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_head.dart';

class FullLedgerView extends ConsumerWidget {
  const FullLedgerView({super.key});
  DateTime _toPakistanTime(DateTime dateTime) {
    return dateTime.isUtc ? dateTime.add(const Duration(hours: 5)) : dateTime;
  }

  Future<void> _exportToExcel(
    List<Expense> expenses,
    String indicatorText,
    List<ExpenseHead> heads,
  ) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Header info
    sheetObject.appendRow([TextCellValue(indicatorText)]);
    sheetObject.appendRow([TextCellValue('')]);

    // Table Headers
    sheetObject.appendRow([
      TextCellValue('ID'),
      TextCellValue('Date'),
      TextCellValue('Time'),
      TextCellValue('Head'),
      TextCellValue('Amount'),
      TextCellValue('Remarks'),
      TextCellValue('Created At'),
      TextCellValue('Created At Time'),
    ]);

    // Data Rows
    for (var exp in expenses) {
      final headName =
          heads
              .where((head) => head.id == exp.expenseHeadId)
              .firstOrNull
              ?.name ??
          'Unknown Category';
      final expenseDate = _toPakistanTime(exp.date);
      final createdAt = exp.createdAt != null
          ? _toPakistanTime(exp.createdAt!)
          : null;

      sheetObject.appendRow([
        TextCellValue(exp.id.toString()),
        TextCellValue(DateFormat('yyyy-MM-dd').format(expenseDate)),
        TextCellValue(DateFormat('hh:mm a').format(expenseDate)),
        TextCellValue(headName),
        TextCellValue(exp.amount.toString()),
        TextCellValue(exp.remarks),
        TextCellValue(
          createdAt != null ? DateFormat('yyyy-MM-dd').format(createdAt) : '',
        ),
        TextCellValue(
          createdAt != null ? DateFormat('hh:mm a').format(createdAt) : '',
        ),
      ]);
    }

    // 1. Get the raw bytes of the Excel file
    List<int>? fileBytes = excel.save();

    if (fileBytes != null) {
      // 2. Convert to Uint8List which file_saver requires
      Uint8List bytes = Uint8List.fromList(fileBytes);

      // 3. Trigger the native save/download dialog!
      await FileSaver.instance.saveFile(
        name: 'ledger_export_${DateTime.now().millisecondsSinceEpoch}',
        bytes: bytes,
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    }
  }

  String _getIndicatorText(
    DateTimeRange? range,
    int? headId,
    List<ExpenseHead> heads,
  ) {
    String headName = "All Categories";
    if (headId != null) {
      try {
        headName = heads.firstWhere((h) => h.id == headId).name;
      } catch (_) {
        headName = "Unknown Category";
      }
    }

    String dateText = "All Time";
    if (range != null) {
      dateText =
          "${DateFormat.yMMMd().format(range.start)} to ${DateFormat.yMMMd().format(range.end)}";
    }

    if (headId == null && range == null) return "Showing Full Ledger";
    return "Showing: $headName • $dateText";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(filteredLedgerProvider);
    final dateRange = ref.watch(ledgerDateRangeProvider);
    final selectedHeadId = ref.watch(selectedLedgerHeadProvider);
    final isMaster = ref.watch(isMasterProvider);

    final headsAsync = ref.watch(expenseHeadsProvider);
    final headsList = headsAsync.value ?? [];

    final indicatorText = _getIndicatorText(
      dateRange,
      selectedHeadId,
      headsList,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Full Daybook View')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            color: AppColors.indicatorBackground,
            child: Text(
              indicatorText,
              style: TextStyle(
                color: AppColors.indicatorText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ledgerAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: $e\n\nPlease check console for Supabase logs.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return const Center(
                    child: Text('No expenses match these filters.'),
                  );
                }

                final totalAmount = expenses.fold(
                  0.0,
                  (sum, item) => sum + item.amount,
                );

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final exp = expenses[index];

                          // Find the matching Expense Head using the headsList we already defined
                          final head = headsList
                              .where((h) => h.id == exp.expenseHeadId)
                              .firstOrNull;
                          final expenseDate = _toPakistanTime(exp.date);
                          final createdAt = exp.createdAt != null
                              ? _toPakistanTime(exp.createdAt!)
                              : null;

                          final title = head?.name ?? 'Unknown Category';
                          final headType = head?.headType.value ?? 'Unknown';

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                              20.0,
                              8.0,
                              20.0,
                              8.0,
                            ),
                            child: GestureDetector(
                              onDoubleTap: () async {
                                await showDialog<void>(
                                  context: context,
                                  builder: (ctx) =>
                                      AddExpenseDialog(expense: exp),
                                );
                                ref.invalidate(filteredLedgerProvider);
                              },
                              child: buildLedgerItem(
                                Icons.receipt_long,
                                title,
                                exp.remarks,
                                NumberFormat.currency(
                                  symbol: 'PKR ',
                                ).format(exp.amount),
                                DateFormat.yMMMd().format(expenseDate),
                                headType,
                                createdAt != null
                                    ? DateFormat.yMMMd().format(createdAt)
                                    : '',
                                AppColors.iconBackground,
                                Colors.teal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.totalSummaryBackground,
                        border: Border(
                          top: BorderSide(color: AppColors.dividerColor),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Entries: ${expenses.length}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                  symbol: 'PKR ',
                                ).format(totalAmount),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          if (isMaster)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                try {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (dialogContext) => const AlertDialog(
                                      title: Text('Exporting...'),
                                      content: Text(
                                        'Your Excel file is being prepared. Please wait a moment.',
                                      ),
                                    ),
                                  );

                                  await Future<void>.delayed(
                                    const Duration(seconds: 1),
                                  );

                                  await _exportToExcel(
                                    expenses,
                                    indicatorText,
                                    headsList,
                                  );
                                  if (context.mounted &&
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).canPop()) {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                  }
                                } catch (e) {
                                  if (context.mounted &&
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).canPop()) {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                  }
                                  ScaffoldMessenger.of(
                                    context.mounted ? context : context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text('Error exporting: $e'),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Export XLSX'),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
