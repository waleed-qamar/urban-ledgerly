import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/orders/domain/entities/order_item_entity.dart';
import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRemoteDatasource {
  final SupabaseClient _client;
  static const String _orderSelect =
      'id, supplierId:supplier_id, clientId:client_id, status, department, po, orderDate:order_date, createdAt:created_at, delivery_term, '
      'items:order_items(id, productId:product_id, setId:set_id, isSet:is_set, quantity, price, invoicedQuantity:invoiced_quantity)';

  OrderRemoteDatasource(this._client);

  Future<void> createOrder(OrderEntity order) async {
    await supabaseSafeCall(() async {
      // 1. Insert order
      final orderRes = await _client
          .from('orders')
          .insert({
            'supplier_id': order.supplierId,
            'client_id': order.clientId,
            'status': order.status ?? 'pending',
            'department': order.department,
            'po': order.po,
            'delivery_term': order.deliveryTerm,
            'order_date': order.orderDate.toIso8601String(),
            'created_at': order.createdAt?.toIso8601String(),
          })
          .select('id')
          .single();

      final orderId = orderRes['id'];

      // 2. Insert order items
      final items = order.items.map((e) {
        return {
          'order_id': orderId,
          'product_id': e.productId,
          'set_id': e.setId,
          'is_set': e.isSet,
          'quantity': e.quantity,
          'price': e.price,
          'invoiced_quantity': 0,
        };
      }).toList();

      await _client.from('order_items').insert(items);

      // 3. Insert Credit ledger entry for the vendor (procurement amount)
      final totalAmount = order.items.fold<double>(
        0,
        (sum, item) => sum + (item.quantity * item.price),
      );

      try {
        await _client.from('ledger').insert({
          'party_type': 'vendor',
          'party_id': order.supplierId,
          'entry_type': 'credit',
          'amount': totalAmount,
          'entry_date':
              order.createdAt?.toIso8601String() ??
              DateTime.now().toIso8601String(),
          'transaction_source': 'order',
          'reference_id': orderId.toString(),
          'remarks': 'Auto recorded credit on procurement generation',
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        final err = e.toString();
        if (err.contains('duplicate key') || err.contains('23505')) {
          // ignore duplicate ledger entry
        } else {
          rethrow;
        }
      }
    });
  }

  Future<void> deleteOrder(int id) async {
    await supabaseSafeCall(() async {
      // First: find linked invoices to restore invoiced_quantity on order_items
      final invoices = await _client
          .from('invoices')
          .select('id')
          .eq('order_id', id);

      for (final inv in (invoices as List)) {
        final invoiceId = inv['id'] as int;
        final invoiceItems = await _client
            .from('invoice_items')
            .select('order_item_id, quantity')
            .eq('invoice_id', invoiceId);

        for (final item in (invoiceItems as List)) {
          final orderItemId = item['order_item_id'];
          final qty = (item['quantity'] as num?)?.toInt() ?? 0;
          if (orderItemId != null && qty > 0) {
            final current = await _client
                .from('order_items')
                .select('invoiced_quantity')
                .eq('id', orderItemId)
                .maybeSingle();
            final currentQty =
                (current?['invoiced_quantity'] as num?)?.toInt() ?? 0;
            final newQty = (currentQty - qty).clamp(0, 999999);
            await _client
                .from('order_items')
                .update({'invoiced_quantity': newQty})
                .eq('id', orderItemId);
          }
        }

        // Delete invoice items
        await _client.from('invoice_items').delete().eq('invoice_id', invoiceId);
      }

      // Delete all linked invoices
      await _client.from('invoices').delete().eq('order_id', id);

      // Delete order items then order
      await _client.from('order_items').delete().eq('order_id', id);
      await _client.from('orders').delete().eq('id', id);
    });
  }

  Future<void> updateOrder(OrderEntity orderData) async {
    await supabaseSafeCall(() async {
      final payload = <String, dynamic>{
        'supplier_id': orderData.supplierId,
        'client_id': orderData.clientId,
        'department': orderData.department,
        'delivery_term': orderData.deliveryTerm,
        'po': orderData.po,
      };
      if (orderData.status != null) {
        payload['status'] = orderData.status;
      }

      final existingOrder = await getOrderById(orderData.id!);

      await _client.from('orders').update(payload).eq('id', orderData.id!);

      if (_hasSameItems(existingOrder.items, orderData.items)) {
        return;
      }

      // Granular update of order items instead of delete-all-and-insert
      final updatedItemIds = orderData.items
          .map((e) => e.id)
          .whereType<int>()
          .toSet();

      final itemsToDelete = existingOrder.items
          .where((e) => e.id != null && !updatedItemIds.contains(e.id))
          .toList();

      for (final item in itemsToDelete) {
        await _client.from('order_items').delete().eq('id', item.id!);
      }

      for (final item in orderData.items) {
        if (item.id != null) {
          await _client
              .from('order_items')
              .update({
                'product_id': item.productId,
                'set_id': item.setId,
                'is_set': item.isSet,
                'quantity': item.quantity,
                'price': item.price,
                'invoiced_quantity': item.invoicedQuantity ?? 0,
              })
              .eq('id', item.id!);
        } else {
          await _client.from('order_items').insert({
            'order_id': orderData.id,
            'product_id': item.productId,
            'set_id': item.setId,
            'is_set': item.isSet,
            'quantity': item.quantity,
            'price': item.price,
            'invoiced_quantity': item.invoicedQuantity ?? 0,
          });
        }
      }
    });
  }

  bool _hasSameItems(
    List<OrderItemEntity> existingItems,
    List<OrderItemEntity> updatedItems,
  ) {
    if (existingItems.length != updatedItems.length) {
      return false;
    }

    for (var index = 0; index < existingItems.length; index++) {
      final existing = existingItems[index];
      final updated = updatedItems[index];

      if (existing.isSet != updated.isSet) return false;
      if (existing.isSet) {
        if (existing.setId != updated.setId) return false;
      } else {
        if (existing.productId != updated.productId) return false;
      }
      if (existing.quantity != updated.quantity) return false;
      if (existing.price != updated.price) return false;
      // Ignore invoicedQuantity differences because invoiced counts are
      // updated separately when invoices are created. Treating only the
      // core line attributes (productId, quantity, price) as the basis for
      // deciding whether to replace order_items prevents accidental deletes
      // of order_items that are referenced by newly created invoice_items.
    }

    return true;
  }

  Future<OrderEntity> getOrderById(int id) async {
    final response = await _client
        .from('orders')
        .select(_orderSelect)
        .eq('id', id)
        .single();
    return OrderEntity.fromJson(_normalizeOrderRow(response));
  }

  Future<List<OrderEntity>> getOrders() async {
    final response = await _client
        .from('orders')
        .select(_orderSelect)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => OrderEntity.fromJson(_normalizeOrderRow(e)))
        .toList();
  }

  Map<String, dynamic> _normalizeOrderRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);

    // Keep parsing resilient while existing rows are migrated.
    normalized['orderDate'] =
        (normalized['orderDate'] ??
                normalized['order_date'] ??
                normalized['createdAt'] ??
                normalized['created_at'] ??
                DateTime.now().toIso8601String())
            .toString();
    normalized['deliveryTerm'] =
        (normalized['deliveryTerm'] ?? normalized['delivery_term'] ?? '')
            .toString();
    normalized['status'] = normalized['status']?.toString();
    normalized['department'] = normalized['department']?.toString();
    normalized['po'] = normalized['po']?.toString();

    return normalized;
  }
}
