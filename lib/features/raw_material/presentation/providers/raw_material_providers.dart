import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/raw_material_remote_datasource.dart';
import '../../data/repositories/raw_material_repository_impl.dart';
import '../../domain/entities/raw_material_entity.dart';
import '../../domain/repositories/raw_material_repository.dart';

part 'raw_material_providers.g.dart';

@riverpod
RawMaterialRemoteDatasource rawMaterialRemoteDatasource(Ref ref) {
  return RawMaterialRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
RawMaterialRepository rawMaterialRepository(Ref ref) {
  return RawMaterialRepositoryImpl(
    ref.watch(rawMaterialRemoteDatasourceProvider),
  );
}

@riverpod
class RawMaterialSearchQuery extends _$RawMaterialSearchQuery {
  @override
  String build() => '';

  void setSearchQuery(String query) => state = query;
}

@riverpod
Future<List<RawMaterialEntity>> getAllRawMaterials(Ref ref) {
  return ref.watch(rawMaterialRepositoryProvider).getRawMaterials();
}

@riverpod
Future<void> addRawMaterial(Ref ref, RawMaterialEntity material) {
  return ref.watch(rawMaterialRepositoryProvider).addRawMaterial(material);
}

@riverpod
Future<void> deleteRawMaterial(Ref ref, int id) {
  return ref.watch(rawMaterialRepositoryProvider).deleteRawMaterial(id);
}

@riverpod
Future<void> updateRawMaterial(Ref ref, RawMaterialEntity material) {
  return ref.watch(rawMaterialRepositoryProvider).updateRawMaterial(material);
}
