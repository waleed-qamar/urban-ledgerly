import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/orders/data/datasource/supplier_remote_datasource.dart';
import 'package:ledgerly/features/orders/data/repositories/supplier_repository_impl.dart';
import 'package:ledgerly/features/orders/domain/repositories/supplier_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/supplier_entity.dart';

part 'supplier_providers.g.dart';

@riverpod
SupplierRemoteDatasource supplierRemoteDatasource(Ref ref) {
  return SupplierRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
SupplierRepository supplierRepository(Ref ref) {
  return SupplierRepositoryImpl(ref.watch(supplierRemoteDatasourceProvider));
}

@riverpod
Future<List<SupplierEntity>> getAllSuppliers(Ref ref) {
  return ref.watch(supplierRepositoryProvider).getSuppliers();
}

@riverpod
Future<SupplierEntity> getSupplierById(Ref ref, int id) {
  return ref.watch(supplierRepositoryProvider).getSupplierById(id);
}

@riverpod
Future<void> addSupplier(Ref ref, SupplierEntity supplier) {
  return ref.watch(supplierRepositoryProvider).addSupplier(supplier);
}

@riverpod
Future<void> updateSupplier(Ref ref, SupplierEntity supplier) {
  return ref.watch(supplierRepositoryProvider).updateSupplier(supplier);
}

@riverpod
Future<void> deleteSupplier(Ref ref, int id) {
  return ref.watch(supplierRepositoryProvider).deleteSupplier(id);
}
