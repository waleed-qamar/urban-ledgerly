// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/orders/data/datasource/order_remote_datasource.dart';
import 'package:ledgerly/features/orders/domain/repositories/order_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order_entity.dart';

part 'order_providers.g.dart';

@riverpod
OrderRemoteDatasource orderRemoteDatasource(Ref ref) {
  return OrderRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
OrderRepository orderRepository(Ref ref) {
  return OrderRepositoryImpl(ref.watch(orderRemoteDatasourceProvider));
}

@riverpod
Future<List<OrderEntity>> getAllOrders(Ref ref) {
  return ref.watch(orderRepositoryProvider).getOrders();
}

@riverpod
Future<void> addOrder(Ref ref, OrderEntity order) {
  return ref.watch(orderRepositoryProvider).createOrder(order);
}

@riverpod
Future<void> deleteOrder(Ref ref, int id) {
  return ref.watch(orderRepositoryProvider).deleteOrder(id);
}

@riverpod
Future<void> updateOrder(Ref ref, OrderEntity order) {
  return ref.watch(orderRepositoryProvider).updateOrder(order);
}

@riverpod
Future<OrderEntity> getOrderById(Ref ref, int id) {
  return ref.watch(orderRepositoryProvider).getOrderById(id);
}
