import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_entity.freezed.dart';
part 'ledger_entity.g.dart';

@freezed
abstract class LedgerEntity with _$LedgerEntity {
  const factory LedgerEntity({
    required int id,
    required PartyType partyType,
    required int partyId,
    required String invoiceNumber,
    required EntryType entryType,
    required double amount,
    String? paymentMethod,
    required DateTime entryDate,

    String? transactionSource, // manual, order, payment
    String? referenceId, // order_id, payment_id etc.

    String? remarks,
    required DateTime createdAt,
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
