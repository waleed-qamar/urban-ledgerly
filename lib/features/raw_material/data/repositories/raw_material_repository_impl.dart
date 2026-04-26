import '../../domain/entities/raw_material_entity.dart';
import '../../domain/repositories/raw_material_repository.dart';
import '../datasource/raw_material_remote_datasource.dart';

class RawMaterialRepositoryImpl implements RawMaterialRepository {
  final RawMaterialRemoteDatasource _dataSource;

  RawMaterialRepositoryImpl(this._dataSource);

  @override
  Future<List<RawMaterialEntity>> getRawMaterials() =>
      _dataSource.getRawMaterials();

  @override
  Future<void> addRawMaterial(RawMaterialEntity material) =>
      _dataSource.addRawMaterial(material);

  @override
  Future<void> updateRawMaterial(RawMaterialEntity material) =>
      _dataSource.updateRawMaterial(material);

  @override
  Future<void> deleteRawMaterial(int materialId) =>
      _dataSource.deleteRawMaterial(materialId);
}
