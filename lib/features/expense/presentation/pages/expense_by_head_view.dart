// features/expense/presentation/views/expenses_by_head_view.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/expense_head.dart';
import '../providers/expense_providers.dart';

class ExpensesByHeadView extends ConsumerWidget {
  final ExpenseHead head;

  const ExpensesByHeadView({super.key, required this.head});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific provider for this head's ID
    final expensesAsync = ref.watch(expensesByHeadProvider(head.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${head.name} Expenses'),
        backgroundColor: AppColors.textWhite,
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(
              child: Text('No expenses recorded for this head.'),
            );
          }

          final totalAmount = expenses.fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

          return Column(
            children: [
              // List of Expenses
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: expenses.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final exp = expenses[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.indicatorBackground,
                        child: const Icon(
                          Icons.receipt_long,
                          color: AppColors.iconColor,
                        ),
                      ),
                      title: Text(
                        exp.remarks ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().add_jm().format(exp.date),
                      ),
                      trailing: Text(
                        NumberFormat.currency(symbol: '\$').format(exp.amount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Summary Bar
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
                    const Text(
                      'Total for Category:',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '\$').format(totalAmount),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
