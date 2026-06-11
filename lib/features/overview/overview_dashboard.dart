import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'presentation/providers/overview_providers.dart';
import 'expenditure_overview/expenditure_detailed_view.dart';
import 'recovery_overview/recovery_detailed_view.dart';
import 'sales_overview/sales_detailed_view.dart';

class OverviewDashboard extends ConsumerWidget {
  const OverviewDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenditureAsync = ref.watch(expenditureOverviewProvider);
    final recoveryAsync = ref.watch(recoveryOverviewProvider);
    final salesAsync = ref.watch(salesOverviewProvider);

    final currencyFormatter = NumberFormat.currency(
      symbol: 'Rs. ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome / Title Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Premium calendar date display
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.5.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: 14.sp,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Responsive grid of the 3 overview cards
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isWide ? 3 : 1,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: isWide ? 1.0 : 1.6,
                  children: [
                    // Card 1: Expenditure
                    expenditureAsync.when(
                      loading: () => const _LoadingCard(),
                      error: (err, _) => _ErrorCard(error: err.toString()),
                      data: (data) => _OverviewCard(
                        title: 'Expenditure Overview',
                        subtitle: 'Spending patterns & category costs',
                        primaryValue: currencyFormatter.format(
                          data.totalExpenditure,
                        ),
                        primaryLabel: 'Total Expenditure',
                        metrics: [
                          _MetricRow(
                            label: 'This Month',
                            value: currencyFormatter.format(
                              data.expenditureThisMonth,
                            ),
                          ),
                          _MetricRow(
                            label: 'Spend Today',
                            value: currencyFormatter.format(
                              data.expenditureToday,
                            ),
                          ),
                          _MetricRow(
                            label: 'Daily Average',
                            value: currencyFormatter.format(data.averageDaily),
                          ),
                        ],
                        icon: Icons.account_balance_wallet,
                        accentColor: Colors.teal,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExpenditureDetailedView(),
                          ),
                        ),
                      ),
                    ),

                    // Card 2: Recovery
                    recoveryAsync.when(
                      loading: () => const _LoadingCard(),
                      error: (err, _) => _ErrorCard(error: err.toString()),
                      data: (data) => _OverviewCard(
                        title: 'Recovery Overview',
                        subtitle: 'Collections, rate & outstanding due',
                        primaryValue: currencyFormatter.format(
                          data.totalRecovery,
                        ),
                        primaryLabel: 'Total Recovery',
                        metrics: [
                          _MetricRow(
                            label: 'Recovery Rate',
                            value: '${data.recoveryRate.toStringAsFixed(1)}%',
                          ),
                          _MetricRow(
                            label: 'Outstanding Balance',
                            value: currencyFormatter.format(
                              data.outstandingBalance,
                            ),
                          ),
                          _MetricRow(
                            label: 'Overdue Balance',
                            value: currencyFormatter.format(data.overdueAmount),
                          ),
                        ],
                        icon: Icons.price_check,
                        accentColor: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecoveryDetailedView(),
                          ),
                        ),
                      ),
                    ),

                    // Card 3: Sales
                    salesAsync.when(
                      loading: () => const _LoadingCard(),
                      error: (err, _) => _ErrorCard(error: err.toString()),
                      data: (data) => _OverviewCard(
                        title: 'Sales Overview',
                        subtitle: 'Revenue metrics & orders funnel',
                        primaryValue: currencyFormatter.format(data.totalSales),
                        primaryLabel: 'Total Sales',
                        metrics: [
                          _MetricRow(
                            label: 'Growth',
                            value:
                                '${data.salesGrowth >= 0 ? '+' : ''}${data.salesGrowth.toStringAsFixed(1)}%',
                            valueColor: data.salesGrowth >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                          _MetricRow(
                            label: 'Orders Count',
                            value: data.orderCount.toString(),
                          ),
                          _MetricRow(
                            label: 'Avg Order Value (AOV)',
                            value: currencyFormatter.format(
                              data.averageOrderValue,
                            ),
                          ),
                        ],
                        icon: Icons.trending_up,
                        accentColor: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SalesDetailedView(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String primaryValue;
  final String primaryLabel;
  final List<_MetricRow> metrics;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _OverviewCard({
    required this.title,
    required this.subtitle,
    required this.primaryValue,
    required this.primaryLabel,
    required this.metrics,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<_OverviewCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: _isHovered
              ? Matrix4.translationValues(0, -1.h, 0)
              : Matrix4.identity(),
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.5)
                  : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.accentColor.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: _isHovered ? 20 : 8,
                offset: _isHovered ? const Offset(0, 10) : const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Icon Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 2.2.h,
                    backgroundColor: widget.accentColor.withValues(alpha: 0.1),
                    child: Icon(widget.icon, color: widget.accentColor, size: 14.sp),
                  ),
                ],
              ),
              const Spacer(),

              // Primary Value
              Text(
                widget.primaryLabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                widget.primaryValue,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 1.5.h),
              const Divider(),
              SizedBox(height: 1.5.h),

              // Sub-metrics
              ...widget.metrics.map(
                (m) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        m.label,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        m.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: m.valueColor ?? Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: widget.accentColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 0.5.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 11.sp,
                    color: widget.accentColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRow {
  final String label;
  final String value;
  final Color? valueColor;

  _MetricRow({required this.label, required this.value, this.valueColor});
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;
  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Text(
          'Error: $error',
          style: TextStyle(color: Colors.red.shade700, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
