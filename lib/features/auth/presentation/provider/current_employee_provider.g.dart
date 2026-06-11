// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_employee_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentEmployee)
const currentEmployeeProvider = CurrentEmployeeProvider._();

final class CurrentEmployeeProvider
    extends
        $FunctionalProvider<
          AsyncValue<EmployeeEntity?>,
          EmployeeEntity?,
          FutureOr<EmployeeEntity?>
        >
    with $FutureModifier<EmployeeEntity?>, $FutureProvider<EmployeeEntity?> {
  const CurrentEmployeeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEmployeeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEmployeeHash();

  @$internal
  @override
  $FutureProviderElement<EmployeeEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EmployeeEntity?> create(Ref ref) {
    return currentEmployee(ref);
  }
}

String _$currentEmployeeHash() => r'5bfb61c57f17d1c532e6c64e1142e8f02065f346';

@ProviderFor(isMaster)
const isMasterProvider = IsMasterProvider._();

final class IsMasterProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isMasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isMasterHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isMaster(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isMasterHash() => r'8c6eb36ebf4824a23cfb17af53d5beebb20b7202';
