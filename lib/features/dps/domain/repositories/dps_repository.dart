import '../entities/dps_models.dart';

abstract class DpsRepository {
  Future<List<Machine>> getMachines();

  Future<List<DpsReport>> getReports();



  Future<List<DpsProductionLog>> getProductionLogsForReport(int reportId);

  Future<List<DpsConsumptionLog>> getConsumptionLogsForReport(int reportId);

  Future<List<DpsDamageLog>> getDamageLogsForReport(int reportId);

  Future<List<DpsProductionLog>> getProductionLogsForReportIds(
    List<int> reportIds,
  );

  Future<List<DpsConsumptionLog>> getConsumptionLogsForReportIds(
    List<int> reportIds,
  );

  Future<List<DpsDamageLog>> getDamageLogsForReportIds(List<int> reportIds);

  Future<int> createReport({
    required DateTime reportDate,
    required List<DpsProductionLog> productionLogs,
    required List<DpsConsumptionLog> consumptionLogs,
    required List<DpsDamageLog> damageLogs,
  });

  Future<void> updateReport({
    required int reportId,
    required DateTime reportDate,
    String? notes,
    required List<DpsProductionLog> productionLogs,
    required List<DpsConsumptionLog> consumptionLogs,
    required List<DpsDamageLog> damageLogs,
  });
}
