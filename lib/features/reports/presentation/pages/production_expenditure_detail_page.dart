import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/production_expenditure_model.dart';
import '../providers/reports_providers.dart';
import '../widgets/report_date_range_picker.dart';

class ProductionExpenditureDetailPage extends ConsumerWidget {
  const ProductionExpenditureDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(productionExpenditureProvider);
    final numberFmt = NumberFormat('#,##0.##');
    final currencyFmt = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Production Expenditure Insights'),
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
                    // KPI Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Total Production Weight',
                            value: '${numberFmt.format(data.totalWeight)} kg',
                            subtitle: 'Production output base',
                            icon: Icons.scale,
                            color: Colors.teal.shade700,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Pure Production / kg',
                            value: 'Rs. ${data.pureProductionCostPerKg.toStringAsFixed(2)}',
                            subtitle: currencyFmt.format(data.pureProduction.totalAmount),
                            icon: Icons.precision_manufacturing,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Overheads / kg',
                            value: 'Rs. ${data.overheadsCostPerKg.toStringAsFixed(2)}',
                            subtitle: 'Admin, Maint, Sale, Factory',
                            icon: Icons.account_balance,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Total Cost / kg',
                            value: 'Rs. ${data.grandTotalCostPerKg.toStringAsFixed(2)}',
                            subtitle: currencyFmt.format(data.totalExpenditure),
                            icon: Icons.price_check,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Visual Cost Breakdown Chart
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
                            'Cost per Kg Breakdown (Rs. / kg)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Comparison of direct production expense vs operational overheads per kg',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 240,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                titlesData: FlTitlesData(
                                  show: true,
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      getTitlesWidget: (val, _) => Text(
                                        'Rs. ${val.toInt()}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (val, _) {
                                        const labels = [
                                          'Pure Prod',
                                          'Mgmt',
                                          'Maint',
                                          'Sale',
                                          'Factory'
                                        ];
                                        final idx = val.toInt();
                                        if (idx >= 0 && idx < labels.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8),
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
                                      sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)),
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
                                  _makeSingleBar(0, data.pureProduction.costPerKg,
                                      const Color(0xFF2E7D32)),
                                  _makeSingleBar(1, data.managementOverhead.costPerKg,
                                      Colors.indigo),
                                  _makeSingleBar(2, data.maintenanceOverhead.costPerKg,
                                      Colors.amber.shade800),
                                  _makeSingleBar(3, data.saleOverhead.costPerKg,
                                      Colors.blue),
                                  _makeSingleBar(4, data.factoryOverhead.costPerKg,
                                      Colors.purple),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Primary Spreadsheet View Table matching Image 1
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
                          // Orange Banner matching Image 1
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            color: const Color(0xFFE65100),
                            child: const Text(
                              'Production expenditure chart',
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
                              // Row: Total weight
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Total weight',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      numberFmt.format(data.totalWeight),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('kg', textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              // Pure production expenditure (Green highlighted in Image 1)
                              _buildExpenseRow(
                                'Pure production expenditure',
                                currencyFmt.format(data.pureProduction.totalAmount),
                                data.pureProduction.costPerKg.toStringAsFixed(4),
                                backgroundColor: const Color(0xFFC8E6C9),
                                isBold: true,
                              ),
                              // Management Over Head
                              _buildExpenseRow(
                                'Managemetn Over Head',
                                currencyFmt.format(data.managementOverhead.totalAmount),
                                data.managementOverhead.costPerKg.toStringAsFixed(4),
                              ),
                              // Maintenance over head
                              _buildExpenseRow(
                                'Maintenance over head',
                                currencyFmt.format(data.maintenanceOverhead.totalAmount),
                                data.maintenanceOverhead.costPerKg.toStringAsFixed(4),
                              ),
                              // Sale Over head
                              _buildExpenseRow(
                                'Sale Over head',
                                currencyFmt.format(data.saleOverhead.totalAmount),
                                data.saleOverhead.costPerKg.toStringAsFixed(4),
                              ),
                              // Factory Over Head
                              _buildExpenseRow(
                                'Factory Over Head',
                                currencyFmt.format(data.factoryOverhead.totalAmount),
                                data.factoryOverhead.costPerKg.toStringAsFixed(4),
                              ),
                              // Total Expenditure (*)
                              _buildExpenseRow(
                                'Total Expenditure (*)',
                                currencyFmt.format(data.totalExpenditure),
                                data.totalCostPerKg.toStringAsFixed(4),
                                backgroundColor: Colors.grey.shade100,
                                isBold: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Summary Breakdown Box matching bottom of Image 1
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Table(
                              border: TableBorder.all(color: Colors.grey.shade300),
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(1),
                                2: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  decoration:
                                      BoxDecoration(color: Colors.grey.shade100),
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Pure Production cost',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Over Heads',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        data.pureProductionCostPerKg
                                            .toStringAsFixed(4),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        data.overheadsCostPerKg
                                            .toStringAsFixed(4),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        data.grandTotalCostPerKg
                                            .toStringAsFixed(4),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Detailed Heads Breakdown by Category (From Image 2 & CSV)
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
                            'Expense Heads Breakdown (Categorized)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildCategoryAccordion(
                              data.pureProduction, currencyFmt),
                          _buildCategoryAccordion(
                              data.managementOverhead, currencyFmt),
                          _buildCategoryAccordion(
                              data.maintenanceOverhead, currencyFmt),
                          _buildCategoryAccordion(data.saleOverhead, currencyFmt),
                          _buildCategoryAccordion(
                              data.factoryOverhead, currencyFmt),
                          _buildCategoryAccordion(data.vehicles, currencyFmt),
                          _buildCategoryAccordion(data.domestic, currencyFmt),
                          _buildCategoryAccordion(data.development, currencyFmt),
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

  Widget _buildCategoryAccordion(
    ExpenditureCategoryDetail category,
    NumberFormat currencyFmt,
  ) {
    if (category.subHeads.isEmpty && category.totalAmount == 0) {
      return const SizedBox();
    }
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          category.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        trailing: Text(
          currencyFmt.format(category.totalAmount),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 14,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Column(
              children: category.subHeads.map((sub) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sub.expenseHeadName,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                      Text(
                        currencyFmt.format(sub.amount),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeSingleBar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  TableRow _buildExpenseRow(
    String label,
    String col1,
    String col2, {
    Color? backgroundColor,
    bool isBold = false,
  }) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: Colors.black87,
    );
    return TableRow(
      decoration: BoxDecoration(color: backgroundColor),
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(label, style: style),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
