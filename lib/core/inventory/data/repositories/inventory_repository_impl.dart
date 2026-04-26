import '../../domain/entities/inventory_transaction_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasource/inventory_remote_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDatasource _dataSource;

  InventoryRepositoryImpl(this._dataSource);

  @override
  Future<List<InventoryTransactionEntity>> getTransactionsForItem(
    int itemId,
    String itemType,
  ) =>
      _dataSource.getTransactionsForItem(itemId, itemType);

  @override
  Future<void> recordIn(
    int itemId,
    String itemType,
    int quantity, {
    String? notes,
    String? referenceType,
    int? referenceId,
  }) =>
      _dataSource.recordIn(
        itemId,
        itemType,
        quantity,
        notes: notes,
        referenceType: referenceType,
        referenceId: referenceId,
      );

  @override
  Future<void> recordOut(
    int itemId,
    String itemType,
    int quantity, {
    String? notes,
    String? referenceType,
    int? referenceId,
  }) =>
      _dataSource.recordOut(
        itemId,
        itemType,
        quantity,
        notes: notes,
        referenceType: referenceType,
        referenceId: referenceId,
      );

  @override
  Future<void> updateTransaction(
    int transactionId, {
    required int quantity,
    required String transactionType,
    String? notes,
    String? referenceType,
    int? referenceId,
  }) =>
      _dataSource.updateTransaction(
        transactionId,
        quantity: quantity,
        transactionType: transactionType,
        notes: notes,
        referenceType: referenceType,
        referenceId: referenceId,
      );

  @override
  Future<void> deleteTransaction(int transactionId) =>
      _dataSource.deleteTransaction(transactionId);
}
