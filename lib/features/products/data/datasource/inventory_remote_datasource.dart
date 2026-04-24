import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/inventory_transaction_entity.dart';

class InventoryRemoteDatasource {
  final SupabaseClient _client;

  InventoryRemoteDatasource(this._client);

  Future<void> addTransaction(int productId, int quantity) async {
    await _client.from('inventory_transactions').insert({
      'product_id': productId,
      'transaction_type': 'IN',
      'quantity': quantity,
    });
  }

  Future<void> removeTransaction(int productId, int quantity) async {
    await _client.from('inventory_transactions').insert({
      'product_id': productId,
      'transaction_type': 'OUT',
      'quantity': quantity,
    });
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
