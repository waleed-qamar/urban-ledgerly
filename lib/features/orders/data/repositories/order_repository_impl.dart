import 'package:ledgerly/features/orders/data/datasource/order_remote_datasource.dart';
import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource _datasource;

  OrderRepositoryImpl(this._datasource);

  @override
  Future<void> createOrder(OrderEntity order) => _datasource.createOrder(order);

  @override
  Future<void> deleteOrder(int id) => _datasource.deleteOrder(id);

  @override
  Future<OrderEntity> getOrderById(int id) => _datasource.getOrderById(id);

  @override
  Future<List<OrderEntity>> getOrders() => _datasource.getOrders();

  @override
  Future<void> updateOrder(OrderEntity order) => _datasource.updateOrder(order);
}
