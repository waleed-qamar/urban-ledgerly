import 'package:ledgerly/features/expense/domain/entities/expense_head.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/expense.dart';

class ExpenseRemoteDatasource {
  final SupabaseClient _client;

  ExpenseRemoteDatasource(this._client);

  Future<List<ExpenseHead>> fectchExpenseHead() async {
    final response = await _client.from('expense_heads').select();

    return response.map((json) => ExpenseHead.fromJson(json)).toList();
  }

  Future<List<Expense>> fectchExpenses() async {
    final response = await _client.from('expenses').select();

    final rows = (response as List).map<Map<String, dynamic>>((r) {
      final m = Map<String, dynamic>.from(r as Map);
      if (m['amount'] == null) m['amount'] = 0;
      if (m['id'] == null) m['id'] = 0;
      if (m['expenseHeadId'] == null && m['expense_head_id'] != null) {
        m['expenseHeadId'] = m['expense_head_id'];
      }
      return m;
    }).toList();

    return rows.map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<Expense>> fectchExpensesByHead(int headId) async {
    final response = await _client
        .from('expenses')
        .select()
        .eq('expense_head_id', headId);
    final rows = (response as List).map<Map<String, dynamic>>((r) {
      final m = Map<String, dynamic>.from(r as Map);
      if (m['amount'] == null) m['amount'] = 0;
      if (m['id'] == null) m['id'] = 0;
      if (m['expenseHeadId'] == null && m['expense_head_id'] != null) {
        m['expenseHeadId'] = m['expense_head_id'];
      }
      return m;
    }).toList();

    return rows.map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<Expense>> fetchExpensesByDateRange(
    DateTime from,
    DateTime to,
  ) async {
    // 1. Explicitly convert 'from' to UTC
    final fromUtc = from.toUtc().toIso8601String();

    // 2. Add 23 hours, 59 minutes, 59 seconds to cover the entire 'to' day, then convert to UTC
    final toUtc = to
        .add(const Duration(hours: 23, minutes: 59, seconds: 59))
        .toUtc()
        .toIso8601String();

    final response = await _client
        .from('expenses')
        .select()
        .gte('date', fromUtc)
        .lte('date', toUtc)
        .order('date', ascending: false);
    final rows = (response as List).map<Map<String, dynamic>>((r) {
      final m = Map<String, dynamic>.from(r as Map);
      if (m['amount'] == null) m['amount'] = 0;
      if (m['id'] == null) m['id'] = 0;
      if (m['expenseHeadId'] == null && m['expense_head_id'] != null) {
        m['expenseHeadId'] = m['expense_head_id'];
      }
      return m;
    }).toList();

    return rows.map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<Expense>> fetchFilteredExpenses({
    int? headId,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      // The explicit cast here prevents the silent infinite loading error
      var query = _client.from('expenses').select();

      if (headId != null) {
        query = query.eq('expenseHeadId', headId);
      }

      if (from != null && to != null) {
        final fromUtc = from.toUtc().toIso8601String();
        final toUtc = to
            .add(const Duration(hours: 23, minutes: 59, seconds: 59))
            .toUtc()
            .toIso8601String();
        query = query.gte('date', fromUtc).lte('date', toUtc);
      }

      final response = await query.order('date', ascending: false);
      final rows = (response as List).map<Map<String, dynamic>>((r) {
        final m = Map<String, dynamic>.from(r as Map);
        if (m['amount'] == null) m['amount'] = 0;
        if (m['id'] == null) m['id'] = 0;
        if (m['expenseHeadId'] == null && m['expense_head_id'] != null) {
          m['expenseHeadId'] = m['expense_head_id'];
        }
        return m;
      }).toList();

      return rows.map((json) => Expense.fromJson(json)).toList();
    } catch (e) {
      // If it fails, print the error to console and pass it to Riverpod
      // print("Supabase Query Error: $e");
      rethrow;
    }
  }

  Future<void> addExpenseHead(ExpenseHead expenseHead) async {
    final payload = expenseHead.toJson()..remove('id');
    await _client.from('expense_heads').insert(payload);
  }

  Future<void> updateExpenseHead(ExpenseHead expenseHead) async {
    await _client
        .from('expense_heads')
        .update(expenseHead.toJson())
        .eq('id', expenseHead.id);
  }

  Future<void> deleteExpenseHead(int headId) async {
    await _client.from('expense_heads').delete().eq('id', headId);
  }

  Future<void> addExpense(Expense expense, {int? accountId}) async {
    await _client.rpc(
      'create_expense',
      params: {
        'p_expense_head_id': expense.expenseHeadId,
        'p_amount': expense.amount,
        'p_remarks': expense.remarks,
        'p_date': expense.date.toIso8601String(),
        'p_account_id': accountId,
      },
    );
  }
}
