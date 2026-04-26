import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/inventory_transaction_entity.dart';

class InventoryRemoteDatasource {
  final SupabaseClient _client;

  InventoryRemoteDatasource(this._client);

  Future<void> addTransaction(
    int productId,
    int quantity,
    String? remarks,
  ) async {
    await _client.from('inventory_transactions').insert({
      'product_id': productId,
      'transaction_type': 'IN',
      'quantity': quantity,
      'remarks': remarks ?? '',
    });
  }

  Future<void> removeTransaction(
    int productId,
    int quantity,
    String? remarks,
  ) async {
    await _client.from('inventory_transactions').insert({
      'product_id': productId,
      'transaction_type': 'OUT',
      'quantity': quantity,
      'remarks': remarks ?? '',
    });
  }

  Future<void> deleteTransaction(int transactionId) async {
    await _client
        .from('inventory_transactions')
        .delete()
        .eq('id', transactionId);
  }

  Future<void> updateTransaction(
    int transactionId,
    int productId,
    int quantity,
    String transactionType,
    String? remarks,
  ) async {
    await _client
        .from('inventory_transactions')
        .update({
          'product_id': productId,
          'transaction_type': transactionType,
          'quantity': quantity,
          'remarks': remarks ?? '',
        })
        .eq('id', transactionId);
  }

  Future<List<InventoryTransactionEntity>> getTransactionsByProduct(
    int productId,
  ) async {
    final response = await _client
        .from('inventory_transactions')
        .select()
        .eq('product_id', productId)
        .order('created_at', ascending: false);

    return response
        .map((json) => InventoryTransactionEntity.fromJson(json))
        .toList();
  }
}
