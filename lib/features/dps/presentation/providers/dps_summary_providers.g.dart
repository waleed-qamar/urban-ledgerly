// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dps_summary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DpsSummaryFilterNotifier)
const dpsSummaryFilterProvider = DpsSummaryFilterNotifierProvider._();

final class DpsSummaryFilterNotifierProvider
    extends $NotifierProvider<DpsSummaryFilterNotifier, DpsSummaryFilter> {
  const DpsSummaryFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dpsSummaryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dpsSummaryFilterNotifierHash();

  @$internal
  @override
  DpsSummaryFilterNotifier create() => DpsSummaryFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DpsSummaryFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DpsSummaryFilter>(value),
    );
  }
}

String _$dpsSummaryFilterNotifierHash() =>
    r'0ade8f69b4ef0a5a074cd811c1c8e80719aa6f6d';

abstract class _$DpsSummaryFilterNotifier extends $Notifier<DpsSummaryFilter> {
  DpsSummaryFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DpsSummaryFilter, DpsSummaryFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DpsSummaryFilter, DpsSummaryFilter>,
              DpsSummaryFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(dpsRawReportData)
const dpsRawReportDataProvider = DpsRawReportDataProvider._();

final class DpsRawReportDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<DpsRawData>,
          DpsRawData,
          FutureOr<DpsRawData>
        >
    with $FutureModifier<DpsRawData>, $FutureProvider<DpsRawData> {
  const DpsRawReportDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dpsRawReportDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dpsRawReportDataHash();

  @$internal
  @override
  $FutureProviderElement<DpsRawData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DpsRawData> create(Ref ref) {
    return dpsRawReportData(ref);
  }
}

String _$dpsRawReportDataHash() => r'd220d1d8e480d79eb56c08a32fffcac048f1f194';

@ProviderFor(dpsSummary)
const dpsSummaryProvider = DpsSummaryProvider._();

final class DpsSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DpsMatrixReportData>,
          DpsMatrixReportData,
          FutureOr<DpsMatrixReportData>
        >
    with
        $FutureModifier<DpsMatrixReportData>,
        $FutureProvider<DpsMatrixReportData> {
  const DpsSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dpsSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dpsSummaryHash();

  @$internal
  @override
  $FutureProviderElement<DpsMatrixReportData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DpsMatrixReportData> create(Ref ref) {
    return dpsSummary(ref);
  }
}

String _$dpsSummaryHash() => r'12f7690b6c6332c9fd63ad26161fd0d229ed11fe';
