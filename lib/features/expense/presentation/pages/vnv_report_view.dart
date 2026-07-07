import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';

import '../providers/expense_providers.dart';
import '../../../receipts/presentation/providers/receipt_providers.dart';

class VnvReportView extends ConsumerWidget {
  final String filter; // 'vendor' | 'nonvendor' | 'both'
  final DateTimeRange? range;

  const VnvReportView({super.key, required this.filter, this.range});

  Future<void> _exportToExcel(List<List<String>> rows, String fileName) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    // Header
    sheet.appendRow([
      TextCellValue('Sr. No'),
      TextCellValue('Type'),
      TextCellValue('Head'),
      TextCellValue('Amount'),
      TextCellValue('Date'),
    ]);

    for (var r in rows) {
      sheet.appendRow(r.map((c) => TextCellValue(c)).toList());
    }

    List<int>? bytes = excel.save();
    if (bytes != null) {
      final u = Uint8List.fromList(bytes);
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: u,
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headsAsync = ref.watch(expenseHeadsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('V / NV Report')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: () async {
          final List<Map<String, dynamic>> rows = [];

          // Vendors
          if (filter == 'vendor' || filter == 'both') {
            final disbs = await ref.read(getAllDisbursementsProvider.future);
            final filtered = (range != null)
                ? disbs
                      .where(
                        (d) =>
                            !d.paidDate.isBefore(range!.start) &&
                            !d.paidDate.isAfter(range!.end),
                      )
                      .toList()
                : disbs;

            for (var d in filtered) {
              rows.add({
                'type': 'V',
                'head': d.category ?? 'Supplier ${d.supplierId}',
                'amount': d.totalAmount,
                'date': d.paidDate,
              });
            }
          }

          // Non-vendors (expenses)
          if (filter == 'nonvendor' || filter == 'both') {
            final expenses = await ref
                .read(expenseRepositoryProvider)
                .getFilteredExpenses(
                  headId: null,
                  from: range?.start,
                  to: range?.end,
                );

            final heads = headsAsync.value ?? [];

            for (var e in expenses) {
              final headName =
                  heads
                      .where((h) => h.id == e.expenseHeadId)
                      .firstOrNull
                      ?.name ??
                  'Unknown Category';
              rows.add({
                'type': 'NV',
                'head': headName,
                'amount': e.amount,
                'date': e.date,
              });
            }
          }

          // Sort by date ascending
          rows.sort(
            (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
          );

          return rows;
        }(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final rows = snap.data ?? [];
          if (rows.isEmpty) {
            return const Center(
              child: Text('No records found for the selected filters.'),
            );
          }

          // Build rows for display and for export
          final displayRows = <TableRow>[];
          final exportRows = <List<String>>[];

          for (var i = 0; i < rows.length; i++) {
            final r = rows[i];
            final idx = i + 1;
            final type = r['type'] as String;
            final head = r['head'] as String;
            final amount = (r['amount'] as num).toStringAsFixed(2);
            final date = DateFormat('M/dd/yyyy').format(r['date'] as DateTime);

            exportRows.add([idx.toString(), type, head, amount, date]);

            displayRows.add(
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(idx.toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(type),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(head),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(amount),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(date),
                  ),
                ],
              ),
            );
          }

          final total = rows.fold<double>(
            0.0,
            (s, e) => s + (e['amount'] as num).toDouble(),
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Records: ${rows.length}'),
                    Text(
                      'Total: ${NumberFormat.currency(symbol: 'PKR ').format(total)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await _exportToExcel(
                            exportRows,
                            'vnv_report_${DateTime.now().millisecondsSinceEpoch}',
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Export complete')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Export failed: $e')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Export XLSX'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: SingleChildScrollView(
                            child: Table(
                              defaultColumnWidth: const FlexColumnWidth(),
                              border: TableBorder.all(
                                color: Colors.grey.shade300,
                              ),
                              children: [
                                const TableRow(
                                  decoration: BoxDecoration(color: Colors.grey),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Sr. No',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Type',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Head',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ...displayRows,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
