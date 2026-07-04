import '../../domain/entities/procurement_entity.dart';
import '../../domain/repositories/procurement_repository.dart';
import '../datasource/procurement_remote_datasource.dart';

class ProcurementRepositoryImpl implements ProcurementRepository {
  final ProcurementRemoteDatasource _datasource;

  ProcurementRepositoryImpl(this._datasource);

  @override
  Future<void> createProcurement(ProcurementEntity procurement) =>
      _datasource.createProcurement(procurement);

  @override
  Future<void> deleteProcurement(int id) => _datasource.deleteProcurement(id);

  @override
  Future<List<ProcurementEntity>> getAllProcurements() =>
      _datasource.getAllProcurements();

  @override
  Future<ProcurementEntity> getProcurementById(int id) =>
      _datasource.getProcurementById(id);

  @override
  Future<void> updateProcurement(ProcurementEntity procurement) =>
      _datasource.updateProcurement(procurement);
}
