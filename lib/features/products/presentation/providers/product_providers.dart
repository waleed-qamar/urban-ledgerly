import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/products/data/datasource/product_remote_datasource.dart';
import 'package:ledgerly/features/products/data/repositories/product_repository_impl.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_entity.dart';
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
Future<List<ProductEntity>> getAllProducts(Ref ref) {
  return ref.watch(productRepositoryProvider).getProducts();
}

@riverpod
Future<List<ProductSetEntity>> getAllProductSets(Ref ref) {
  return ref.watch(productRepositoryProvider).getProductSets();
}

@riverpod
Future<void> addProduct(Ref ref, ProductEntity product) {
  return ref.watch(productRepositoryProvider).addProduct(product);
}

@riverpod
Future<void> addProductSet(Ref ref, ProductSetEntity productSet) {
  return ref.watch(productRepositoryProvider).addProductSet(productSet);
}

@riverpod
Future<void> deleteProduct(Ref ref, int id) {
  return ref.watch(productRepositoryProvider).deleteProduct(id);
}

@riverpod
Future<void> updateProduct(Ref ref, ProductEntity product) {
  return ref.watch(productRepositoryProvider).updateProduct(product);
}
