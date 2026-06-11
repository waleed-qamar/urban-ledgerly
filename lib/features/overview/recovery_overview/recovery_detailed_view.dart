import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../presentation/providers/overview_providers.dart';

class RecoveryDetailedView extends ConsumerWidget {
  const RecoveryDetailedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recoveryAsync = ref.watch(recoveryOverviewProvider);
    final currencyFormatter = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Recovery Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: recoveryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading recovery data: $err')),
        data: (data) {
          final sortedTrend = data.monthlyTrend.entries.toList();
          sortedTrend.sort((a, b) => a.key.compareTo(b.key));

          final methods = data.recoveryByPaymentMethod.entries.toList();
          final customers = data.recoveryByCustomer.entries.toList();
          customers.sort((a, b) => b.value.compareTo(a.value));

          final isMobile = Device.screenType == ScreenType.mobile;

          return SingleChildScrollView(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metrics Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 2 : 5,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: isMobile ? 1.4 : 1.3,
                  children: [
                    _buildSummaryCard(
                      context,
                      'Total Recovery',
                      currencyFormatter.format(data.totalRecovery),
                      Icons.price_check,
                      Colors.teal,
                    ),
                    _buildSummaryCard(
                      context,
                      'Recovery This Month',
                      currencyFormatter.format(data.recoveryThisMonth),
                      Icons.insights,
                      Colors.blue,
                    ),
                    _buildSummaryCard(
                      context,
                      'Recovery Rate',
                      '${data.recoveryRate.toStringAsFixed(1)}%',
                      Icons.percent,
                      Colors.orange,
                    ),
                    _buildSummaryCard(
                      context,
                      'Outstanding Balance',
                      currencyFormatter.format(data.outstandingBalance),
                      Icons.pending_actions,
                      Colors.red,
                    ),
                    _buildSummaryCard(
                      context,
                      'Overdue Balance',
                      currencyFormatter.format(data.overdueAmount),
                      Icons.running_with_errors,
                      Colors.deepOrange,
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Charts Row 1: Trend and Recovered vs Outstanding
                isMobile
                    ? Column(
                        children: [
                          _buildTrendChart(sortedTrend),
                          SizedBox(height: 2.h),
                          _buildDonutChart(data, currencyFormatter),
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
                            child: _buildDonutChart(data, currencyFormatter),
                          ),
                        ],
                      ),
                SizedBox(height: 3.h),

                // Row 2: Aging Analysis and Customer/Payment Breakdown
                isMobile
                    ? Column(
                        children: [
                          _buildAgingAnalysis(data, currencyFormatter),
                          SizedBox(height: 2.h),
                          _buildBreakdowns(methods, customers, currencyFormatter),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildAgingAnalysis(data, currencyFormatter),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildBreakdowns(methods, customers, currencyFormatter),
                          ),
                        ],
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
              'Recovery Trend Over Time',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 28.h,
              child: sortedTrend.isEmpty
                  ? const Center(child: Text('No historical recovery trend available'))
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
                            color: Colors.teal,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.teal.withValues(alpha: 0.1),
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

  Widget _buildDonutChart(dynamic data, NumberFormat currencyFormatter) {
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
              'Recovered vs Outstanding',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              height: 22.h,
              child: (data.totalRecovery == 0 && data.outstandingBalance == 0)
                  ? const Center(child: Text('No recovery data available'))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            color: Colors.teal,
                            value: data.totalRecovery,
                            title: 'Recovered',
                            radius: 40,
                            titleStyle: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: data.outstandingBalance,
                            title: 'Outstanding',
                            radius: 40,
                            titleStyle: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 3.h),
            _buildLegendItem('Recovered Amount', currencyFormatter.format(data.totalRecovery), Colors.teal),
            SizedBox(height: 1.h),
            _buildLegendItem('Outstanding Balance', currencyFormatter.format(data.outstandingBalance), Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildAgingAnalysis(dynamic data, NumberFormat currencyFormatter) {
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
              'Aging Analysis (Invoice Overdue)',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            _buildAgingProgressRow('0 - 30 Days', data.agingAnalysis['0-30'] ?? 0.0, data.outstandingBalance, currencyFormatter, Colors.teal),
            SizedBox(height: 1.5.h),
            _buildAgingProgressRow('31 - 60 Days', data.agingAnalysis['31-60'] ?? 0.0, data.outstandingBalance, currencyFormatter, Colors.amber.shade700),
            SizedBox(height: 1.5.h),
            _buildAgingProgressRow('61 - 90 Days', data.agingAnalysis['61-90'] ?? 0.0, data.outstandingBalance, currencyFormatter, Colors.orange),
            SizedBox(height: 1.5.h),
            _buildAgingProgressRow('90+ Days', data.agingAnalysis['90+'] ?? 0.0, data.outstandingBalance, currencyFormatter, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdowns(List<MapEntry<String, double>> methods, List<MapEntry<String, double>> customers, NumberFormat currencyFormatter) {
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
              'Recovery by Customer & Method',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
            SizedBox(height: 1.h),
            ...methods.map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
                      Text(currencyFormatter.format(e.value), style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp)),
                    ],
                  ),
                )),
            Divider(height: 3.h),
            Text('Top Recoveries by Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
            SizedBox(height: 1.h),
            ...customers.take(5).map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(e.key, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp))),
                      Text(currencyFormatter.format(e.value), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp)),
                    ],
                  ),
                )),
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

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 1.2.h,
          height: 1.2.h,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 2.w),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildAgingProgressRow(String label, double value, double total, NumberFormat formatter, Color color) {
    final pct = total > 0 ? value / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
            Text(formatter.format(value), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 0.5.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 1.h,
          ),
        ),
      ],
    );
  }
}
