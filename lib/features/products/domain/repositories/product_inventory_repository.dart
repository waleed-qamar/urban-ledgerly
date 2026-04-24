import '../entities/inventory_transaction_entity.dart';

abstract class ProductInventoryRepository {
  Future<void> addTransaction(int productId, int quantity);
  Future<void> removeTransaction(int productId, int quantity);
  Future<List<InventoryTransactionEntity>> getTransactionsByProduct(
    int productId,
  );
}
