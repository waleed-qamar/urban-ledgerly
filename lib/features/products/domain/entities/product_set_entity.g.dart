// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_set_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSetEntity _$ProductSetEntityFromJson(Map<String, dynamic> json) =>
    _ProductSetEntity(
      setId: (json['set_id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      products:
          (json['products'] as List<dynamic>?)
              ?.map(
                (e) => ProductSetItemEntity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ProductSetEntityToJson(_ProductSetEntity instance) =>
    <String, dynamic>{
      'set_id': instance.setId,
      'name': instance.name,
      'description': instance.description,
      'products': instance.products,
      'created_at': instance.createdAt?.toIso8601String(),
    };
