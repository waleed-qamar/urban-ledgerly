import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/payroll_sheet_entity.dart';
import '../../domain/entities/payroll_row_entity.dart';

class PayrollRemoteDatasource {
  final SupabaseClient _client;

  PayrollRemoteDatasource(this._client);

  /// Fetch all payout sheets sorted by cutoff date desc
  Future<List<PayrollSheetEntity>> fetchSheets() async {
    final response = await _client
        .from('payroll_sheets')
        .select()
        .order('cutoff_date', ascending: false);

    return (response as List)
        .map((json) => PayrollSheetEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single sheet by ID
  Future<PayrollSheetEntity> fetchSheetById(String sheetId) async {
    final response = await _client
        .from('payroll_sheets')
        .select()
        .eq('id', sheetId)
        .single();

    return PayrollSheetEntity.fromJson(response);
  }

  /// Create a new payout sheet and auto-populate all active operators via DB RPC
  Future<String> createSheet({
    required String company,
    required String category,
    required String title,
    required DateTime cutoffDate,
    String? operatorName,
    double amountGiven = 0.0,
    String sheetType = 'kharcha',
  }) async {
    return await supabaseSafeCall(() async {
      final res = await _client.rpc(
        'fn_create_payroll_sheet',
        params: {
          'p_company': company,
          'p_category': category,
          'p_title': title,
          'p_cutoff_date': cutoffDate.toIso8601String().split('T').first,
          'p_operator_name': operatorName,
          'p_amount_given': amountGiven,
          'p_sheet_type': sheetType,
        },
      );
      return res as String;
    });
  }

  /// Update sheet header metadata
  Future<void> updateSheet(PayrollSheetEntity sheet) async {
    await supabaseSafeCall(() async {
      await _client
          .from('payroll_sheets')
          .update(sheet.toJson())
          .eq('id', sheet.id);
    });
  }

  /// Lock sheet permanently as finalized
  Future<void> finalizeSheet(String sheetId) async {
    await supabaseSafeCall(() async {
      await _client
          .from('payroll_sheets')
          .update({'status': 'finalized'})
          .eq('id', sheetId);
    });
  }

  /// Delete a draft sheet
  Future<void> deleteSheet(String sheetId) async {
    await supabaseSafeCall(() async {
      await _client.from('payroll_sheets').delete().eq('id', sheetId);
    });
  }

  /// Fetch all rows for a sheet
  Future<List<PayrollRowEntity>> fetchSheetRows(String sheetId) async {
    final response = await _client
        .from('payroll_rows')
        .select()
        .eq('sheet_id', sheetId)
        .order('employee_id', ascending: true);

    return (response as List)
        .map((json) => PayrollRowEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Patch a single row and return the server trigger recomputed row
  Future<PayrollRowEntity> patchRow(PayrollRowEntity row) async {
    return await supabaseSafeCall(() async {
      final res = await _client
          .from('payroll_rows')
          .update(row.toPatchJson())
          .eq('id', row.id)
          .select()
          .single();

      return PayrollRowEntity.fromJson(res);
    });
  }
}
