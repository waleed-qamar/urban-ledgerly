// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LedgerEntity _$LedgerEntityFromJson(Map<String, dynamic> json) =>
    _LedgerEntity(
      id: (json['id'] as num).toInt(),
      partyType: $enumDecode(_$PartyTypeEnumMap, json['partyType']),
      partyId: (json['partyId'] as num).toInt(),
      invoiceNumber: json['invoiceNumber'] as String,
      entryType: $enumDecode(_$EntryTypeEnumMap, json['entryType']),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      entryDate: DateTime.parse(json['entryDate'] as String),
      transactionSource: json['transactionSource'] as String?,
      referenceId: json['referenceId'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LedgerEntityToJson(_LedgerEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partyType': _$PartyTypeEnumMap[instance.partyType]!,
      'partyId': instance.partyId,
      'invoiceNumber': instance.invoiceNumber,
      'entryType': _$EntryTypeEnumMap[instance.entryType]!,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'entryDate': instance.entryDate.toIso8601String(),
      'transactionSource': instance.transactionSource,
      'referenceId': instance.referenceId,
      'remarks': instance.remarks,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PartyTypeEnumMap = {
  PartyType.client: 'client',
  PartyType.vendor: 'vendor',
};

const _$EntryTypeEnumMap = {
  EntryType.debit: 'debit',
  EntryType.credit: 'credit',
};
