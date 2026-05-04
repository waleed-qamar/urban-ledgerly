import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../invoices/presentation/widgets/invoice_view_dialog.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../receipts/presentation/providers/receipt_providers.dart';
import '../../../receipts/presentation/widgets/payment_view_dialog.dart';
import '../../domain/entities/ledger_entity.dart';
import '../../../account_ledger/presentation/provider/account_ledger_providers.dart';
import '../providers/ledger_providers.dart';
import '../widgets/add_ledger_entry_dialog.dart';

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
        entry.transactionSource == 'disbursement';

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
            child: Text(
              entry.remarks ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDetails(BuildContext context) async {
    final source = entry.transactionSource;
    final refId = int.tryParse(entry.referenceId ?? '');
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
        final productNames = {for (var p in products) p.id: p.name};

        if (!context.mounted) return;
        Navigator.pop(context); // close loader
        showDialog(
          context: context,
          builder: (_) => InvoiceViewDialog(
            invoice: invoice,
            clientName: entry.partyType == PartyType.client
                ? partyName
                : 'Unknown Client',
            supplierName: entry.partyType == PartyType.vendor
                ? partyName
                : 'Unknown Supplier',
            productNames: productNames,
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
