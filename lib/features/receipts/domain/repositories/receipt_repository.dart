import '../entities/receipt_entity.dart';
import '../entities/disbursement_record.dart';

abstract class ReceiptRepository {
  Future<ReceiptEntity> createReceipt(ReceiptEntity receipt);
  Future<void> createDisbursement({
    required int supplierId,
    required double totalAmount,
    required String paymentMethod,
    String? accountNo,
    String? category,
    String? remarks,
    DateTime? paidDate,
  });
  Future<void> deleteReceipt(int id);
  Future<ReceiptEntity> getReceiptById(int id);
  Future<List<DisbursementRecord>> getDisbursements();
  Future<List<ReceiptEntity>> getReceipts();
}
