// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_set_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSetItemEntity _$ProductSetItemEntityFromJson(
  Map<String, dynamic> json,
) => _ProductSetItemEntity(
  setid: (json['setid'] as num?)?.toInt(),
  productId: (json['productId'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductSetItemEntityToJson(
  _ProductSetItemEntity instance,
) => <String, dynamic>{
  'setid': instance.setid,
  'productId': instance.productId,
  'createdAt': instance.createdAt?.toIso8601String(),
};
