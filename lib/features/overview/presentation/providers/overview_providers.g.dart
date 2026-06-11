// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(overviewRemoteDatasource)
const overviewRemoteDatasourceProvider = OverviewRemoteDatasourceProvider._();

final class OverviewRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          OverviewRemoteDatasource,
          OverviewRemoteDatasource,
          OverviewRemoteDatasource
        >
    with $Provider<OverviewRemoteDatasource> {
  const OverviewRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<OverviewRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OverviewRemoteDatasource create(Ref ref) {
    return overviewRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverviewRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverviewRemoteDatasource>(value),
    );
  }
}

String _$overviewRemoteDatasourceHash() =>
    r'04970cab3db808251a3dfbd112fc8a3e1c05ee9d';

@ProviderFor(expenditureOverview)
const expenditureOverviewProvider = ExpenditureOverviewProvider._();

final class ExpenditureOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ExpenditureOverviewData>,
          ExpenditureOverviewData,
          FutureOr<ExpenditureOverviewData>
        >
    with
        $FutureModifier<ExpenditureOverviewData>,
        $FutureProvider<ExpenditureOverviewData> {
  const ExpenditureOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenditureOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenditureOverviewHash();

  @$internal
  @override
  $FutureProviderElement<ExpenditureOverviewData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ExpenditureOverviewData> create(Ref ref) {
    return expenditureOverview(ref);
  }
}

String _$expenditureOverviewHash() =>
    r'283272753c7739d0e54c46fd99b2bf5a45ee65c9';

@ProviderFor(recoveryOverview)
const recoveryOverviewProvider = RecoveryOverviewProvider._();

final class RecoveryOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<RecoveryOverviewData>,
          RecoveryOverviewData,
          FutureOr<RecoveryOverviewData>
        >
    with
        $FutureModifier<RecoveryOverviewData>,
        $FutureProvider<RecoveryOverviewData> {
  const RecoveryOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recoveryOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recoveryOverviewHash();

  @$internal
  @override
  $FutureProviderElement<RecoveryOverviewData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RecoveryOverviewData> create(Ref ref) {
    return recoveryOverview(ref);
  }
}

String _$recoveryOverviewHash() => r'2d1a1956f24aabd2de9c0878e2013f3d8d310ff4';

@ProviderFor(salesOverview)
const salesOverviewProvider = SalesOverviewProvider._();

final class SalesOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<SalesOverviewData>,
          SalesOverviewData,
          FutureOr<SalesOverviewData>
        >
    with
        $FutureModifier<SalesOverviewData>,
        $FutureProvider<SalesOverviewData> {
  const SalesOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesOverviewHash();

  @$internal
  @override
  $FutureProviderElement<SalesOverviewData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SalesOverviewData> create(Ref ref) {
    return salesOverview(ref);
  }
}

String _$salesOverviewHash() => r'cdaf46aa15a038bff6411e7e066d31c3af63591f';
