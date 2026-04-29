import '../entities/receipt_entity.dart';

abstract class ReceiptRepository {
  Future<ReceiptEntity> createReceipt(ReceiptEntity receipt);
  Future<void> deleteReceipt(int id);
  Future<ReceiptEntity> getReceiptById(int id);
  Future<List<ReceiptEntity>> getReceipts();
}
