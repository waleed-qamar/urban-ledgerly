import '../entities/inventory_transaction_entity.dart';

/// Abstract repository for the unified inventory_transactions table.
///
/// Pass [itemType] as 'PRODUCT' or 'RAW_MATERIAL'.
/// The optional [referenceType] / [referenceId] are for future modules
/// (Procurement, Invoices, BOM, Production).
abstract class InventoryRepository {
  Future<List<InventoryTransactionEntity>> getTransactionsForItem(
    int itemId,
    String itemType,
  );

  Future<void> recordIn(
    int itemId,
    String itemType,
    double quantity, {
    String? notes,
    String? referenceType,
    int? referenceId,
    DateTime? transactionDate,
  });

  Future<void> recordOut(
    int itemId,
    String itemType,
    double quantity, {
    String? notes,
    String? referenceType,
    int? referenceId,
    DateTime? transactionDate,
  });

  Future<void> updateTransaction(
    int transactionId, {
    required double quantity,
    required String transactionType,
    String? notes,
    String? referenceType,
    int? referenceId,
  });

  Future<void> deleteTransaction(int transactionId);
}
