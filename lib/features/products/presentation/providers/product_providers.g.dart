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
