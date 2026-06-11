// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_set_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSetEntity _$ProductSetEntityFromJson(Map<String, dynamic> json) =>
    _ProductSetEntity(
      setId: (json['setId'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductSetItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProductSetEntityToJson(_ProductSetEntity instance) =>
    <String, dynamic>{
      'setId': instance.setId,
      'name': instance.name,
      'description': instance.description,
      'products': instance.products,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
