import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/reports_providers.dart';
import '../widgets/report_date_range_picker.dart';

class MonthlyClosingReportDetailPage extends ConsumerWidget {
  const MonthlyClosingReportDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(monthlyClosingReportProvider);
    final currencyFmt = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Monthly Closing Report Insights'),
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
                    // Highlight Value Addition Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFF9A825),
                            Colors.amber.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NET VALUE ADDITION',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                currencyFmt.format(data.valueAddition),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Net capital addition created during this period (Closing Total - Opening Total)',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              size: 36,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Visual Comparison Chart
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Balance Sheet Position: Opening vs Closing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildLegendDot(Colors.blueGrey, 'Opening Balance'),
                              const SizedBox(width: 16),
                              _buildLegendDot(AppColors.primary, 'Closing Balance'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 260,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                titlesData: FlTitlesData(
                                  show: true,
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 60,
                                      getTitlesWidget: (val, _) {
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
                                      getTitlesWidget: (val, _) {
                                        const labels = [
                                          'Raw',
                                          'Finish',
                                          'Recov',
                                          'Cash',
                                          'Payables',
                                          'Balance'
                                        ];
                                        final idx = val.toInt();
                                        if (idx >= 0 && idx < labels.length) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              labels[idx],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
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
                                  _makeGroup(0, data.rawStockOpening,
                                      data.rawStockClosing),
                                  _makeGroup(1, data.finishProductOpening,
                                      data.finishProductClosing),
                                  _makeGroup(2, data.recoverableOpening,
                                      data.recoverableClosing),
                                  _makeGroup(3, data.cashInHandOpening,
                                      data.cashInHandClosing),
                                  _makeGroup(4, data.payablesOpening,
                                      data.payablesClosing),
                                  _makeGroup(5, data.balanceOpening,
                                      data.balanceClosing),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Spreadsheet View Format matching Image 1
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Orange Banner Header matching Image 1
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            color: const Color(0xFFE65100),
                            child: const Text(
                              'Monthly closing report',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Table(
                            border: TableBorder.all(color: Colors.grey.shade300),
                            columnWidths: const {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(3),
                            },
                            children: [
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade100),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Item',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Opening balance',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Closing Balance',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              // Raw Stock (+) - Light Green Row
                              _buildTableRow(
                                'Raw Stock (+)',
                                currencyFmt.format(data.rawStockOpening),
                                currencyFmt.format(data.rawStockClosing),
                                backgroundColor: const Color(0xFFE8F5E9),
                              ),
                              // Finish Product (+) - Light Green Row
                              _buildTableRow(
                                'Finish Product (+)',
                                currencyFmt.format(data.finishProductOpening),
                                currencyFmt.format(data.finishProductClosing),
                                backgroundColor: const Color(0xFFE8F5E9),
                              ),
                              // Recoverable (+)
                              _buildTableRow(
                                'Recoverable (+)',
                                currencyFmt.format(data.recoverableOpening),
                                currencyFmt.format(data.recoverableClosing),
                              ),
                              // Cash in hand (+)
                              _buildTableRow(
                                'Cash in hand (+)',
                                currencyFmt.format(data.cashInHandOpening),
                                currencyFmt.format(data.cashInHandClosing),
                              ),
                              // Payables (-)
                              _buildTableRow(
                                'Paybles (-)',
                                currencyFmt.format(data.payablesOpening),
                                currencyFmt.format(data.payablesClosing),
                              ),
                              // Balance
                              _buildTableRow(
                                'Balance',
                                currencyFmt.format(data.balanceOpening),
                                currencyFmt.format(data.balanceClosing),
                                isBold: true,
                              ),
                              // Domestic expenditure (deduction)
                              _buildTableRow(
                                'Domestic expenditure',
                                '-',
                                '-${currencyFmt.format(data.domesticExpenditure)}',
                                textColor: Colors.red.shade700,
                              ),
                              // Production expenditure (*) - Light Green Row
                              _buildTableRow(
                                'production expenditure (*)',
                                '-',
                                '-${currencyFmt.format(data.productionExpenditure)}',
                                backgroundColor: const Color(0xFFE8F5E9),
                                textColor: Colors.red.shade700,
                              ),
                              // Total
                              _buildTableRow(
                                'Total',
                                currencyFmt.format(data.totalOpening),
                                currencyFmt.format(data.totalClosing),
                                isBold: true,
                              ),
                              // Value Addition - Yellow Highlighted Row
                              TableRow(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD54F),
                                ),
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'Value Addition',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text('-', textAlign: TextAlign.right),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      currencyFmt.format(data.valueAddition),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
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

  BarChartGroupData _makeGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.blueGrey.shade400,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: y2,
          color: AppColors.primary,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  TableRow _buildTableRow(
    String title,
    String col1,
    String col2, {
    Color? backgroundColor,
    Color? textColor,
    bool isBold = false,
  }) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: textColor ?? Colors.black87,
    );
    return TableRow(
      decoration: BoxDecoration(color: backgroundColor),
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(title, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(col1, textAlign: TextAlign.right, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(col2, textAlign: TextAlign.right, style: style),
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
