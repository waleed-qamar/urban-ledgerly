// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(procurementRemoteDatasource)
const procurementRemoteDatasourceProvider =
    ProcurementRemoteDatasourceProvider._();

final class ProcurementRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          ProcurementRemoteDatasource,
          ProcurementRemoteDatasource,
          ProcurementRemoteDatasource
        >
    with $Provider<ProcurementRemoteDatasource> {
  const ProcurementRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'procurementRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$procurementRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ProcurementRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProcurementRemoteDatasource create(Ref ref) {
    return procurementRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProcurementRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProcurementRemoteDatasource>(value),
    );
  }
}

String _$procurementRemoteDatasourceHash() =>
    r'006f0f5607fdd775a80bf3064286de9ba9daf7a4';

@ProviderFor(procurementRepository)
const procurementRepositoryProvider = ProcurementRepositoryProvider._();

final class ProcurementRepositoryProvider
    extends
        $FunctionalProvider<
          ProcurementRepository,
          ProcurementRepository,
          ProcurementRepository
        >
    with $Provider<ProcurementRepository> {
  const ProcurementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'procurementRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$procurementRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProcurementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProcurementRepository create(Ref ref) {
    return procurementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProcurementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProcurementRepository>(value),
    );
  }
}

String _$procurementRepositoryHash() =>
    r'9563bb7d60b3eb5dc148a03c0846dad13adb9c0d';

@ProviderFor(getAllProcurements)
const getAllProcurementsProvider = GetAllProcurementsProvider._();

final class GetAllProcurementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProcurementEntity>>,
          List<ProcurementEntity>,
          FutureOr<List<ProcurementEntity>>
        >
    with
        $FutureModifier<List<ProcurementEntity>>,
        $FutureProvider<List<ProcurementEntity>> {
  const GetAllProcurementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllProcurementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllProcurementsHash();

  @$internal
  @override
  $FutureProviderElement<List<ProcurementEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProcurementEntity>> create(Ref ref) {
    return getAllProcurements(ref);
  }
}

String _$getAllProcurementsHash() =>
    r'37846ed4bd19a5ad7ca7096ff97d7185367c867c';
