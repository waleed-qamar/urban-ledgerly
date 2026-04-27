import '../entities/procurement_entity.dart';

abstract class ProcurementRepository {
  Future<List<ProcurementEntity>> getAllProcurements();
  Future<ProcurementEntity> getProcurementById(int id);
  Future<void> createProcurement(ProcurementEntity procurement);
  Future<void> updateProcurement(ProcurementEntity procurement);
  Future<void> deleteProcurement(int id);
}
