// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_allocation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptAllocationEntity _$ReceiptAllocationEntityFromJson(
  Map<String, dynamic> json,
) => _ReceiptAllocationEntity(
  id: (json['id'] as num?)?.toInt(),
  receiptId: (json['receiptId'] as num?)?.toInt(),
  invoiceId: (json['invoiceId'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ReceiptAllocationEntityToJson(
  _ReceiptAllocationEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'receiptId': instance.receiptId,
  'invoiceId': instance.invoiceId,
  'amount': instance.amount,
  'createdAt': instance.createdAt?.toIso8601String(),
};
