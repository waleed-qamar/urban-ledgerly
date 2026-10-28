import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_entity.dart';
import 'package:ledgerly/features/products/domain/repositories/product_repository.dart';

import '../datasource/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource _dataSource;

  ProductRepositoryImpl(this._dataSource);
  @override
  Future<void> addProduct(ProductEntity product) =>
      _dataSource.addProduct(product);

  @override
  Future<void> deleteProduct(int productId) =>
      _dataSource.deleteProduct(productId);

  @override
  Future<List<ProductEntity>> getProducts() => _dataSource.getProducts();

  @override
  Future<void> updateProduct(ProductEntity product) =>
      _dataSource.updateProduct(product);

  @override
  Future<void> addProductSet(ProductSetEntity productSet) =>
      _dataSource.addProductSet(productSet);

  @override
  Future<void> updateProductSet(ProductSetEntity productSet) =>
      _dataSource.updateProductSet(productSet);

  @override
  Future<void> deleteProductSet(int setId) =>
      _dataSource.deleteProductSet(setId);

  @override
  Future<List<ProductSetEntity>> getProductSets() =>
      _dataSource.getProductSets();
}
