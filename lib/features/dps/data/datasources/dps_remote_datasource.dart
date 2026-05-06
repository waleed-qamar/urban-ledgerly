import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/dps_models.dart';

class DpsRemoteDataSource {
  final SupabaseClient _client;

  DpsRemoteDataSource(this._client);

  Future<List<Map<String, dynamic>>> _selectFrom(
    String table, {
    String? eqColumn,
    dynamic eqValue,
    List<int>? inIds,
    String? orderBy,
  }) async {
    // Use a dynamic builder to avoid Postgrest type mismatches and use
    // `.filter(..., 'in', ...)` for list membership which the client supports.
    dynamic query = _client.from(table).select();
    if (eqColumn != null && eqValue != null) {
      query = query.eq(eqColumn, eqValue);
    }
    if (inIds != null && inIds.isNotEmpty) {
      // PostgREST expects an `in` value like "(1,2,3)"
      final inValue = '(${inIds.join(',')})';
      query = query.filter('report_id', 'in', inValue);
    }
    if (orderBy != null) {
      query = query.order(orderBy);
    }
    final response = await query;
    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<List<Machine>> getMachines() async {
    final response = await _selectFrom('machines', orderBy: 'name');
    return response.map((json) => Machine.fromJson(json)).toList();
  }

  Future<List<DpsReport>> getReports() async {
    final response = await _selectFrom('dps_reports', orderBy: 'report_date');
    return response.map((json) => DpsReport.fromJson(json)).toList();
  }

  Future<List<DpsEnergyLog>> getEnergyLogsForReport(int reportId) async {
    final response = await _selectFrom(
      'dps_energy_logs',
      eqColumn: 'report_id',
      eqValue: reportId,
      orderBy: 'machine_id',
    );
    return response.map((json) => DpsEnergyLog.fromJson(json)).toList();
  }

  Future<List<DpsProductionLog>> getProductionLogsForReport(
    int reportId,
  ) async {
    final response = await _selectFrom(
      'dps_production_logs',
      eqColumn: 'report_id',
      eqValue: reportId,
      orderBy: 'machine_id',
    );
    return response.map((json) => DpsProductionLog.fromJson(json)).toList();
  }

  Future<List<DpsConsumptionLog>> getConsumptionLogsForReport(
    int reportId,
  ) async {
    final response = await _selectFrom(
      'dps_consumption_logs',
      eqColumn: 'report_id',
      eqValue: reportId,
      orderBy: 'machine_id',
    );
    return response.map((json) => DpsConsumptionLog.fromJson(json)).toList();
  }

  Future<List<DpsDamageLog>> getDamageLogsForReport(int reportId) async {
    final response = await _selectFrom(
      'dps_damage_logs',
      eqColumn: 'report_id',
      eqValue: reportId,
      orderBy: 'machine_id',
    );
    return response.map((json) => DpsDamageLog.fromJson(json)).toList();
  }

  Future<List<DpsProductionLog>> getProductionLogsForReportIds(
    List<int> reportIds,
  ) async {
    if (reportIds.isEmpty) return [];
    final response = await _selectFrom(
      'dps_production_logs',
      inIds: reportIds,
      orderBy: 'machine_id',
    );
    return response.map((json) => DpsProductionLog.fromJson(json)).toList();
  }

  Future<List<DpsConsumptionLog>> getConsumptionLogsForReportIds(
    List<int> reportIds,
  ) async {
    if (reportIds.isEmpty) return [];
    final response = await _selectFrom(
      'dps_consumption_logs',
      inIds: reportIds,
      orderBy: 'machine_id',
    );
    return response.map((json) => DpsConsumptionLog.fromJson(json)).toList();
  }

  Future<List<DpsDamageLog>> getDamageLogsForReportIds(
    List<int> reportIds,
  ) async {
    if (reportIds.isEmpty) return [];
    final response = await _selectFrom(
      'dps_damage_logs',
      inIds: reportIds,
      orderBy: 'machine_id',
    );
    return response.map((json) => DpsDamageLog.fromJson(json)).toList();
  }

  Future<int> createReport({
    required DateTime reportDate,
    required List<DpsEnergyLog> energyLogs,
    required List<DpsProductionLog> productionLogs,
    required List<DpsConsumptionLog> consumptionLogs,
    required List<DpsDamageLog> damageLogs,
  }) async {
    final payload = {
      'report_date': reportDate.toIso8601String().split('T').first,
      'energy': energyLogs.map((e) => e.toJson()).toList(),
      'production': productionLogs.map((e) => e.toJson()).toList(),
      'consumption': consumptionLogs.map((e) => e.toJson()).toList(),
      'damage': damageLogs.map((e) => e.toJson()).toList(),
    };

    final response = await _client.rpc(
      'create_dps_report',
      params: {'payload': payload},
    );
    return response as int;
  }
}
