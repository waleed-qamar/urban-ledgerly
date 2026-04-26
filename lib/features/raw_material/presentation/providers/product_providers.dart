import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/products/data/datasource/inventory_remote_datasource.dart';
import 'package:ledgerly/features/products/data/datasource/product_remote_datasource.dart';
import 'package:ledgerly/features/products/data/repositories/product_invevtory_repository_impl.dart';
import 'package:ledgerly/features/products/data/repositories/product_repository_impl.dart';
import 'package:ledgerly/features/products/domain/entities/inventory_transaction_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/domain/repositories/product_inventory_repository.dart';
import 'package:ledgerly/features/products/domain/repositories/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_providers.g.dart';

@riverpod
ProductRemoteDatasource productRemoteDatasource(Ref ref) {
  return ProductRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(ref.watch(productRemoteDatasourceProvider));
}

@riverpod
InventoryRemoteDatasource inventoryRemoteDatasource(Ref ref) {
  return InventoryRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ProductInventoryRepository productInventoryRepository(Ref ref) {
  return ProductInventoryRepositoryImpl(
    ref.watch(inventoryRemoteDatasourceProvider),
  );
}

@riverpod
Future<List<ProductEntity>> getAllProducts(Ref ref) {
  return ref.watch(productRepositoryProvider).getProducts();
}

@riverpod
Future<void> addProduct(Ref ref, ProductEntity product) {
  return ref.watch(productRepositoryProvider).addProduct(product);
}

@riverpod
Future<void> deleteProduct(Ref ref, int id) {
  return ref.watch(productRepositoryProvider).deleteProduct(id);
}

@riverpod
Future<void> updateProduct(Ref ref, ProductEntity product) {
  return ref.watch(productRepositoryProvider).updateProduct(product);
}

@riverpod
Future<List<InventoryTransactionEntity>> inventoryTransactionsByProduct(
  Ref ref,
  int productId,
) {
  return ref
      .watch(productInventoryRepositoryProvider)
      .getTransactionsByProduct(productId);
}

@riverpod
Future<void> deleteInventoryTransaction(Ref ref, int transactionId) {
  return ref
      .watch(productInventoryRepositoryProvider)
      .deleteTransaction(transactionId);
}

@riverpod
Future<void> updateInventoryTransaction(
  Ref ref,
  int transactionId,
  int productId,
  int quantity,
  String transactionType,
  String? remarks,
) {
  return ref
      .watch(productInventoryRepositoryProvider)
      .updateTransaction(
        transactionId,
        productId,
        quantity,
        transactionType,
        remarks,
      );
}
