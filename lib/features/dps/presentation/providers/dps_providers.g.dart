// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dps_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dpsRepository)
const dpsRepositoryProvider = DpsRepositoryProvider._();

final class DpsRepositoryProvider
    extends $FunctionalProvider<DpsRepository, DpsRepository, DpsRepository>
    with $Provider<DpsRepository> {
  const DpsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dpsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dpsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DpsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DpsRepository create(Ref ref) {
    return dpsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DpsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DpsRepository>(value),
    );
  }
}

String _$dpsRepositoryHash() => r'5b6fd6dcba8e0143ea0394e7626610a9f377d3b6';

@ProviderFor(dpsMachines)
const dpsMachinesProvider = DpsMachinesProvider._();

final class DpsMachinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Machine>>,
          List<Machine>,
          FutureOr<List<Machine>>
        >
    with $FutureModifier<List<Machine>>, $FutureProvider<List<Machine>> {
  const DpsMachinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dpsMachinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dpsMachinesHash();

  @$internal
  @override
  $FutureProviderElement<List<Machine>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Machine>> create(Ref ref) {
    return dpsMachines(ref);
  }
}

String _$dpsMachinesHash() => r'4044d5a961a82f03a7d1743b849e1f123878271e';

@ProviderFor(dpsReports)
const dpsReportsProvider = DpsReportsProvider._();

final class DpsReportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DpsReport>>,
          List<DpsReport>,
          FutureOr<List<DpsReport>>
        >
    with $FutureModifier<List<DpsReport>>, $FutureProvider<List<DpsReport>> {
  const DpsReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dpsReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dpsReportsHash();

  @$internal
  @override
  $FutureProviderElement<List<DpsReport>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DpsReport>> create(Ref ref) {
    return dpsReports(ref);
  }
}

String _$dpsReportsHash() => r'6a66ec4331cc31690fb1b8d411915b55ecb1d7a7';

@ProviderFor(DpsFormNotifier)
const dpsFormProvider = DpsFormNotifierProvider._();

final class DpsFormNotifierProvider
    extends $NotifierProvider<DpsFormNotifier, DpsFormState> {
  const DpsFormNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dpsFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dpsFormNotifierHash();

  @$internal
  @override
  DpsFormNotifier create() => DpsFormNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DpsFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DpsFormState>(value),
    );
  }
}

String _$dpsFormNotifierHash() => r'8d8653fe167b8636fa5750ab73554d3172a712cd';

abstract class _$DpsFormNotifier extends $Notifier<DpsFormState> {
  DpsFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DpsFormState, DpsFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DpsFormState, DpsFormState>,
              DpsFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
