import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../provider/account_ledger_providers.dart';
import 'account_details_page.dart';
import 'add_account_dialog.dart';

class AccountDashboard extends ConsumerWidget {
  const AccountDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(getAllAccountsProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      // appBar: AppBar(
      //   title: const Text(
      //     'Accounts',
      //     style: TextStyle(fontWeight: FontWeight.w800),
      //   ),
      //   backgroundColor: AppColors.textWhite,
      //   elevation: 0,
      //   foregroundColor: AppColors.textBlack,
      //   actions: [
      //     FloatingActionButton(onPressed: )
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accounts',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        AccountFormDialog.show(
                          context,
                          onSave: (account) async {
                            await ref
                                .read(accountLedgerRepositoryProvider)
                                .createAccount(account);
                            ref.invalidate(getAllAccountsProvider);
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Account'),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'All Accounts',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            // const SizedBox(height: 8),
            // Text(
            //   'Overview of cash and bank accounts along with their current balances.',
            //   style: TextStyle(color: Colors.grey.shade600),
            // ),
            const SizedBox(height: 24),
            Expanded(
              child: accountsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load accounts: $error',
                    style: const TextStyle(color: AppColors.errorText),
                  ),
                ),
                data: (accounts) {
                  if (accounts.isEmpty) {
                    return const Center(child: Text('No accounts found.'));
                  }

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.dividerColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.grey.shade50,
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Account Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Bank Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Current Balance',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Type',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: accounts.map((account) {
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.blue.withValues(alpha: 0.05);
                                }
                                return null;
                              }),
                              cells: [
                                DataCell(
                                  Text(
                                    account.accountTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () =>
                                      _navigateToDetails(context, account.id),
                                ),
                                DataCell(
                                  Text(account.bankName ?? 'N/A'),
                                  onTap: () =>
                                      _navigateToDetails(context, account.id),
                                ),
                                DataCell(
                                  Text(
                                    '${account.currency} ${account.currentBalance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: account.currentBalance >= 0
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                    ),
                                  ),
                                  onTap: () =>
                                      _navigateToDetails(context, account.id),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: account.accountType == 'bank'
                                          ? Colors.blue.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      account.accountType.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: account.accountType == 'bank'
                                            ? Colors.blue.shade700
                                            : Colors.orange.shade700,
                                      ),
                                    ),
                                  ),
                                  onTap: () =>
                                      _navigateToDetails(context, account.id),
                                ),
                              ],
                            );
                          }).toList(),
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

  void _navigateToDetails(BuildContext context, int accountId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountDetailsPage(accountId: accountId),
      ),
    );
  }
}
