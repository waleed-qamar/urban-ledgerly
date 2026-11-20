import 'package:supabase_flutter/supabase_flutter.dart';

class OverviewRemoteDatasource {
  final SupabaseClient _client;

  OverviewRemoteDatasource(this._client);

  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    final response = await _client
        .from('expenses')
        .select('*, expense_heads(name, head_type)');
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchDisbursements() async {
    final response = await _client.from('disbursements').select('*');
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchInvoices() async {
    final response = await _client.from('invoices').select(
        '*, invoice_items(*, products(name))');
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchReceipts() async {
    final response = await _client.from('receipts').select('*');
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchReceiptAllocations() async {
    final response = await _client.from('receipt_allocations').select('*');
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final response = await _client.from('orders').select('*, order_items(*)');
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchClients() async {
    final response = await _client.from('clients').select('*');
    return List<Map<String, dynamic>>.from(response as List);
  }
}
