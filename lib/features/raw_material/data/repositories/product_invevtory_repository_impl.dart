import 'package:ledgerly/features/products/domain/repositories/product_inventory_repository.dart';

import '../datasource/inventory_remote_datasource.dart';
import '../../domain/entities/inventory_transaction_entity.dart';

class ProductInventoryRepositoryImpl implements ProductInventoryRepository {
  final InventoryRemoteDatasource _dataSource;
  ProductInventoryRepositoryImpl(this._dataSource);
  @override
  Future<void> addTransaction(
    int productId,
    int quantity,
    String? remarks,
  ) async => _dataSource.addTransaction(productId, quantity, remarks);

  @override
  Future<void> removeTransaction(
    int productId,
    int quantity,
    String? remarks,
  ) async => _dataSource.removeTransaction(productId, quantity, remarks);

  @override
  Future<List<InventoryTransactionEntity>> getTransactionsByProduct(
    int productId,
  ) => _dataSource.getTransactionsByProduct(productId);

  @override
  Future<void> deleteTransaction(int transactionId) =>
      _dataSource.deleteTransaction(transactionId);

  @override
  Future<void> updateTransaction(
    int transactionId,
    int productId,
    int quantity,
    String transactionType,
    String? remarks,
  ) => _dataSource.updateTransaction(
    transactionId,
    productId,
    quantity,
    transactionType,
    remarks,
  );
}
