import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/orders/domain/entities/order_item_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRemoteDatasource {
  final SupabaseClient _client;
  static const String _orderSelect =
      'id, supplierId:supplier_id, clientId:client_id, status, department, po, createdAt:created_at, delivery_term, '
      'items:order_items(id, productId:product_id, quantity, price, invoicedQuantity:invoiced_quantity)';

  OrderRemoteDatasource(this._client);

  Future<void> createOrder(OrderEntity order) async {
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

    // (Phase 2)
    // 4. Insert inventory RESERVE transactions
  }

  Future<void> deleteOrder(int id) async {
    await _client.from('orders').delete().eq('id', id);
  }

  Future<void> updateOrder(OrderEntity orderData) async {
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

    // Replace order items only when the line-item payload has changed.
    await _client.from('order_items').delete().eq('order_id', orderData.id!);

    if (orderData.items.isNotEmpty) {
      final itemsPayload = orderData.items
          .map(
            (item) => {
              'order_id': orderData.id,
              'product_id': item.productId,
              'quantity': item.quantity,
              'price': item.price,
              'invoiced_quantity': item.invoicedQuantity ?? 0,
            },
          )
          .toList();

      await _client.from('order_items').insert(itemsPayload);
    }
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

      if (existing.productId != updated.productId) return false;
      if (existing.quantity != updated.quantity) return false;
      if (existing.price != updated.price) return false;
      if ((existing.invoicedQuantity ?? 0) != (updated.invoicedQuantity ?? 0)) {
        return false;
      }
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
    normalized['delivery_term'] =
        (normalized['delivery_term'] ?? normalized['deliveryTerm'] ?? '')
            .toString();

    return normalized;
  }
}
