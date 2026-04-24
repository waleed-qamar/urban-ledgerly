import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRemoteDatasource {
  final SupabaseClient _client;
  static const String _orderSelect =
      'id, customerId:customer_id, status, createdAt:created_at, '
      'items:order_items(id, productId:product_id, quantity, price)';

  OrderRemoteDatasource(this._client);

  Future<void> createOrder(OrderEntity order) async {
    // 1. Insert order
    final orderRes = await _client
        .from('orders')
        .insert({
          'customer_id': order.customerId,
          'status': order.status ?? 'pending',
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
    final payload = <String, dynamic>{'customer_id': orderData.customerId};
    if (orderData.status != null) {
      payload['status'] = orderData.status;
    }

    await _client.from('orders').update(payload).eq('id', orderData.id!);
  }

  Future<OrderEntity> getOrderById(int id) async {
    final response = await _client
        .from('orders')
        .select(_orderSelect)
        .eq('id', id)
        .single();
    return OrderEntity.fromJson(response);
  }

  Future<List<OrderEntity>> getOrders() async {
    final response = await _client
        .from('orders')
        .select(_orderSelect)
        .order('created_at', ascending: false);
    return (response as List).map((e) => OrderEntity.fromJson(e)).toList();
  }
}
