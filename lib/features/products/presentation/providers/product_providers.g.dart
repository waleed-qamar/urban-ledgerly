// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRemoteDatasource)
const productRemoteDatasourceProvider = ProductRemoteDatasourceProvider._();

final class ProductRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          ProductRemoteDatasource,
          ProductRemoteDatasource,
          ProductRemoteDatasource
        >
    with $Provider<ProductRemoteDatasource> {
  const ProductRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ProductRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRemoteDatasource create(Ref ref) {
    return productRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRemoteDatasource>(value),
    );
  }
}

String _$productRemoteDatasourceHash() =>
    r'67cbeac4a3c8996f4a8338986102c5ae4b14cc9f';

@ProviderFor(productRepository)
const productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  const ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'3f5ae24697b7fc114b01d7b89a42094813b98548';

@ProviderFor(inventoryRemoteDatasource)
const inventoryRemoteDatasourceProvider = InventoryRemoteDatasourceProvider._();

final class InventoryRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          InventoryRemoteDatasource,
          InventoryRemoteDatasource,
          InventoryRemoteDatasource
        >
    with $Provider<InventoryRemoteDatasource> {
  const InventoryRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<InventoryRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRemoteDatasource create(Ref ref) {
    return inventoryRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRemoteDatasource>(value),
    );
  }
}

String _$inventoryRemoteDatasourceHash() =>
    r'ac4496a3d46b466a1b7e9ea0618ca1bf5bb56406';

@ProviderFor(productInventoryRepository)
const productInventoryRepositoryProvider =
    ProductInventoryRepositoryProvider._();

final class ProductInventoryRepositoryProvider
    extends
        $FunctionalProvider<
          ProductInventoryRepository,
          ProductInventoryRepository,
          ProductInventoryRepository
        >
    with $Provider<ProductInventoryRepository> {
  const ProductInventoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productInventoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productInventoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductInventoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductInventoryRepository create(Ref ref) {
    return productInventoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductInventoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductInventoryRepository>(value),
    );
  }
}

String _$productInventoryRepositoryHash() =>
    r'f0756548eac4fb49ebad0112398197001d958c15';

@ProviderFor(getAllProducts)
const getAllProductsProvider = GetAllProductsProvider._();

final class GetAllProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductEntity>>,
          List<ProductEntity>,
          FutureOr<List<ProductEntity>>
        >
    with
        $FutureModifier<List<ProductEntity>>,
        $FutureProvider<List<ProductEntity>> {
  const GetAllProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<ProductEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductEntity>> create(Ref ref) {
    return getAllProducts(ref);
  }
}

String _$getAllProductsHash() => r'0859175af7b0aae5d8fb58247f5238cc9c4e20bb';

@ProviderFor(addProduct)
const addProductProvider = AddProductFamily._();

final class AddProductProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddProductProvider._({
    required AddProductFamily super.from,
    required ProductEntity super.argument,
  }) : super(
         retry: null,
         name: r'addProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addProductHash();

  @override
  String toString() {
    return r'addProductProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ProductEntity;
    return addProduct(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addProductHash() => r'bfec834845d2d5e4453d313e465fafab48034fa4';

final class AddProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, ProductEntity> {
  const AddProductFamily._()
    : super(
        retry: null,
        name: r'addProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddProductProvider call(ProductEntity product) =>
      AddProductProvider._(argument: product, from: this);

  @override
  String toString() => r'addProductProvider';
}

@ProviderFor(deleteProduct)
const deleteProductProvider = DeleteProductFamily._();

final class DeleteProductProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteProductProvider._({
    required DeleteProductFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteProductHash();

  @override
  String toString() {
    return r'deleteProductProvider'
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
    return deleteProduct(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteProductHash() => r'6b04fcbe4389d8c055e4ba55af63cf86b95e0989';

final class DeleteProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteProductFamily._()
    : super(
        retry: null,
        name: r'deleteProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteProductProvider call(int id) =>
      DeleteProductProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteProductProvider';
}

@ProviderFor(updateProduct)
const updateProductProvider = UpdateProductFamily._();

final class UpdateProductProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateProductProvider._({
    required UpdateProductFamily super.from,
    required ProductEntity super.argument,
  }) : super(
         retry: null,
         name: r'updateProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateProductHash();

  @override
  String toString() {
    return r'updateProductProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ProductEntity;
    return updateProduct(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateProductHash() => r'0473f36adf24a47a7f29b23dba16ae2ab957a477';

final class UpdateProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, ProductEntity> {
  const UpdateProductFamily._()
    : super(
        retry: null,
        name: r'updateProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateProductProvider call(ProductEntity product) =>
      UpdateProductProvider._(argument: product, from: this);

  @override
  String toString() => r'updateProductProvider';
}

@ProviderFor(inventoryTransactionsByProduct)
const inventoryTransactionsByProductProvider =
    InventoryTransactionsByProductFamily._();

final class InventoryTransactionsByProductProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryTransactionEntity>>,
          List<InventoryTransactionEntity>,
          FutureOr<List<InventoryTransactionEntity>>
        >
    with
        $FutureModifier<List<InventoryTransactionEntity>>,
        $FutureProvider<List<InventoryTransactionEntity>> {
  const InventoryTransactionsByProductProvider._({
    required InventoryTransactionsByProductFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'inventoryTransactionsByProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inventoryTransactionsByProductHash();

  @override
  String toString() {
    return r'inventoryTransactionsByProductProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<InventoryTransactionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryTransactionEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return inventoryTransactionsByProduct(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryTransactionsByProductProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inventoryTransactionsByProductHash() =>
    r'a3fb23fa44399d67d8d9581ffa69f610e0e1784f';

final class InventoryTransactionsByProductFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<InventoryTransactionEntity>>,
          int
        > {
  const InventoryTransactionsByProductFamily._()
    : super(
        retry: null,
        name: r'inventoryTransactionsByProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InventoryTransactionsByProductProvider call(int productId) =>
      InventoryTransactionsByProductProvider._(argument: productId, from: this);

  @override
  String toString() => r'inventoryTransactionsByProductProvider';
}

@ProviderFor(deleteInventoryTransaction)
const deleteInventoryTransactionProvider = DeleteInventoryTransactionFamily._();

final class DeleteInventoryTransactionProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteInventoryTransactionProvider._({
    required DeleteInventoryTransactionFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteInventoryTransactionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteInventoryTransactionHash();

  @override
  String toString() {
    return r'deleteInventoryTransactionProvider'
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
    return deleteInventoryTransaction(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteInventoryTransactionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteInventoryTransactionHash() =>
    r'3183a561a72edd7de4f00935851b23af05990082';

final class DeleteInventoryTransactionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteInventoryTransactionFamily._()
    : super(
        retry: null,
        name: r'deleteInventoryTransactionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteInventoryTransactionProvider call(int transactionId) =>
      DeleteInventoryTransactionProvider._(argument: transactionId, from: this);

  @override
  String toString() => r'deleteInventoryTransactionProvider';
}

@ProviderFor(updateInventoryTransaction)
const updateInventoryTransactionProvider = UpdateInventoryTransactionFamily._();

final class UpdateInventoryTransactionProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateInventoryTransactionProvider._({
    required UpdateInventoryTransactionFamily super.from,
    required (int, int, int, String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'updateInventoryTransactionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateInventoryTransactionHash();

  @override
  String toString() {
    return r'updateInventoryTransactionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as (int, int, int, String, String?);
    return updateInventoryTransaction(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
      argument.$5,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateInventoryTransactionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateInventoryTransactionHash() =>
    r'77d3fde5fb99f6cf649d8b9222dbdc946f60ba7e';

final class UpdateInventoryTransactionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          (int, int, int, String, String?)
        > {
  const UpdateInventoryTransactionFamily._()
    : super(
        retry: null,
        name: r'updateInventoryTransactionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateInventoryTransactionProvider call(
    int transactionId,
    int productId,
    int quantity,
    String transactionType,
    String? remarks,
  ) => UpdateInventoryTransactionProvider._(
    argument: (transactionId, productId, quantity, transactionType, remarks),
    from: this,
  );

  @override
  String toString() => r'updateInventoryTransactionProvider';
}
