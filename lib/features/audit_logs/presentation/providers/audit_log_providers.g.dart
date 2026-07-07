// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(auditLogRemoteDataSource)
const auditLogRemoteDataSourceProvider = AuditLogRemoteDataSourceProvider._();

final class AuditLogRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuditLogRemoteDataSource,
          AuditLogRemoteDataSource,
          AuditLogRemoteDataSource
        >
    with $Provider<AuditLogRemoteDataSource> {
  const AuditLogRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuditLogRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuditLogRemoteDataSource create(Ref ref) {
    return auditLogRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditLogRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditLogRemoteDataSource>(value),
    );
  }
}

String _$auditLogRemoteDataSourceHash() =>
    r'f01d96ef160290684c30d0287a93093c5145a2f8';

@ProviderFor(auditLogRepository)
const auditLogRepositoryProvider = AuditLogRepositoryProvider._();

final class AuditLogRepositoryProvider
    extends
        $FunctionalProvider<
          AuditLogRepository,
          AuditLogRepository,
          AuditLogRepository
        >
    with $Provider<AuditLogRepository> {
  const AuditLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuditLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuditLogRepository create(Ref ref) {
    return auditLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditLogRepository>(value),
    );
  }
}

String _$auditLogRepositoryHash() =>
    r'c3265eb50e0efdd8d42d0113da3c5c517ed6ccef';

@ProviderFor(auditLogFilterOptions)
const auditLogFilterOptionsProvider = AuditLogFilterOptionsProvider._();

final class AuditLogFilterOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<({List<AuditLogActor> actors, List<String> tables})>,
          ({List<AuditLogActor> actors, List<String> tables}),
          FutureOr<({List<AuditLogActor> actors, List<String> tables})>
        >
    with
        $FutureModifier<({List<AuditLogActor> actors, List<String> tables})>,
        $FutureProvider<({List<AuditLogActor> actors, List<String> tables})> {
  const AuditLogFilterOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogFilterOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogFilterOptionsHash();

  @$internal
  @override
  $FutureProviderElement<({List<AuditLogActor> actors, List<String> tables})>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<({List<AuditLogActor> actors, List<String> tables})> create(
    Ref ref,
  ) {
    return auditLogFilterOptions(ref);
  }
}

String _$auditLogFilterOptionsHash() =>
    r'c156c9b3521d8ba3ba96dbd79ff9ad3a4b532225';

@ProviderFor(AuditLogFilterController)
const auditLogFilterControllerProvider = AuditLogFilterControllerProvider._();

final class AuditLogFilterControllerProvider
    extends $NotifierProvider<AuditLogFilterController, AuditLogFilter> {
  const AuditLogFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogFilterControllerHash();

  @$internal
  @override
  AuditLogFilterController create() => AuditLogFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditLogFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditLogFilter>(value),
    );
  }
}

String _$auditLogFilterControllerHash() =>
    r'f1815659bc8fd8adb0e1439a22f3c62bee3b8186';

abstract class _$AuditLogFilterController extends $Notifier<AuditLogFilter> {
  AuditLogFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuditLogFilter, AuditLogFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuditLogFilter, AuditLogFilter>,
              AuditLogFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Rebuilds (and resets to page 0) automatically whenever the filter
/// controller changes, because it `watch`es it below.

@ProviderFor(AuditLogListController)
const auditLogListControllerProvider = AuditLogListControllerProvider._();

/// Rebuilds (and resets to page 0) automatically whenever the filter
/// controller changes, because it `watch`es it below.
final class AuditLogListControllerProvider
    extends $AsyncNotifierProvider<AuditLogListController, AuditLogPage> {
  /// Rebuilds (and resets to page 0) automatically whenever the filter
  /// controller changes, because it `watch`es it below.
  const AuditLogListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogListControllerHash();

  @$internal
  @override
  AuditLogListController create() => AuditLogListController();
}

String _$auditLogListControllerHash() =>
    r'5f5847c46466c8806a1fe02635e2b6a48ec855f5';

/// Rebuilds (and resets to page 0) automatically whenever the filter
/// controller changes, because it `watch`es it below.

abstract class _$AuditLogListController extends $AsyncNotifier<AuditLogPage> {
  FutureOr<AuditLogPage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AuditLogPage>, AuditLogPage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuditLogPage>, AuditLogPage>,
              AsyncValue<AuditLogPage>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
