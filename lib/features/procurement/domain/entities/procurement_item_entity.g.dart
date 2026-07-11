// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcurementItemEntity _$ProcurementItemEntityFromJson(
  Map<String, dynamic> json,
) => _ProcurementItemEntity(
  id: (json['id'] as num?)?.toInt(),
  procurementId: (json['procurement_id'] as num?)?.toInt(),
  rawMaterialId: (json['raw_material_id'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  price: (_readDouble(json, 'price') as num).toDouble(),
  total: (_readDouble(json, 'total') as num).toDouble(),
);

Map<String, dynamic> _$ProcurementItemEntityToJson(
  _ProcurementItemEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'procurement_id': instance.procurementId,
  'raw_material_id': instance.rawMaterialId,
  'quantity': instance.quantity,
  'price': instance.price,
  'total': instance.total,
};
