import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/receipt_entity.dart';

class ReceiptRemoteDatasource {
  final SupabaseClient _client;

  ReceiptRemoteDatasource(this._client);

  static const String _receiptSelect =
      'id, client_id, receipt_number, total_amount, payment_method, account_no, remarks, received_date, created_at, '
      'allocations:receipt_allocations(id, receipt_id, invoice_id, amount, created_at)';

  Future<ReceiptEntity> createReceipt(ReceiptEntity receipt) async {
    final allocationPayload = receipt.allocations
        .map(
          (allocation) => {
            'invoice_id': allocation.invoiceId,
            'amount': allocation.amount,
          },
        )
        .toList();

    final createdReceiptId = await _client.rpc(
      'create_receipt',
      params: {
        'p_client_id': receipt.clientId,
        'p_total_amount': receipt.totalAmount,
        'p_payment_method': receipt.paymentMethod,
        'p_account_no': receipt.accountNo,
        'p_remarks': receipt.remarks,
        'p_received_date': receipt.receivedDate.toIso8601String(),
        'p_allocations': allocationPayload,
      },
    );

    final receiptId = (createdReceiptId as num).toInt();
    return getReceiptById(receiptId);
  }

  Future<void> deleteReceipt(int id) async {
    await _client.rpc('delete_receipt', params: {'p_receipt_id': id});
  }

  Future<ReceiptEntity> getReceiptById(int id) async {
    final response = await _client
        .from('receipts')
        .select(_receiptSelect)
        .eq('id', id)
        .single();

    return ReceiptEntity.fromJson(_normalizeReceiptRow(response));
  }

  Future<List<ReceiptEntity>> getReceipts() async {
    final response = await _client
        .from('receipts')
        .select(_receiptSelect)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => ReceiptEntity.fromJson(_normalizeReceiptRow(row)))
        .toList();
  }

  Map<String, dynamic> _normalizeReceiptRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);

    normalized['id'] = normalized['id'] ?? 0;
    normalized['clientId'] = normalized['clientId'] ?? normalized['client_id'];
    normalized['receiptNumber'] =
        (normalized['receiptNumber'] ?? normalized['receipt_number'])
            ?.toString();
    normalized['totalAmount'] =
        (normalized['totalAmount'] ?? normalized['total_amount'] ?? 0)
            .toDouble();
    normalized['paymentMethod'] =
        (normalized['paymentMethod'] ?? normalized['payment_method'] ?? '')
            .toString();
    normalized['accountNo'] =
        normalized['accountNo'] ?? normalized['account_no'];
    normalized['remarks'] = normalized['remarks']?.toString();
    normalized['receivedDate'] =
        (normalized['receivedDate'] ??
                normalized['received_date'] ??
                DateTime.now().toIso8601String())
            .toString();
    normalized['createdAt'] =
        normalized['createdAt'] ?? normalized['created_at'];
    normalized['allocations'] =
        (normalized['allocations'] as List<dynamic>?)
            ?.map(_normalizeAllocationRow)
            .toList() ??
        const [];

    return normalized;
  }

  Map<String, dynamic> _normalizeAllocationRow(dynamic row) {
    final normalized = Map<String, dynamic>.from(row as Map);

    normalized['id'] = normalized['id'] ?? 0;
    normalized['receiptId'] =
        normalized['receiptId'] ?? normalized['receipt_id'];
    normalized['invoiceId'] =
        normalized['invoiceId'] ?? normalized['invoice_id'] ?? 0;
    normalized['amount'] = (normalized['amount'] ?? 0).toDouble();
    normalized['createdAt'] =
        normalized['createdAt'] ?? normalized['created_at'];

    return normalized;
  }
}
