import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRemoteDatasource {
  final SupabaseClient _client;
  static const String _orderSelect =
      'id, supplierId:supplier_id, clientId:client_id, status, department, po, createdAt:created_at, delivery_term, '
      'items:order_items(id, productId:product_id, quantity, price)';

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
      };
    }).toList();

    await _client.from('order_items').insert(items);

    // (Phase 2)
    // 3. Insert inventory RESERVE transactions
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

    await _client.from('orders').update(payload).eq('id', orderData.id!);

    // Replace order items in one go so edits (add/remove/update lines)
    // are reflected consistently for the same order number.
    await _client.from('order_items').delete().eq('order_id', orderData.id!);

    if (orderData.items.isNotEmpty) {
      final itemsPayload = orderData.items
          .map(
            (item) => {
              'order_id': orderData.id,
              'product_id': item.productId,
              'quantity': item.quantity,
              'price': item.price,
            },
          )
          .toList();

      await _client.from('order_items').insert(itemsPayload);
    }
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
