import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_entity.freezed.dart';
part 'ledger_entity.g.dart';

@freezed
abstract class LedgerEntity with _$LedgerEntity {
  const factory LedgerEntity({
    required int id,
    @JsonKey(name: 'party_type') required PartyType partyType,
    @JsonKey(name: 'party_id') required int partyId,
    @JsonKey(name: 'invoice_number') String? invoiceNumber,
    @JsonKey(name: 'entry_type') required EntryType entryType,
    required double amount,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'entry_date') required DateTime entryDate,

    @JsonKey(name: 'transaction_source') String? transactionSource,
    @JsonKey(name: 'reference_id') String? referenceId,

    String? remarks,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _LedgerEntity;

  factory LedgerEntity.fromJson(Map<String, dynamic> json) =>
      _$LedgerEntityFromJson(json);
}

enum PartyType {
  client,
  vendor;

  String get value => switch (this) {
    PartyType.client => 'client',
    PartyType.vendor => 'vendor',
  };
}

enum EntryType {
  debit,
  credit;

  String get value {
    switch (this) {
      case EntryType.debit:
        return 'debit';
      case EntryType.credit:
        return 'credit';
    }
  }
}
