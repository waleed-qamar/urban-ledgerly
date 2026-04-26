import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/raw_material_entity.dart';

class RawMaterialRemoteDatasource {
  final SupabaseClient _client;

  RawMaterialRemoteDatasource(this._client);

  Future<List<RawMaterialEntity>> getRawMaterials() async {
    final response = await _client
        .from('raw_material')
        .select()
        .order('created_at', ascending: false);

    return response.map((json) => RawMaterialEntity.fromJson(json)).toList();
  }

  Future<void> addRawMaterial(RawMaterialEntity material) async {
    final payload = material.toJson()..remove('id');
    await _client.from('raw_material').insert(payload);
  }

  Future<void> updateRawMaterial(RawMaterialEntity material) async {
    await _client
        .from('raw_material')
        .update(material.toJson())
        .eq('id', material.id);
  }

  Future<void> deleteRawMaterial(int materialId) async {
    await _client.from('raw_material').delete().eq('id', materialId);
  }
}
