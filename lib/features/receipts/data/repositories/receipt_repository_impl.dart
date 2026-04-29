import '../../domain/entities/receipt_entity.dart';
import '../../domain/entities/disbursement_record.dart';
import '../../domain/repositories/receipt_repository.dart';
import '../datasources/receipt_remote_datasource.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDatasource _datasource;

  ReceiptRepositoryImpl(this._datasource);

  @override
  Future<ReceiptEntity> createReceipt(ReceiptEntity receipt) {
    return _datasource.createReceipt(receipt);
  }

  @override
  Future<void> createDisbursement({
    required int supplierId,
    required double totalAmount,
    required String paymentMethod,
    String? accountNo,
    String? category,
    String? remarks,
    DateTime? paidDate,
  }) {
    return _datasource.createDisbursement(
      supplierId: supplierId,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      accountNo: accountNo,
      category: category,
      remarks: remarks,
      paidDate: paidDate,
    );
  }

  @override
  Future<void> deleteReceipt(int id) {
    return _datasource.deleteReceipt(id);
  }

  @override
  Future<ReceiptEntity> getReceiptById(int id) {
    return _datasource.getReceiptById(id);
  }

  @override
  Future<List<DisbursementRecord>> getDisbursements() {
    return _datasource.getDisbursements();
  }

  @override
  Future<List<ReceiptEntity>> getReceipts() {
    return _datasource.getReceipts();
  }
}
