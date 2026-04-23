// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LedgerEntity _$LedgerEntityFromJson(Map<String, dynamic> json) =>
    _LedgerEntity(
      id: (json['id'] as num).toInt(),
      partyType: $enumDecode(_$PartyTypeEnumMap, json['party_type']),
      partyId: (json['party_id'] as num).toInt(),
      invoiceNumber: json['invoice_number'] as String,
      entryType: $enumDecode(_$EntryTypeEnumMap, json['entry_type']),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String?,
      entryDate: DateTime.parse(json['entry_date'] as String),
      transactionSource: json['transaction_source'] as String?,
      referenceId: json['reference_id'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$LedgerEntityToJson(_LedgerEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'party_type': _$PartyTypeEnumMap[instance.partyType]!,
      'party_id': instance.partyId,
      'invoice_number': instance.invoiceNumber,
      'entry_type': _$EntryTypeEnumMap[instance.entryType]!,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
      'entry_date': instance.entryDate.toIso8601String(),
      'transaction_source': instance.transactionSource,
      'reference_id': instance.referenceId,
      'remarks': instance.remarks,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$PartyTypeEnumMap = {
  PartyType.client: 'client',
  PartyType.vendor: 'vendor',
};

const _$EntryTypeEnumMap = {
  EntryType.debit: 'debit',
  EntryType.credit: 'credit',
};
