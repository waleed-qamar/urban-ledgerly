// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderEntity _$OrderEntityFromJson(Map<String, dynamic> json) => _OrderEntity(
  id: (json['id'] as num?)?.toInt(),
  customerId: (json['customerId'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: json['status'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrderEntityToJson(_OrderEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'items': instance.items,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
