import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import '../../domain/entities/payroll_sheet_entity.dart';
import '../providers/payroll_providers.dart';
import '../widgets/create_sheet_dialog.dart';
import 'payroll_sheet_view.dart';
import 'overtime_sheet_view.dart';

class PayrollDashboard extends ConsumerStatefulWidget {
  const PayrollDashboard({super.key});

  @override
  ConsumerState<PayrollDashboard> createState() => _PayrollDashboardState();
}

class _PayrollDashboardState extends ConsumerState<PayrollDashboard> {
  String _selectedFilter = 'all'; // 'all' | 'kharcha' | 'overtime'

  void _openSheet(PayrollSheetEntity sheet) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => sheet.isOvertime
            ? OvertimeSheetView(sheetId: sheet.id)
            : PayrollSheetView(sheetId: sheet.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      'Manage labour payout runs, advance deductions, demands, disbursements, and overtime.',
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
                      // Fetch the newly created sheet to route to the correct view
                      final sheet = await ref.read(payrollRepositoryProvider).getSheetById(sheetId);
                      if (context.mounted) {
                        _openSheet(sheet);
                      }
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Payout Sheet'),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Dropdown Filter Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.dividerColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
                      style: const TextStyle(
                        color: AppColors.textBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Row(
                            children: [
                              Icon(Icons.dashboard_outlined, size: 18, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('All Sheets'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'kharcha',
                          child: Row(
                            children: [
                              Icon(Icons.receipt_long, size: 18, color: Color(0xFF1E88E5)),
                              SizedBox(width: 8),
                              Text('Kharcha Sheets'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'overtime',
                          child: Row(
                            children: [
                              Icon(Icons.more_time, size: 18, color: Color(0xFFE65100)),
                              SizedBox(width: 8),
                              Text('Overtime Sheets'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedFilter = val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sheet List
            Expanded(
              child: sheetsAsync.when(
                data: (sheets) {
                  final filteredSheets = sheets.where((s) {
                    if (_selectedFilter == 'kharcha') return s.isKharcha;
                    if (_selectedFilter == 'overtime') return s.isOvertime;
                    return true;
                  }).toList();

                  if (filteredSheets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedFilter == 'overtime'
                                ? Icons.more_time
                                : Icons.request_quote_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedFilter == 'overtime'
                                ? 'No overtime sheets created yet.'
                                : _selectedFilter == 'kharcha'
                                    ? 'No kharcha sheets created yet.'
                                    : 'No payroll sheets created yet.',
                            style: const TextStyle(color: AppColors.textGrey, fontSize: 16),
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
                                final sheet = await ref
                                    .read(payrollRepositoryProvider)
                                    .getSheetById(sheetId);
                                if (context.mounted) {
                                  _openSheet(sheet);
                                }
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create Sheet'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredSheets.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final s = filteredSheets[index];

                      return InkWell(
                        onTap: () => _openSheet(s),
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
                                      : s.isOvertime
                                          ? const Color(0xFFFFB300).withValues(alpha: 0.15)
                                          : AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  s.isFinalized
                                      ? Icons.lock
                                      : s.isOvertime
                                          ? Icons.more_time
                                          : Icons.table_chart_outlined,
                                  color: s.isFinalized
                                      ? Colors.green[800]
                                      : s.isOvertime
                                          ? const Color(0xFFE65100)
                                          : AppColors.primaryDark,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Title & Tags
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

                                        // Sheet Type Badge (Kharcha vs Overtime)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: s.isOvertime
                                                ? const Color(0xFFFFD54F).withValues(alpha: 0.3)
                                                : Colors.blue.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: s.isOvertime
                                                  ? const Color(0xFFFFA000)
                                                  : Colors.blue.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Text(
                                            s.isOvertime ? 'OVERTIME' : 'KHARCHA',
                                            style: TextStyle(
                                              color: s.isOvertime
                                                  ? const Color(0xFFE65100)
                                                  : const Color(0xFF1565C0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),

                                        // Category Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            s.category,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
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
