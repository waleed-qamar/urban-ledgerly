import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/ledger_remote_datasource.dart';
import '../../data/repositories/ledger_repository_impl.dart';
import '../../domain/entities/ledger_entity.dart';
import '../../domain/repositories/ledger_repository.dart';

part 'ledger_providers.g.dart';

@riverpod
LedgerRemoteDatasource ledgerRemoteDatasource(Ref ref) {
  return LedgerRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
LedgerRepository ledgerRepository(Ref ref) {
  return LedgerRepositoryImpl(ref.watch(ledgerRemoteDatasourceProvider));
}

@riverpod
Future<List<LedgerEntity>> getAllEntries(Ref ref) async {
  return ref.watch(ledgerRepositoryProvider).getAllEntries();
}

@riverpod
Future<void> addEntry(Ref ref, LedgerEntity entry) async {
  await ref.watch(ledgerRepositoryProvider).addEntry(entry);
}

@riverpod
Future<List<LedgerEntity>> getEntriesByDateRange(
  Ref ref,
  DateTime start,
  DateTime end,
) {
  return ref.watch(ledgerRepositoryProvider).getEntriesByDateRange(start, end);
}

@riverpod
Future<List<LedgerEntity>> getEntriesByType(Ref ref, PartyType partyType) {
  return ref.watch(ledgerRepositoryProvider).getEntriesByType(partyType);
}

@riverpod
Future<List<LedgerEntity>> getEntriesByParty(
  Ref ref, {
  required PartyType partyType,
  required int partyId,
}) async {
  final repository = ref.read(ledgerRepositoryProvider);
  return repository.getEntriesByParty(partyType: partyType, partyId: partyId);
}

@riverpod
Future<double> getBalance(
  Ref ref, {
  required PartyType partyType,
  required int partyId,
}) async {
  final repository = ref.read(ledgerRepositoryProvider);
  return repository.getBalance(partyType: partyType, partyId: partyId);
}
