import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasource/account_ledger_remote_datasource.dart';
import '../../data/repositories/account_ledger_repository_impl.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_transaction_entity.dart';
import '../../domain/repositories/account_ledger_repository.dart';

part 'account_ledger_providers.g.dart';

@riverpod
AccountLedgerRemoteDatasource accountLedgerRemoteDatasource(Ref ref) {
  return AccountLedgerRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
AccountLedgerRepository accountLedgerRepository(Ref ref) {
  return AccountLedgerRepositoryImpl(
    ref.watch(accountLedgerRemoteDatasourceProvider),
  );
}

@riverpod
Future<List<AccountEntity>> getAllAccounts(Ref ref) {
  return ref.watch(accountLedgerRepositoryProvider).getAllAccounts();
}

@riverpod
Future<AccountEntity> getAccountById(Ref ref, int accountId) {
  return ref.watch(accountLedgerRepositoryProvider).getAccountById(accountId);
}

@riverpod
Future<List<AccountTransactionEntity>> getAccountTransactions(
  Ref ref,
  int accountId,
) {
  return ref
      .watch(accountLedgerRepositoryProvider)
      .getAccountTransactions(accountId);
}

@riverpod
Future<void> createAccount(Ref ref, AccountEntity account) {
  return ref.watch(accountLedgerRepositoryProvider).createAccount(account);
}

@riverpod
Future<int?> getAccountIdByReference(
  Ref ref, {
  required String referenceType,
  required int referenceId,
}) {
  return ref
      .watch(accountLedgerRepositoryProvider)
      .getAccountIdByReference(referenceType, referenceId);
}

@riverpod
Future<void> transferBetweenAccounts(
  Ref ref, {
  required int fromAccountId,
  required int toAccountId,
  required double amount,
  required String description,
}) {
  return ref
      .watch(accountLedgerRepositoryProvider)
      .transferBetweenAccounts(
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        amount: amount,
        description: description,
      );
}
