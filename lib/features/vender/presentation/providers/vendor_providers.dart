import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/vendor_remote_datasource.dart';
import '../../data/repositories/vendor_repository_impl.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/repositories/vendor_repository.dart';

part 'vendor_providers.g.dart';

enum VendorFilter { all, active, inactive }

@riverpod
class VendorFilterNotifier extends _$VendorFilterNotifier {
  @override
  VendorFilter build() => VendorFilter.all;

  void setFilter(VendorFilter filter) => state = filter;
}

@riverpod
VendorRemoteDatasource vendorRemoteDatasource(Ref ref) {
  return VendorRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
VendorRepository vendorRepository(Ref ref) {
  return VendorRepositoryImpl(ref.watch(vendorRemoteDatasourceProvider));
}

@riverpod
Future<List<VendorEntity>> getAllvendors(Ref ref) async {
  return ref.watch(vendorRepositoryProvider).getAllVenders();
}

@riverpod
Future<void> addvendor(Ref ref, VendorEntity vendor) async {
  await ref.watch(vendorRepositoryProvider).addVender(vendor);
}

@riverpod
Future<void> updatevendor(Ref ref, VendorEntity vendor) async {
  await ref.watch(vendorRepositoryProvider).updateVender(vendor);
}

@riverpod
Future<void> deletevendor(Ref ref, int vendorId) async {
  await ref.watch(vendorRepositoryProvider).deleteVender(vendorId);
}
