import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
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
    ]);

    // Data Rows
    for (var exp in expenses) {
      final headName =
          heads
              .where((head) => head.id == exp.expenseHeadId)
              .firstOrNull
              ?.name ??
          'Unknown Category';

      sheetObject.appendRow([
        TextCellValue(exp.id.toString()),
        TextCellValue(DateFormat('yyyy-MM-dd').format(exp.date)),
        TextCellValue(DateFormat('hh:mm a').format(exp.date)),
        TextCellValue(headName),
        TextCellValue(exp.amount.toString()),
        TextCellValue(exp.remarks),
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

  // The trick to force a dialog DatePicker instead of full screen
  // Future<DateTimeRange?> _showDialogDatePicker(
  //   BuildContext context,
  //   DateTimeRange? initialRange,
  // ) {
  //   return showDialog<DateTimeRange>(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         child: SizedBox(
  //           width: 700,
  //           child: DateRangePickerDialog(
  //             firstDate: DateTime(2020),
  //             lastDate: DateTime.now(),
  //             initialDateRange: initialRange,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(filteredLedgerProvider);
    final dateRange = ref.watch(ledgerDateRangeProvider);
    final selectedHeadId = ref.watch(selectedLedgerHeadProvider);

    final headsAsync = ref.watch(expenseHeadsProvider);
    final headsList = headsAsync.value ?? [];

    final indicatorText = _getIndicatorText(
      dateRange,
      selectedHeadId,
      headsList,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Daybook View'),
        // actions: [
        //   PopupMenuButton<String>(
        //     icon: const Icon(Icons.filter_alt),
        //     tooltip: 'Filter Options',
        //     onSelected: (value) async {
        //       if (value == 'all') {
        //         ref.read(selectedLedgerHeadProvider.notifier).setHead(null);
        //         ref.read(ledgerDateRangeProvider.notifier).setRange(null);
        //       } else if (value == 'range') {
        //         final picked = await _showDialogDatePicker(context, dateRange);
        //         if (picked != null) {
        //           ref
        //               .read(selectedLedgerHeadProvider.notifier)
        //               .setHead(null); // Clear head
        //           ref.read(ledgerDateRangeProvider.notifier).setRange(picked);
        //         }
        //       } else if (value == 'head') {
        //         _showHeadFilterDialog(
        //           context,
        //           ref,
        //           headsList,
        //           selectedHeadId,
        //           dateRange,
        //         );
        //       }
        //     },
        //     itemBuilder: (context) => [
        //       const PopupMenuItem(
        //         value: 'all',
        //         child: Text('Fetch All (Clear Filters)'),
        //       ),
        //       const PopupMenuItem(
        //         value: 'range',
        //         child: Text('Filter by Date Range'),
        //       ),
        //       const PopupMenuItem(
        //         value: 'head',
        //         child: Text('Filter by Category Head'),
        //       ),
        //     ],
        //   ),
        //   if (dateRange != null || selectedHeadId != null)
        //     IconButton(
        //       icon: const Icon(Icons.clear_all, color: AppColors.negativeAccent),
        //       tooltip: 'Clear Filters',
        //       onPressed: () {
        //         ref.read(ledgerDateRangeProvider.notifier).setRange(null);
        //         ref.read(selectedLedgerHeadProvider.notifier).setHead(null);
        //       },
        //     ),
        // ],
      ),
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
                                DateFormat.yMMMd().format(
                                  exp.date,
                                ), // Added time here for extra detail in full ledger!
                                headType,
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

  // Dialog specifically for filtering by Head (and optionally range)
  // void _showHeadFilterDialog(
  //   BuildContext context,
  //   WidgetRef ref,
  //   List<ExpenseHead> heads,
  //   int? currentHeadId,
  //   DateTimeRange? currentRange,
  // ) {
  //   int? tempHeadId = currentHeadId;
  //   DateTimeRange? tempRange = currentRange;

  //   showDialog(
  //     context: context,
  //     builder: (ctx) => StatefulBuilder(
  //       builder: (context, setState) {
  //         return AlertDialog(
  //           title: const Text('Filter by Head'),
  //           content: SizedBox(
  //             width: 400,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 DropdownButtonFormField<int?>(
  //                   initialValue: tempHeadId,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Expense Category',
  //                     border: OutlineInputBorder(),
  //                   ),
  //                   items: [
  //                     const DropdownMenuItem(
  //                       value: null,
  //                       child: Text('All Categories'),
  //                     ),
  //                     ...heads.map(
  //                       (h) =>
  //                           DropdownMenuItem(value: h.id, child: Text(h.name)),
  //                     ),
  //                   ],
  //                   onChanged: (val) => setState(() => tempHeadId = val),
  //                 ),
  //                 const SizedBox(height: 24),

  //                 const Text(
  //                   'Optional Date Range',
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: OutlinedButton.icon(
  //                         onPressed: () async {
  //                           final picked = await _showDialogDatePicker(
  //                             context,
  //                             tempRange,
  //                           );
  //                           if (picked != null) {
  //                             setState(() => tempRange = picked);
  //                           }
  //                         },
  //                         icon: const Icon(Icons.calendar_month),
  //                         label: Text(
  //                           tempRange == null
  //                               ? 'Select Dates'
  //                               : '${DateFormat.MMMd().format(tempRange!.start)} - ${DateFormat.MMMd().format(tempRange!.end)}',
  //                         ),
  //                       ),
  //                     ),
  //                     if (tempRange != null) ...[
  //                       const SizedBox(width: 8),
  //                       IconButton(
  //                         icon: const Icon(Icons.clear, color: Colors.red),
  //                         onPressed: () => setState(() => tempRange = null),
  //                       ),
  //                     ],
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(ctx),
  //               child: const Text('Cancel'),
  //             ),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColors.primary,
  //                 foregroundColor: Colors.white,
  //               ),
  //               onPressed: () {
  //                 ref
  //                     .read(selectedLedgerHeadProvider.notifier)
  //                     .setHead(tempHeadId);
  //                 ref
  //                     .read(ledgerDateRangeProvider.notifier)
  //                     .setRange(tempRange);
  //                 Navigator.pop(ctx);
  //               },
  //               child: const Text('Apply'),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }
}
