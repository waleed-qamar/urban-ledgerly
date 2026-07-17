import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/attendance_adjustment_draft.dart';
import '../models/attendance_day_row_model.dart';
import '../models/operator_wage_rate_model.dart';
import '../models/wage_role_model.dart';

class AttendanceReviewSupabaseDatasource {
  final SupabaseClient _client;

  AttendanceReviewSupabaseDatasource(this._client);

  Future<List<AttendanceDayRowModel>> getDayRows({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _client.rpc('attendance_review_rows', params: {
      'p_operator_id': operatorId,
      'p_from_date': from.toIso8601String().split('T')[0],
      'p_to_date': to.toIso8601String().split('T')[0],
    });

    return (response as List<dynamic>)
        .map((e) => AttendanceDayRowModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<WageRoleModel>> getWageRolesForWorkGroup(int workGroupId) async {
    final response = await _client
        .from('wage_roles')
        .select()
        .eq('work_group_id', workGroupId)
        .eq('is_active', true);

    return (response as List<dynamic>)
        .map((e) => WageRoleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OperatorWageRateModel?> getWageRate({
    required int operatorId,
    required int wageRoleId,
    required DateTime asOfDate,
  }) async {
    final response = await _client.rpc('get_operator_wage_rate', params: {
      'p_operator_id': operatorId,
      'p_wage_role_id': wageRoleId,
      'p_as_of_date': asOfDate.toIso8601String().split('T')[0],
    }).maybeSingle();

    if (response == null) return null;
    return OperatorWageRateModel.fromJson(response);
  }

  Future<void> saveAdjustments(List<AttendanceAdjustmentDraft> drafts) async {
    final payload = drafts.map((d) {
      return {
        'operatorId': d.operatorId,
        'date': d.date.toIso8601String().split('T')[0],
        'adjustedInAt': d.adjustedInAt?.toIso8601String(),
        'adjustedOutAt': d.adjustedOutAt?.toIso8601String(),
        'adjustedOtMinutes': d.adjustedOtMinutes,
        'shiftRoleId': d.shiftRoleId,
        'otRoleId': d.otRoleId,
        'reason': d.reason,
      };
    }).toList();

    await _client.rpc('save_attendance_adjustments', params: {
      'p_payload': payload,
    });
  }

  Future<void> recalculate({
    required DateTime from,
    required DateTime to,
    int? operatorId,
  }) async {
    await _client.rpc('recalculate_attendance_daily', params: {
      'p_from_date': from.toIso8601String().split('T')[0],
      'p_to_date': to.toIso8601String().split('T')[0],
      if (operatorId != null) 'p_operator_id': operatorId,
    });
  }

  Future<void> finalizeWeek({
    required DateTime from,
    required DateTime to,
  }) async {
    await _client.rpc('finalize_attendance_week', params: {
      'p_from_date': from.toIso8601String().split('T')[0],
      'p_to_date': to.toIso8601String().split('T')[0],
    });
  }

  Future<Map<String, dynamic>> getPeriodSummary({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  }) async {
    // This is a simplified calculation, normally this could be a dedicated RPC
    // or view that aggregates the daily_work_segments over a period.
    // For now, we will query the operator info and use the rows RPC as a base.
    
    final operatorRes = await _client
        .from('operators')
        .select('name')
        .eq('id', operatorId)
        .single();
        
    final rows = await getDayRows(operatorId: operatorId, from: from, to: to);
    
    int absentDays = 0;
    int totalShiftMinutes = 0;
    int totalOtMinutes = 0;
    double baseSalary = 0.0;
    double overtimePay = 0.0;
    double takeHome = 0.0;
    
    for (var row in rows) {
      if (row.isAbsent == true) absentDays++;
      totalShiftMinutes += row.shiftMinutes ?? 0;
      totalOtMinutes += row.otMinutes ?? 0;
      baseSalary += row.salaryAmount ?? 0.0;
      overtimePay += row.overtimeAmount ?? 0.0;
      takeHome += row.takeHomeAmount ?? 0.0;
    }
    
    return {
      'operator_id': operatorId,
      'operator_name': operatorRes['name'] ?? 'Unknown',
      'absent_days': absentDays,
      'total_shift_minutes': totalShiftMinutes,
      'total_ot_minutes': totalOtMinutes,
      'base_salary': baseSalary,
      'overtime_pay': overtimePay,
      'take_home': takeHome,
    };
  }
}
