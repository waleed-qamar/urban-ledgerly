// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderEntity _$OrderEntityFromJson(Map<String, dynamic> json) => _OrderEntity(
  id: (json['id'] as num?)?.toInt(),
  supplierId: (json['supplierId'] as num).toInt(),
  clientId: (json['clientId'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: json['status'] as String?,
  department: json['department'] as String?,
  po: json['po'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrderEntityToJson(_OrderEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplierId': instance.supplierId,
      'clientId': instance.clientId,
      'items': instance.items,
      'status': instance.status,
      'department': instance.department,
      'po': instance.po,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
