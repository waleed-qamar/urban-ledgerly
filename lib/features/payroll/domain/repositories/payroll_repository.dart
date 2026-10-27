import '../entities/payroll_sheet_entity.dart';
import '../entities/payroll_row_entity.dart';

abstract class PayrollRepository {
  Future<List<PayrollSheetEntity>> getSheets();
  Future<PayrollSheetEntity> getSheetById(String sheetId);
  Future<String> createSheet({
    required String company,
    required String category,
    required String title,
    required DateTime cutoffDate,
    String? operatorName,
    double amountGiven = 0.0,
  });
  Future<void> updateSheet(PayrollSheetEntity sheet);
  Future<void> finalizeSheet(String sheetId);
  Future<void> deleteSheet(String sheetId);
  Future<List<PayrollRowEntity>> getSheetRows(String sheetId);
  Future<PayrollRowEntity> patchRow(PayrollRowEntity row);
}
