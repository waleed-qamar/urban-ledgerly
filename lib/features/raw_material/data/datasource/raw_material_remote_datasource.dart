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

    return (response as List)
        .map((row) => RawMaterialEntity.fromJson(_normalizeRow(row)))
        .toList();
  }

  Future<void> addRawMaterial(RawMaterialEntity material) async {
    final payload = _toDbRow(material.toJson())..remove('id');
    await _client.from('raw_material').insert(payload);
  }

  Future<void> updateRawMaterial(RawMaterialEntity material) async {
    await _client
        .from('raw_material')
        .update(_toDbRow(material.toJson()))
        .eq('id', material.id);
  }

  Future<void> deleteRawMaterial(int materialId) async {
    await _client.from('raw_material').delete().eq('id', materialId);
  }

  Map<String, dynamic> _normalizeRow(dynamic row) {
    final json = Map<String, dynamic>.from(row as Map);
    return {
      'id': (json['id'] as num?)?.toInt() ?? 0,
      'name': (json['name'] ?? '').toString(),
      'price': (json['price'] as num?)?.toDouble() ?? 0.0,
      'description': json['description']?.toString(),
      'createdAt':
          (json['createdAt'] ??
                  json['created_at'] ??
                  DateTime.now().toIso8601String())
              .toString(),
    };
  }

  Map<String, dynamic> _toDbRow(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'name': json['name'],
      'price': json['price'],
      'description': json['description'],
      'created_at': json['createdAt'],
    };
  }
}
