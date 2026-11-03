import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../invoices/presentation/widgets/invoice_view_dialog.dart';
import '../../../orders/domain/entities/supplier_entity.dart';
import '../../../orders/presentation/providers/supplier_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../receipts/presentation/providers/receipt_providers.dart';
import '../../../receipts/presentation/widgets/payment_view_dialog.dart';
import '../../domain/entities/ledger_entity.dart';
import '../../../account_ledger/presentation/provider/account_ledger_providers.dart';
import '../providers/ledger_providers.dart';
import '../widgets/add_ledger_entry_dialog.dart';
import 'package:ledgerly/features/procurement/presentation/widgets/procurement_details_dialog.dart';
import 'package:ledgerly/features/procurement/presentation/providers/procurement_providers.dart';
import 'package:ledgerly/features/raw_material/presentation/providers/raw_material_providers.dart';
import 'package:ledgerly/features/vender/presentation/providers/vendor_providers.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart' hide Border;
import 'package:file_saver/file_saver.dart';
import 'package:ledgerly/features/ledger/utils/ledger_pdf_generator.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../vender/domain/entities/vendor_entity.dart';
import '../../../orders/presentation/providers/order_providers.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/domain/entities/product_set_entity.dart';
import '../../../raw_material/domain/entities/raw_material_entity.dart';
import '../../../receipts/domain/entities/disbursement_record.dart';
import '../../../receipts/domain/entities/receipt_entity.dart';
import '../../../invoices/domain/entities/invoice_entity.dart';
import '../../../procurement/domain/entities/procurement_entity.dart';

class LedgerDetailsPage extends ConsumerWidget {
  final int partyId;
  final PartyType partyType;
  final String partyName;

  const LedgerDetailsPage({
    super.key,
    required this.partyId,
    required this.partyType,
    required this.partyName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(
      getEntriesByPartyProvider(partyType: partyType, partyId: partyId),
    );

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        title: Text(
          '$partyName - Ledger',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.textWhite,
        elevation: 0,
        foregroundColor: AppColors.textBlack,
        actions: [
          entriesAsync.maybeWhen(
            data: (entries) => PopupMenuButton<String>(
              tooltip: 'Export Ledger',
              offset: const Offset(0, 48),
              onSelected: (value) {
                if (value == 'excel') {
                  _exportToExcel(context, ref, entries);
                } else if (value == 'pdf_detailed') {
                  _exportToPdf(
                    context,
                    ref,
                    entries,
                    style: LedgerPdfStyle.detailed,
                  );
                } else if (value == 'pdf_standard') {
                  _exportToPdf(
                    context,
                    ref,
                    entries,
                    style: LedgerPdfStyle.standard,
                  );
                } else if (value == 'pdf_custom') {
                  _showDateRangePdfDialog(context, ref, entries);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'excel',
                  child: Row(
                    children: [
                      Icon(Icons.table_view_outlined, color: Colors.green, size: 20),
                      SizedBox(width: 10),
                      Text('Excel Export (.xlsx)'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'pdf_detailed',
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf_outlined, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text('PDF Export (Detailed)'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'pdf_standard',
                  child: Row(
                    children: [
                      Icon(Icons.article_outlined, color: Colors.deepOrange, size: 20),
                      SizedBox(width: 10),
                      Text('PDF Export (Standard)'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'pdf_custom',
                  child: Row(
                    children: [
                      Icon(Icons.date_range_outlined, color: Colors.blue, size: 20),
                      SizedBox(width: 10),
                      Text('PDF Export (Date Range)...'),
                    ],
                  ),
                ),
              ],
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_download_outlined, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Export Ledger',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            tooltip: 'Add entry',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddLedgerEntryDialog(
                  initialPartyType: partyType,
                  initialPartyId: partyId,
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1100 ? 40.0 : 16.0;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              24,
              horizontalPadding,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SummaryCard(
                      title: 'Total Debit',
                      value: _money(
                        entriesAsync.when(
                          data: (entries) => _LedgerSummary.fromEntries(
                            entries,
                            partyType: partyType,
                          ).totalDebit,
                          loading: () => 0,
                          error: (_, _) => 0,
                        ),
                      ),
                      valueColor: AppColors.errorText,
                    ),
                    _SummaryCard(
                      title: 'Total Credit',
                      value: _money(
                        entriesAsync.when(
                          data: (entries) => _LedgerSummary.fromEntries(
                            entries,
                            partyType: partyType,
                          ).totalCredit,
                          loading: () => 0,
                          error: (_, _) => 0,
                        ),
                      ),
                      valueColor: AppColors.successText,
                    ),
                    _SummaryCard(
                      title: 'Balance',
                      value: _money(
                        entriesAsync.when(
                          data: (entries) => _LedgerSummary.fromEntries(
                            entries,
                            partyType: partyType,
                          ).balance,
                          loading: () => 0,
                          error: (_, _) => 0,
                        ),
                      ),
                      valueColor: AppColors.successText,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  partyType == PartyType.client
                      ? 'This is how much the client owes you.'
                      : 'This is how much you owe this vendor.',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Transactions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: entriesAsync.when(
                    data: (entries) {
                      final displayEntries = entries.toList().reversed.toList();
                      final runningBalances = _buildRunningBalances(entries);

                      if (displayEntries.isEmpty) {
                        return const Center(
                          child: Text('No transactions found.'),
                        );
                      }

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth > 1080
                                  ? constraints.maxWidth -
                                        (horizontalPadding * 2)
                                  : 1080,
                            ),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.2),
                                1: FlexColumnWidth(1.2),
                                2: FlexColumnWidth(1.2),
                                3: FlexColumnWidth(1.5),
                                4: FlexColumnWidth(3.0),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  color: AppColors.dividerColor.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              children: [
                                const TableRow(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F1F1),
                                  ),
                                  children: [
                                    _LedgerHeaderCell('Date'),
                                    _LedgerHeaderCell('Credit'),
                                    _LedgerHeaderCell('Debit'),
                                    _LedgerHeaderCell('Balance'),
                                    _LedgerHeaderCell('Remarks'),
                                  ],
                                ),
                                ...displayEntries.map((entry) {
                                  final runningBalance =
                                      runningBalances[entry.id] ?? 0;

                                  return TableRow(
                                    children: [
                                      _LedgerValueCell(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(entry.entryDate),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      _LedgerValueCell(
                                        entry.entryType == EntryType.credit
                                            ? LedgerDetailsPage._money(
                                                entry.amount,
                                              )
                                            : '-',
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w600,
                                        textColor:
                                            entry.entryType == EntryType.credit
                                            ? AppColors.successText
                                            : AppColors.textGrey,
                                      ),
                                      _LedgerValueCell(
                                        entry.entryType == EntryType.debit
                                            ? LedgerDetailsPage._money(
                                                entry.amount,
                                              )
                                            : '-',
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w600,
                                        textColor:
                                            entry.entryType == EntryType.debit
                                            ? AppColors.errorText
                                            : AppColors.textGrey,
                                      ),
                                      _LedgerValueCell(
                                        LedgerDetailsPage._money(
                                          runningBalance,
                                        ),
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            LedgerDetailsPage._balanceColorForAmount(
                                              runningBalance,
                                            ),
                                      ),
                                      _RemarksCell(
                                        entry: entry,
                                        partyName: partyName,
                                        ref: ref,
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('Error: $err')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static double _signedEffect({
    required PartyType partyType,
    required EntryType entryType,
    required double amount,
  }) {
    if (partyType == PartyType.client) {
      // Client owes us more on debit, less on credit.
      return entryType == EntryType.debit ? amount : -amount;
    }

    // We owe vendor more on credit, less on debit.
    return entryType == EntryType.credit ? amount : -amount;
  }

  static double _entryBalanceEffect({
    required PartyType partyType,
    required LedgerEntity entry,
  }) {
    return _signedEffect(
      partyType: partyType,
      entryType: entry.entryType,
      amount: entry.amount,
    );
  }

  static Map<int, double> _buildRunningBalances(List<LedgerEntity> entries) {
    final balances = <int, double>{};
    double runningBalance = 0;

    for (final entry in entries) {
      runningBalance += _entryBalanceEffect(
        partyType: entry.partyType,
        entry: entry,
      );
      balances[entry.id] = runningBalance;
    }

    return balances;
  }

  static String _money(double amount) {
    return NumberFormat.decimalPattern('en_IN').format(amount);
  }

  Future<void> _exportToExcel(
    BuildContext context,
    WidgetRef ref,
    List<LedgerEntity> entries,
  ) async {
    if (entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No transactions to export')),
      );
      return;
    }

    try {
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.setColumnWidth(0, 16); // Date
      sheet.setColumnWidth(1, 20); // Voucher/Invoice #
      sheet.setColumnWidth(2, 45); // Description/Remarks
      sheet.setColumnWidth(3, 18); // Debit
      sheet.setColumnWidth(4, 18); // Credit
      sheet.setColumnWidth(5, 20); // Balance

      int row = 0;

      sheet.appendRow([TextCellValue('URBAN COMPOSITES / URBAN CONSTRUCTIONS')]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true, fontSize: 14);
      row++;

      sheet.appendRow([TextCellValue('LEDGER STATEMENT')]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true, fontSize: 12);
      row++;

      sheet.appendRow([TextCellValue('')]);
      row++;

      sheet.appendRow([TextCellValue('Party Name:'), TextCellValue(partyName)]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true);
      row++;

      sheet.appendRow([
        TextCellValue('Party Type:'),
        TextCellValue(partyType.name.toUpperCase()),
      ]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true);
      row++;

      sheet.appendRow([
        TextCellValue('Generated Date:'),
        TextCellValue(DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())),
      ]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true);
      row++;

      final summary = _LedgerSummary.fromEntries(entries, partyType: partyType);

      sheet.appendRow([
        TextCellValue('Total Debit:'),
        TextCellValue('PKR ${_money(summary.totalDebit)}'),
      ]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true);
      row++;

      sheet.appendRow([
        TextCellValue('Total Credit:'),
        TextCellValue('PKR ${_money(summary.totalCredit)}'),
      ]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true);
      row++;

      sheet.appendRow([
        TextCellValue('Net Balance:'),
        TextCellValue(
          'PKR ${_money(summary.balance.abs())} ${summary.balance >= 0 ? "Cr." : "Dr."}',
        ),
      ]);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
          CellStyle(bold: true);
      row++;

      sheet.appendRow([TextCellValue('')]);
      row++;

      sheet.appendRow([
        TextCellValue('Date'),
        TextCellValue('Voucher #'),
        TextCellValue('Remarks / Description'),
        TextCellValue('Debit (PKR)'),
        TextCellValue('Credit (PKR)'),
        TextCellValue('Balance (PKR)'),
      ]);

      for (int col = 0; col < 6; col++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
            CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.fromHexString('#E0E0E0'),
        );
      }
      row++;

      final sortedEntries = List<LedgerEntity>.from(entries)
        ..sort((a, b) {
          final cmp = a.entryDate.compareTo(b.entryDate);
          if (cmp != 0) return cmp;
          return a.id.compareTo(b.id);
        });

      double runningBalance = 0;
      for (final entry in sortedEntries) {
        final isDebit = entry.entryType == EntryType.debit;
        final debitAmt = isDebit ? entry.amount : 0.0;
        final creditAmt = !isDebit ? entry.amount : 0.0;

        if (partyType == PartyType.client) {
          runningBalance += (debitAmt - creditAmt);
        } else {
          runningBalance += (creditAmt - debitAmt);
        }

        final vch = entry.invoiceNumber?.isNotEmpty == true
            ? entry.invoiceNumber!
            : (entry.referenceId?.isNotEmpty == true ? entry.referenceId! : '-');

        sheet.appendRow([
          TextCellValue(DateFormat('dd/MM/yyyy').format(entry.entryDate)),
          TextCellValue(vch),
          TextCellValue(entry.remarks ?? ''),
          TextCellValue(debitAmt > 0 ? _money(debitAmt) : '-'),
          TextCellValue(creditAmt > 0 ? _money(creditAmt) : '-'),
          TextCellValue(
            '${_money(runningBalance.abs())} ${runningBalance >= 0 ? "Cr." : "Dr."}',
          ),
        ]);
        row++;
      }

      final bytes = excel.encode();
      if (bytes != null) {
        final sanitizedParty =
            partyName.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
        await FileSaver.instance.saveFile(
          name: '${sanitizedParty.toUpperCase()}_LEDGER',
          bytes: Uint8List.fromList(bytes),
          fileExtension: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Excel ledger exported successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export Excel: $e'),
            backgroundColor: AppColors.errorText,
          ),
        );
      }
    }
  }

  Future<void> _exportToPdf(
    BuildContext context,
    WidgetRef ref,
    List<LedgerEntity> entries, {
    LedgerPdfStyle style = LedgerPdfStyle.detailed,
    DateTime? customFromDate,
    DateTime? customToDate,
  }) async {
    if (entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No transactions to export')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Generating PDF statement...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final invoicesFuture = ref
          .read(getAllInvoicesProvider.future)
          .catchError((_) => <InvoiceEntity>[]);
      final receiptsFuture = ref
          .read(getAllReceiptsProvider.future)
          .catchError((_) => <ReceiptEntity>[]);
      final disbursementsFuture = ref
          .read(getAllDisbursementsProvider.future)
          .catchError((_) => <DisbursementRecord>[]);
      final procurementsFuture = ref
          .read(getAllProcurementsProvider.future)
          .catchError((_) => <ProcurementEntity>[]);
      final productsFuture = ref
          .read(getAllProductsProvider.future)
          .catchError((_) => <ProductEntity>[]);
      final setsFuture = ref
          .read(getAllProductSetsProvider.future)
          .catchError((_) => <ProductSetEntity>[]);
      final materialsFuture = ref
          .read(getAllRawMaterialsProvider.future)
          .catchError((_) => <RawMaterialEntity>[]);
      final ordersFuture = ref
          .read(getAllOrdersProvider.future)
          .catchError((_) => <OrderEntity>[]);

      final invoices = await invoicesFuture;
      final receipts = await receiptsFuture;
      final disbursements = await disbursementsFuture;
      final procurements = await procurementsFuture;
      final products = await productsFuture;
      final sets = await setsFuture;
      final materials = await materialsFuture;
      final orders = await ordersFuture;

      String? address;
      String? contact;
      if (partyType == PartyType.client) {
        final clients = await ref
            .read(getAllClientsProvider.future)
            .catchError((_) => <ClientEntity>[]);
        final c = clients.where((item) => item.id == partyId).firstOrNull;
        address = c?.clientAddress;
        contact = c?.contactNumber;
      } else {
        final vendors = await ref
            .read(getAllvendorsProvider.future)
            .catchError((_) => <VendorEntity>[]);
        final v = vendors.where((item) => item.id == partyId).firstOrNull;
        address = v?.vendorAddress;
        contact = v?.contactNumber;
      }

      final productsMap = {for (final p in products) p.id: p.name};
      final productSetsMap = {
        for (final s in sets)
          if (s.setId != null) s.setId!: s.name,
      };
      final rawMaterialsMap = {for (final m in materials) m.id: m.name};

      final earliestDate = entries
          .map((e) => e.entryDate)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      final fromDate = customFromDate ?? earliestDate;
      final toDate = customToDate ?? DateTime.now();

      await LedgerPdfGenerator.generateAndDownload(
        partyId: partyId,
        partyName: partyName,
        partyType: partyType,
        style: style,
        address: address,
        contact: contact,
        companyName: 'URBAN COMPOSITES',
        companyCity: 'GUJRANWALA',
        fromDate: fromDate,
        toDate: toDate,
        allEntries: entries,
        procurements: procurements,
        rawMaterialsMap: rawMaterialsMap,
        disbursements: disbursements,
        invoices: invoices,
        receipts: receipts,
        productsMap: productsMap,
        productSetsMap: productSetsMap,
        orders: orders,
      );

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF Ledger downloaded successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppColors.errorText,
          ),
        );
      }
    }
  }

  void _showDateRangePdfDialog(
    BuildContext context,
    WidgetRef ref,
    List<LedgerEntity> entries,
  ) {
    final earliestDate = entries.isNotEmpty
        ? entries.map((e) => e.entryDate).reduce((a, b) => a.isBefore(b) ? a : b)
        : DateTime(DateTime.now().year, 1, 1);

    DateTime fromDate = earliestDate;
    DateTime toDate = DateTime.now();
    LedgerPdfStyle selectedStyle = LedgerPdfStyle.detailed;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final dateFormat = DateFormat('dd MMM yyyy');
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
                const SizedBox(width: 10),
                Text('Export $partyName PDF'),
              ],
            ),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Date Range:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        initialDateRange:
                            DateTimeRange(start: fromDate, end: toDate),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          fromDate = picked.start;
                          toDate = picked.end;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${dateFormat.format(fromDate)}  —  ${dateFormat.format(toDate)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Statement Format:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setDialogState(
                            () => selectedStyle = LedgerPdfStyle.detailed,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedStyle == LedgerPdfStyle.detailed
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width:
                                    selectedStyle == LedgerPdfStyle.detailed
                                        ? 2
                                        : 1,
                              ),
                              color: selectedStyle == LedgerPdfStyle.detailed
                                  ? AppColors.primary.withValues(alpha: 0.05)
                                  : Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      selectedStyle == LedgerPdfStyle.detailed
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color:
                                          selectedStyle ==
                                                  LedgerPdfStyle.detailed
                                              ? AppColors.primary
                                              : Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Detailed',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Itemized with products & subtotals',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => setDialogState(
                            () => selectedStyle = LedgerPdfStyle.standard,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedStyle == LedgerPdfStyle.standard
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width:
                                    selectedStyle == LedgerPdfStyle.standard
                                        ? 2
                                        : 1,
                              ),
                              color: selectedStyle == LedgerPdfStyle.standard
                                  ? AppColors.primary.withValues(alpha: 0.05)
                                  : Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      selectedStyle == LedgerPdfStyle.standard
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color:
                                          selectedStyle ==
                                                  LedgerPdfStyle.standard
                                              ? AppColors.primary
                                              : Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Standard',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Clean 6-column statement grid',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                  _exportToPdf(
                    context,
                    ref,
                    entries,
                    style: selectedStyle,
                    customFromDate: fromDate,
                    customToDate: toDate,
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
              ),
            ],
          );
        },
      ),
    );
  }

  static Color _balanceColorForAmount(double amount) {
    return amount < 0 ? AppColors.errorText : AppColors.successText;
  }
}

class _LedgerSummary {
  final double totalDebit;
  final double totalCredit;
  final double balance;

  const _LedgerSummary({
    required this.totalDebit,
    required this.totalCredit,
    required this.balance,
  });

  factory _LedgerSummary.fromEntries(
    List<LedgerEntity> entries, {
    required PartyType partyType,
  }) {
    double totalDebit = 0;
    double totalCredit = 0;
    double balance = 0;

    for (final entry in entries) {
      if (entry.entryType == EntryType.debit) {
        totalDebit += entry.amount;
      } else {
        totalCredit += entry.amount;
      }

      balance += LedgerDetailsPage._entryBalanceEffect(
        partyType: partyType,
        entry: entry,
      );
    }

    return _LedgerSummary(
      totalDebit: totalDebit,
      totalCredit: totalCredit,
      balance: balance,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textBlack,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerHeaderCell extends StatelessWidget {
  final String label;

  const _LedgerHeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textBlack87,
        ),
      ),
    );
  }
}

class _LedgerValueCell extends StatelessWidget {
  final String value;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final Color? textColor;

  const _LedgerValueCell(
    this.value, {
    this.textAlign = TextAlign.left,
    this.fontWeight = FontWeight.w600,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Text(
        value,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: fontWeight,
          color: textColor ?? AppColors.textBlack,
        ),
      ),
    );
  }
}

class _RemarksCell extends StatelessWidget {
  final LedgerEntity entry;
  final String partyName;
  final WidgetRef ref;

  const _RemarksCell({
    required this.entry,
    required this.partyName,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final hasDetails =
        entry.transactionSource == 'invoice' ||
        entry.transactionSource == 'receipt' ||
        entry.transactionSource == 'disbursement' ||
        entry.transactionSource == 'procurement' ||
        entry.transactionSource == 'procurement_brokerage';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          if (hasDetails)
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 20,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.only(right: 8),
              onPressed: () => _showDetails(context),
            ),
          Expanded(
            child: Tooltip(
              message: entry.remarks ?? '-',
              child: Text(
                entry.remarks ?? '-',
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDetails(BuildContext context) async {
    final source = entry.transactionSource;
    final referenceId = entry.referenceId ?? '';
    int? refId;

    if (referenceId.startsWith('invoice:')) {
      refId = int.tryParse(referenceId.substring('invoice:'.length));
    } else {
      refId = int.tryParse(referenceId);
    }

    if (refId == null) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      if (source == 'invoice') {
        final invoice = await ref.read(getInvoiceByIdProvider(refId).future);
        final products = await ref.read(getAllProductsProvider.future);
        final sets = await ref.read(getAllProductSetsProvider.future);
        final suppliers = await ref
            .read(getAllSuppliersProvider.future)
            .catchError((_) => <SupplierEntity>[]);
        final supplierMap = {
          for (final s in suppliers)
            if (s.id != null) s.id!: s.name,
        };
        final resolvedSupplier =
            (invoice.supplierName?.trim().isNotEmpty == true)
            ? invoice.supplierName!.trim()
            : (supplierMap[invoice.supplierId] ?? 'Unknown Supplier');
        final productNames = {for (var p in products) p.id: p.name};
        final setNames = {
          for (final set in sets)
            if (set.setId != null) set.setId!: set.name,
        };

        if (!context.mounted) return;
        Navigator.pop(context); // close loader
        showDialog(
          context: context,
          builder: (_) => InvoiceViewDialog(
            invoice: invoice,
            clientName: (entry.partyType == PartyType.client)
                ? partyName
                : (invoice.clientName ?? 'Unknown Client'),

            supplierName: resolvedSupplier,

            productNames: productNames,
            setNames: setNames,
          ),
        );
      } else if (source == 'receipt') {
        final receipts = await ref.read(getAllReceiptsProvider.future);
        final receipt = receipts.firstWhere((r) => r.id == refId);

        // Lookup account_id from account_transactions via provider
        final resolvedAccountId = await ref
            .read(accountLedgerRepositoryProvider)
            .getAccountIdByReference('receipt', refId);

        final accounts = await ref.read(getAllAccountsProvider.future);
        final account = accounts.isEmpty
            ? null
            : accounts.where((a) => a.id == resolvedAccountId).firstOrNull;

        if (!context.mounted) return;
        Navigator.pop(context); // close loader
        showDialog(
          context: context,
          builder: (_) => PaymentViewDialog(
            title: 'Receipt Details',
            name: partyName,
            bankTitle: (account?.bankName?.trim().isNotEmpty == true)
                ? account!.bankName!.trim()
                : (receipt.accountNo?.isNotEmpty == true
                      ? receipt.accountNo!
                      : receipt.paymentMethod),
            date: receipt.receivedDate,
            amount: receipt.totalAmount,
            remarks: receipt.remarks,
          ),
        );
      } else if (source == 'disbursement') {
        final disbursements = await ref.read(
          getAllDisbursementsProvider.future,
        );
        final disp = disbursements.firstWhere((d) => d.id == refId);

        // Lookup account_id from account_transactions via provider
        final resolvedAccountId = await ref
            .read(accountLedgerRepositoryProvider)
            .getAccountIdByReference('disbursement', refId);

        // Fetch accounts to resolve bank name
        final accounts = await ref.read(getAllAccountsProvider.future);
        final account = accounts.isEmpty
            ? null
            : accounts.where((a) => a.id == resolvedAccountId).firstOrNull;

        if (!context.mounted) return;
        Navigator.pop(context); // close loader
        showDialog(
          context: context,
          builder: (_) => PaymentViewDialog(
            title: 'Disbursement Details',
            name: partyName,
            bankTitle: (account?.bankName?.trim().isNotEmpty == true)
                ? account!.bankName!.trim()
                : (disp.accountNo?.isNotEmpty == true
                      ? disp.accountNo!
                      : disp.paymentMethod),
            date: disp.paidDate,
            amount: disp.totalAmount,
            remarks: disp.remarks,
          ),
        );
      } else if (source == 'procurement' || source == 'procurement_brokerage') {
        final procurement = await ref
            .read(procurementRepositoryProvider)
            .getProcurementById(refId);
        final vendors = await ref.read(getAllvendorsProvider.future);
        final materials = await ref.read(getAllRawMaterialsProvider.future);
        final vendorName = vendors
                .where((v) => v.id == procurement.vendorId)
                .firstOrNull
                ?.vendorName ??
            'Vendor #${procurement.vendorId}';
        final materialsById = {for (final m in materials) m.id: m};

        if (!context.mounted) return;
        Navigator.pop(context); // close loader
        showDialog(
          context: context,
          builder: (_) => ProcurementDetailsDialog(
            procurement: procurement,
            vendorName: vendorName,
            materialsById: materialsById,
          ),
        );
      } else {
        if (!context.mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // close loader
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not load details: $e')));
    }
  }
}
