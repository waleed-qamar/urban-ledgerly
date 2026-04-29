// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptEntity _$ReceiptEntityFromJson(Map<String, dynamic> json) =>
    _ReceiptEntity(
      id: (json['id'] as num?)?.toInt(),
      clientId: (json['clientId'] as num).toInt(),
      receiptNumber: json['receiptNumber'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      accountNo: json['accountNo'] as String?,
      remarks: json['remarks'] as String?,
      receivedDate: DateTime.parse(json['receivedDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      allocations:
          (json['allocations'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ReceiptAllocationEntity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ReceiptEntityToJson(_ReceiptEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'receiptNumber': instance.receiptNumber,
      'totalAmount': instance.totalAmount,
      'paymentMethod': instance.paymentMethod,
      'accountNo': instance.accountNo,
      'remarks': instance.remarks,
      'receivedDate': instance.receivedDate.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'allocations': instance.allocations,
    };
