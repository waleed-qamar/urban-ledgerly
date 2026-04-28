// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceItemEntity _$InvoiceItemEntityFromJson(Map<String, dynamic> json) =>
    _InvoiceItemEntity(
      id: (json['id'] as num?)?.toInt(),
      invoiceId: (json['invoiceId'] as num?)?.toInt(),
      orderItemId: (json['orderItemId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemEntityToJson(_InvoiceItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceId': instance.invoiceId,
      'orderItemId': instance.orderItemId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
    };
