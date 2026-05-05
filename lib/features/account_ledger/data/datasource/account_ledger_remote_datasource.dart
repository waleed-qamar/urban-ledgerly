import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_transaction_entity.dart';

class AccountLedgerRemoteDatasource {
  final SupabaseClient _client;

  AccountLedgerRemoteDatasource(this._client);

  Future<List<AccountEntity>> getAllAccounts() async {
    // Fetch all accounts and calculate their current balances
    final accountsResponse = await _client
        .from('accounts')
        .select()
        .eq('is_active', true);

    List<AccountEntity> accounts = [];

    for (var row in accountsResponse) {
      final accountId = row['id'];

      // Compute balance from account_transactions
      final txResponse = await _client
          .from('account_transactions')
          .select('amount, transaction_type')
          .eq('account_id', accountId);

      double balance = 0.0;
      for (var tx in txResponse) {
        final amount = (tx['amount'] as num).toDouble();
        if (tx['transaction_type'] == 'credit') {
          balance += amount; // Money in
        } else {
          balance -= amount; // Money out
        }
      }

      var normalized = _normalizeAccountRow(row);
      normalized['currentBalance'] = balance;
      accounts.add(AccountEntity.fromJson(normalized));
    }

    return accounts;
  }

  Future<AccountEntity> getAccountById(int accountId) async {
    final row = await _client
        .from('accounts')
        .select()
        .eq('id', accountId)
        .single();

    final txResponse = await _client
        .from('account_transactions')
        .select('amount, transaction_type')
        .eq('account_id', accountId);

    double balance = 0.0;
    for (var tx in txResponse) {
      final amount = (tx['amount'] as num).toDouble();
      if (tx['transaction_type'] == 'credit') {
        balance += amount;
      } else {
        balance -= amount;
      }
    }

    var normalized = _normalizeAccountRow(row);
    normalized['currentBalance'] = balance;
    return AccountEntity.fromJson(normalized);
  }

  Future<List<AccountTransactionEntity>> getAccountTransactions(
    int accountId,
  ) async {
    final response = await _client
        .from('account_transactions')
        .select()
        .eq('account_id', accountId)
        .order(
          'transaction_date',
          ascending: true,
        ); // Ascending to calculate running balance

    List<AccountTransactionEntity> transactions = [];
    double runningBalance = 0.0;

    for (var row in response) {
      final normalized = _normalizeTransactionRow(row);
      final amount = normalized['amount'] as double;
      if (normalized['transactionType'] == 'credit') {
        runningBalance += amount;
      } else {
        runningBalance -= amount;
      }
      normalized['runningBalance'] = runningBalance;
      transactions.add(AccountTransactionEntity.fromJson(normalized));
    }

    // Usually we want to show the newest first in the UI
    return transactions.reversed.toList();
  }

  Future<AccountEntity> createAccount(AccountEntity account) async {
    final payload = account.toJson()
      ..remove('id')
      ..remove('currentBalance')
      ..remove('createdAt')
      ..remove('updatedAt');

    final response = await _client
        .from('accounts')
        .insert(payload)
        .select()
        .single();

    return AccountEntity.fromJson(_normalizeAccountRow(response));
  }

  Map<String, dynamic> _normalizeAccountRow(Map<String, dynamic> row) {
    return {
      'id': row['id'] ?? 0,
      'accountTitle': row['account_title']?.toString() ?? '',
      'accountType': row['account_type']?.toString() ?? '',
      'bankName': row['bank_name']?.toString(),
      'accountNumber': row['account_number']?.toString(),
      'currency': row['currency']?.toString() ?? 'PKR',
      'isActive': row['is_active'] ?? true,
      'createdAt': row['created_at']?.toString(),
      'updatedAt': row['updated_at']?.toString(),
      'currentBalance': row['currentBalance'] ?? 0.0,
    };
  }

  Map<String, dynamic> _normalizeTransactionRow(Map<String, dynamic> row) {
    return {
      'id': row['id'] ?? 0,
      'accountId': row['account_id'] ?? 0,
      'amount': (row['amount'] as num?)?.toDouble() ?? 0.0,
      'transactionType': row['transaction_type']?.toString() ?? '',
      'referenceType': row['reference_type']?.toString() ?? '',
      'referenceId': row['reference_id'],
      'description': row['description']?.toString(),
      'transactionDate':
          row['transaction_date']?.toString() ??
          DateTime.now().toIso8601String(),
      'isReconciled': row['is_reconciled'] ?? false,
      'reconciledAt': row['reconciled_at']?.toString(),
      'externalReference': row['external_reference']?.toString(),
      'transferId': row['transfer_id'],
      'createdAt': row['created_at']?.toString(),
    };
  }

  Future<int?> getAccountIdByReference(
    String referenceType,
    int referenceId,
  ) async {
    final response = await _client
        .from('account_transactions')
        .select('account_id')
        .eq('reference_type', referenceType)
        .eq('reference_id', referenceId)
        .limit(1);

    if (response.isEmpty) return null;
    return response.first['account_id'] as int?;
  }

  /// Transfer money between two accounts
  /// Creates a debit transaction in [fromAccountId] and a credit in [toAccountId]
  /// Both transactions are linked via [transfer_id]
  Future<void> transferBetweenAccounts({
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String description,
  }) async {
    try {
      // First, create the transfer record in account_transfers table
      final transferResponse = await _client
          .from('account_transfers')
          .insert({
            'from_account_id': fromAccountId,
            'to_account_id': toAccountId,
            'amount': amount,
            'description': description,
          })
          .select()
          .single();

      final transferId = transferResponse['id'] as int;

      // Create debit transaction in source account
      await _client.from('account_transactions').insert({
        'account_id': fromAccountId,
        'amount': amount,
        'transaction_type': 'debit',
        'reference_type': 'transfer',
        'reference_id': transferId,
        'description': 'Transfer to another account: $description',
        'transfer_id': transferId,
      });

      // Create credit transaction in destination account
      await _client.from('account_transactions').insert({
        'account_id': toAccountId,
        'amount': amount,
        'transaction_type': 'credit',
        'reference_type': 'transfer',
        'reference_id': transferId,
        'description': 'Transfer from another account: $description',
        'transfer_id': transferId,
      });
    } catch (e) {
      throw Exception('Failed to transfer between accounts: $e');
    }
  }
}
