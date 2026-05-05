import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/inventory_transaction_entity.dart';

/// Handles all DB calls to the unified `inventory_transactions` table.
///
/// Filters by both [itemId] and [itemType] so products and raw materials
/// never see each other's transactions.
class InventoryRemoteDatasource {
  final SupabaseClient _client;

  InventoryRemoteDatasource(this._client);

  Future<List<InventoryTransactionEntity>> getTransactionsForItem(
    int itemId,
    String itemType,
  ) async {
    final response = await _client
        .from('inventory_transactions')
        .select()
        .eq('item_id', itemId)
        .eq('item_type', itemType)
        .order('created_at', ascending: false);

    return response
        .map((json) => InventoryTransactionEntity.fromJson(json))
        .toList();
  }

  Future<void> recordIn(
    int itemId,
    String itemType,
    double quantity, {
    String? notes,
    String? referenceType,
    int? referenceId,
  }) async {
    await _client.from('inventory_transactions').insert({
      'item_id': itemId,
      'item_type': itemType,
      'transaction_type': 'IN',
      'quantity': quantity,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      'reference_type': referenceType,
      'reference_id': referenceId,
    });
  }

  Future<void> recordOut(
    int itemId,
    String itemType,
    double quantity, {
    String? notes,
    String? referenceType,
    int? referenceId,
  }) async {
    await _client.from('inventory_transactions').insert({
      'item_id': itemId,
      'item_type': itemType,
      'transaction_type': 'OUT',
      'quantity': quantity,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      'reference_type': referenceType,
      'reference_id': referenceId,
    });
  }

  Future<void> updateTransaction(
    int transactionId, {
    required double quantity,
    required String transactionType,
    String? notes,
    String? referenceType,
    int? referenceId,
  }) async {
    await _client
        .from('inventory_transactions')
        .update({
          'transaction_type': transactionType,
          'quantity': quantity,
          'notes': notes,
          'reference_type': referenceType,
          'reference_id': referenceId,
        })
        .eq('id', transactionId);
  }

  Future<void> deleteTransaction(int transactionId) async {
    await _client
        .from('inventory_transactions')
        .delete()
        .eq('id', transactionId);
  }
}
