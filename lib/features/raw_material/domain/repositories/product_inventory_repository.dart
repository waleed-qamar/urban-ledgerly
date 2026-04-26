import '../entities/inventory_transaction_entity.dart';

abstract class ProductInventoryRepository {
  Future<void> addTransaction(int productId, int quantity, String? remarks);
  Future<void> removeTransaction(int productId, int quantity, String? remarks);
  Future<List<InventoryTransactionEntity>> getTransactionsByProduct(
    int productId,
  );

  Future<void> deleteTransaction(int transactionId);
  Future<void> updateTransaction(
    int transactionId,
    int productId,
    int quantity,
    String transactionType,
    String? remarks,
  );
}
