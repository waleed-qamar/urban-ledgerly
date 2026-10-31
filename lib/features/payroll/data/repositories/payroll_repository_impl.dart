import '../../domain/entities/payroll_sheet_entity.dart';
import '../../domain/entities/payroll_row_entity.dart';
import '../../domain/repositories/payroll_repository.dart';
import '../datasources/payroll_remote_datasource.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final PayrollRemoteDatasource _datasource;

  PayrollRepositoryImpl(this._datasource);

  @override
  Future<List<PayrollSheetEntity>> getSheets() {
    return _datasource.fetchSheets();
  }

  @override
  Future<PayrollSheetEntity> getSheetById(String sheetId) {
    return _datasource.fetchSheetById(sheetId);
  }

  @override
  Future<String> createSheet({
    required String company,
    required String category,
    required String title,
    required DateTime cutoffDate,
    String? operatorName,
    double amountGiven = 0.0,
    String sheetType = 'kharcha',
  }) {
    return _datasource.createSheet(
      company: company,
      category: category,
      title: title,
      cutoffDate: cutoffDate,
      operatorName: operatorName,
      amountGiven: amountGiven,
      sheetType: sheetType,
    );
  }

  @override
  Future<void> updateSheet(PayrollSheetEntity sheet) {
    return _datasource.updateSheet(sheet);
  }

  @override
  Future<void> finalizeSheet(String sheetId) {
    return _datasource.finalizeSheet(sheetId);
  }

  @override
  Future<void> deleteSheet(String sheetId) {
    return _datasource.deleteSheet(sheetId);
  }

  @override
  Future<List<PayrollRowEntity>> getSheetRows(String sheetId) {
    return _datasource.fetchSheetRows(sheetId);
  }

  @override
  Future<PayrollRowEntity> patchRow(PayrollRowEntity row) {
    return _datasource.patchRow(row);
  }
}
