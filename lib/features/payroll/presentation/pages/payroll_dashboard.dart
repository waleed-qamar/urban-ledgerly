import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import '../providers/payroll_providers.dart';
import '../widgets/create_sheet_dialog.dart';
import 'payroll_sheet_view.dart';

class PayrollDashboard extends ConsumerWidget {
  const PayrollDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetsAsync = ref.watch(payrollSheetsProvider);
    final currencyFmt = NumberFormat('#,##0');

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payroll & Payout Sheets',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Manage labour payout runs, advance deductions, demands, and disbursements.',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final sheetId = await showDialog<String>(
                      context: context,
                      builder: (_) => const CreatePayrollSheetDialog(),
                    );
                    if (sheetId != null && context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PayrollSheetView(sheetId: sheetId),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Payout Sheet'),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Sheet List
            Expanded(
              child: sheetsAsync.when(
                data: (sheets) {
                  if (sheets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.request_quote_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No payroll sheets created yet.',
                            style: TextStyle(color: AppColors.textGrey, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textWhite,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            onPressed: () async {
                              final sheetId = await showDialog<String>(
                                context: context,
                                builder: (_) => const CreatePayrollSheetDialog(),
                              );
                              if (sheetId != null && context.mounted) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PayrollSheetView(sheetId: sheetId),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create First Sheet'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: sheets.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final s = sheets[index];

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PayrollSheetView(sheetId: s.id),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.dividerColor.withValues(alpha: 0.6),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Sheet Icon
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: s.isFinalized
                                      ? Colors.green.withValues(alpha: 0.12)
                                      : AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  s.isFinalized ? Icons.lock : Icons.table_chart_outlined,
                                  color: s.isFinalized ? Colors.green[800] : AppColors.primaryDark,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Title & Company
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          s.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.textBlack,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE65100).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            s.category,
                                            style: const TextStyle(
                                              color: Color(0xFFE65100),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      s.company,
                                      style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Cutoff Date
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cutoff Date',
                                      style: TextStyle(color: AppColors.textGrey, fontSize: 11),
                                    ),
                                    Text(
                                      DateFormat('MMM d, yyyy').format(s.cutoffDate),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Cash Handed Over
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cash Given',
                                      style: TextStyle(color: AppColors.textGrey, fontSize: 11),
                                    ),
                                    Text(
                                      s.amountGiven > 0 ? '₨ ${currencyFmt.format(s.amountGiven)}' : '—',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: s.isFinalized
                                      ? const Color(0xFFE8F5E9)
                                      : const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  s.status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: s.isFinalized ? Colors.green[800] : Colors.blue[800],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Delete (if draft)
                              if (!s.isFinalized)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Sheet'),
                                        content: Text('Are you sure you want to delete ${s.title}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, false),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed: () => Navigator.pop(ctx, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await ref.read(payrollRepositoryProvider).deleteSheet(s.id);
                                      ref.invalidate(payrollSheetsProvider);
                                    }
                                  },
                                ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error loading sheets: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
