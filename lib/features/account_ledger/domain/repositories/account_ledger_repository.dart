import '../entities/account_entity.dart';
import '../entities/account_transaction_entity.dart';

abstract class AccountLedgerRepository {
  Future<List<AccountEntity>> getAllAccounts();
  Future<AccountEntity> getAccountById(int accountId);
  Future<List<AccountTransactionEntity>> getAccountTransactions(int accountId);
  Future<AccountEntity> createAccount(AccountEntity account);
  Future<int?> getAccountIdByReference(String referenceType, int referenceId);
  Future<void> transferBetweenAccounts({
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String description,
    DateTime? date,
  });

  Future<Map<String, dynamic>> getTransferDetails(int transferId);

  Future<void> updateTransfer({
    required int transferId,
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String description,
    required DateTime date,
  });
}
