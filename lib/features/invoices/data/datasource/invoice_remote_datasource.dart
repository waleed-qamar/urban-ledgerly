import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/invoice_entity.dart';

class InvoiceRemoteDatasource {
  final SupabaseClient _client;

  static const String _invoiceSelect =
      'id, order_id, client_id, supplier_id, invoice_number, status, po, issue_date, sub_total, shipping_cost, tax_percent, tax_amount, grand_total, representative, created_at, '
      'items:invoice_items(id, invoice_id, order_item_id, product_id, quantity, unit_price, total_price)';

  InvoiceRemoteDatasource(this._client);

  Future<void> createInvoice(InvoiceEntity invoice) async {
    // Insert invoice
    final invoiceRes = await _client
        .from('invoices')
        .insert({
          'order_id': invoice.orderId,
          'client_id': invoice.clientId,
          'supplier_id': invoice.supplierId,
          'invoice_number': invoice.invoiceNumber,
          'status': 'undispatched',
          'po': invoice.po,
          'issue_date': invoice.issueDate.toIso8601String(),
          'sub_total': invoice.subTotal,
          'shipping_cost': invoice.shippingCost,
          'tax_percent': invoice.taxPercent,
          'tax_amount': invoice.taxAmount,
          'grand_total': invoice.grandTotal,
          'representative': invoice.representative,
        })
        .select('id')
        .single();

    final invoiceId = invoiceRes['id'];

    // Insert invoice items
    if (invoice.items.isNotEmpty) {
      final itemsData = invoice.items
          .map(
            (item) => {
              'invoice_id': invoiceId,
              'order_item_id': item.orderItemId,
              'product_id': item.productId,
              'quantity': item.quantity,
              'unit_price': item.unitPrice,
              'total_price': item.totalPrice,
            },
          )
          .toList();

      await _client.from('invoice_items').insert(itemsData);

      // Increment invoiced_quantity in order_items for each row
      // We process sequentially assuming few items per invoice
      for (var item in invoice.items) {
        final currentOrderItem = await _client
            .from('order_items')
            .select('invoiced_quantity')
            .eq('id', item.orderItemId)
            .single();
        final currentQty =
            (currentOrderItem['invoiced_quantity'] as num?)?.toInt() ?? 0;

        await _client
            .from('order_items')
            .update({'invoiced_quantity': (currentQty + item.quantity).toInt()})
            .eq('id', item.orderItemId);
      }
    }

    // Insert Debit ledger entry as requested by user
    await _client.from('ledger').insert({
      'party_type': 'client',
      'party_id': invoice.clientId,
      'invoice_number': invoice.invoiceNumber,
      'entry_type': 'debit',
      'amount': invoice.grandTotal,
      'entry_date': invoice.issueDate.toIso8601String(),
      'transaction_source': 'invoice',
      'reference_id': invoiceId.toString(),
      'remarks': 'auto entry against invoice ${invoice.invoiceNumber}',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateInvoiceStatus(int id, String status) async {
    await _client.from('invoices').update({'status': status}).eq('id', id);
  }

  /// Always does a fresh DB query — never relies on cached provider data.
  /// Reads all invoice_number values, parses the numeric suffix of INV-N,
  /// and returns the next available number.
  Future<String> getNextInvoiceNumber() async {
    final rows = await _client
        .from('invoices')
        .select('invoice_number');

    int maxNum = 0;
    for (final row in (rows as List)) {
      final invoiceNumber = (row['invoice_number'] as String?) ?? '';
      final match = RegExp(r'INV-(\d+)').firstMatch(invoiceNumber);
      if (match != null) {
        final parsed = int.tryParse(match.group(1) ?? '') ?? 0;
        if (parsed > maxNum) maxNum = parsed;
      }
    }
    return 'INV-${maxNum + 1}';
  }

  Future<InvoiceEntity> getInvoiceById(int id) async {
    final response = await _client
        .from('invoices')
        .select(_invoiceSelect)
        .eq('id', id);
    final invoiceRow = (response as List).cast<Map<String, dynamic>>().single;
    return InvoiceEntity.fromJson(_normalizeInvoiceRow(invoiceRow));
  }

  Future<List<InvoiceEntity>> getInvoices() async {
    final invoiceRows = await _client
        .from('invoices')
        .select(_invoiceSelect)
        .order('created_at', ascending: false);

    return (invoiceRows as List)
        .cast<Map<String, dynamic>>()
        .map((row) => InvoiceEntity.fromJson(_normalizeInvoiceRow(row)))
        .toList();
  }

  Map<String, dynamic> _normalizeInvoiceRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);
    final grandTotal =
        (normalized['grandTotal'] ?? normalized['grand_total'] ?? 0).toDouble();

    normalized['id'] = normalized['id'] ?? 0;
    normalized['orderId'] =
        normalized['orderId'] ?? normalized['order_id'] ?? 0;
    normalized['clientId'] =
        normalized['clientId'] ?? normalized['client_id'] ?? 0;
    normalized['supplierId'] =
        normalized['supplierId'] ?? normalized['supplier_id'] ?? 0;
    normalized['invoiceNumber'] =
        (normalized['invoiceNumber'] ?? normalized['invoice_number'] ?? '')
            .toString();
    // Status is dispatched/undispatched — read directly from DB.
    final rawStatus = (normalized['status'] ?? 'undispatched').toString();
    normalized['status'] = rawStatus.isEmpty ? 'undispatched' : rawStatus;
    normalized['po'] = normalized['po']?.toString();
    normalized['issueDate'] =
        (normalized['issueDate'] ??
                normalized['issue_date'] ??
                DateTime.now().toIso8601String())
            .toString();
    normalized['subTotal'] =
        (normalized['subTotal'] ?? normalized['sub_total'] ?? 0).toDouble();
    normalized['shippingCost'] =
        (normalized['shippingCost'] ?? normalized['shipping_cost'] ?? 0)
            .toDouble();
    normalized['taxPercent'] =
        (normalized['taxPercent'] ?? normalized['tax_percent'] ?? 18)
            .toDouble();
    normalized['taxAmount'] =
        (normalized['taxAmount'] ?? normalized['tax_amount'] ?? 0).toDouble();
    normalized['grandTotal'] = grandTotal;
    normalized['representative'] = (normalized['representative'] ?? '')
        .toString();
    // paidAmount/remainingAmount are no longer tracked on the invoice.
    normalized['paidAmount'] = 0.0;
    normalized['remainingAmount'] = 0.0;
    normalized['createdAt'] =
        normalized['createdAt'] ?? normalized['created_at'];
    normalized['items'] =
        (normalized['items'] as List<dynamic>?)
            ?.map(_normalizeInvoiceItemRow)
            .toList() ??
        const [];

    return normalized;
  }

  Map<String, dynamic> _normalizeInvoiceItemRow(dynamic row) {
    final normalized = Map<String, dynamic>.from(row as Map);

    normalized['id'] = normalized['id'] ?? 0;
    normalized['invoiceId'] =
        normalized['invoiceId'] ?? normalized['invoice_id'] ?? 0;
    normalized['orderItemId'] =
        normalized['orderItemId'] ?? normalized['order_item_id'] ?? 0;
    normalized['productId'] =
        normalized['productId'] ?? normalized['product_id'] ?? 0;
    normalized['quantity'] = (normalized['quantity'] ?? 0).toDouble();
    normalized['unitPrice'] =
        (normalized['unitPrice'] ?? normalized['unit_price'] ?? 0).toDouble();
    normalized['totalPrice'] =
        (normalized['totalPrice'] ?? normalized['total_price'] ?? 0).toDouble();

    return normalized;
  }
}
