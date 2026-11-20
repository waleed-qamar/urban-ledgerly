import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/provider/current_employee_provider.dart';
import '../../../dps/presentation/pages/dps_summary_page.dart';
import '../providers/reports_providers.dart';
import '../widgets/report_date_range_picker.dart';
import '../widgets/report_table_card.dart';
import 'financial_report_detail_page.dart';
import 'monthly_closing_report_detail_page.dart';
import 'production_expenditure_detail_page.dart';
import 'production_report_detail_page.dart';
import 'sale_stock_report_detail_page.dart';

class ReportsDashboardPage extends ConsumerWidget {
  const ReportsDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAli = ref.watch(isAliProvider);

    if (!isAli) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_person_outlined,
                    size: 64, color: Colors.red.shade400),
                const SizedBox(height: 18),
                const Text(
                  'Access Restricted',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Only Ali has administrative authorization to access the Reports module.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final bundleAsync = ref.watch(reportsDashboardBundleProvider);
    final numberFmt = NumberFormat('#,##0.##');
    final currencyFmt = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Title & Actions Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reports & Financial Closing',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Periodic production, sales, stock, and expenditure intelligence',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DpsSummaryPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.grid_view_rounded, size: 18),
                      label: const Text('DPS Report Summary'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Refresh Reports',
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                      onPressed: () {
                        ref.invalidate(reportsDashboardBundleProvider);
                        ref.invalidate(financialReportProvider);
                        ref.invalidate(productionReportProvider);
                        ref.invalidate(saleStockReportProvider);
                        ref.invalidate(productionExpenditureProvider);
                        ref.invalidate(monthlyClosingReportProvider);
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date Range Selector
            const ReportDateRangePicker(),

            const SizedBox(height: 24),

            bundleAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'Failed to generate reports: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              data: (bundle) {
                final fin = bundle.financial;
                final prod = bundle.production;
                final stock = bundle.saleStock;
                final close = bundle.closing;
                final exp = bundle.expenditure;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ROW 1: Financial Report & Production Report Side-by-Side (or stacked on small screens)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 900;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: _buildFinancialReportCard(
                                    context, fin, currencyFmt),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 5,
                                child: _buildProductionReportCard(
                                    context, prod, numberFmt),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildFinancialReportCard(
                                  context, fin, currencyFmt),
                              const SizedBox(height: 20),
                              _buildProductionReportCard(
                                  context, prod, numberFmt),
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // SECTION 2: Sale / Stock Report
                    ReportTableCard(
                      title: 'sale /stock report',
                      subtitle:
                          'Opening balance (a) + Produced (b) - Sold (c) = Stock (b+a-c)',
                      onViewDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SaleStockReportDetailPage(),
                          ),
                        );
                      },
                      child: Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade100),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('list of tiem',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Opening Balance\n(a)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Produced\n(b)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Sold\n(c)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Stock\n(b+a-c)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...stock.items.take(6).map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.productName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    numberFmt.format(item.openingBalance),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    numberFmt.format(item.produced),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    numberFmt.format(item.sold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    numberFmt.format(item.stock),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SECTION 3: Monthly Closing Report
                    ReportTableCard(
                      title: 'Monthly closing report',
                      headerColor: const Color(0xFFE65100),
                      onViewDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const MonthlyClosingReportDetailPage(),
                          ),
                        );
                      },
                      child: Table(
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
                                padding: EdgeInsets.all(8),
                                child: Text('Item',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Opening balance',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Closing Balance',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          _buildSimpleRow(
                            'Raw Stock (+)',
                            currencyFmt.format(close.rawStockOpening),
                            currencyFmt.format(close.rawStockClosing),
                            bgColor: const Color(0xFFE8F5E9),
                          ),
                          _buildSimpleRow(
                            'Finish Product (+)',
                            currencyFmt.format(close.finishProductOpening),
                            currencyFmt.format(close.finishProductClosing),
                            bgColor: const Color(0xFFE8F5E9),
                          ),
                          _buildSimpleRow(
                            'Recoverable (+)',
                            currencyFmt.format(close.recoverableOpening),
                            currencyFmt.format(close.recoverableClosing),
                          ),
                          _buildSimpleRow(
                            'Cash in hand (+)',
                            currencyFmt.format(close.cashInHandOpening),
                            currencyFmt.format(close.cashInHandClosing),
                          ),
                          _buildSimpleRow(
                            'Paybles (-)',
                            currencyFmt.format(close.payablesOpening),
                            currencyFmt.format(close.payablesClosing),
                          ),
                          _buildSimpleRow(
                            'Balance',
                            currencyFmt.format(close.balanceOpening),
                            currencyFmt.format(close.balanceClosing),
                            isBold: true,
                          ),
                          _buildSimpleRow(
                            'Domestic expenditure',
                            '-',
                            '-${currencyFmt.format(close.domesticExpenditure)}',
                            textColor: Colors.red.shade700,
                          ),
                          _buildSimpleRow(
                            'production expenditure (*)',
                            '-',
                            '-${currencyFmt.format(close.productionExpenditure)}',
                            bgColor: const Color(0xFFE8F5E9),
                            textColor: Colors.red.shade700,
                          ),
                          _buildSimpleRow(
                            'Total',
                            currencyFmt.format(close.totalOpening),
                            currencyFmt.format(close.totalClosing),
                            isBold: true,
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD54F),
                            ),
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Value Addition',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('-', textAlign: TextAlign.right),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  currencyFmt.format(close.valueAddition),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SECTION 4: Production Expenditure Chart
                    ReportTableCard(
                      title: 'Production expenditure chart',
                      headerColor: const Color(0xFFE65100),
                      onViewDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const ProductionExpenditureDetailPage(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Table(
                            border: TableBorder.all(color: Colors.grey.shade300),
                            columnWidths: const {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(3),
                            },
                            children: [
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Total weight',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      numberFmt.format(exp.totalWeight),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('kg', textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              _buildSimpleRow(
                                'Pure production expenditure',
                                currencyFmt.format(exp.pureProduction.totalAmount),
                                exp.pureProduction.costPerKg.toStringAsFixed(4),
                                bgColor: const Color(0xFFC8E6C9),
                                isBold: true,
                              ),
                              _buildSimpleRow(
                                'Managemetn Over Head',
                                currencyFmt
                                    .format(exp.managementOverhead.totalAmount),
                                exp.managementOverhead.costPerKg
                                    .toStringAsFixed(4),
                              ),
                              _buildSimpleRow(
                                'Maintenance over head',
                                currencyFmt
                                    .format(exp.maintenanceOverhead.totalAmount),
                                exp.maintenanceOverhead.costPerKg
                                    .toStringAsFixed(4),
                              ),
                              _buildSimpleRow(
                                'Sale Over head',
                                currencyFmt.format(exp.saleOverhead.totalAmount),
                                exp.saleOverhead.costPerKg.toStringAsFixed(4),
                              ),
                              _buildSimpleRow(
                                'Factory Over Head',
                                currencyFmt
                                    .format(exp.factoryOverhead.totalAmount),
                                exp.factoryOverhead.costPerKg.toStringAsFixed(4),
                              ),
                              _buildSimpleRow(
                                'Total Expenditure (*)',
                                currencyFmt.format(exp.totalExpenditure),
                                exp.totalCostPerKg.toStringAsFixed(4),
                                isBold: true,
                                bgColor: Colors.grey.shade100,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Table(
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
                                    padding: EdgeInsets.all(8),
                                    child: Text('Pure Production cost',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Over Heads',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      exp.pureProductionCostPerKg
                                          .toStringAsFixed(4),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      exp.overheadsCostPerKg.toStringAsFixed(4),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      exp.grandTotalCostPerKg.toStringAsFixed(4),
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

  Widget _buildFinancialReportCard(
    BuildContext context,
    dynamic fin,
    NumberFormat currencyFmt,
  ) {
    return ReportTableCard(
      title: 'Financial Report',
      onViewDetails: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const FinancialReportDetailPage(),
          ),
        );
      },
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
        },
        children: [
          _buildSimpleRow(
              'Monthly sale', currencyFmt.format(fin.monthlySale), ''),
          _buildSimpleRow(
              'Monthly recovery', currencyFmt.format(fin.monthlyRecovery), ''),
          _buildSimpleRow('monthly production',
              currencyFmt.format(fin.monthlyProduction), ''),
        ],
      ),
    );
  }

  Widget _buildProductionReportCard(
    BuildContext context,
    dynamic prod,
    NumberFormat numberFmt,
  ) {
    return ReportTableCard(
      title: 'Production Report',
      trailing: TextButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const DpsSummaryPage(),
            ),
          );
        },
        icon: const Icon(Icons.grid_view_rounded, size: 16),
        label: const Text('DPS Summary'),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      onViewDetails: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ProductionReportDetailPage(),
          ),
        );
      },
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            children: const [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('List of item',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('qty',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ...prod.items.take(4).map((item) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.productName),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(numberFmt.format(item.quantity),
                      textAlign: TextAlign.right),
                ),
              ],
            );
          }),
          TableRow(
            decoration:
                BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08)),
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('total weight',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${numberFmt.format(prod.totalWeight)} kg',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildSimpleRow(
    String col1,
    String col2,
    String col3, {
    Color? bgColor,
    Color? textColor,
    bool isBold = false,
  }) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: textColor ?? Colors.black87,
    );
    return TableRow(
      decoration: BoxDecoration(color: bgColor),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(col1, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(col2, textAlign: TextAlign.right, style: style),
        ),
        if (col3.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(col3, textAlign: TextAlign.right, style: style),
          ),
      ],
    );
  }
}
