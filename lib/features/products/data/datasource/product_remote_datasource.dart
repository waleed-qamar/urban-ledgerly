import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRemoteDatasource {
  final SupabaseClient _client;

  ProductRemoteDatasource(this._client);

  Future<List<ProductEntity>> getProducts() async {
    final response = await _client.from('products').select();

    return response.map((json) => ProductEntity.fromJson(json)).toList();
  }

  Future<void> addProduct(ProductEntity product) async {
    await _client.from('products').insert(product.toJson());
  }

  Future<void> updateProduct(ProductEntity product) async {
    await _client
        .from('products')
        .update(product.toJson())
        .eq('id', product.id);
  }

  Future<void> deleteProduct(int productId) async {
    await _client.from('products').delete().eq('id', productId);
  }
}
