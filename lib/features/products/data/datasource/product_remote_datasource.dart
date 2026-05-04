import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRemoteDatasource {
  final SupabaseClient _client;

  ProductRemoteDatasource(this._client);

  Future<List<ProductEntity>> getProducts() async {
    final response = await _client.from('products').select();

    return response
        .map((json) => ProductEntity.fromJson(_normalizeProductRow(json)))
        .toList();
  }

  Future<void> addProduct(ProductEntity product) async {
    final payload = product.toJson()
      ..remove('id')
      ..['CreatedAt'] = payloadCreatedAt(product);
    payload.remove('createdAt');
    await _client.from('products').insert(payload);
  }

  Future<void> updateProduct(ProductEntity product) async {
    final payload = product.toJson();
    payload['CreatedAt'] = payloadCreatedAt(product);
    payload.remove('createdAt');
    await _client.from('products').update(payload).eq('id', product.id);
  }

  Future<void> deleteProduct(int productId) async {
    await _client.from('products').delete().eq('id', productId);
  }

  Map<String, dynamic> _normalizeProductRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);

    normalized['id'] = normalized['id'] ?? 0;
    normalized['name'] = (normalized['name'] ?? '').toString();
    normalized['weight'] = (normalized['weight'] ?? 0).toDouble();
    normalized['description'] = normalized['description']?.toString();
    normalized['createdAt'] =
        (normalized['createdAt'] ??
                normalized['CreatedAt'] ??
                normalized['created_at'] ??
                DateTime.now().toIso8601String())
            .toString();

    return normalized;
  }

  String payloadCreatedAt(ProductEntity product) {
    return product.createdAt.toIso8601String();
  }
}
