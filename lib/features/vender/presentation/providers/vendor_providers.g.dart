// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorFilterNotifier)
const vendorFilterProvider = VendorFilterNotifierProvider._();

final class VendorFilterNotifierProvider
    extends $NotifierProvider<VendorFilterNotifier, VendorFilter> {
  const VendorFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorFilterNotifierHash();

  @$internal
  @override
  VendorFilterNotifier create() => VendorFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorFilter>(value),
    );
  }
}

String _$vendorFilterNotifierHash() =>
    r'dd6706bb5601e9edf63df3033a5d2e1f90f26bda';

abstract class _$VendorFilterNotifier extends $Notifier<VendorFilter> {
  VendorFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VendorFilter, VendorFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VendorFilter, VendorFilter>,
              VendorFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(vendorRemoteDatasource)
const vendorRemoteDatasourceProvider = VendorRemoteDatasourceProvider._();

final class VendorRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          VendorRemoteDatasource,
          VendorRemoteDatasource,
          VendorRemoteDatasource
        >
    with $Provider<VendorRemoteDatasource> {
  const VendorRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<VendorRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VendorRemoteDatasource create(Ref ref) {
    return vendorRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorRemoteDatasource>(value),
    );
  }
}

String _$vendorRemoteDatasourceHash() =>
    r'26e94d00b2c64f5b18ce69daa0c353bfc770ee9c';

@ProviderFor(vendorRepository)
const vendorRepositoryProvider = VendorRepositoryProvider._();

final class VendorRepositoryProvider
    extends
        $FunctionalProvider<
          VendorRepository,
          VendorRepository,
          VendorRepository
        >
    with $Provider<VendorRepository> {
  const VendorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorRepositoryHash();

  @$internal
  @override
  $ProviderElement<VendorRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VendorRepository create(Ref ref) {
    return vendorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorRepository>(value),
    );
  }
}

String _$vendorRepositoryHash() => r'9e7831c5959083706e557438b1d56d2e5a4b75d1';

@ProviderFor(getAllvendors)
const getAllvendorsProvider = GetAllvendorsProvider._();

final class GetAllvendorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VendorEntity>>,
          List<VendorEntity>,
          FutureOr<List<VendorEntity>>
        >
    with
        $FutureModifier<List<VendorEntity>>,
        $FutureProvider<List<VendorEntity>> {
  const GetAllvendorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllvendorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllvendorsHash();

  @$internal
  @override
  $FutureProviderElement<List<VendorEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VendorEntity>> create(Ref ref) {
    return getAllvendors(ref);
  }
}

String _$getAllvendorsHash() => r'a923d001c41d1ba56694c4e2dfb201805b6e27cc';

@ProviderFor(addvendor)
const addvendorProvider = AddvendorFamily._();

final class AddvendorProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddvendorProvider._({
    required AddvendorFamily super.from,
    required VendorEntity super.argument,
  }) : super(
         retry: null,
         name: r'addvendorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addvendorHash();

  @override
  String toString() {
    return r'addvendorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as VendorEntity;
    return addvendor(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddvendorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addvendorHash() => r'5ca86e9e5c985f5799dd3caa69002e21cb2d3a02';

final class AddvendorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, VendorEntity> {
  const AddvendorFamily._()
    : super(
        retry: null,
        name: r'addvendorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddvendorProvider call(VendorEntity vendor) =>
      AddvendorProvider._(argument: vendor, from: this);

  @override
  String toString() => r'addvendorProvider';
}

@ProviderFor(updatevendor)
const updatevendorProvider = UpdatevendorFamily._();

final class UpdatevendorProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdatevendorProvider._({
    required UpdatevendorFamily super.from,
    required VendorEntity super.argument,
  }) : super(
         retry: null,
         name: r'updatevendorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updatevendorHash();

  @override
  String toString() {
    return r'updatevendorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as VendorEntity;
    return updatevendor(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatevendorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updatevendorHash() => r'7f3e692a561abb5cdc18ef3ceb1eb681638db07c';

final class UpdatevendorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, VendorEntity> {
  const UpdatevendorFamily._()
    : super(
        retry: null,
        name: r'updatevendorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdatevendorProvider call(VendorEntity vendor) =>
      UpdatevendorProvider._(argument: vendor, from: this);

  @override
  String toString() => r'updatevendorProvider';
}

@ProviderFor(deletevendor)
const deletevendorProvider = DeletevendorFamily._();

final class DeletevendorProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeletevendorProvider._({
    required DeletevendorFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deletevendorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deletevendorHash();

  @override
  String toString() {
    return r'deletevendorProvider'
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
    return deletevendor(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeletevendorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deletevendorHash() => r'c925e724504542014881fcf7a5d9fafee7e1530e';

final class DeletevendorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeletevendorFamily._()
    : super(
        retry: null,
        name: r'deletevendorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeletevendorProvider call(int vendorId) =>
      DeletevendorProvider._(argument: vendorId, from: this);

  @override
  String toString() => r'deletevendorProvider';
}
