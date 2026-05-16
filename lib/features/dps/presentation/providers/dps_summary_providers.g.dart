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
    r'904be6418f347bad7e37441916df73520a893ee4';

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

@ProviderFor(dpsSummary)
const dpsSummaryProvider = DpsSummaryProvider._();

final class DpsSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DpsSummaryResult>,
          DpsSummaryResult,
          FutureOr<DpsSummaryResult>
        >
    with $FutureModifier<DpsSummaryResult>, $FutureProvider<DpsSummaryResult> {
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
  $FutureProviderElement<DpsSummaryResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DpsSummaryResult> create(Ref ref) {
    return dpsSummary(ref);
  }
}

String _$dpsSummaryHash() => r'048f4f27c521d2c2a67bbf1ae3db7ef394e64b96';
