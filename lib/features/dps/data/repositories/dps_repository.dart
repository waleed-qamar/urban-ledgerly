import '../../domain/entities/dps_models.dart';
import '../../domain/repositories/dps_repository.dart';
import '../datasources/dps_remote_datasource.dart';

class DpsRepositoryImpl implements DpsRepository {
  final DpsRemoteDataSource remote;

  DpsRepositoryImpl(this.remote);

  @override
  Future<List<Machine>> getMachines() => remote.getMachines();

  @override
  Future<List<DpsReport>> getReports() => remote.getReports();

  @override
  Future<List<DpsProductionLog>> getProductionLogsForReport(int reportId) =>
      remote.getProductionLogsForReport(reportId);

  @override
  Future<List<DpsConsumptionLog>> getConsumptionLogsForReport(int reportId) =>
      remote.getConsumptionLogsForReport(reportId);

  @override
  Future<List<DpsDamageLog>> getDamageLogsForReport(int reportId) =>
      remote.getDamageLogsForReport(reportId);

  @override
  Future<List<DpsProductionLog>> getProductionLogsForReportIds(
    List<int> reportIds,
  ) => remote.getProductionLogsForReportIds(reportIds);

  @override
  Future<List<DpsConsumptionLog>> getConsumptionLogsForReportIds(
    List<int> reportIds,
  ) => remote.getConsumptionLogsForReportIds(reportIds);

  @override
  Future<List<DpsDamageLog>> getDamageLogsForReportIds(List<int> reportIds) =>
      remote.getDamageLogsForReportIds(reportIds);

  @override
  Future<int> createReport({
    required DateTime reportDate,
    required List<DpsProductionLog> productionLogs,
    required List<DpsConsumptionLog> consumptionLogs,
    required List<DpsDamageLog> damageLogs,
  }) => remote.createReport(
    reportDate: reportDate,
    productionLogs: productionLogs,
    consumptionLogs: consumptionLogs,
    damageLogs: damageLogs,
  );

  @override
  Future<void> updateReport({
    required int reportId,
    required DateTime reportDate,
    String? notes,
    required List<DpsProductionLog> productionLogs,
    required List<DpsConsumptionLog> consumptionLogs,
    required List<DpsDamageLog> damageLogs,
  }) => remote.updateReport(
    reportId: reportId,
    reportDate: reportDate,
    notes: notes,
    productionLogs: productionLogs,
    consumptionLogs: consumptionLogs,
    damageLogs: damageLogs,
  );
}
