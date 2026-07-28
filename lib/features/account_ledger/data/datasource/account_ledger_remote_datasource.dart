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
      normalized['current_balance'] = balance;
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
    normalized['current_balance'] = balance;
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
      ..remove('current_balance')
      ..remove('created_at')
      ..remove('updated_at');

    final response = await _client
        .from('accounts')
        .insert(payload)
        .select()
        .single();

    return AccountEntity.fromJson(_normalizeAccountRow(response));
  }

  Map<String, dynamic> _normalizeAccountRow(Map<String, dynamic> row) {
    return {
      ...row,
      'current_balance': row['current_balance'] ?? row['currentBalance'] ?? 0.0,
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
    DateTime? date,
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
            if (date != null) 'transfer_date': date.toIso8601String(),
          })
          .select()
          .single();

      final transferId = transferResponse['id'] as int;

      await _client.from('account_transactions').insert({
        'account_id': fromAccountId,
        'amount': amount,
        'transaction_type': 'debit',
        'reference_type': 'transfer',
        'reference_id': transferId,
        'description': 'Transfer to another account: $description',
        'transfer_id': transferId,
        if (date != null) 'transaction_date': date.toIso8601String(),
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
        if (date != null) 'transaction_date': date.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to transfer between accounts: $e');
    }
  }

  Future<Map<String, dynamic>> getTransferDetails(int transferId) async {
    try {
      final response = await _client
          .from('account_transfers')
          .select()
          .eq('id', transferId)
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch transfer details: $e');
    }
  }

  Future<void> updateTransfer({
    required int transferId,
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String description,
    required DateTime date,
  }) async {
    try {
      // 1. Update transfer record
      await _client.from('account_transfers').update({
        'from_account_id': fromAccountId,
        'to_account_id': toAccountId,
        'amount': amount,
        'description': description,
        'transfer_date': date.toIso8601String(),
      }).eq('id', transferId);

      // 2. Update debit transaction
      await _client
          .from('account_transactions')
          .update({
            'account_id': fromAccountId,
            'amount': amount,
            'description': 'Transfer to another account: $description',
            'transaction_date': date.toIso8601String(),
          })
          .eq('reference_type', 'transfer')
          .eq('reference_id', transferId)
          .eq('transaction_type', 'debit');

      // 3. Update credit transaction
      await _client
          .from('account_transactions')
          .update({
            'account_id': toAccountId,
            'amount': amount,
            'description': 'Transfer from another account: $description',
            'transaction_date': date.toIso8601String(),
          })
          .eq('reference_type', 'transfer')
          .eq('reference_id', transferId)
          .eq('transaction_type', 'credit');
    } catch (e) {
      throw Exception('Failed to update transfer: $e');
    }
  }
}
