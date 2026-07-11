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

String _$currentEmployeeHash() => r'c9923e20ba656f7dcecb0517644dbf0604d484c3';

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

String _$isMasterHash() => r'411b0ee931eb1d0f0000d2a92b83f5122e9bb768';

@ProviderFor(userPermissions)
const userPermissionsProvider = UserPermissionsProvider._();

final class UserPermissionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  const UserPermissionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPermissionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPermissionsHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return userPermissions(ref);
  }
}

String _$userPermissionsHash() => r'03975edcba9bb079ef909de9001136efd12b1569';

@ProviderFor(hasPermission)
const hasPermissionProvider = HasPermissionFamily._();

final class HasPermissionProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const HasPermissionProvider._({
    required HasPermissionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hasPermissionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasPermissionHash();

  @override
  String toString() {
    return r'hasPermissionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return hasPermission(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HasPermissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasPermissionHash() => r'e55d3c16352382c067e119b0c4f41e3105176a72';

final class HasPermissionFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const HasPermissionFamily._()
    : super(
        retry: null,
        name: r'hasPermissionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HasPermissionProvider call(String permissionKey) =>
      HasPermissionProvider._(argument: permissionKey, from: this);

  @override
  String toString() => r'hasPermissionProvider';
}
