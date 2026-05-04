import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../provider/account_ledger_providers.dart';

class AccountDetailsPage extends ConsumerWidget {
  final int accountId;

  const AccountDetailsPage({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(getAccountByIdProvider(accountId));
    final transactionsAsync = ref.watch(getAccountTransactionsProvider(accountId));

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        title: accountAsync.when(
          data: (acc) => Text(acc.accountTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        backgroundColor: AppColors.textWhite,
        elevation: 0,
        foregroundColor: AppColors.textBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            accountAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (account) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.indigo.shade50],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Account Info', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            account.bankName ?? 'Cash Account',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (account.accountNumber != null && account.accountNumber!.isNotEmpty)
                            Text(account.accountNumber!),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Current Balance', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '${account.currency} ${account.currentBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: account.currentBalance >= 0 ? Colors.green.shade700 : Colors.red.shade700,
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
            Text(
              'Transactions History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: transactionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text('No transactions found for this account.'));
                  }
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.35)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 48),
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                              columns: const [
                                DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Ref Type', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Credit', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Debit', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Balance', style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: transactions.map((tx) {
                                final isCredit = tx.transactionType == 'credit';
                                final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
                                return DataRow(
                                  cells: [
                                    DataCell(Text(dateFormat.format(tx.transactionDate))),
                                    DataCell(
                                      SizedBox(
                                        width: 300,
                                        child: Text(tx.description ?? '', overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          tx.referenceType.toUpperCase(),
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        isCredit ? tx.amount.toStringAsFixed(2) : '-',
                                        style: TextStyle(
                                          color: isCredit ? Colors.green.shade700 : Colors.black,
                                          fontWeight: isCredit ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        !isCredit ? tx.amount.toStringAsFixed(2) : '-',
                                        style: TextStyle(
                                          color: !isCredit ? Colors.red.shade700 : Colors.black,
                                          fontWeight: !isCredit ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        tx.runningBalance.toStringAsFixed(2),
                                        style: const TextStyle(fontWeight: FontWeight.w800),
                                      ),
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
}
