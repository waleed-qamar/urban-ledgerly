import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/reports_remote_datasource.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/entities/financial_report_model.dart';
import '../../domain/entities/production_report_model.dart';
import '../../domain/entities/sale_stock_report_model.dart';
import '../../domain/entities/monthly_closing_model.dart';
import '../../domain/entities/production_expenditure_model.dart';
import '../../domain/repositories/reports_repository.dart';
import 'reports_filter_provider.dart';

final reportsRemoteDatasourceProvider = Provider<ReportsRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ReportsRemoteDatasource(client);
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final datasource = ref.watch(reportsRemoteDatasourceProvider);
  return ReportsRepositoryImpl(datasource);
});

/// Financial Report Provider
final financialReportProvider = FutureProvider<FinancialReportModel>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final range = ref.watch(reportDateRangeProvider);
  return repo.getFinancialReport(range);
});

/// Production Report Provider
final productionReportProvider = FutureProvider<ProductionReportModel>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final range = ref.watch(reportDateRangeProvider);
  return repo.getProductionReport(range);
});

/// Sale / Stock Report Provider
final saleStockReportProvider = FutureProvider<SaleStockReportModel>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final range = ref.watch(reportDateRangeProvider);
  return repo.getSaleStockReport(range);
});

/// Production Expenditure Provider
final productionExpenditureProvider =
    FutureProvider<ProductionExpenditureModel>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final range = ref.watch(reportDateRangeProvider);
  final prodReport = await ref.watch(productionReportProvider.future);
  return repo.getProductionExpenditure(range, totalWeight: prodReport.totalWeight);
});

/// Monthly Closing Report Provider
final monthlyClosingReportProvider =
    FutureProvider<MonthlyClosingModel>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final range = ref.watch(reportDateRangeProvider);
  final expModel = await ref.watch(productionExpenditureProvider.future);
  return repo.getMonthlyClosingReport(range, expenditureModel: expModel);
});

/// Combined report bundle for Dashboard
class ReportsDashboardBundle {
  final FinancialReportModel financial;
  final ProductionReportModel production;
  final SaleStockReportModel saleStock;
  final ProductionExpenditureModel expenditure;
  final MonthlyClosingModel closing;

  const ReportsDashboardBundle({
    required this.financial,
    required this.production,
    required this.saleStock,
    required this.expenditure,
    required this.closing,
  });
}

final reportsDashboardBundleProvider =
    FutureProvider<ReportsDashboardBundle>((ref) async {
  final financial = await ref.watch(financialReportProvider.future);
  final production = await ref.watch(productionReportProvider.future);
  final saleStock = await ref.watch(saleStockReportProvider.future);
  final expenditure = await ref.watch(productionExpenditureProvider.future);
  final closing = await ref.watch(monthlyClosingReportProvider.future);

  return ReportsDashboardBundle(
    financial: financial,
    production: production,
    saleStock: saleStock,
    expenditure: expenditure,
    closing: closing,
  );
});
