import 'package:ledgerly/features/vender/domain/entities/vendor_entity.dart';

abstract class VendorRepository {
  Future<List<VendorEntity>> getAllVenders();
  Future<void> addVender(VendorEntity vendor);
  Future<void> updateVender(VendorEntity vendor);
  Future<void> deleteVender(int vendorId);
}
