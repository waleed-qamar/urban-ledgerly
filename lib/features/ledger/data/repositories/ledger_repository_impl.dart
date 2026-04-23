import 'package:ledgerly/features/ledger/domain/entities/ledger_entity.dart';
import 'package:ledgerly/features/ledger/domain/repositories/ledger_repository.dart';

import '../datasources/ledger_remote_datasource.dart';

class LedgerRepositoryImpl implements LedgerRepository {
  final LedgerRemoteDatasource _datasource;

  LedgerRepositoryImpl(this._datasource);

  @override
  Future<void> addEntry(LedgerEntity entry) => _datasource.addEntry(entry);

  @override
  Future<List<LedgerEntity>> getAllEntries() => _datasource.getAllEntries();

  @override
  Future<List<LedgerEntity>> getEntriesByDateRange(
    DateTime start,
    DateTime end,
  ) => _datasource.getEntriesByDateRange(start, end);

  @override
  Future<List<LedgerEntity>> getEntriesByType(PartyType partyType) =>
      _datasource.getEntriesByPartyType(partyType);

  @override
  Future<double> getBalance({
    required PartyType partyType,
    required int partyId,
  }) => _datasource.getBalance(partyType: partyType, partyId: partyId);

  @override
  Future<List<LedgerEntity>> getEntriesByParty({
    required PartyType partyType,
    required int partyId,
  }) => _datasource.getEntriesByParty(partyType: partyType, partyId: partyId);
}
