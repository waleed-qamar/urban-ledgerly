// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_material_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rawMaterialRemoteDatasource)
const rawMaterialRemoteDatasourceProvider =
    RawMaterialRemoteDatasourceProvider._();

final class RawMaterialRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          RawMaterialRemoteDatasource,
          RawMaterialRemoteDatasource,
          RawMaterialRemoteDatasource
        >
    with $Provider<RawMaterialRemoteDatasource> {
  const RawMaterialRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawMaterialRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawMaterialRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<RawMaterialRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RawMaterialRemoteDatasource create(Ref ref) {
    return rawMaterialRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RawMaterialRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RawMaterialRemoteDatasource>(value),
    );
  }
}

String _$rawMaterialRemoteDatasourceHash() =>
    r'f4031d64a8a5add87d9f168a7d47398623a2aeba';

@ProviderFor(rawMaterialRepository)
const rawMaterialRepositoryProvider = RawMaterialRepositoryProvider._();

final class RawMaterialRepositoryProvider
    extends
        $FunctionalProvider<
          RawMaterialRepository,
          RawMaterialRepository,
          RawMaterialRepository
        >
    with $Provider<RawMaterialRepository> {
  const RawMaterialRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawMaterialRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawMaterialRepositoryHash();

  @$internal
  @override
  $ProviderElement<RawMaterialRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RawMaterialRepository create(Ref ref) {
    return rawMaterialRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RawMaterialRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RawMaterialRepository>(value),
    );
  }
}

String _$rawMaterialRepositoryHash() =>
    r'bee5af1761a1db4cae8b2326d01f43cc1eb0ca40';

@ProviderFor(getAllRawMaterials)
const getAllRawMaterialsProvider = GetAllRawMaterialsProvider._();

final class GetAllRawMaterialsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RawMaterialEntity>>,
          List<RawMaterialEntity>,
          FutureOr<List<RawMaterialEntity>>
        >
    with
        $FutureModifier<List<RawMaterialEntity>>,
        $FutureProvider<List<RawMaterialEntity>> {
  const GetAllRawMaterialsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllRawMaterialsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllRawMaterialsHash();

  @$internal
  @override
  $FutureProviderElement<List<RawMaterialEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RawMaterialEntity>> create(Ref ref) {
    return getAllRawMaterials(ref);
  }
}

String _$getAllRawMaterialsHash() =>
    r'd0901cc03f426c0386ffcb5ebcfae207b29bb0c5';

@ProviderFor(addRawMaterial)
const addRawMaterialProvider = AddRawMaterialFamily._();

final class AddRawMaterialProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddRawMaterialProvider._({
    required AddRawMaterialFamily super.from,
    required RawMaterialEntity super.argument,
  }) : super(
         retry: null,
         name: r'addRawMaterialProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addRawMaterialHash();

  @override
  String toString() {
    return r'addRawMaterialProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as RawMaterialEntity;
    return addRawMaterial(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddRawMaterialProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addRawMaterialHash() => r'644b367471f82ccb525cdac10d08b623b18bb2ab';

final class AddRawMaterialFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, RawMaterialEntity> {
  const AddRawMaterialFamily._()
    : super(
        retry: null,
        name: r'addRawMaterialProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddRawMaterialProvider call(RawMaterialEntity material) =>
      AddRawMaterialProvider._(argument: material, from: this);

  @override
  String toString() => r'addRawMaterialProvider';
}

@ProviderFor(deleteRawMaterial)
const deleteRawMaterialProvider = DeleteRawMaterialFamily._();

final class DeleteRawMaterialProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteRawMaterialProvider._({
    required DeleteRawMaterialFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteRawMaterialProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteRawMaterialHash();

  @override
  String toString() {
    return r'deleteRawMaterialProvider'
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
    return deleteRawMaterial(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteRawMaterialProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteRawMaterialHash() => r'4b7138cc0225df5289f682175180597327eada84';

final class DeleteRawMaterialFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteRawMaterialFamily._()
    : super(
        retry: null,
        name: r'deleteRawMaterialProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteRawMaterialProvider call(int id) =>
      DeleteRawMaterialProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteRawMaterialProvider';
}

@ProviderFor(updateRawMaterial)
const updateRawMaterialProvider = UpdateRawMaterialFamily._();

final class UpdateRawMaterialProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateRawMaterialProvider._({
    required UpdateRawMaterialFamily super.from,
    required RawMaterialEntity super.argument,
  }) : super(
         retry: null,
         name: r'updateRawMaterialProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateRawMaterialHash();

  @override
  String toString() {
    return r'updateRawMaterialProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as RawMaterialEntity;
    return updateRawMaterial(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateRawMaterialProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateRawMaterialHash() => r'9f6a5ea7287f40d8a62ec4384cbf48afdbcb35f7';

final class UpdateRawMaterialFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, RawMaterialEntity> {
  const UpdateRawMaterialFamily._()
    : super(
        retry: null,
        name: r'updateRawMaterialProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateRawMaterialProvider call(RawMaterialEntity material) =>
      UpdateRawMaterialProvider._(argument: material, from: this);

  @override
  String toString() => r'updateRawMaterialProvider';
}
