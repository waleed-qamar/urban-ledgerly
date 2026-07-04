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
