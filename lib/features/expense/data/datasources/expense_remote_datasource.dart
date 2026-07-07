import 'package:ledgerly/features/expense/domain/entities/expense_head.dart';
import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/expense.dart';

class ExpenseRemoteDatasource {
  final SupabaseClient _client;

  ExpenseRemoteDatasource(this._client);

  List<Map<String, dynamic>> _normalizeExpenseRows(List<dynamic> rows) {
    return rows.map<Map<String, dynamic>>((r) {
      final m = Map<String, dynamic>.from(r as Map);
      if (m['amount'] == null) m['amount'] = 0;
      if (m['id'] == null) m['id'] = 0;
      if (m['expenseHeadId'] == null && m['expense_head_id'] != null) {
        m['expenseHeadId'] = m['expense_head_id'];
      }
      return m;
    }).toList();
  }

  Future<List<Expense>> _fetchPagedExpenses(
    Future<List<dynamic>> Function(int from, int to) fetchPage,
  ) async {
    const pageSize = 1000;
    var from = 0;
    final allRows = <dynamic>[];

    while (true) {
      final rows = await fetchPage(from, from + pageSize - 1);
      allRows.addAll(rows);

      if (rows.length < pageSize) break;
      from += pageSize;
    }

    return _normalizeExpenseRows(
      allRows,
    ).map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<ExpenseHead>> fectchExpenseHead() async {
    final response = await _client.from('expense_heads').select();

    return response.map((json) => ExpenseHead.fromJson(json)).toList();
  }

  Future<List<Expense>> fectchExpenses() async {
    return _fetchPagedExpenses(
      (from, to) async =>
          await _client
                  .from('expenses')
                  .select()
                  .order('date', ascending: false)
                  .range(from, to)
              as List<dynamic>,
    );
  }

  Future<List<Expense>> fectchExpensesByHead(int headId) async {
    return _fetchPagedExpenses(
      (from, to) async =>
          await _client
                  .from('expenses')
                  .select()
                  .eq('expense_head_id', headId)
                  .order('date', ascending: false)
                  .range(from, to)
              as List<dynamic>,
    );
  }

  Future<List<Expense>> fetchExpensesByDateRange(
    DateTime from,
    DateTime to,
  ) async {
    final fromUtc = from.toUtc().toIso8601String();
    final toUtc = to
        .add(const Duration(hours: 23, minutes: 59, seconds: 59))
        .toUtc()
        .toIso8601String();

    return _fetchPagedExpenses(
      (pageFrom, pageTo) async =>
          await _client
                  .from('expenses')
                  .select()
                  .gte('date', fromUtc)
                  .lte('date', toUtc)
                  .order('date', ascending: false)
                  .range(pageFrom, pageTo)
              as List<dynamic>,
    );
  }

  Future<List<Expense>> fetchFilteredExpenses({
    int? headId,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      return _fetchPagedExpenses((fromPage, toPage) async {
        var query = _client.from('expenses').select();

        if (headId != null) {
          query = query.eq('expense_head_id', headId);
        }

        if (from != null && to != null) {
          final fromUtc = from.toUtc().toIso8601String();
          final toUtc = to
              .add(const Duration(hours: 23, minutes: 59, seconds: 59))
              .toUtc()
              .toIso8601String();
          query = query.gte('date', fromUtc).lte('date', toUtc);
        }

        return await query
                .order('date', ascending: false)
                .range(fromPage, toPage)
            as List<dynamic>;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addExpenseHead(ExpenseHead expenseHead) async {
    await supabaseSafeCall(() async {
      final payload = expenseHead.toJson()..remove('id');
      await _client.from('expense_heads').insert(payload);
    });
  }

  Future<void> updateExpenseHead(ExpenseHead expenseHead) async {
    await supabaseSafeCall(() async {
      await _client
          .from('expense_heads')
          .update(expenseHead.toJson())
          .eq('id', expenseHead.id);
    });
  }

  Future<void> deleteExpenseHead(int headId) async {
    await supabaseSafeCall(() async {
      await _client.from('expense_heads').delete().eq('id', headId);
    });
  }

  Future<void> addExpense(Expense expense, {int? accountId}) async {
    await supabaseSafeCall(() async {
      await _client.rpc(
        'create_expense',
        params: {
          'p_expense_head_id': expense.expenseHeadId,
          'p_amount': expense.amount,
          'p_remarks': expense.remarks,
          'p_date': expense.date.toIso8601String(),
          'p_created_at': expense.createdAt?.toIso8601String(),
          'p_account_id': accountId,
        },
      );
    });
  }

  Future<void> updateExpense(Expense expense) async {
    await supabaseSafeCall(() async {
      final payload = expense.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at');

      // Set updated_at to now so DB records last modification time
      payload['updated_at'] = DateTime.now().toIso8601String();

      await _client.from('expenses').update(payload).eq('id', expense.id);
    });
  }
}
