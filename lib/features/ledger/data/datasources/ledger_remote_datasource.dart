import 'package:ledgerly/features/ledger/domain/entities/ledger_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LedgerRemoteDatasource {
  final SupabaseClient _client;

  LedgerRemoteDatasource(this._client);
  Future<void> addEntry(LedgerEntity entry) async {
    await _client.from('ledger').insert(entry.toJson());
  }

  Future<List<LedgerEntity>> getAllEntries() async {
    final response = await _client.from('ledger').select();

    return response.map((json) => LedgerEntity.fromJson(json)).toList();
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

    return response.map((json) => LedgerEntity.fromJson(json)).toList();
  }

  Future<List<LedgerEntity>> getEntriesByPartyType(PartyType type) async {
    final response = await _client
        .from('ledger')
        .select()
        .eq('party_type', type.value);

    return response.map((json) => LedgerEntity.fromJson(json)).toList();
  }

  Future<List<LedgerEntity>> getEntriesByParty({
    required PartyType partyType,
    required int partyId,
  }) async {
    final response = await _client
        .from('ledger')
        .select()
        .eq('party_type', partyType.value)
        .eq('party_id', partyId)
        .order('entry_date', ascending: true);

    return response.map((json) => LedgerEntity.fromJson(json)).toList();
  }

  Future<double> getBalance({
    required PartyType partyType,
    required int partyId,
  }) async {
    final response = await _client
        .from('ledger')
        .select('entry_type, amount')
        .eq('party_type', partyType.value)
        .eq('party_id', partyId);

    double balance = 0;

    for (final row in response) {
      if (row['entry_type'] == 'credit') {
        balance += row['amount'];
      } else {
        balance -= row['amount'];
      }
    }

    return balance;
  }
}
