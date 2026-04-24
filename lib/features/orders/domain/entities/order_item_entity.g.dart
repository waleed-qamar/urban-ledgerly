// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItemEntity _$OrderItemEntityFromJson(Map<String, dynamic> json) =>
    _OrderItemEntity(
      id: (json['id'] as num?)?.toInt(),
      productId: (json['productId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemEntityToJson(_OrderItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'price': instance.price,
    };
