import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrderById(int id);
  Future<void> createOrder(OrderEntity order);
  Future<void> updateOrder(OrderEntity order);
  Future<void> deleteOrder(int id);
}
