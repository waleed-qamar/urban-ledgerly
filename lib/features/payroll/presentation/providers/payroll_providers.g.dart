// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(payrollRemoteDatasource)
const payrollRemoteDatasourceProvider = PayrollRemoteDatasourceProvider._();

final class PayrollRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          PayrollRemoteDatasource,
          PayrollRemoteDatasource,
          PayrollRemoteDatasource
        >
    with $Provider<PayrollRemoteDatasource> {
  const PayrollRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payrollRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payrollRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<PayrollRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PayrollRemoteDatasource create(Ref ref) {
    return payrollRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayrollRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayrollRemoteDatasource>(value),
    );
  }
}

String _$payrollRemoteDatasourceHash() =>
    r'ca61fbb76b7798715fbee5c34f88197b29d9bcb9';

@ProviderFor(payrollRepository)
const payrollRepositoryProvider = PayrollRepositoryProvider._();

final class PayrollRepositoryProvider
    extends
        $FunctionalProvider<
          PayrollRepository,
          PayrollRepository,
          PayrollRepository
        >
    with $Provider<PayrollRepository> {
  const PayrollRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payrollRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payrollRepositoryHash();

  @$internal
  @override
  $ProviderElement<PayrollRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PayrollRepository create(Ref ref) {
    return payrollRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayrollRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayrollRepository>(value),
    );
  }
}

String _$payrollRepositoryHash() => r'921fcbf0d7ba0252336758bdd260e24d73182669';

@ProviderFor(payrollSheets)
const payrollSheetsProvider = PayrollSheetsProvider._();

final class PayrollSheetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PayrollSheetEntity>>,
          List<PayrollSheetEntity>,
          FutureOr<List<PayrollSheetEntity>>
        >
    with
        $FutureModifier<List<PayrollSheetEntity>>,
        $FutureProvider<List<PayrollSheetEntity>> {
  const PayrollSheetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payrollSheetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payrollSheetsHash();

  @$internal
  @override
  $FutureProviderElement<List<PayrollSheetEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PayrollSheetEntity>> create(Ref ref) {
    return payrollSheets(ref);
  }
}

String _$payrollSheetsHash() => r'2c627259b65c1b87699d4f3f7eecae990be61f86';

@ProviderFor(PayrollSheetDetail)
const payrollSheetDetailProvider = PayrollSheetDetailFamily._();

final class PayrollSheetDetailProvider
    extends $NotifierProvider<PayrollSheetDetail, PayrollSheetState> {
  const PayrollSheetDetailProvider._({
    required PayrollSheetDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'payrollSheetDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$payrollSheetDetailHash();

  @override
  String toString() {
    return r'payrollSheetDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PayrollSheetDetail create() => PayrollSheetDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayrollSheetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayrollSheetState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PayrollSheetDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$payrollSheetDetailHash() =>
    r'fadabe651d9e9923543bde7266d7da3345e39554';

final class PayrollSheetDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          PayrollSheetDetail,
          PayrollSheetState,
          PayrollSheetState,
          PayrollSheetState,
          String
        > {
  const PayrollSheetDetailFamily._()
    : super(
        retry: null,
        name: r'payrollSheetDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PayrollSheetDetailProvider call(String sheetId) =>
      PayrollSheetDetailProvider._(argument: sheetId, from: this);

  @override
  String toString() => r'payrollSheetDetailProvider';
}

abstract class _$PayrollSheetDetail extends $Notifier<PayrollSheetState> {
  late final _$args = ref.$arg as String;
  String get sheetId => _$args;

  PayrollSheetState build(String sheetId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<PayrollSheetState, PayrollSheetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PayrollSheetState, PayrollSheetState>,
              PayrollSheetState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
