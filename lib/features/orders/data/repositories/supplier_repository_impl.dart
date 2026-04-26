import 'package:ledgerly/features/orders/data/datasource/supplier_remote_datasource.dart';
import 'package:ledgerly/features/orders/domain/entities/supplier_entity.dart';
import 'package:ledgerly/features/orders/domain/repositories/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierRemoteDatasource _datasource;

  SupplierRepositoryImpl(this._datasource);

  @override
  Future<void> addSupplier(SupplierEntity supplier) =>
      _datasource.addSupplier(supplier);

  @override
  Future<void> deleteSupplier(int id) => _datasource.deleteSupplier(id);
  @override
  Future<SupplierEntity> getSupplierById(int id) =>
      _datasource.getSupplierById(id);

  @override
  Future<List<SupplierEntity>> getSuppliers() => _datasource.getSuppliers();

  @override
  Future<void> updateSupplier(SupplierEntity supplier) =>
      _datasource.updateSupplier(supplier);
}
