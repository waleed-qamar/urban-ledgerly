// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_material_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RawMaterialEntity _$RawMaterialEntityFromJson(Map<String, dynamic> json) =>
    _RawMaterialEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RawMaterialEntityToJson(_RawMaterialEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };
