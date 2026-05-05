import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/inventory_remote_datasource.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/entities/inventory_transaction_entity.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'inventory_providers.g.dart';

/// The shared Supabase-backed datasource for inventory_transactions.
@riverpod
InventoryRemoteDatasource inventoryRemoteDatasource(Ref ref) {
  return InventoryRemoteDatasource(ref.watch(supabaseClientProvider));
}

/// The shared repository — inject this wherever you need inventory ops.
@riverpod
InventoryRepository inventoryRepository(Ref ref) {
  return InventoryRepositoryImpl(ref.watch(inventoryRemoteDatasourceProvider));
}

/// Fetch all transactions for a specific item (product or raw material).
///
/// Usage:
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'PRODUCT'))
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'RAW_MATERIAL'))
@riverpod
Future<List<InventoryTransactionEntity>> inventoryTransactionsForItem(
  Ref ref,
  int itemId,
  String itemType,
) {
  return ref
      .watch(inventoryRepositoryProvider)
      .getTransactionsForItem(itemId, itemType);
}

/// Delete a single transaction by id.
@riverpod
Future<void> deleteInventoryTransaction(Ref ref, int transactionId) {
  return ref
      .watch(inventoryRepositoryProvider)
      .deleteTransaction(transactionId);
}

/// Update a transaction's quantity, type, and notes.
@riverpod
Future<void> updateInventoryTransaction(
  Ref ref,
  int transactionId,
  double quantity,
  String transactionType, {
  String? notes,
  String? referenceType,
  int? referenceId,
}) {
  return ref.watch(inventoryRepositoryProvider).updateTransaction(
        transactionId,
        quantity: quantity,
        transactionType: transactionType,
        notes: notes,
        referenceType: referenceType,
        referenceId: referenceId,
      );
}
