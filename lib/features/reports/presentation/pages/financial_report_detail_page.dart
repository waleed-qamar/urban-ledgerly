import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/reports_providers.dart';
import '../widgets/report_date_range_picker.dart';

class FinancialReportDetailPage extends ConsumerWidget {
  const FinancialReportDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(financialReportProvider);
    final currencyFmt = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Financial Report Insights'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ReportDateRangePicker(),
            const SizedBox(height: 20),

            reportAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('Error loading report: $err',
                      style: const TextStyle(color: Colors.red)),
                ),
              ),
              data: (data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // KPI Cards Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Monthly Sale',
                            value: currencyFmt.format(data.monthlySale),
                            subtitle: 'Invoiced grand total',
                            icon: Icons.point_of_sale,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Monthly Recovery',
                            value: currencyFmt.format(data.monthlyRecovery),
                            subtitle: 'Cash & bank receipts',
                            icon: Icons.payments,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Monthly Production',
                            value: currencyFmt.format(data.monthlyProduction),
                            subtitle: 'Base price × Qty produced',
                            icon: Icons.precision_manufacturing,
                            color: Colors.deepOrange.shade700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Chart Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Financial Performance Comparison',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Comparison of sales, collections, and manufactured value in this period',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 280,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: [
                                      data.monthlySale,
                                      data.monthlyRecovery,
                                      data.monthlyProduction,
                                      1000.0
                                    ].reduce((a, b) => a > b ? a : b) *
                                    1.2,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                      final titles = [
                                        'Sale',
                                        'Recovery',
                                        'Production'
                                      ];
                                      return BarTooltipItem(
                                        '${titles[group.x]}: ${currencyFmt.format(rod.toY)}',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 60,
                                      getTitlesWidget: (val, meta) {
                                        if (val == 0) return const SizedBox();
                                        return Text(
                                          val >= 1000000
                                              ? '${(val / 1000000).toStringAsFixed(1)}M'
                                              : val >= 1000
                                                  ? '${(val / 1000).toStringAsFixed(0)}K'
                                                  : val.toStringAsFixed(0),
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (val, meta) {
                                        switch (val.toInt()) {
                                          case 0:
                                            return const Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text('Sale',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            );
                                          case 1:
                                            return const Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text('Recovery',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            );
                                          case 2:
                                            return const Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text('Production',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            );
                                          default:
                                            return const SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (val) => FlLine(
                                    color: Colors.grey.shade200,
                                    strokeWidth: 1,
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: [
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(
                                        toY: data.monthlySale,
                                        color: Colors.blue.shade600,
                                        width: 40,
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(6)),
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(
                                        toY: data.monthlyRecovery,
                                        color: Colors.green.shade600,
                                        width: 40,
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(6)),
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(
                                        toY: data.monthlyProduction,
                                        color: Colors.deepOrange.shade600,
                                        width: 40,
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(6)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Spreadsheet View Format
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Financial Report Summary Table',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Table(
                            border: TableBorder.all(color: Colors.grey.shade300),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(3),
                            },
                            children: [
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade100),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Metric',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Amount (PKR)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Monthly sale'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                        currencyFmt.format(data.monthlySale),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Monthly recovery'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                        currencyFmt
                                            .format(data.monthlyRecovery),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Monthly production'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                        currencyFmt
                                            .format(data.monthlyProduction),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
