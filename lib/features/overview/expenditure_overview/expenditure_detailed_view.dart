import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../presentation/providers/overview_providers.dart';

class ExpenditureDetailedView extends ConsumerWidget {
  const ExpenditureDetailedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenditureAsync = ref.watch(expenditureOverviewProvider);
    final currencyFormatter = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Expenditure Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: expenditureAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading expenditure data: $err')),
        data: (data) {
          final categories = data.expensesByCategory.entries.toList();
          categories.sort((a, b) => b.value.compareTo(a.value));

          final sortedTrend = data.monthlyTrend.entries.toList();
          sortedTrend.sort((a, b) => a.key.compareTo(b.key));

          final isMobile = Device.screenType == ScreenType.mobile;

          return SingleChildScrollView(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 2 : 4,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: isMobile ? 1.4 : 1.3,
                  children: [
                    _buildSummaryCard(
                      context,
                      'Total Expenditure',
                      currencyFormatter.format(data.totalExpenditure),
                      Icons.account_balance_wallet,
                      Colors.teal,
                    ),
                    _buildSummaryCard(
                      context,
                      'Spend This Month',
                      currencyFormatter.format(data.expenditureThisMonth),
                      Icons.calendar_month,
                      Colors.blue,
                    ),
                    _buildSummaryCard(
                      context,
                      'Spend Today',
                      currencyFormatter.format(data.expenditureToday),
                      Icons.today,
                      Colors.orange,
                    ),
                    _buildSummaryCard(
                      context,
                      'Monthly Average',
                      currencyFormatter.format(data.averageMonthly),
                      Icons.analytics,
                      Colors.purple,
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Charts Section
                isMobile
                    ? Column(
                        children: [
                          _buildTrendChart(sortedTrend),
                          SizedBox(height: 2.h),
                          _buildCategoryAllocation(categories, data.totalExpenditure),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTrendChart(sortedTrend),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 2,
                            child: _buildCategoryAllocation(categories, data.totalExpenditure),
                          ),
                        ],
                      ),
                SizedBox(height: 3.h),

                // Recent Transactions List
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2.h),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.recentTransactions.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final tx = data.recentTransactions[index];
                            final dt = tx['date'] as DateTime;
                            final formattedDate = DateFormat('MMM dd, yyyy').format(dt);
                            final amount = currencyFormatter.format(tx['amount']);
                            final isDisb = tx['type'] == 'disbursement';

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isDisb ? Colors.indigo.shade50 : Colors.teal.shade50,
                                child: Icon(
                                  isDisb ? Icons.payment : Icons.receipt_long,
                                  color: isDisb ? Colors.indigo : Colors.teal,
                                  size: 14.sp,
                                ),
                              ),
                              title: Text(tx['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                              subtitle: Text('${tx['remarks']}\n$formattedDate', style: TextStyle(fontSize: 11.sp)),
                              trailing: Text(
                                amount,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                              ),
                              isThreeLine: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendChart(List<MapEntry<String, double>> sortedTrend) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Spend Trend',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            Text(
              'Shows transaction volumes across billing periods.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 28.h,
              child: sortedTrend.isEmpty
                  ? const Center(child: Text('No historical spend trend available'))
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx >= 0 && idx < sortedTrend.length) {
                                  final key = sortedTrend[idx].key; // yyyy-MM
                                  final parts = key.split('-');
                                  if (parts.length == 2) {
                                    final monthNum = int.tryParse(parts[1]) ?? 1;
                                    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                    return Text(
                                      monthNames[monthNum - 1],
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11.sp),
                                    );
                                  }
                                  return Text(key, style: TextStyle(fontSize: 11.sp));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: sortedTrend.asMap().entries.map((e) {
                              return FlSpot(e.key.toDouble(), e.value.value);
                            }).toList(),
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAllocation(List<MapEntry<String, double>> categories, double totalExpenditure) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Allocation',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 22.h,
              child: categories.isEmpty
                  ? const Center(child: Text('No spending categories'))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildPieSections(categories),
                      ),
                    ),
            ),
            SizedBox(height: 2.h),
            Column(
              children: categories.asMap().entries.map((entry) {
                final idx = entry.key;
                final cat = entry.value;
                final color = _getColor(idx);
                final pct = totalExpenditure > 0
                    ? (cat.value / totalExpenditure) * 100
                    : 0.0;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    children: [
                      Container(
                        width: 1.5.h,
                        height: 1.5.h,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          cat.key,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${pct.toStringAsFixed(1)}%',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(List<MapEntry<String, double>> categories) {
    double total = categories.fold(0.0, (sum, item) => sum + item.value);
    if (total == 0) return [];

    return categories.asMap().entries.map((entry) {
      final idx = entry.key;
      final cat = entry.value;
      final pct = (cat.value / total) * 100;
      final color = _getColor(idx);

      return PieChartSectionData(
        color: color,
        value: cat.value,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Color _getColor(int index) {
    final colors = [
      Colors.teal,
      Colors.indigo,
      Colors.amber.shade700,
      Colors.pink,
      Colors.cyan,
      Colors.purple,
      Colors.deepOrange,
      Colors.blue,
    ];
    return colors[index % colors.length];
  }
}
