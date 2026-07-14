import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/disbursement_record.dart';
import '../../domain/entities/receipt_entity.dart';

class ReceiptRemoteDatasource {
  final SupabaseClient _client;

  ReceiptRemoteDatasource(this._client);

  static const String _receiptSelect =
      'id, client_id, receipt_number, total_amount, payment_method, account_no, remarks, received_date, created_at, '
      'allocations:receipt_allocations(id, receipt_id, invoice_id, amount, created_at)';

  Future<ReceiptEntity> createReceipt(ReceiptEntity receipt) async {
    return supabaseSafeCall(() async {
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
          'p_account_id': receipt.accountId,
          'p_remarks': receipt.remarks,
          'p_received_date': receipt.receivedDate.toIso8601String(),
          'p_allocations': allocationPayload,
        },
      );

      final receiptId = (createdReceiptId as num).toInt();
      return getReceiptById(receiptId);
    });
  }

  Future<void> createDisbursement({
    required int supplierId,
    required double totalAmount,
    required String paymentMethod,
    String? accountNo,
    int? accountId,
    String? category,
    String? remarks,
    DateTime? paidDate,
  }) async {
    await supabaseSafeCall(() async {
      await _client.rpc(
        'create_disbursement',
        params: {
          'p_supplier_id': supplierId,
          'p_total_amount': totalAmount,
          'p_payment_method': paymentMethod,
          'p_account_no': accountNo,
          'p_account_id': accountId,
          'p_category': category,
          'p_remarks': remarks,
          'p_paid_date': (paidDate ?? DateTime.now()).toIso8601String(),
        },
      );
    });
  }

  Future<void> deleteReceipt(int id) async {
    await supabaseSafeCall(() async {
      await _client.rpc('delete_receipt', params: {'p_receipt_id': id});
    });
  }

  Future<void> updateReceipt({
    required int id,
    required String paymentMethod,
    String? accountNo,
    String? remarks,
    required DateTime receivedDate,
  }) async {
    await supabaseSafeCall(() async {
      await _client.from('receipts').update({
        'payment_method': paymentMethod,
        'account_no': accountNo,
        'remarks': remarks,
        'received_date': receivedDate.toIso8601String(),
      }).eq('id', id);
    });
  }

  Future<void> updateDisbursement({
    required int id,
    required String paymentMethod,
    String? accountNo,
    String? category,
    String? remarks,
    required DateTime paidDate,
  }) async {
    await supabaseSafeCall(() async {
      await _client.from('disbursements').update({
        'payment_method': paymentMethod,
        'account_no': accountNo,
        'category': category,
        'remarks': remarks,
        'paid_date': paidDate.toIso8601String(),
      }).eq('id', id);
    });
  }

  Future<List<DisbursementRecord>> getDisbursements() async {
    final response = await _client
        .from('disbursements')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (row) => DisbursementRecord.fromJson(_normalizeDisbursementRow(row)),
        )
        .toList();
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

  Map<String, dynamic> _normalizeDisbursementRow(dynamic row) {
    final normalized = Map<String, dynamic>.from(row as Map);

    normalized['id'] = normalized['id'] ?? 0;
    normalized['supplierId'] =
        normalized['supplierId'] ?? normalized['supplier_id'] ?? 0;
    normalized['disbursementNumber'] =
        (normalized['disbursementNumber'] ?? normalized['disbursement_number'])
            ?.toString();
    normalized['totalAmount'] =
        (normalized['totalAmount'] ?? normalized['total_amount'] ?? 0)
            .toDouble();
    normalized['paymentMethod'] =
        (normalized['paymentMethod'] ?? normalized['payment_method'] ?? '')
            .toString();
    normalized['accountNo'] =
        normalized['accountNo'] ?? normalized['account_no'];
    normalized['category'] = normalized['category']?.toString();
    normalized['remarks'] = normalized['remarks']?.toString();
    normalized['paidDate'] =
        (normalized['paidDate'] ??
                normalized['paid_date'] ??
                DateTime.now().toIso8601String())
            .toString();
    normalized['createdAt'] =
        (normalized['createdAt'] ??
                normalized['created_at'] ??
                DateTime.now().toIso8601String())
            .toString();

    return normalized;
  }
}
