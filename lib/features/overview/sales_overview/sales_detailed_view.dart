import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../presentation/providers/overview_providers.dart';

class SalesDetailedView extends ConsumerWidget {
  const SalesDetailedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesOverviewProvider);
    final currencyFormatter = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Sales Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading sales data: $err')),
        data: (data) {
          final sortedTrend = data.salesTrend.entries.toList();
          sortedTrend.sort((a, b) => a.key.compareTo(b.key));

          final depts = data.salesByCategory.entries.toList();
          final customers = data.salesByCustomer.entries.toList();
          customers.sort((a, b) => b.value.compareTo(a.value));

          final isMobile = Device.screenType == ScreenType.mobile;

          return SingleChildScrollView(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metrics Grid (containing all 8 cards)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 2 : 4,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: isMobile ? 1.4 : 1.3,
                  children: [
                    _buildSummaryCard(context, 'Total Sales', currencyFormatter.format(data.totalSales), Icons.payments, Colors.teal),
                    _buildSummaryCard(context, 'Sales Today', currencyFormatter.format(data.salesToday), Icons.flash_on, Colors.orange),
                    _buildSummaryCard(context, 'Sales This Month', currencyFormatter.format(data.salesThisMonth), Icons.calendar_today, Colors.blue),
                    _buildSummaryCard(
                      context,
                      'Growth',
                      '${data.salesGrowth >= 0 ? '+' : ''}${data.salesGrowth.toStringAsFixed(1)}%',
                      data.salesGrowth >= 0 ? Icons.trending_up : Icons.trending_down,
                      data.salesGrowth >= 0 ? Colors.green : Colors.red,
                    ),
                    _buildSummaryCard(context, 'Avg Order Value (AOV)', currencyFormatter.format(data.averageOrderValue), Icons.shopping_bag, Colors.purple),
                    _buildSummaryCard(context, 'Orders Count', data.orderCount.toString(), Icons.receipt, Colors.indigo),
                    _buildSummaryCard(context, 'Gross Revenue', currencyFormatter.format(data.grossRevenue), Icons.attach_money, Colors.teal),
                    _buildSummaryCard(context, 'Net Revenue', currencyFormatter.format(data.netRevenue), Icons.filter_list, Colors.cyan),
                  ],
                ),
                SizedBox(height: 3.h),

                // Charts Row 1: Trend and Funnel
                isMobile
                    ? Column(
                        children: [
                          _buildTrendChart(sortedTrend),
                          SizedBox(height: 2.h),
                          _buildFunnelChart(data, currencyFormatter),
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
                            child: _buildFunnelChart(data, currencyFormatter),
                          ),
                        ],
                      ),
                SizedBox(height: 3.h),

                // Row 2: Top Selling Products and Client Segment (Department)
                isMobile
                    ? Column(
                        children: [
                          _buildTopProducts(data, currencyFormatter),
                          SizedBox(height: 2.h),
                          _buildBreakdowns(depts, customers, currencyFormatter),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTopProducts(data, currencyFormatter),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildBreakdowns(depts, customers, currencyFormatter),
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
              'Sales Volume Trend',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 28.h,
              child: sortedTrend.isEmpty
                  ? const Center(child: Text('No historical sales trend available'))
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

  Widget _buildFunnelChart(dynamic data, NumberFormat currencyFormatter) {
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
              'Sales Funnel',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3.h),
            _buildFunnelStage(
              'Orders Created',
              data.salesFunnel['Orders'] ?? 0.0,
              1.0,
              currencyFormatter,
              Colors.indigo.shade700,
            ),
            _buildFunnelConnector(),
            _buildFunnelStage(
              'Invoiced Sales',
              data.salesFunnel['Invoiced'] ?? 0.0,
              (data.salesFunnel['Orders'] ?? 0.0) > 0
                  ? (data.salesFunnel['Invoiced'] ?? 0.0) / (data.salesFunnel['Orders'] ?? 0.0)
                  : 1.0,
              currencyFormatter,
              Colors.teal,
            ),
            _buildFunnelConnector(),
            _buildFunnelStage(
              'Recovered Cash',
              data.salesFunnel['Recovered'] ?? 0.0,
              (data.salesFunnel['Invoiced'] ?? 0.0) > 0
                  ? (data.salesFunnel['Recovered'] ?? 0.0) / (data.salesFunnel['Invoiced'] ?? 0.0)
                  : 1.0,
              currencyFormatter,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts(dynamic data, NumberFormat currencyFormatter) {
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
              'Top Performing Products',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            if (data.topProducts.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('No product sales recorded yet'),
              ))
            else
              ...data.topProducts.map((p) {
                final name = p['name'] as String;
                final amount = p['amount'] as double;
                final qty = p['quantity'] as double;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.8.h),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        foregroundColor: AppColors.primary,
                        radius: 2.2.h,
                        child: Icon(Icons.inventory_2, size: 14.sp),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                            SizedBox(height: 0.5.h),
                            Text('Quantity: ${qty.toStringAsFixed(0)} units', style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp)),
                          ],
                        ),
                      ),
                      Text(currencyFormatter.format(amount), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdowns(List<MapEntry<String, double>> depts, List<MapEntry<String, double>> customers, NumberFormat currencyFormatter) {
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
              'Customer & Department Breakdown',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            Text('Sales by Customer Department', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
            SizedBox(height: 1.h),
            ...depts.map((e) => Padding(
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
            Text('Top Sales by Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
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

  Widget _buildFunnelStage(String stage, double value, double conversion, NumberFormat formatter, Color color) {
    final widthFactor = conversion.clamp(0.4, 1.0);
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
            width: 30.w * widthFactor,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Text(stage, style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 0.5.h),
                Text(formatter.format(value), style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                if (conversion < 1.0) ...[
                  SizedBox(height: 0.5.h),
                  Text('Conversion: ${(conversion * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelConnector() {
    return Center(
      child: Container(
        height: 2.h,
        width: 2,
        color: Colors.grey.shade300,
      ),
    );
  }
}
