import 'package:ledgerly/features/ledger/domain/entities/ledger_entity.dart';

abstract class LedgerRepository {
  Future<void> addEntry(LedgerEntity entry);
  Future<List<LedgerEntity>> getEntriesByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<List<LedgerEntity>> getEntriesByType(PartyType partyType);
  Future<List<LedgerEntity>> getAllEntries();

  Future<List<LedgerEntity>> getEntriesByParty({
    required PartyType partyType,
    required int partyId,
  });

  Future<double> getBalance({
    required PartyType partyType,
    required int partyId,
  });
}
