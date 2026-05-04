import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_transaction_entity.freezed.dart';
part 'account_transaction_entity.g.dart';

@freezed
abstract class AccountTransactionEntity with _$AccountTransactionEntity {
  const factory AccountTransactionEntity({
    required int id,
    required int accountId,
    required double amount,
    required String transactionType, // 'credit' or 'debit'
    required String referenceType, // 'receipt', 'disbursement', 'transfer', 'expense', etc.
    int? referenceId,
    String? description,
    required DateTime transactionDate,
    @Default(false) bool isReconciled,
    DateTime? reconciledAt,
    String? externalReference,
    int? transferId,
    DateTime? createdAt,
    @Default(0.0) double runningBalance,
  }) = _AccountTransactionEntity;

  factory AccountTransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountTransactionEntityFromJson(json);
}
