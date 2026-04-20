// features/expense/presentation/views/expense_dashboard_view.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/expense_providers.dart';
import '../widgets/build_ladger_item.dart';
import 'add_expense_dialog.dart';
import 'add_expense_head_dialog.dart';
import 'full_ledger_view.dart';
import 'manage_heads_view.dart';
import '../../domain/entities/expense_head.dart';

class ExpenseDashboardView extends ConsumerWidget {
  const ExpenseDashboardView({super.key});

  Future<DateTimeRange?> _showDialogDatePicker(
    BuildContext context,
    DateTimeRange? initialRange,
  ) {
    return showDialog<DateTimeRange>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.5,
            child: DateRangePickerDialog(
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDateRange: initialRange,
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showHeadFilterDialog(
    BuildContext context,
    WidgetRef ref,
    List<ExpenseHead> heads,
    int? currentHeadId,
    DateTimeRange? currentRange,
  ) {
    int? tempHeadId = currentHeadId;
    DateTimeRange? tempRange = currentRange;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter by Head'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int?>(
                    initialValue: tempHeadId,
                    decoration: const InputDecoration(
                      labelText: 'Expense Category',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...heads.map(
                        (h) => DropdownMenuItem<int?>(
                          value: h.id,
                          child: Text(h.name),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => tempHeadId = val),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Optional Date Range',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await _showDialogDatePicker(
                              context,
                              tempRange,
                            );
                            if (picked != null) {
                              setState(() => tempRange = picked);
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: Text(
                            tempRange == null
                                ? 'Select Dates'
                                : '${DateFormat.MMMd().format(tempRange!.start)} - ${DateFormat.MMMd().format(tempRange!.end)}',
                          ),
                        ),
                      ),
                      if (tempRange != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () => setState(() => tempRange = null),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ref
                      .read(selectedLedgerHeadProvider.notifier)
                      .setHead(tempHeadId);
                  ref
                      .read(ledgerDateRangeProvider.notifier)
                      .setRange(tempRange);
                  Navigator.pop(ctx, true);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    ).then((value) => value ?? false);
  }

  void _openFullLedgerView(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const FullLedgerView()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch our providers
    final recentExpensesAsync = ref.watch(recentExpensesProvider);
    final expenseHeadsAsync = ref.watch(expenseHeadsProvider);
    final insightsAsync = ref.watch(monthlyInsightsProvider);
    final headsList = expenseHeadsAsync.value ?? [];
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // const Text(
                  //   'Curate and oversee your organizational outlays with precision.',
                  //   style: TextStyle(color: Colors.grey, fontSize: 16),
                  // ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddExpenseHeadDialog(),
                      );
                    },
                    icon: const Icon(
                      Icons.account_tree_outlined,
                      color: Colors.grey,
                    ),
                    label: const Text(
                      'New Expense Head',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  PopupMenuButton<String>(
                    tooltip: 'View Full Daybook',
                    onSelected: (value) async {
                      if (value == 'all') {
                        ref
                            .read(selectedLedgerHeadProvider.notifier)
                            .setHead(null);
                        ref
                            .read(ledgerDateRangeProvider.notifier)
                            .setRange(null);
                        if (!context.mounted) return;
                        _openFullLedgerView(context);
                      } else if (value == 'range') {
                        final picked = await _showDialogDatePicker(
                          context,
                          ref.read(ledgerDateRangeProvider),
                        );
                        if (picked != null) {
                          ref
                              .read(selectedLedgerHeadProvider.notifier)
                              .setHead(null);
                          ref
                              .read(ledgerDateRangeProvider.notifier)
                              .setRange(picked);
                          if (!context.mounted) return;
                          _openFullLedgerView(context);
                        }
                      } else if (value == 'head') {
                        final applied = await _showHeadFilterDialog(
                          context,
                          ref,
                          headsList,
                          ref.read(selectedLedgerHeadProvider),
                          ref.read(ledgerDateRangeProvider),
                        );
                        if (applied && context.mounted) {
                          _openFullLedgerView(context);
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'all',
                        child: Text('Fetch All (Clear Filters)'),
                      ),
                      PopupMenuItem(
                        value: 'range',
                        child: Text('Filter by Date Range'),
                      ),
                      PopupMenuItem(
                        value: 'head',
                        child: Text('Filter by Category Head'),
                      ),
                    ],
                    child: const Text(
                      'View Full Daybook →',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Content Grid
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Expense Ledger
                Expanded(
                  flex: 5,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Expense Daybook',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'RECENT',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Inject Riverpod State Here
                          Expanded(
                            child: recentExpensesAsync.when(
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (err, stack) =>
                                  Center(child: Text('Error: $err')),
                              data: (expenses) {
                                if (expenses.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No recent expenses found.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }
                                return ListView.separated(
                                  itemCount: expenses.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(height: 32),
                                  itemBuilder: (context, index) {
                                    final exp = expenses[index];

                                    // Find the matching Expense Head
                                    // Using an iterable approach safely handles nulls if a head was somehow deleted
                                    final head = headsList
                                        .where((h) => h.id == exp.expenseHeadId)
                                        .firstOrNull;

                                    final title =
                                        head?.name ?? 'Unknown Category';
                                    final headType =
                                        head?.headType.value ?? 'Unknown';

                                    return buildLedgerItem(
                                      Icons.receipt_long,
                                      title, // Showing Head Name as title
                                      exp.remarks, // Showing Remark as subtitle
                                      NumberFormat.currency(
                                        symbol: 'PKR ',
                                      ).format(exp.amount),
                                      DateFormat.yMMMd().format(exp.date),
                                      headType, // Showing Head Type in badge
                                      AppColors.iconBackground,
                                      Colors.teal,
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const AddExpenseDialog(),
                                );
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('New Expense'),
                            ),

                            //
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // Right Column: Insights & Categories
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      // Monthly Insights Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        // Replace the static Column with the Riverpod .when() mapping
                        child: insightsAsync.when(
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(
                                color: AppColors.positiveAccent,
                              ),
                            ),
                          ),
                          error: (error, stack) => const Center(
                            child: Text(
                              'Failed to load insights',
                              style: TextStyle(color: AppColors.negativeAccent),
                            ),
                          ),
                          data: (insights) {
                            final change = insights['change'] as double;
                            final isPositive = change >= 0;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MONTHLY INSIGHTS',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  // Make sure to import 'package:intl/intl.dart'; at the top of the file
                                  NumberFormat.currency(
                                    symbol: 'PKR ',
                                  ).format(insights['total']),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${isPositive ? '↑' : '↓'} ${change.abs().toStringAsFixed(1)}% vs last month',
                                  style: TextStyle(
                                    color: isPositive
                                        ? AppColors.negativeAccent
                                        : AppColors.positiveAccent,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Keeping your static placeholder bars for now
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildBar(40, AppColors.barPlaceholder),
                                    _buildBar(60, AppColors.barPlaceholder),
                                    _buildBar(30, AppColors.barPlaceholder),
                                    _buildBar(80, AppColors.barPlaceholder),
                                    _buildBar(50, AppColors.positiveAccent),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Expense Heads Card
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Expense Heads',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.more_horiz, color: Colors.grey),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Inject Riverpod State Here
                                Expanded(
                                  child: expenseHeadsAsync.when(
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (err, stack) =>
                                        Center(child: Text('Error: $err')),
                                    data: (heads) {
                                      if (heads.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            'No heads added yet.',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      }
                                      return ListView.separated(
                                        itemCount: heads.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 16),
                                        itemBuilder: (context, index) {
                                          final head = heads[index];
                                          return _buildHeadItem(
                                            head.name,
                                            head
                                                .headType
                                                .name, // Reusing percentage spot to show type for now
                                            AppColors.dotActive,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),

                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ManageHeadsView(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Manage Heads',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadItem(String title, String subtitle, Color dotColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: dotColor),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 40,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
