import 'package:ledgerly/features/products/domain/entities/product_set_entity.dart';

import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(int productId);
  Future<void> addProductSet(ProductSetEntity productSet);
  Future<void> updateProductSet(ProductSetEntity productSet);
  Future<void> deleteProductSet(int setId);
  Future<List<ProductSetEntity>> getProductSets();
}
