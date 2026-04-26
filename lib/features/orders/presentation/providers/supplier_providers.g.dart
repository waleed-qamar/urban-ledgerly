// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supplierRemoteDatasource)
const supplierRemoteDatasourceProvider = SupplierRemoteDatasourceProvider._();

final class SupplierRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          SupplierRemoteDatasource,
          SupplierRemoteDatasource,
          SupplierRemoteDatasource
        >
    with $Provider<SupplierRemoteDatasource> {
  const SupplierRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supplierRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supplierRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<SupplierRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupplierRemoteDatasource create(Ref ref) {
    return supplierRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupplierRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupplierRemoteDatasource>(value),
    );
  }
}

String _$supplierRemoteDatasourceHash() =>
    r'c29e0a407776819dc1280183f716131d12ecc9de';

@ProviderFor(supplierRepository)
const supplierRepositoryProvider = SupplierRepositoryProvider._();

final class SupplierRepositoryProvider
    extends
        $FunctionalProvider<
          SupplierRepository,
          SupplierRepository,
          SupplierRepository
        >
    with $Provider<SupplierRepository> {
  const SupplierRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supplierRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supplierRepositoryHash();

  @$internal
  @override
  $ProviderElement<SupplierRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupplierRepository create(Ref ref) {
    return supplierRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupplierRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupplierRepository>(value),
    );
  }
}

String _$supplierRepositoryHash() =>
    r'1a64525c9ab388152a2f619fd190a44d057fba1d';

@ProviderFor(getAllSuppliers)
const getAllSuppliersProvider = GetAllSuppliersProvider._();

final class GetAllSuppliersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SupplierEntity>>,
          List<SupplierEntity>,
          FutureOr<List<SupplierEntity>>
        >
    with
        $FutureModifier<List<SupplierEntity>>,
        $FutureProvider<List<SupplierEntity>> {
  const GetAllSuppliersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllSuppliersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllSuppliersHash();

  @$internal
  @override
  $FutureProviderElement<List<SupplierEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SupplierEntity>> create(Ref ref) {
    return getAllSuppliers(ref);
  }
}

String _$getAllSuppliersHash() => r'a56f9abf1b5f0f8ac786215c5fa786a8fe2f8098';

@ProviderFor(getSupplierById)
const getSupplierByIdProvider = GetSupplierByIdFamily._();

final class GetSupplierByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<SupplierEntity>,
          SupplierEntity,
          FutureOr<SupplierEntity>
        >
    with $FutureModifier<SupplierEntity>, $FutureProvider<SupplierEntity> {
  const GetSupplierByIdProvider._({
    required GetSupplierByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getSupplierByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getSupplierByIdHash();

  @override
  String toString() {
    return r'getSupplierByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SupplierEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SupplierEntity> create(Ref ref) {
    final argument = this.argument as int;
    return getSupplierById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSupplierByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getSupplierByIdHash() => r'ab1e41734744b7f093092f5edba2f4a204c2c8fe';

final class GetSupplierByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SupplierEntity>, int> {
  const GetSupplierByIdFamily._()
    : super(
        retry: null,
        name: r'getSupplierByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetSupplierByIdProvider call(int id) =>
      GetSupplierByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'getSupplierByIdProvider';
}

@ProviderFor(addSupplier)
const addSupplierProvider = AddSupplierFamily._();

final class AddSupplierProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddSupplierProvider._({
    required AddSupplierFamily super.from,
    required SupplierEntity super.argument,
  }) : super(
         retry: null,
         name: r'addSupplierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addSupplierHash();

  @override
  String toString() {
    return r'addSupplierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as SupplierEntity;
    return addSupplier(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddSupplierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addSupplierHash() => r'ded440e02cd477439892d6e01519b39ff68501a4';

final class AddSupplierFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, SupplierEntity> {
  const AddSupplierFamily._()
    : super(
        retry: null,
        name: r'addSupplierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddSupplierProvider call(SupplierEntity supplier) =>
      AddSupplierProvider._(argument: supplier, from: this);

  @override
  String toString() => r'addSupplierProvider';
}

@ProviderFor(updateSupplier)
const updateSupplierProvider = UpdateSupplierFamily._();

final class UpdateSupplierProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateSupplierProvider._({
    required UpdateSupplierFamily super.from,
    required SupplierEntity super.argument,
  }) : super(
         retry: null,
         name: r'updateSupplierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateSupplierHash();

  @override
  String toString() {
    return r'updateSupplierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as SupplierEntity;
    return updateSupplier(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateSupplierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateSupplierHash() => r'dad656d736f35af2aa7eab33d16f4408fcb7f0d7';

final class UpdateSupplierFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, SupplierEntity> {
  const UpdateSupplierFamily._()
    : super(
        retry: null,
        name: r'updateSupplierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateSupplierProvider call(SupplierEntity supplier) =>
      UpdateSupplierProvider._(argument: supplier, from: this);

  @override
  String toString() => r'updateSupplierProvider';
}

@ProviderFor(deleteSupplier)
const deleteSupplierProvider = DeleteSupplierFamily._();

final class DeleteSupplierProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteSupplierProvider._({
    required DeleteSupplierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteSupplierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteSupplierHash();

  @override
  String toString() {
    return r'deleteSupplierProvider'
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
    return deleteSupplier(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteSupplierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteSupplierHash() => r'6f0f8234f14967eb18406f9cec84fc0bbd01a3c9';

final class DeleteSupplierFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteSupplierFamily._()
    : super(
        retry: null,
        name: r'deleteSupplierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteSupplierProvider call(int id) =>
      DeleteSupplierProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteSupplierProvider';
}
