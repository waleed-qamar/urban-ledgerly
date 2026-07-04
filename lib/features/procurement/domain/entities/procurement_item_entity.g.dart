// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcurementItemEntity _$ProcurementItemEntityFromJson(
  Map<String, dynamic> json,
) => _ProcurementItemEntity(
  id: (json['id'] as num?)?.toInt(),
  procurementId: (json['procurementId'] as num?)?.toInt(),
  rawMaterialId: (json['rawMaterialId'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
);

Map<String, dynamic> _$ProcurementItemEntityToJson(
  _ProcurementItemEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'procurementId': instance.procurementId,
  'rawMaterialId': instance.rawMaterialId,
  'quantity': instance.quantity,
  'price': instance.price,
  'total': instance.total,
};
