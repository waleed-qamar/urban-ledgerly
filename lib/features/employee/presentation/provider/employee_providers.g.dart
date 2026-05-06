// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employeeRemoteDatasource)
const employeeRemoteDatasourceProvider = EmployeeRemoteDatasourceProvider._();

final class EmployeeRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          EmployeeRemoteDatasource,
          EmployeeRemoteDatasource,
          EmployeeRemoteDatasource
        >
    with $Provider<EmployeeRemoteDatasource> {
  const EmployeeRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<EmployeeRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRemoteDatasource create(Ref ref) {
    return employeeRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRemoteDatasource>(value),
    );
  }
}

String _$employeeRemoteDatasourceHash() =>
    r'540078860120387ecdf814039739b84b874bca9d';

@ProviderFor(employeeRepository)
const employeeRepositoryProvider = EmployeeRepositoryProvider._();

final class EmployeeRepositoryProvider
    extends
        $FunctionalProvider<
          EmployeeRepository,
          EmployeeRepository,
          EmployeeRepository
        >
    with $Provider<EmployeeRepository> {
  const EmployeeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmployeeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRepository create(Ref ref) {
    return employeeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRepository>(value),
    );
  }
}

String _$employeeRepositoryHash() =>
    r'58c758357b1b9dfa9c68adeb6ab91aaa87b31c74';

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

String _$getAllEmployeesHash() => r'685441ce0e3a2ce03c93cf5578e100574f420b21';

@ProviderFor(addEmployee)
const addEmployeeProvider = AddEmployeeFamily._();

final class AddEmployeeProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddEmployeeProvider._({
    required AddEmployeeFamily super.from,
    required EmployeeEntity super.argument,
  }) : super(
         retry: null,
         name: r'addEmployeeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addEmployeeHash();

  @override
  String toString() {
    return r'addEmployeeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as EmployeeEntity;
    return addEmployee(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddEmployeeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addEmployeeHash() => r'a0182388e1b1ae1f51a91f918489ad4e93c4f7b8';

final class AddEmployeeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, EmployeeEntity> {
  const AddEmployeeFamily._()
    : super(
        retry: null,
        name: r'addEmployeeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddEmployeeProvider call(EmployeeEntity employee) =>
      AddEmployeeProvider._(argument: employee, from: this);

  @override
  String toString() => r'addEmployeeProvider';
}

@ProviderFor(deleteEmployee)
const deleteEmployeeProvider = DeleteEmployeeFamily._();

final class DeleteEmployeeProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteEmployeeProvider._({
    required DeleteEmployeeFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteEmployeeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteEmployeeHash();

  @override
  String toString() {
    return r'deleteEmployeeProvider'
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
    return deleteEmployee(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteEmployeeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteEmployeeHash() => r'fba8bbe77271c0bbf579caa66d793e0f31b763b9';

final class DeleteEmployeeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteEmployeeFamily._()
    : super(
        retry: null,
        name: r'deleteEmployeeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteEmployeeProvider call(int id) =>
      DeleteEmployeeProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteEmployeeProvider';
}

@ProviderFor(updateEmployee)
const updateEmployeeProvider = UpdateEmployeeFamily._();

final class UpdateEmployeeProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateEmployeeProvider._({
    required UpdateEmployeeFamily super.from,
    required EmployeeEntity super.argument,
  }) : super(
         retry: null,
         name: r'updateEmployeeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateEmployeeHash();

  @override
  String toString() {
    return r'updateEmployeeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as EmployeeEntity;
    return updateEmployee(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateEmployeeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateEmployeeHash() => r'78b143e8c2e18f46bf5e76c004483bd8845f8908';

final class UpdateEmployeeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, EmployeeEntity> {
  const UpdateEmployeeFamily._()
    : super(
        retry: null,
        name: r'updateEmployeeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateEmployeeProvider call(EmployeeEntity employee) =>
      UpdateEmployeeProvider._(argument: employee, from: this);

  @override
  String toString() => r'updateEmployeeProvider';
}
