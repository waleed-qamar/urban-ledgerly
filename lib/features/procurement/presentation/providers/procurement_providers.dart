import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/procurement/data/datasource/procurement_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/procurement_repository_impl.dart';
import '../../domain/entities/procurement_entity.dart';
import '../../domain/repositories/procurement_repository.dart';

part 'procurement_providers.g.dart';

@riverpod
ProcurementRemoteDatasource procurementRemoteDatasource(Ref ref) {
  return ProcurementRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ProcurementRepository procurementRepository(Ref ref) {
  return ProcurementRepositoryImpl(
    ref.watch(procurementRemoteDatasourceProvider),
  );
}

@riverpod
class ProcurementSearchQuery extends _$ProcurementSearchQuery {
  @override
  String build() => '';

  void setSearchQuery(String query) => state = query;
}

@riverpod
Future<List<ProcurementEntity>> getAllProcurements(Ref ref) {
  return ref.watch(procurementRepositoryProvider).getAllProcurements();
}

Future<ProcurementEntity> getProcurementById(Ref ref, int id) {
  return ref.watch(procurementRepositoryProvider).getProcurementById(id);
}

Future<void> createProcurement(Ref ref, ProcurementEntity procurement) {
  return ref
      .watch(procurementRepositoryProvider)
      .createProcurement(procurement);
}

Future<void> updateProcurement(Ref ref, ProcurementEntity procurement) {
  return ref
      .watch(procurementRepositoryProvider)
      .updateProcurement(procurement);
}

Future<void> deleteProcurement(Ref ref, int id) {
  return ref.watch(procurementRepositoryProvider).deleteProcurement(id);
}
