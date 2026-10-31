import 'package:excel/excel.dart' hide Border;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/audit_log_list_widget.dart';
import '../../domain/entities/account_entity.dart';

import '../../../../core/theme/app_colors.dart';
// import '../../../../core/widgets/pdf_button.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../provider/account_ledger_providers.dart';
import 'opening_balance_dialog.dart';
import 'withdraw_dialog.dart';

class AccountDetailsPage extends ConsumerStatefulWidget {
  final int accountId;

  const AccountDetailsPage({super.key, required this.accountId});

  @override
  ConsumerState<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends ConsumerState<AccountDetailsPage> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(getAccountByIdProvider(widget.accountId));
    final transactionsAsync = ref.watch(
      getAccountTransactionsProvider(widget.accountId),
    );

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        title: accountAsync.when(
          data: (acc) => Text(
            acc.accountTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          loading: () => const Text('Loading...'),
          error: (_, _) => const Text('Error'),
        ),
        backgroundColor: AppColors.textWhite,
        elevation: 0,
        foregroundColor: AppColors.textBlack,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () =>
                  _exportToXlsx(context, accountAsync, transactionsAsync),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Export XLSX'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                Text(
                  'Account Details',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => OpeningBalanceDialog.show(
                    context,
                    initialAccountId: widget.accountId,
                  ),
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  label: const Text('Initial Balance'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            accountAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text(
                'Error loading account: $err',
                style: const TextStyle(color: Colors.red),
              ),
              data: (account) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.dividerColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Info',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            account.bankName ?? 'Cash Account',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (account.accountNumber != null &&
                              account.accountNumber!.isNotEmpty)
                            Text(account.accountNumber!),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Current Balance',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${account.currency} ${account.currentBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: account.currentBalance >= 0
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _activeTab = 0),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          'Transactions History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _activeTab == 0
                                ? AppColors.primary
                                : AppColors.textGrey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () => setState(() => _activeTab = 1),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          'System Activity Logs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _activeTab == 1
                                ? AppColors.primary
                                : AppColors.textGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_activeTab == 0)
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange.shade800,
                          side: BorderSide(color: Colors.orange.shade800),
                        ),
                        onPressed: () => WithdrawDialog.show(
                          context,
                          initialAccountId: widget.accountId,
                        ),
                        icon: const Icon(Icons.money_off),
                        label: const Text('Withdraw Money'),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: () => _openTransferDialog(context),
                        icon: const Icon(Icons.compare_arrows),
                        label: const Text('Transfer Money'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _activeTab == 1
                  ? SingleChildScrollView(
                      child: AuditLogListWidget(
                        tableName: 'accounts',
                        recordId: widget.accountId.toString(),
                      ),
                    )
                  : transactionsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(
                        child: Text(
                          'Error: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (transactions) {
                        if (transactions.isEmpty) {
                          return const Center(
                            child: Text(
                              'No transactions found for this account.',
                            ),
                          );
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.dividerColor.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width - 48,
                                  ),
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Remarks',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Ref Type',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Credit',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Debit',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Balance',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Actions',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: transactions.map((tx) {
                                      final isCredit =
                                          tx.transactionType == 'credit';
                                      final dateFormat = DateFormat(
                                        'dd MMM yyyy, hh:mm a',
                                      );
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              dateFormat.format(
                                                tx.transactionDate,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: 300,
                                              child: Text(
                                                tx.description ?? '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                tx.referenceType.toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              isCredit
                                                  ? tx.amount.toStringAsFixed(2)
                                                  : '-',
                                              style: TextStyle(
                                                color: isCredit
                                                    ? Colors.green.shade700
                                                    : Colors.black,
                                                fontWeight: isCredit
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              !isCredit
                                                  ? tx.amount.toStringAsFixed(2)
                                                  : '-',
                                              style: TextStyle(
                                                color: !isCredit
                                                    ? Colors.red.shade700
                                                    : Colors.black,
                                                fontWeight: !isCredit
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              tx.runningBalance.toStringAsFixed(
                                                2,
                                              ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            tx.referenceType == 'transfer' &&
                                                    tx.referenceId != null
                                                ? IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: AppColors.primary,
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                            _EditTransferDialog(
                                                              transferId: tx
                                                                  .referenceId!,
                                                              accountId: widget
                                                                  .accountId,
                                                            ),
                                                      );
                                                    },
                                                    tooltip: 'Edit Transfer',
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTransferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) =>
          _TransferMoneyDialog(fromAccountId: widget.accountId),
    );
  }

  Future<void> _exportToXlsx(
    BuildContext context,
    AsyncValue accountAsync,
    AsyncValue transactionsAsync,
  ) async {
    try {
      final account = accountAsync.asData?.value;
      final transactions = transactionsAsync.asData?.value ?? [];

      if (account == null || transactions.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data available to export')),
        );
        return;
      }

      // Create workbook and sheet
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Set column widths
      sheet.setColumnWidth(0, 18); // Date
      sheet.setColumnWidth(1, 40); // Description
      sheet.setColumnWidth(2, 15); // Ref Type
      sheet.setColumnWidth(3, 15); // Credit
      sheet.setColumnWidth(4, 15); // Debit
      sheet.setColumnWidth(5, 15); // Balance

      // Use appendRow with TextCellValue and apply lightweight styling
      int row = 0;

      // Title
      sheet.appendRow([TextCellValue('BANK STATEMENT')]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .cellStyle = CellStyle(
        fontFamily: 'Times New Roman',
        fontSize: 16,
        bold: true,
      );
      row++;
      sheet.appendRow([TextCellValue('')]);
      row++;

      // Account info (label in bold)
      sheet.appendRow([
        TextCellValue('Account Name:'),
        TextCellValue(account.accountTitle),
      ]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .cellStyle = CellStyle(
        bold: true,
      );
      row++;

      sheet.appendRow([
        TextCellValue('Account Number:'),
        TextCellValue(account.accountNumber ?? 'N/A'),
      ]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .cellStyle = CellStyle(
        bold: true,
      );
      row++;

      sheet.appendRow([
        TextCellValue('Bank:'),
        TextCellValue(account.bankName ?? 'Cash Account'),
      ]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .cellStyle = CellStyle(
        bold: true,
      );
      row++;

      sheet.appendRow([
        TextCellValue('Currency:'),
        TextCellValue(account.currency),
      ]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .cellStyle = CellStyle(
        bold: true,
      );
      row++;

      sheet.appendRow([
        TextCellValue('Statement Date:'),
        TextCellValue(DateFormat('MMM dd yyyy').format(DateTime.now())),
      ]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .cellStyle = CellStyle(
        bold: true,
      );
      row++;
      sheet.appendRow([TextCellValue('')]);
      row++;

      // Table headers
      sheet.appendRow([
        TextCellValue('Date'),
        TextCellValue('Description'),
        TextCellValue('Ref Type'),
        TextCellValue('Credit'),
        TextCellValue('Debit'),
        TextCellValue('Balance'),
      ]);
      for (int col = 0; col < 6; col++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
            .cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.fromHexString('#F0F0F0'),
        );
      }
      row++;

      // Transactions
      final dateFormat = DateFormat('M/dd/yyyy');
      for (final tx in transactions) {
        final isCredit = tx.transactionType == 'credit';
        final date = dateFormat.format(tx.transactionDate);

        sheet.appendRow([
          TextCellValue(date),
          TextCellValue(tx.description ?? ''),
          TextCellValue(tx.referenceType.toUpperCase()),
          TextCellValue(isCredit ? tx.amount.toStringAsFixed(2) : '-'),
          TextCellValue(!isCredit ? tx.amount.toStringAsFixed(2) : '-'),
          TextCellValue(tx.runningBalance.toStringAsFixed(2)),
        ]);

        // Right-align numeric columns
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .cellStyle = CellStyle(
          horizontalAlign: HorizontalAlign.Right,
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .cellStyle = CellStyle(
          horizontalAlign: HorizontalAlign.Right,
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .cellStyle = CellStyle(
          horizontalAlign: HorizontalAlign.Right,
        );

        row++;
      }

      // Summary
      sheet.appendRow([TextCellValue('')]);
      row++;
      final firstTx = transactions.isNotEmpty
          ? transactions.first.runningBalance -
                (transactions.first.transactionType == 'credit'
                    ? transactions.first.amount
                    : -transactions.first.amount)
          : 0.0;
      sheet.appendRow([
        TextCellValue('Opening Balance:'),
        TextCellValue(firstTx.toStringAsFixed(2)),
      ]);
      row++;
      final lastBalance = transactions.isNotEmpty
          ? transactions.last.runningBalance
          : account.currentBalance;
      sheet.appendRow([
        TextCellValue('Closing Balance:'),
        TextCellValue(lastBalance.toStringAsFixed(2)),
      ]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .cellStyle = CellStyle(
        bold: true,
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Right,
        bold: true,
      );

      // Generate bytes and save
      final bytes = excel.encode();

      if (bytes != null) {
        final fileName =
            '${account.accountTitle}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';

        // Capture scaffold messenger before async gap
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: Uint8List.fromList(bytes),
          mimeType: MimeType.microsoftExcel,
        );

        if (!mounted) return;
        scaffoldMessenger?.showSnackBar(
          SnackBar(content: Text('Statement exported: $fileName')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context.mounted ? context : context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  // Using appendRow with TextCellValue for Excel export; no per-cell helper needed.
}

/// Dialog for transferring money between accounts
class _TransferMoneyDialog extends ConsumerStatefulWidget {
  final int fromAccountId;

  const _TransferMoneyDialog({required this.fromAccountId});

  @override
  ConsumerState<_TransferMoneyDialog> createState() =>
      _TransferMoneyDialogState();
}

class _TransferMoneyDialogState extends ConsumerState<_TransferMoneyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedToAccountId;
  bool _isSubmitting = false;
  DateTime _transactionDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedToAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination account')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Capture navigator and messenger before async call to avoid using
      // BuildContext across async gaps.
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

      await ref.read(
        transferBetweenAccountsProvider(
          fromAccountId: widget.fromAccountId,
          toAccountId: _selectedToAccountId!,
          amount: amount,
          description: _descriptionController.text.trim().isEmpty
              ? 'Transfer between accounts'
              : _descriptionController.text.trim(),
          date: _transactionDate,
        ).future,
      );

      ref.invalidate(getAllAccountsProvider);
      ref.invalidate(getAccountByIdProvider(widget.fromAccountId));
      ref.invalidate(getAccountTransactionsProvider(widget.fromAccountId));
      if (_selectedToAccountId != null) {
        ref.invalidate(getAccountByIdProvider(_selectedToAccountId!));
        ref.invalidate(getAccountTransactionsProvider(_selectedToAccountId!));
      }

      if (!mounted) return;
      navigator.pop();
      scaffoldMessenger?.showSnackBar(
        const SnackBar(content: Text('Transfer completed successfully')),
      );
    } catch (e) {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      scaffoldMessenger?.showSnackBar(
        SnackBar(content: Text('Transfer failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAccountsAsync = ref.watch(getAllAccountsProvider);
    final fromAccountAsync = ref.watch(
      getAccountByIdProvider(widget.fromAccountId),
    );

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: const Text(
        'Transfer Money',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // From Account
                fromAccountAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                  data: (fromAccount) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'From Account:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          fromAccount.accountTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Balance: ${fromAccount.currency} ${fromAccount.currentBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: fromAccount.currentBalance >= 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // To Account Dropdown
                allAccountsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                  data: (accounts) {
                    final otherAccounts = accounts
                        .where((acc) => acc.id != widget.fromAccountId)
                        .toList();

                    String formatAccount(AccountEntity a) {
                      final parts = <String>[];
                      if (a.bankName != null && a.bankName!.isNotEmpty) {
                        parts.add(a.bankName!);
                      }
                      parts.add(a.accountTitle);
                      if (a.accountNumber != null &&
                          a.accountNumber!.isNotEmpty) {
                        parts.add('(${a.accountNumber})');
                      }
                      return parts.join(' - ');
                    }

                    final selectedAcc = _selectedToAccountId != null
                        ? otherAccounts
                              .where((acc) => acc.id == _selectedToAccountId)
                              .firstOrNull
                        : null;

                    return SearchableDropdown<AccountEntity>(
                      initialText: selectedAcc != null
                          ? formatAccount(selectedAcc)
                          : null,
                      labelText: 'To Account *',
                      prefixIcon: const Icon(Icons.account_balance_outlined),
                      items: otherAccounts,
                      displayStringForOption: formatAccount,
                      onSelected: (account) {
                        setState(() {
                          _selectedToAccountId = account.id;
                        });
                      },
                      errorText:
                          _selectedToAccountId == null ||
                              _selectedToAccountId == -1
                          ? 'Please select a destination account'
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Amount *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.payments_outlined),
                    prefixText: 'PKR ',
                  ),
                  validator: (value) {
                    final amount = double.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _transactionDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _transactionDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Transaction Date *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(_transactionDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSubmitting ? null : _submit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Icon(Icons.compare_arrows),
          label: Text(_isSubmitting ? 'Transferring...' : 'Transfer'),
        ),
      ],
    );
  }
}

class _EditTransferDialog extends ConsumerStatefulWidget {
  final int transferId;
  final int accountId;
  const _EditTransferDialog({
    required this.transferId,
    required this.accountId,
  });

  @override
  ConsumerState<_EditTransferDialog> createState() =>
      _EditTransferDialogState();
}

class _EditTransferDialogState extends ConsumerState<_EditTransferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedFromAccountId;
  int? _selectedToAccountId;
  DateTime _transactionDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFromAccountId == null || _selectedToAccountId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select accounts')));
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

      await ref.read(
        updateTransferProvider(
          transferId: widget.transferId,
          fromAccountId: _selectedFromAccountId!,
          toAccountId: _selectedToAccountId!,
          amount: amount,
          description: _descriptionController.text.trim(),
          date: _transactionDate,
        ).future,
      );

      ref.invalidate(getAccountTransactionsProvider(widget.accountId));
      ref.invalidate(getAllAccountsProvider);

      if (mounted) {
        scaffoldMessenger?.showSnackBar(
          const SnackBar(content: Text('Transfer updated successfully')),
        );
        navigator.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating transfer: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAccountsAsync = ref.watch(getAllAccountsProvider);
    final transferDetailsAsync = ref.watch(
      getTransferDetailsProvider(widget.transferId),
    );

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: const Text(
        'Edit Transfer',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 480,
        child: allAccountsAsync.when(
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error: $e'),
          data: (accounts) => transferDetailsAsync.when(
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (transfer) {
              if (_selectedFromAccountId == null &&
                  _selectedToAccountId == null &&
                  _amountController.text.isEmpty) {
                _selectedFromAccountId = transfer['from_account_id'] as int;
                _selectedToAccountId = transfer['to_account_id'] as int;
                _amountController.text = transfer['amount'].toString();
                _descriptionController.text = transfer['description'] ?? '';
                if (transfer['transfer_date'] != null) {
                  _transactionDate = DateTime.parse(
                    transfer['transfer_date'] as String,
                  );
                }
              }

              String formatAccount(AccountEntity a) {
                final parts = <String>[];
                if (a.bankName != null && a.bankName!.isNotEmpty) {
                  parts.add(a.bankName!);
                }
                parts.add(a.accountTitle);
                if (a.accountNumber != null && a.accountNumber!.isNotEmpty) {
                  parts.add('(${a.accountNumber})');
                }
                return parts.join(' - ');
              }

              final selectedFromAcc = accounts
                  .where((a) => a.id == _selectedFromAccountId)
                  .firstOrNull;
              final selectedToAcc = accounts
                  .where((a) => a.id == _selectedToAccountId)
                  .firstOrNull;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SearchableDropdown<AccountEntity>(
                        initialText: selectedFromAcc != null
                            ? formatAccount(selectedFromAcc)
                            : null,
                        labelText: 'From Account *',
                        prefixIcon: const Icon(Icons.account_balance_outlined),
                        items: accounts,
                        displayStringForOption: formatAccount,
                        onSelected: (acc) =>
                            setState(() => _selectedFromAccountId = acc.id),
                        errorText: _selectedFromAccountId == null
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      SearchableDropdown<AccountEntity>(
                        initialText: selectedToAcc != null
                            ? formatAccount(selectedToAcc)
                            : null,
                        labelText: 'To Account *',
                        prefixIcon: const Icon(Icons.account_balance_outlined),
                        items: accounts,
                        displayStringForOption: formatAccount,
                        onSelected: (acc) =>
                            setState(() => _selectedToAccountId = acc.id),
                        errorText: _selectedToAccountId == null
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Amount *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.payments_outlined),
                          prefixText: 'PKR ',
                        ),
                        validator: (val) {
                          final amt = double.tryParse(val ?? '');
                          if (amt == null || amt <= 0) return 'Invalid amount';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _transactionDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _transactionDate = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Transaction Date *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(
                            DateFormat('dd MMM yyyy').format(_transactionDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.notes_outlined),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSubmitting ? null : _submit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Icon(Icons.save),
          label: Text(_isSubmitting ? 'Saving...' : 'Save'),
        ),
      ],
    );
  }
}
