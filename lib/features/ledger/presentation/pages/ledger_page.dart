import 'dart:typed_data';
import 'package:excel/excel.dart' hide Border;
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/widgets/build_search_box.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../vender/presentation/providers/vendor_providers.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../vender/domain/entities/vendor_entity.dart';
import '../../domain/entities/ledger_entity.dart';
import '../providers/ledger_providers.dart';
import '../widgets/add_ledger_entry_dialog.dart';
import 'ledger_details_page.dart';

enum LedgerFilter { all, clients, vendors }

class LedgerPage extends ConsumerStatefulWidget {
  const LedgerPage({super.key});

  @override
  ConsumerState<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends ConsumerState<LedgerPage> {
  late final TextEditingController _searchController;
  LedgerFilter _filter = LedgerFilter.all;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(getAllClientsProvider);
    final vendorsAsync = ref.watch(getAllvendorsProvider);
    final searchQuery = ref.watch(ledgerSearchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ledger',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                _buildDownloadDropdown(context),
              ],
            ),
            const SizedBox(height: 32),

            BuildSearchBox(
              searchController: _searchController,
              searchQueryProvider: ledgerSearchQueryProvider,
              onQueryChanged: (value) => ref
                  .read(ledgerSearchQueryProvider.notifier)
                  .setSearchQuery(value),
              hintText: 'Search by client or vendor name...',
            ),
            const SizedBox(height: 24),
            // Summary Cards (Optional, like in Vendor view)
            // For now, focusing on the list as requested.

            // Filters
            Row(
              children: [
                _buildFilterPill(
                  'All',
                  isSelected: _filter == LedgerFilter.all,
                  onTap: () => setState(() => _filter = LedgerFilter.all),
                ),
                const SizedBox(width: 12),
                _buildFilterPill(
                  'Clients',
                  isSelected: _filter == LedgerFilter.clients,
                  onTap: () => setState(() => _filter = LedgerFilter.clients),
                ),
                const SizedBox(width: 12),
                _buildFilterPill(
                  'Vendors',
                  isSelected: _filter == LedgerFilter.vendors,
                  onTap: () => setState(() => _filter = LedgerFilter.vendors),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Combined List
            Expanded(
              child: _buildCombinedList(
                clientsAsync,
                vendorsAsync,
                searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.badgeBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: AppColors.dividerColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.textBlack : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedList(
    AsyncValue<List<ClientEntity>> clientsAsync,
    AsyncValue<List<VendorEntity>> vendorsAsync,
    String searchQuery, // new param
  ) {
    if (clientsAsync.isLoading || vendorsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (clientsAsync.hasError || vendorsAsync.hasError) {
      return Center(
        child: Text(
          'Error loading data: ${clientsAsync.error ?? vendorsAsync.error}',
        ),
      );
    }

    final clients = clientsAsync.value ?? [];
    final vendors = vendorsAsync.value ?? [];

    final List<_PartyListItem> items = [];

    if (_filter == LedgerFilter.all || _filter == LedgerFilter.clients) {
      items.addAll(
        clients.map<_PartyListItem>(
          (c) => _PartyListItem(
            id: c.id,
            name: c.clientName,
            type: PartyType.client,
            subtitle: c.contactNumber,
          ),
        ),
      );
    }

    if (_filter == LedgerFilter.all || _filter == LedgerFilter.vendors) {
      items.addAll(
        vendors.map<_PartyListItem>(
          (v) => _PartyListItem(
            id: v.id,
            name: v.vendorName,
            type: PartyType.vendor,
            subtitle: v.vendorNotes.isNotEmpty ? v.vendorNotes : v.companyName,
          ),
        ),
      );
    }

    // Search filter (new)
    var filteredItems = items;
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      filteredItems = items.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query);
      }).toList();
    }

    if (filteredItems.isEmpty) {
      return const Center(
        child: Text(
          'No parties found matching the filter.',
          style: TextStyle(color: AppColors.textGrey),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _PartyTile(item: item);
      },
    );
  }


  Widget _buildDownloadDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Download Balance Sheet',
      elevation: 4,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onSelected: (option) => _downloadBalanceSheet(context, option),
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'client',
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: AppColors.primary),
              SizedBox(width: 12),
              Text(
                'Client',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'vendor',
          child: Row(
            children: [
              Icon(Icons.storefront_outlined, size: 20, color: AppColors.primary),
              SizedBox(width: 12),
              Text(
                'Vendor',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'all',
          child: Row(
            children: [
              Icon(Icons.people_alt_outlined, size: 20, color: AppColors.primary),
              SizedBox(width: 12),
              Text(
                'All',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Download Sheet',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadBalanceSheet(BuildContext context, String option) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(
                  'Generating balance sheet...',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final excel = Excel.createExcel();
      final defaultSheet = excel.getDefaultSheet();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String fileName = '';

      if (option == 'client') {
        final clients = await ref.read(getAllClientsProvider.future);
        final clientEntries = await ref
            .read(ledgerRepositoryProvider)
            .getEntriesByType(PartyType.client);

        final Map<int, double> balances = {};
        for (final entry in clientEntries) {
          final isDebit = entry.entryType == EntryType.debit;
          final amount = entry.amount;
          balances[entry.partyId] = (balances[entry.partyId] ?? 0.0) +
              (isDebit ? amount : -amount);
        }

        _buildClientSheet(excel, clients, balances);
        fileName = 'CLIENT_BALANCES_$timestamp';
      } else if (option == 'vendor') {
        final vendors = await ref.read(getAllvendorsProvider.future);
        final vendorEntries = await ref
            .read(ledgerRepositoryProvider)
            .getEntriesByType(PartyType.vendor);

        final Map<int, double> balances = {};
        for (final entry in vendorEntries) {
          final isCredit = entry.entryType == EntryType.credit;
          final amount = entry.amount;
          balances[entry.partyId] = (balances[entry.partyId] ?? 0.0) +
              (isCredit ? amount : -amount);
        }

        _buildVendorSheet(excel, vendors, balances);
        fileName = 'VENDOR_BALANCES_$timestamp';
      } else {
        // all
        final clients = await ref.read(getAllClientsProvider.future);
        final clientEntries = await ref
            .read(ledgerRepositoryProvider)
            .getEntriesByType(PartyType.client);

        final Map<int, double> clientBalances = {};
        for (final entry in clientEntries) {
          final isDebit = entry.entryType == EntryType.debit;
          final amount = entry.amount;
          clientBalances[entry.partyId] = (clientBalances[entry.partyId] ?? 0.0) +
              (isDebit ? amount : -amount);
        }

        final vendors = await ref.read(getAllvendorsProvider.future);
        final vendorEntries = await ref
            .read(ledgerRepositoryProvider)
            .getEntriesByType(PartyType.vendor);

        final Map<int, double> vendorBalances = {};
        for (final entry in vendorEntries) {
          final isCredit = entry.entryType == EntryType.credit;
          final amount = entry.amount;
          vendorBalances[entry.partyId] = (vendorBalances[entry.partyId] ?? 0.0) +
              (isCredit ? amount : -amount);
        }

        _buildCombinedSheet(
          excel,
          clients,
          clientBalances,
          vendors,
          vendorBalances,
        );
        _buildClientSheet(excel, clients, clientBalances);
        _buildVendorSheet(excel, vendors, vendorBalances);
        fileName = 'ALL_BALANCES_$timestamp';
      }

      if (defaultSheet != null &&
          defaultSheet != 'Client Balances' &&
          defaultSheet != 'Vendor Balances' &&
          defaultSheet != 'All Balances') {
        excel.delete(defaultSheet);
      }

      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Failed to generate Excel file');
      }

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(bytes),
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Balance sheet saved successfully: $fileName.xlsx'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download balance sheet: $e'),
            backgroundColor: AppColors.errorText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _buildClientSheet(
    Excel excel,
    List<ClientEntity> clients,
    Map<int, double> balances,
  ) {
    final sheet = excel['Client Balances'];
    int row = 0;

    sheet.appendRow([TextCellValue('URBAN COMPOSITES / URBAN CONSTRUCTIONS')]);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
        CellStyle(bold: true);
    row++;

    sheet.appendRow([TextCellValue('CLIENT BALANCES REPORT (RECEIVABLES)')]);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
        CellStyle(bold: true);
    row++;

    sheet.appendRow([
      TextCellValue(
        'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
      ),
    ]);
    row++;

    sheet.appendRow([TextCellValue('')]);
    row++;

    final headers = [
      'Sr. #',
      'Client Name',
      'Address',
      'Contact Number',
      'Amount Owed to Us (PKR)',
      'Status',
    ];
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#E0E0E0'),
      );
    }
    row++;

    final sortedClients = List<ClientEntity>.from(clients)
      ..sort((a, b) => a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase()));

    double totalReceivable = 0;
    for (int i = 0; i < sortedClients.length; i++) {
      final client = sortedClients[i];
      final balance = balances[client.id] ?? 0.0;
      totalReceivable += balance;

      final status = balance > 0
          ? 'Owed to Us (Receivable)'
          : balance < 0
              ? 'Advance / Overpaid'
              : 'Cleared';

      sheet.appendRow([
        IntCellValue(i + 1),
        TextCellValue(client.clientName),
        TextCellValue(client.clientAddress.isNotEmpty ? client.clientAddress : '-'),
        TextCellValue(client.contactNumber.isNotEmpty ? client.contactNumber : '-'),
        DoubleCellValue(balance),
        TextCellValue(status),
      ]);
      row++;
    }

    sheet.appendRow([
      TextCellValue(''),
      TextCellValue('TOTAL AMOUNT OWED TO US'),
      TextCellValue(''),
      TextCellValue(''),
      DoubleCellValue(totalReceivable),
      TextCellValue(''),
    ]);
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#D9E1F2'),
      );
    }

    sheet.setColumnWidth(0, 8.0);
    sheet.setColumnWidth(1, 28.0);
    sheet.setColumnWidth(2, 35.0);
    sheet.setColumnWidth(3, 18.0);
    sheet.setColumnWidth(4, 25.0);
    sheet.setColumnWidth(5, 24.0);
  }

  void _buildVendorSheet(
    Excel excel,
    List<VendorEntity> vendors,
    Map<int, double> balances,
  ) {
    final sheet = excel['Vendor Balances'];
    int row = 0;

    sheet.appendRow([TextCellValue('URBAN COMPOSITES / URBAN CONSTRUCTIONS')]);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
        CellStyle(bold: true);
    row++;

    sheet.appendRow([TextCellValue('VENDOR BALANCES REPORT (PAYABLES)')]);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
        CellStyle(bold: true);
    row++;

    sheet.appendRow([
      TextCellValue(
        'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
      ),
    ]);
    row++;

    sheet.appendRow([TextCellValue('')]);
    row++;

    final headers = [
      'Sr. #',
      'Vendor Name',
      'Company Name',
      'Address',
      'Contact Number',
      'Amount We Owe (PKR)',
      'Status',
    ];
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#E0E0E0'),
      );
    }
    row++;

    final sortedVendors = List<VendorEntity>.from(vendors)
      ..sort((a, b) => a.vendorName.toLowerCase().compareTo(b.vendorName.toLowerCase()));

    double totalPayable = 0;
    for (int i = 0; i < sortedVendors.length; i++) {
      final vendor = sortedVendors[i];
      final balance = balances[vendor.id] ?? 0.0;
      totalPayable += balance;

      final status = balance > 0
          ? 'We Owe Vendor (Payable)'
          : balance < 0
              ? 'Advance Paid'
              : 'Cleared';

      sheet.appendRow([
        IntCellValue(i + 1),
        TextCellValue(vendor.vendorName),
        TextCellValue(vendor.companyName.isNotEmpty ? vendor.companyName : '-'),
        TextCellValue(vendor.vendorAddress.isNotEmpty ? vendor.vendorAddress : '-'),
        TextCellValue(vendor.contactNumber.isNotEmpty ? vendor.contactNumber : '-'),
        DoubleCellValue(balance),
        TextCellValue(status),
      ]);
      row++;
    }

    sheet.appendRow([
      TextCellValue(''),
      TextCellValue('TOTAL AMOUNT WE OWE'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      DoubleCellValue(totalPayable),
      TextCellValue(''),
    ]);
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#D9E1F2'),
      );
    }

    sheet.setColumnWidth(0, 8.0);
    sheet.setColumnWidth(1, 28.0);
    sheet.setColumnWidth(2, 25.0);
    sheet.setColumnWidth(3, 35.0);
    sheet.setColumnWidth(4, 18.0);
    sheet.setColumnWidth(5, 25.0);
    sheet.setColumnWidth(6, 24.0);
  }

  void _buildCombinedSheet(
    Excel excel,
    List<ClientEntity> clients,
    Map<int, double> clientBalances,
    List<VendorEntity> vendors,
    Map<int, double> vendorBalances,
  ) {
    final sheet = excel['All Balances'];
    int row = 0;

    sheet.appendRow([TextCellValue('URBAN COMPOSITES / URBAN CONSTRUCTIONS')]);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
        CellStyle(bold: true);
    row++;

    sheet.appendRow([
      TextCellValue('ALL PARTIES BALANCE STATEMENT (CLIENTS & VENDORS)'),
    ]);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).cellStyle =
        CellStyle(bold: true);
    row++;

    sheet.appendRow([
      TextCellValue(
        'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
      ),
    ]);
    row++;

    sheet.appendRow([TextCellValue('')]);
    row++;

    final headers = [
      'Sr. #',
      'Party Name',
      'Party Type',
      'Address',
      'Contact Number',
      'Balance Amount (PKR)',
      'Balance Nature',
      'Status',
    ];
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#E0E0E0'),
      );
    }
    row++;

    int serialNumber = 1;
    double totalReceivables = 0;
    double totalPayables = 0;

    final sortedClients = List<ClientEntity>.from(clients)
      ..sort((a, b) => a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase()));

    for (final client in sortedClients) {
      final balance = clientBalances[client.id] ?? 0.0;
      totalReceivables += balance;

      final nature = balance >= 0
          ? 'Receivable (Client owes us)'
          : 'Advance from Client';
      final status = balance > 0
          ? 'Outstanding'
          : balance < 0
              ? 'Advance'
              : 'Cleared';

      sheet.appendRow([
        IntCellValue(serialNumber++),
        TextCellValue(client.clientName),
        TextCellValue('Client'),
        TextCellValue(client.clientAddress.isNotEmpty ? client.clientAddress : '-'),
        TextCellValue(client.contactNumber.isNotEmpty ? client.contactNumber : '-'),
        DoubleCellValue(balance),
        TextCellValue(nature),
        TextCellValue(status),
      ]);
      row++;
    }

    final sortedVendors = List<VendorEntity>.from(vendors)
      ..sort((a, b) => a.vendorName.toLowerCase().compareTo(b.vendorName.toLowerCase()));

    for (final vendor in sortedVendors) {
      final balance = vendorBalances[vendor.id] ?? 0.0;
      totalPayables += balance;

      final nature = balance >= 0
          ? 'Payable (We owe vendor)'
          : 'Advance to Vendor';
      final status = balance > 0
          ? 'Outstanding'
          : balance < 0
              ? 'Advance'
              : 'Cleared';

      sheet.appendRow([
        IntCellValue(serialNumber++),
        TextCellValue(vendor.vendorName),
        TextCellValue('Vendor'),
        TextCellValue(vendor.vendorAddress.isNotEmpty ? vendor.vendorAddress : '-'),
        TextCellValue(vendor.contactNumber.isNotEmpty ? vendor.contactNumber : '-'),
        DoubleCellValue(balance),
        TextCellValue(nature),
        TextCellValue(status),
      ]);
      row++;
    }

    sheet.appendRow([TextCellValue('')]);
    row++;

    sheet.appendRow([
      TextCellValue(''),
      TextCellValue('TOTAL RECEIVABLES (Clients owe us)'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      DoubleCellValue(totalReceivables),
      TextCellValue('Receivable'),
      TextCellValue(''),
    ]);
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#D9E1F2'),
      );
    }
    row++;

    sheet.appendRow([
      TextCellValue(''),
      TextCellValue('TOTAL PAYABLES (We owe vendors)'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      DoubleCellValue(totalPayables),
      TextCellValue('Payable'),
      TextCellValue(''),
    ]);
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#FCE4D6'),
      );
    }
    row++;

    final netDiff = totalReceivables - totalPayables;
    sheet.appendRow([
      TextCellValue(''),
      TextCellValue('NET BALANCE POSITION'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      DoubleCellValue(netDiff.abs()),
      TextCellValue(netDiff >= 0 ? 'Net Receivable' : 'Net Payable'),
      TextCellValue(''),
    ]);
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row)).cellStyle =
          CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#E2EFDA'),
      );
    }

    sheet.setColumnWidth(0, 8.0);
    sheet.setColumnWidth(1, 28.0);
    sheet.setColumnWidth(2, 14.0);
    sheet.setColumnWidth(3, 35.0);
    sheet.setColumnWidth(4, 18.0);
    sheet.setColumnWidth(5, 24.0);
    sheet.setColumnWidth(6, 26.0);
    sheet.setColumnWidth(7, 16.0);
  }
}

class _PartyListItem {
  final int id;
  final String name;
  final PartyType type;
  final String subtitle;

  _PartyListItem({
    required this.id,
    required this.name,
    required this.type,
    required this.subtitle,
  });
}

class _PartyTile extends ConsumerWidget {
  final _PartyListItem item;

  const _PartyTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(
      getBalanceProvider(partyType: item.type, partyId: item.id),
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LedgerDetailsPage(
              partyId: item.id,
              partyType: item.type,
              partyName: item.name,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.dividerColor.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textGrey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightBackground,
              child: Icon(
                item.type == PartyType.client ? Icons.person : Icons.business,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddLedgerEntryDialog(
                          initialPartyType: item.type,
                          initialPartyId: item.id,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Entry'),
                  ),
                  SizedBox(width: 48),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Balance',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        item.type == PartyType.client
                            ? 'Client owes you'
                            : 'You owe vendor',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11,
                        ),
                      ),
                      balanceAsync.when(
                        data: (balance) => Text(
                          balance.abs().toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _balanceColorForParty(partyType: item.type),
                          ),
                        ),
                        loading: () => const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, _) => const Text(
                          'Error',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.chevron_right, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  static Color _balanceColorForParty({required PartyType partyType}) {
    return partyType == PartyType.client
        ? AppColors.successText
        : AppColors.errorText;
  }
}
