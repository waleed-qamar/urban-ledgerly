import 'package:ledgerly/features/vender/data/datasources/vendor_remote_datasource.dart';
import 'package:ledgerly/features/vender/domain/entities/vendor_entity.dart';
import 'package:ledgerly/features/vender/domain/repositories/vendor_repository.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDatasource _datasource;

  VendorRepositoryImpl(this._datasource);

  @override
  Future<void> addVender(VendorEntity vendor) => _datasource.addVender(vendor);

  @override
  Future<void> deleteVender(int vendorId) => _datasource.deleteVender(vendorId);

  @override
  Future<List<VendorEntity>> getAllVenders() => _datasource.fetchAllVenders();

  @override
  Future<void> updateVender(VendorEntity vendor) =>
      _datasource.updateVender(vendor);
}
