import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_entity.dart';
import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRemoteDatasource {
  final SupabaseClient _client;

  ProductRemoteDatasource(this._client);

  Future<List<ProductEntity>> getProducts() async {
    final response = await _client.from('products').select();

    return response.map((json) => ProductEntity.fromJson((json))).toList();
  }

  Future<void> addProduct(ProductEntity product) async {
    await supabaseSafeCall(() async {
      final payload = product.toJson()
        ..remove('id')
        ..['created_at'] = payloadCreatedAt(product);
      payload.remove('created_at');
      await _client.from('products').insert(payload);
    });
  }

  Future<List<ProductSetEntity>> getProductSets() async {
    final response = await _client
        .from('product_sets')
        .select(
          'set_id, name, description, created_at, products:product_set_items(set_id, product_id, created_at)',
        )
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ProductSetEntity.fromJson((json)))
        .toList();
  }

  Future<void> addProductSet(ProductSetEntity productSet) async {
    await supabaseSafeCall(() async {
      final createdAt = productSet.createdAt ?? DateTime.now();
      final payload = <String, dynamic>{
        'name': productSet.name.trim(),
        'created_at': createdAt.toIso8601String(),
      };

      final description = productSet.description?.trim();
      if (description != null && description.isNotEmpty) {
        payload['description'] = description;
      }

      final inserted = await _client
          .from('product_sets')
          .insert(payload)
          .select('set_id')
          .single();
      final setId = (inserted['set_id'] as num).toInt();

      final productIds = <int>{
        for (final item in productSet.products) item.productId,
      }.toList();

      if (productIds.isEmpty) {
        throw ArgumentError('Product set must contain at least one product.');
      }

      final itemsPayload = productIds
          .map(
            (productId) => {
              'set_id': setId,
              'product_id': productId,
              'created_at': createdAt.toIso8601String(),
            },
          )
          .toList();

      await _client.from('product_set_items').insert(itemsPayload);
    });
  }

  Future<void> updateProduct(ProductEntity product) async {
    await supabaseSafeCall(() async {
      final payload = product.toJson();
      payload['created_at'] = payloadCreatedAt(product);
      payload.remove('created_at');
      await _client.from('products').update(payload).eq('id', product.id);
    });
  }

  Future<void> deleteProduct(int productId) async {
    await supabaseSafeCall(() async {
      await _client.from('products').delete().eq('id', productId);
    });
  }

  // Map<String, dynamic> _normalizeProductRow(Map<String, dynamic> row) {
  //   final normalized = Map<String, dynamic>.from(row);

  //   normalized['id'] = normalized['id'] ?? 0;
  //   normalized['name'] = (normalized['name'] ?? '').toString();
  //   normalized['weight'] = (normalized['weight'] ?? 0).toDouble();
  //   normalized['description'] = normalized['description']?.toString();
  //   normalized['createdAt'] =
  //       (normalized['createdAt'] ??
  //               normalized['created_at'] ??
  //               DateTime.now().toIso8601String())
  //           .toString();

  //   return normalized;
  // }

  // Map<String, dynamic> _normalizeProductSetRow(Map<String, dynamic> row) {
  //   final normalized = Map<String, dynamic>.from(row);

  //   normalized['setId'] = normalized['setId'] ?? normalized['set_id'];
  //   normalized['createdAt'] =
  //       normalized['createdAt'] ?? normalized['created_at'];

  //   final rawProducts = normalized['products'];
  //   if (rawProducts is List) {
  //     normalized['products'] = rawProducts.whereType<Map>().map((item) {
  //       final productRow = Map<String, dynamic>.from(item);
  //       productRow['setId'] = productRow['setId'] ?? productRow['set_id'];
  //       productRow['createdAt'] =
  //           productRow['createdAt'] ?? productRow['created_at'];
  //       productRow['productId'] =
  //           productRow['productId'] ?? productRow['product_id'];
  //       return productRow;
  //     }).toList();
  //   }

  //   return normalized;
  // }

  String payloadCreatedAt(ProductEntity product) {
    return product.createdAt.toIso8601String();
  }
}
