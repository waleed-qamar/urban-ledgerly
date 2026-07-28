import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_transaction_entity.dart';
import '../../domain/repositories/account_ledger_repository.dart';
import '../datasource/account_ledger_remote_datasource.dart';

class AccountLedgerRepositoryImpl implements AccountLedgerRepository {
  final AccountLedgerRemoteDatasource _datasource;

  AccountLedgerRepositoryImpl(this._datasource);

  @override
  Future<List<AccountEntity>> getAllAccounts() {
    return _datasource.getAllAccounts();
  }

  @override
  Future<AccountEntity> getAccountById(int accountId) {
    return _datasource.getAccountById(accountId);
  }

  @override
  Future<List<AccountTransactionEntity>> getAccountTransactions(int accountId) {
    return _datasource.getAccountTransactions(accountId);
  }

  @override
  Future<AccountEntity> createAccount(AccountEntity account) {
    return _datasource.createAccount(account);
  }

  @override
  Future<int?> getAccountIdByReference(String referenceType, int referenceId) {
    return _datasource.getAccountIdByReference(referenceType, referenceId);
  }

  @override
  Future<void> transferBetweenAccounts({
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String description,
    DateTime? date,
  }) {
    return _datasource.transferBetweenAccounts(
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
      description: description,
      date: date,
    );
  }

  @override
  Future<Map<String, dynamic>> getTransferDetails(int transferId) {
    return _datasource.getTransferDetails(transferId);
  }

  @override
  Future<void> updateTransfer({
    required int transferId,
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String description,
    required DateTime date,
  }) {
    return _datasource.updateTransfer(
      transferId: transferId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
      description: description,
      date: date,
    );
  }
}
