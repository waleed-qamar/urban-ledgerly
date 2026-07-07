// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_set_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSetItemEntity _$ProductSetItemEntityFromJson(
  Map<String, dynamic> json,
) => _ProductSetItemEntity(
  setid: (json['set_id'] as num?)?.toInt(),
  productId: (json['product_id'] as num).toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProductSetItemEntityToJson(
  _ProductSetItemEntity instance,
) => <String, dynamic>{
  'set_id': instance.setid,
  'product_id': instance.productId,
  'created_at': instance.createdAt?.toIso8601String(),
};
