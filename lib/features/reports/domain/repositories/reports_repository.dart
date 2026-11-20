import '../entities/report_date_range.dart';
import '../entities/financial_report_model.dart';
import '../entities/production_report_model.dart';
import '../entities/sale_stock_report_model.dart';
import '../entities/monthly_closing_model.dart';
import '../entities/production_expenditure_model.dart';

abstract class ReportsRepository {
  Future<FinancialReportModel> getFinancialReport(ReportDateRange range);
  Future<ProductionReportModel> getProductionReport(ReportDateRange range);
  Future<SaleStockReportModel> getSaleStockReport(ReportDateRange range);
  Future<ProductionExpenditureModel> getProductionExpenditure(
    ReportDateRange range, {
    double? totalWeight,
  });
  Future<MonthlyClosingModel> getMonthlyClosingReport(
    ReportDateRange range, {
    ProductionExpenditureModel? expenditureModel,
  });
}
