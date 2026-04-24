import 'package:ledgerly/features/products/domain/repositories/product_inventory_repository.dart';

import '../datasource/inventory_remote_datasource.dart';
import '../../domain/entities/inventory_transaction_entity.dart';

class ProductInventoryRepositoryImpl implements ProductInventoryRepository {
  final InventoryRemoteDatasource _dataSource;
  ProductInventoryRepositoryImpl(this._dataSource);
  @override
  Future<void> addTransaction(int productId, int quantity) async =>
      _dataSource.addTransaction(productId, quantity);

  @override
  Future<void> removeTransaction(int productId, int quantity) async =>
      _dataSource.removeTransaction(productId, quantity);

  @override
  Future<List<InventoryTransactionEntity>> getTransactionsByProduct(
    int productId,
  ) => _dataSource.getTransactionsByProduct(productId);
}
