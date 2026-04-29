import 'package:ledgerly/features/ledger/domain/entities/ledger_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LedgerRemoteDatasource {
  final SupabaseClient _client;

  LedgerRemoteDatasource(this._client);
  Future<void> addEntry(LedgerEntity entry) async {
    final payload = _toDbRow(entry.toJson())..remove('id');
    await _client.from('ledger').insert(payload);
  }

  Future<List<LedgerEntity>> getAllEntries() async {
    final response = await _client.from('ledger').select();

    return response
        .map((json) => LedgerEntity.fromJson(_normalizeLedgerRow(json)))
        .toList();
  }

  Future<List<LedgerEntity>> getEntriesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final response = await _client
        .from('ledger')
        .select()
        .gte('entry_date', start.toIso8601String())
        .lte('entry_date', end.toIso8601String());

    return response
        .map((json) => LedgerEntity.fromJson(_normalizeLedgerRow(json)))
        .toList();
  }

  Future<List<LedgerEntity>> getEntriesByPartyType(PartyType type) async {
    final response = await _client
        .from('ledger')
        .select()
        .eq('party_type', type.value);

    return response
        .map((json) => LedgerEntity.fromJson(_normalizeLedgerRow(json)))
        .toList();
  }

  Future<List<LedgerEntity>> getEntriesByParty({
    required PartyType partyType,
    required int partyId,
  }) async {
    try {
      final response = await _client
          .from('ledger')
          .select()
          .eq('party_type', partyType.value)
          .eq('party_id', partyId)
          .order('entry_date', ascending: true);

      return response
          .map((json) => LedgerEntity.fromJson(_normalizeLedgerRow(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<double> getBalance({
    required PartyType partyType,
    required int partyId,
  }) async {
    try {
      final response = await _client
          .from('ledger')
          .select('entry_type, amount')
          .eq('party_type', partyType.value)
          .eq('party_id', partyId);

      double balance = 0;

      for (final row in response) {
        final amount = (row['amount'] as num?)?.toDouble() ?? 0.0;
        final entryType = row['entry_type'] as String?;

        if (partyType == PartyType.client) {
          // Client balance = how much client owes us.
          // Debit increases receivable, credit decreases receivable.
          if (entryType == 'debit') {
            balance += amount;
          } else {
            balance -= amount;
          }
        } else {
          // Vendor balance = how much we owe vendor.
          // Credit increases payable, debit decreases payable.
          if (entryType == 'credit') {
            balance += amount;
          } else {
            balance -= amount;
          }
        }
      }

      return balance;
    } catch (e) {
      // Return 0 if the query fails to avoid infinite loading state
      return 0.0;
    }
  }

  Map<String, dynamic> _normalizeLedgerRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);

    normalized['id'] = normalized['id'] ?? 0;
    normalized['partyType'] =
        (normalized['partyType'] ?? normalized['party_type'] ?? '').toString();
    normalized['partyId'] =
        normalized['partyId'] ?? normalized['party_id'] ?? 0;
    normalized['invoiceNumber'] =
        (normalized['invoiceNumber'] ?? normalized['invoice_number'] ?? '')
            .toString();
    normalized['entryType'] =
        (normalized['entryType'] ?? normalized['entry_type'] ?? '').toString();
    normalized['amount'] = (normalized['amount'] ?? 0).toDouble();
    normalized['paymentMethod'] =
        (normalized['paymentMethod'] ?? normalized['payment_method'])
            ?.toString();
    normalized['entryDate'] =
        (normalized['entryDate'] ??
                normalized['entry_date'] ??
                DateTime.now().toIso8601String())
            .toString();
    normalized['transactionSource'] =
        (normalized['transactionSource'] ?? normalized['transaction_source'])
            ?.toString();
    normalized['referenceId'] =
        (normalized['referenceId'] ?? normalized['reference_id'])?.toString();
    normalized['remarks'] = normalized['remarks']?.toString();
    normalized['createdAt'] =
        (normalized['createdAt'] ??
                normalized['created_at'] ??
                DateTime.now().toIso8601String())
            .toString();

    return normalized;
  }

  Map<String, dynamic> _toDbRow(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'party_type': json['partyType'],
      'party_id': json['partyId'],
      'invoice_number': json['invoiceNumber'],
      'entry_type': json['entryType'],
      'amount': json['amount'],
      'payment_method': json['paymentMethod'],
      'entry_date': json['entryDate'],
      'transaction_source': json['transactionSource'],
      'reference_id': json['referenceId'],
      'remarks': json['remarks'],
      'created_at': json['createdAt'],
    };
  }
}
