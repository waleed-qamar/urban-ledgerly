import '../entities/receipt_entity.dart';
import '../entities/disbursement_record.dart';

abstract class ReceiptRepository {
  Future<ReceiptEntity> createReceipt(ReceiptEntity receipt);
  Future<void> createDisbursement({
    required int supplierId,
    required double totalAmount,
    required String paymentMethod,
    String? accountNo,
    int? accountId,
    String? category,
    String? remarks,
    DateTime? paidDate,
  });
  Future<void> deleteReceipt(int id);
  Future<void> deleteDisbursement(int id);
  Future<ReceiptEntity> getReceiptById(int id);
  Future<List<DisbursementRecord>> getDisbursements();
  Future<List<ReceiptEntity>> getReceipts();
  Future<void> updateReceipt({
    required int id,
    int? clientId,
    int? accountId,
    required String paymentMethod,
    String? accountNo,
    String? remarks,
    required DateTime receivedDate,
    double? totalAmount,
  });
  Future<void> updateDisbursement({
    required int id,
    int? supplierId,
    int? accountId,
    required String paymentMethod,
    String? accountNo,
    String? category,
    String? remarks,
    required DateTime paidDate,
    double? totalAmount,
  });
}
