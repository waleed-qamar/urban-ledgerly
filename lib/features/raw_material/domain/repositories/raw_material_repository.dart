import '../entities/raw_material_entity.dart';

abstract class RawMaterialRepository {
  Future<List<RawMaterialEntity>> getRawMaterials();
  Future<void> addRawMaterial(RawMaterialEntity material);
  Future<void> updateRawMaterial(RawMaterialEntity material);
  Future<void> deleteRawMaterial(int materialId);
}
