import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportsRemoteDatasource {
  final SupabaseClient _client;

  ReportsRemoteDatasource(this._client);

  String _formatDateOnly(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  /// Fetch non-cancelled invoices with items in the given date range
  Future<List<Map<String, dynamic>>> fetchInvoices(
    DateTime start,
    DateTime end,
  ) async {
    final response = await _client
        .from('invoices')
        .select('id, grand_total, sub_total, issue_date, status, invoice_items(id, product_id, quantity, unit_price, total_price)')
        .gte('issue_date', start.toIso8601String())
        .lte('issue_date', end.toIso8601String())
        .neq('status', 'cancelled');
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Fetch invoice items sold within the date range
  Future<List<Map<String, dynamic>>> fetchSoldInvoiceItems(
    DateTime start,
    DateTime end,
  ) async {
    final invoices = await fetchInvoices(start, end);
    final List<Map<String, dynamic>> items = [];
    for (final inv in invoices) {
      final rawItems = inv['invoice_items'];
      if (rawItems is List) {
        for (final item in rawItems) {
          items.add(Map<String, dynamic>.from(item as Map));
        }
      }
    }
    return items;
  }

  /// Fetch cash/bank receipts in date range
  Future<List<Map<String, dynamic>>> fetchReceipts(
    DateTime start,
    DateTime end,
  ) async {
    final response = await _client
        .from('receipts')
        .select('id, total_amount, received_date')
        .gte('received_date', start.toIso8601String())
        .lte('received_date', end.toIso8601String());
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Fetch all products
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await _client
        .from('products')
        .select('id, name, price, weight')
        .order('name');
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Fetch all raw materials
  Future<List<Map<String, dynamic>>> fetchRawMaterials() async {
    final response = await _client
        .from('raw_material')
        .select('id, name, price, unit')
        .order('name');
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Fetch DPS reports and their production logs in the date range
  Future<List<Map<String, dynamic>>> fetchDpsProductionLogs(
    DateTime start,
    DateTime end,
  ) async {
    final startStr = _formatDateOnly(start);
    final endStr = _formatDateOnly(end);

    final response = await _client
        .from('dps_reports')
        .select('id, report_date, status, dps_production_logs(id, product_id, quantity, unit_weight)')
        .gte('report_date', startStr)
        .lte('report_date', endStr);

    final List<Map<String, dynamic>> logs = [];
    for (final report in response as List) {
      final reportMap = Map<String, dynamic>.from(report as Map);
      final rawLogs = reportMap['dps_production_logs'];
      if (rawLogs is List) {
        for (final log in rawLogs) {
          final logMap = Map<String, dynamic>.from(log as Map);
          logMap['report_date'] = reportMap['report_date'];
          logs.add(logMap);
        }
      }
    }
    return logs;
  }

  /// Fetch all inventory transactions up to [upToDate]
  Future<List<Map<String, dynamic>>> fetchInventoryTransactionsUpTo(
    DateTime upToDate,
  ) async {
    final response = await _client
        .from('inventory_transactions')
        .select('id, item_id, item_type, transaction_type, quantity, transaction_date')
        .lte('transaction_date', upToDate.toIso8601String());
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Fetch ledger entries up to [upToDate]
  Future<List<Map<String, dynamic>>> fetchLedgerEntriesUpTo(
    DateTime upToDate,
  ) async {
    final dateStr = _formatDateOnly(upToDate);
    final response = await _client
        .from('ledger')
        .select('id, party_type, party_id, entry_type, amount, entry_date')
        .lte('entry_date', dateStr);
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Fetch accounts and transactions to calculate cash in hand as of [upToDate]
  Future<double> fetchCashInHandAsOf(DateTime upToDate) async {
    // 1. Get initial balances from accounts
    final accounts = await _client
        .from('accounts')
        .select('id, initial_balance, is_active')
        .eq('is_active', true);

    double total = 0.0;
    for (final acc in accounts as List) {
      total += ((acc['initial_balance'] as num?)?.toDouble() ?? 0.0);
    }

    // 2. Add net credit - debit up to [upToDate]
    final txs = await _client
        .from('account_transactions')
        .select('amount, transaction_type, transaction_date')
        .lte('transaction_date', upToDate.toIso8601String());

    for (final tx in txs as List) {
      final amt = ((tx['amount'] as num?)?.toDouble() ?? 0.0);
      final type = tx['transaction_type'] as String?;
      if (type == 'credit') {
        total += amt;
      } else if (type == 'debit') {
        total -= amt;
      }
    }

    return total;
  }

  /// Fetch expenses joined with expense_heads in date range
  Future<List<Map<String, dynamic>>> fetchExpenses(
    DateTime start,
    DateTime end,
  ) async {
    final response = await _client
        .from('expenses')
        .select('id, expense_head_id, amount, remarks, date, expense_heads(id, name, head_type)')
        .gte('date', start.toIso8601String())
        .lte('date', end.toIso8601String());
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Fetch procurements in date range
  Future<List<Map<String, dynamic>>> fetchProcurements(
    DateTime start,
    DateTime end,
  ) async {
    final startStr = _formatDateOnly(start);
    final endStr = _formatDateOnly(end);
    final response = await _client
        .from('procurements')
        .select('id, grand_total, items_total, procurement_date')
        .gte('procurement_date', startStr)
        .lte('procurement_date', endStr);
    return List<Map<String, dynamic>>.from(response as List);
  }
}
