import '../entities/account_entity.dart';
import '../entities/account_transaction_entity.dart';

abstract class AccountLedgerRepository {
  Future<List<AccountEntity>> getAllAccounts();
  Future<AccountEntity> getAccountById(int accountId);
  Future<List<AccountTransactionEntity>> getAccountTransactions(int accountId);
  Future<AccountEntity> createAccount(AccountEntity account);
  Future<int?> getAccountIdByReference(String referenceType, int referenceId);
}
