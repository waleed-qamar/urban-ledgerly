import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/dps_models.dart';

class DpsRepository {
  final SupabaseClient _client;

  DpsRepository(this._client);

  Future<List<Machine>> getMachines() async {
    final response = await _client.from('machines').select().order('name');
    return response.map((json) => Machine.fromJson(json)).toList();
  }

  Future<List<DpsReport>> getReports() async {
    final response = await _client.from('dps_reports').select().order('report_date', ascending: false);
    return response.map((json) => DpsReport.fromJson(json)).toList();
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

    final response = await _client.rpc('create_dps_report', params: {'payload': payload});
    return response as int;
  }
}
