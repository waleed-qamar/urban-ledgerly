// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountTransactionEntity _$AccountTransactionEntityFromJson(
  Map<String, dynamic> json,
) => _AccountTransactionEntity(
  id: (json['id'] as num).toInt(),
  accountId: (json['accountId'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  transactionType: json['transactionType'] as String,
  referenceType: json['referenceType'] as String,
  referenceId: (json['referenceId'] as num?)?.toInt(),
  description: json['description'] as String?,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  isReconciled: json['isReconciled'] as bool? ?? false,
  reconciledAt: json['reconciledAt'] == null
      ? null
      : DateTime.parse(json['reconciledAt'] as String),
  externalReference: json['externalReference'] as String?,
  transferId: (json['transferId'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  runningBalance: (json['runningBalance'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$AccountTransactionEntityToJson(
  _AccountTransactionEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'accountId': instance.accountId,
  'amount': instance.amount,
  'transactionType': instance.transactionType,
  'referenceType': instance.referenceType,
  'referenceId': instance.referenceId,
  'description': instance.description,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'isReconciled': instance.isReconciled,
  'reconciledAt': instance.reconciledAt?.toIso8601String(),
  'externalReference': instance.externalReference,
  'transferId': instance.transferId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'runningBalance': instance.runningBalance,
};
