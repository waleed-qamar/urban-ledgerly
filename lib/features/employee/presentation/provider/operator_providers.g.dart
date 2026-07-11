// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(operatorRemoteDatasource)
const operatorRemoteDatasourceProvider = OperatorRemoteDatasourceProvider._();

final class OperatorRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          EmployeeRemoteDatasource,
          EmployeeRemoteDatasource,
          EmployeeRemoteDatasource
        >
    with $Provider<EmployeeRemoteDatasource> {
  const OperatorRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'operatorRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$operatorRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<EmployeeRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRemoteDatasource create(Ref ref) {
    return operatorRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRemoteDatasource>(value),
    );
  }
}

String _$operatorRemoteDatasourceHash() =>
    r'bbf4c3aea32ac5dd156f73f739c874c78b80b772';

@ProviderFor(OperatorSearchQuery)
const operatorSearchQueryProvider = OperatorSearchQueryProvider._();

final class OperatorSearchQueryProvider
    extends $NotifierProvider<OperatorSearchQuery, String> {
  const OperatorSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'operatorSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$operatorSearchQueryHash();

  @$internal
  @override
  OperatorSearchQuery create() => OperatorSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$operatorSearchQueryHash() =>
    r'197693047aee442cd41d876f5a96b7723f9485e4';

abstract class _$OperatorSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(EmployeeSearchQuery)
const employeeSearchQueryProvider = EmployeeSearchQueryProvider._();

final class EmployeeSearchQueryProvider
    extends $NotifierProvider<EmployeeSearchQuery, String> {
  const EmployeeSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeSearchQueryHash();

  @$internal
  @override
  EmployeeSearchQuery create() => EmployeeSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$employeeSearchQueryHash() =>
    r'71d8cbc4c1363033f4ec9cdaaa4f33664726987a';

abstract class _$EmployeeSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(operatorRepository)
const operatorRepositoryProvider = OperatorRepositoryProvider._();

final class OperatorRepositoryProvider
    extends
        $FunctionalProvider<
          EmployeeRepository,
          EmployeeRepository,
          EmployeeRepository
        >
    with $Provider<EmployeeRepository> {
  const OperatorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'operatorRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$operatorRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmployeeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRepository create(Ref ref) {
    return operatorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRepository>(value),
    );
  }
}

String _$operatorRepositoryHash() =>
    r'222163a077311db9772f50b75ccb5c2697246ec6';

@ProviderFor(getAllOperators)
const getAllOperatorsProvider = GetAllOperatorsProvider._();

final class GetAllOperatorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OperatorEntity>>,
          List<OperatorEntity>,
          FutureOr<List<OperatorEntity>>
        >
    with
        $FutureModifier<List<OperatorEntity>>,
        $FutureProvider<List<OperatorEntity>> {
  const GetAllOperatorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllOperatorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllOperatorsHash();

  @$internal
  @override
  $FutureProviderElement<List<OperatorEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OperatorEntity>> create(Ref ref) {
    return getAllOperators(ref);
  }
}

String _$getAllOperatorsHash() => r'cc9afbb7532fa3bb135a8b7cd189290db6a97a9d';

@ProviderFor(addOperator)
const addOperatorProvider = AddOperatorFamily._();

final class AddOperatorProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddOperatorProvider._({
    required AddOperatorFamily super.from,
    required OperatorEntity super.argument,
  }) : super(
         retry: null,
         name: r'addOperatorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addOperatorHash();

  @override
  String toString() {
    return r'addOperatorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as OperatorEntity;
    return addOperator(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddOperatorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addOperatorHash() => r'e1956a18b6bed76846335522198b1c996586ff65';

final class AddOperatorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, OperatorEntity> {
  const AddOperatorFamily._()
    : super(
        retry: null,
        name: r'addOperatorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddOperatorProvider call(OperatorEntity employee) =>
      AddOperatorProvider._(argument: employee, from: this);

  @override
  String toString() => r'addOperatorProvider';
}

@ProviderFor(deleteOperator)
const deleteOperatorProvider = DeleteOperatorFamily._();

final class DeleteOperatorProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteOperatorProvider._({
    required DeleteOperatorFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteOperatorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteOperatorHash();

  @override
  String toString() {
    return r'deleteOperatorProvider'
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
    return deleteOperator(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteOperatorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteOperatorHash() => r'2dd0ad531545593f62a99225982fe05eba9d3941';

final class DeleteOperatorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteOperatorFamily._()
    : super(
        retry: null,
        name: r'deleteOperatorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteOperatorProvider call(int id) =>
      DeleteOperatorProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteOperatorProvider';
}

@ProviderFor(updateOperator)
const updateOperatorProvider = UpdateOperatorFamily._();

final class UpdateOperatorProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateOperatorProvider._({
    required UpdateOperatorFamily super.from,
    required OperatorEntity super.argument,
  }) : super(
         retry: null,
         name: r'updateOperatorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateOperatorHash();

  @override
  String toString() {
    return r'updateOperatorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as OperatorEntity;
    return updateOperator(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateOperatorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateOperatorHash() => r'2c928031d3290d32d166dd75b23bc27be63c7bdf';

final class UpdateOperatorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, OperatorEntity> {
  const UpdateOperatorFamily._()
    : super(
        retry: null,
        name: r'updateOperatorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateOperatorProvider call(OperatorEntity employee) =>
      UpdateOperatorProvider._(argument: employee, from: this);

  @override
  String toString() => r'updateOperatorProvider';
}

@ProviderFor(getAllEmployees)
const getAllEmployeesProvider = GetAllEmployeesProvider._();

final class GetAllEmployeesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EmployeeEntity>>,
          List<EmployeeEntity>,
          FutureOr<List<EmployeeEntity>>
        >
    with
        $FutureModifier<List<EmployeeEntity>>,
        $FutureProvider<List<EmployeeEntity>> {
  const GetAllEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllEmployeesHash();

  @$internal
  @override
  $FutureProviderElement<List<EmployeeEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EmployeeEntity>> create(Ref ref) {
    return getAllEmployees(ref);
  }
}

String _$getAllEmployeesHash() => r'8cea96e2e1e68615f73f7b6e6f92d66f3ff9ef4b';

@ProviderFor(getAllRoles)
const getAllRolesProvider = GetAllRolesProvider._();

final class GetAllRolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  const GetAllRolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllRolesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllRolesHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return getAllRoles(ref);
  }
}

String _$getAllRolesHash() => r'257f047ad7a94c98afc632494dd79c4d2bec2588';

@ProviderFor(getAllPermissions)
const getAllPermissionsProvider = GetAllPermissionsProvider._();

final class GetAllPermissionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  const GetAllPermissionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllPermissionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllPermissionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return getAllPermissions(ref);
  }
}

String _$getAllPermissionsHash() => r'd266df3160859f514eeff1f51b5f17b10e9803ed';

@ProviderFor(getRolePermissions)
const getRolePermissionsProvider = GetRolePermissionsProvider._();

final class GetRolePermissionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  const GetRolePermissionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRolePermissionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRolePermissionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return getRolePermissions(ref);
  }
}

String _$getRolePermissionsHash() =>
    r'a8f7e20b8059d6335792e9e44c98ac4b02250cec';

@ProviderFor(getAllWorkGroups)
const getAllWorkGroupsProvider = GetAllWorkGroupsProvider._();

final class GetAllWorkGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  const GetAllWorkGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllWorkGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllWorkGroupsHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return getAllWorkGroups(ref);
  }
}

String _$getAllWorkGroupsHash() => r'5f973f609e41c469b4bed144b27a60f1765665d5';

@ProviderFor(getAllWageRoles)
const getAllWageRolesProvider = GetAllWageRolesProvider._();

final class GetAllWageRolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  const GetAllWageRolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllWageRolesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllWageRolesHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return getAllWageRoles(ref);
  }
}

String _$getAllWageRolesHash() => r'f1a4f69738a72ebbd6e258cce2750f16df461dea';
