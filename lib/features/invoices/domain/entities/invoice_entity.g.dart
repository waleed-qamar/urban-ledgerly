// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceEntity _$InvoiceEntityFromJson(Map<String, dynamic> json) =>
    _InvoiceEntity(
      id: (json['id'] as num?)?.toInt(),
      orderId: (json['orderId'] as num).toInt(),
      clientId: (json['clientId'] as num).toInt(),
      supplierId: (json['supplierId'] as num).toInt(),
      invoiceNumber: json['invoiceNumber'] as String,
      status: json['status'] as String,
      po: json['po'] as String?,
      issueDate: DateTime.parse(json['issueDate'] as String),
      subTotal: (json['subTotal'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      taxPercent: (json['taxPercent'] as num?)?.toDouble() ?? 18.00,
      taxAmount: (json['taxAmount'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      representative: json['representative'] as String,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => InvoiceItemEntity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InvoiceEntityToJson(_InvoiceEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'clientId': instance.clientId,
      'supplierId': instance.supplierId,
      'invoiceNumber': instance.invoiceNumber,
      'status': instance.status,
      'po': instance.po,
      'issueDate': instance.issueDate.toIso8601String(),
      'subTotal': instance.subTotal,
      'shippingCost': instance.shippingCost,
      'taxPercent': instance.taxPercent,
      'taxAmount': instance.taxAmount,
      'grandTotal': instance.grandTotal,
      'representative': instance.representative,
      'paidAmount': instance.paidAmount,
      'remainingAmount': instance.remainingAmount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'items': instance.items,
    };
