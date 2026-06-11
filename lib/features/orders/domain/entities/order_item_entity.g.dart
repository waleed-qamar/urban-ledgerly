// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItemEntity _$OrderItemEntityFromJson(Map<String, dynamic> json) =>
    _OrderItemEntity(
      id: (json['id'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      setId: (json['setId'] as num?)?.toInt(),
      isSet: json['isSet'] as bool? ?? false,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      invoicedQuantity: (json['invoicedQuantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderItemEntityToJson(_OrderItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'setId': instance.setId,
      'isSet': instance.isSet,
      'quantity': instance.quantity,
      'price': instance.price,
      'invoicedQuantity': instance.invoicedQuantity,
    };
