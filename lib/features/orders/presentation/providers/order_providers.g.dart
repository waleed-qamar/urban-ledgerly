// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderRemoteDatasource)
const orderRemoteDatasourceProvider = OrderRemoteDatasourceProvider._();

final class OrderRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          OrderRemoteDatasource,
          OrderRemoteDatasource,
          OrderRemoteDatasource
        >
    with $Provider<OrderRemoteDatasource> {
  const OrderRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<OrderRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrderRemoteDatasource create(Ref ref) {
    return orderRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRemoteDatasource>(value),
    );
  }
}

String _$orderRemoteDatasourceHash() =>
    r'5b43ba088d53a9b2be0b710d9bfdae071ec59632';

@ProviderFor(orderRepository)
const orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider
    extends
        $FunctionalProvider<OrderRepository, OrderRepository, OrderRepository>
    with $Provider<OrderRepository> {
  const OrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'b0a4784a3bfb9b3c0aed5037ba65be098bfc40bf';

@ProviderFor(getAllOrders)
const getAllOrdersProvider = GetAllOrdersProvider._();

final class GetAllOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderEntity>>,
          List<OrderEntity>,
          FutureOr<List<OrderEntity>>
        >
    with
        $FutureModifier<List<OrderEntity>>,
        $FutureProvider<List<OrderEntity>> {
  const GetAllOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<OrderEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrderEntity>> create(Ref ref) {
    return getAllOrders(ref);
  }
}

String _$getAllOrdersHash() => r'3b879bde68e9531b5ce7a6b080c1eb325f93c7b2';

@ProviderFor(addOrder)
const addOrderProvider = AddOrderFamily._();

final class AddOrderProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddOrderProvider._({
    required AddOrderFamily super.from,
    required OrderEntity super.argument,
  }) : super(
         retry: null,
         name: r'addOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addOrderHash();

  @override
  String toString() {
    return r'addOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as OrderEntity;
    return addOrder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addOrderHash() => r'f1927e04364c071c6619eed5e46cf3da3c30753c';

final class AddOrderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, OrderEntity> {
  const AddOrderFamily._()
    : super(
        retry: null,
        name: r'addOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddOrderProvider call(OrderEntity order) =>
      AddOrderProvider._(argument: order, from: this);

  @override
  String toString() => r'addOrderProvider';
}

@ProviderFor(deleteOrder)
const deleteOrderProvider = DeleteOrderFamily._();

final class DeleteOrderProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteOrderProvider._({
    required DeleteOrderFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteOrderHash();

  @override
  String toString() {
    return r'deleteOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as int;
    return deleteOrder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteOrderHash() => r'199ec617d9388de6ec7407a6da7b1a3c6b1050d9';

final class DeleteOrderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteOrderFamily._()
    : super(
        retry: null,
        name: r'deleteOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteOrderProvider call(int id) =>
      DeleteOrderProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteOrderProvider';
}

@ProviderFor(updateOrder)
const updateOrderProvider = UpdateOrderFamily._();

final class UpdateOrderProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateOrderProvider._({
    required UpdateOrderFamily super.from,
    required OrderEntity super.argument,
  }) : super(
         retry: null,
         name: r'updateOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateOrderHash();

  @override
  String toString() {
    return r'updateOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as OrderEntity;
    return updateOrder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateOrderHash() => r'd95ec159b0ddbda91192f5eab1a308b835c5510c';

final class UpdateOrderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, OrderEntity> {
  const UpdateOrderFamily._()
    : super(
        retry: null,
        name: r'updateOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateOrderProvider call(OrderEntity order) =>
      UpdateOrderProvider._(argument: order, from: this);

  @override
  String toString() => r'updateOrderProvider';
}

@ProviderFor(getOrderById)
const getOrderByIdProvider = GetOrderByIdFamily._();

final class GetOrderByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderEntity>,
          OrderEntity,
          FutureOr<OrderEntity>
        >
    with $FutureModifier<OrderEntity>, $FutureProvider<OrderEntity> {
  const GetOrderByIdProvider._({
    required GetOrderByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getOrderByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getOrderByIdHash();

  @override
  String toString() {
    return r'getOrderByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderEntity> create(Ref ref) {
    final argument = this.argument as int;
    return getOrderById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetOrderByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getOrderByIdHash() => r'7401ec509efa2baef48c65b7ec6aeb201f9a6667';

final class GetOrderByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderEntity>, int> {
  const GetOrderByIdFamily._()
    : super(
        retry: null,
        name: r'getOrderByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetOrderByIdProvider call(int id) =>
      GetOrderByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'getOrderByIdProvider';
}
