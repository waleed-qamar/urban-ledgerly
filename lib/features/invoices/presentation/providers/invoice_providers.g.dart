// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(invoiceRemoteDatasource)
const invoiceRemoteDatasourceProvider = InvoiceRemoteDatasourceProvider._();

final class InvoiceRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          InvoiceRemoteDatasource,
          InvoiceRemoteDatasource,
          InvoiceRemoteDatasource
        >
    with $Provider<InvoiceRemoteDatasource> {
  const InvoiceRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoiceRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoiceRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<InvoiceRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InvoiceRemoteDatasource create(Ref ref) {
    return invoiceRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvoiceRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvoiceRemoteDatasource>(value),
    );
  }
}

String _$invoiceRemoteDatasourceHash() =>
    r'4c15b067c046589c189938031234cfe693ed1412';

@ProviderFor(invoiceRepository)
const invoiceRepositoryProvider = InvoiceRepositoryProvider._();

final class InvoiceRepositoryProvider
    extends
        $FunctionalProvider<
          InvoiceRepository,
          InvoiceRepository,
          InvoiceRepository
        >
    with $Provider<InvoiceRepository> {
  const InvoiceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoiceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoiceRepositoryHash();

  @$internal
  @override
  $ProviderElement<InvoiceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InvoiceRepository create(Ref ref) {
    return invoiceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvoiceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvoiceRepository>(value),
    );
  }
}

String _$invoiceRepositoryHash() => r'273315b6f1e8a4e1dbe86f7774d08a56b12ef960';

@ProviderFor(getAllInvoices)
const getAllInvoicesProvider = GetAllInvoicesProvider._();

final class GetAllInvoicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InvoiceEntity>>,
          List<InvoiceEntity>,
          FutureOr<List<InvoiceEntity>>
        >
    with
        $FutureModifier<List<InvoiceEntity>>,
        $FutureProvider<List<InvoiceEntity>> {
  const GetAllInvoicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllInvoicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllInvoicesHash();

  @$internal
  @override
  $FutureProviderElement<List<InvoiceEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InvoiceEntity>> create(Ref ref) {
    return getAllInvoices(ref);
  }
}

String _$getAllInvoicesHash() => r'200fcac228928615bfeca79284e901b862645bd5';

@ProviderFor(createInvoice)
const createInvoiceProvider = CreateInvoiceFamily._();

final class CreateInvoiceProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const CreateInvoiceProvider._({
    required CreateInvoiceFamily super.from,
    required InvoiceEntity super.argument,
  }) : super(
         retry: null,
         name: r'createInvoiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createInvoiceHash();

  @override
  String toString() {
    return r'createInvoiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as InvoiceEntity;
    return createInvoice(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateInvoiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createInvoiceHash() => r'237981ec92bf944f5461118f63b708012b18ab5e';

final class CreateInvoiceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, InvoiceEntity> {
  const CreateInvoiceFamily._()
    : super(
        retry: null,
        name: r'createInvoiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateInvoiceProvider call(InvoiceEntity invoice) =>
      CreateInvoiceProvider._(argument: invoice, from: this);

  @override
  String toString() => r'createInvoiceProvider';
}

@ProviderFor(getInvoiceById)
const getInvoiceByIdProvider = GetInvoiceByIdFamily._();

final class GetInvoiceByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<InvoiceEntity>,
          InvoiceEntity,
          FutureOr<InvoiceEntity>
        >
    with $FutureModifier<InvoiceEntity>, $FutureProvider<InvoiceEntity> {
  const GetInvoiceByIdProvider._({
    required GetInvoiceByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getInvoiceByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getInvoiceByIdHash();

  @override
  String toString() {
    return r'getInvoiceByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<InvoiceEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InvoiceEntity> create(Ref ref) {
    final argument = this.argument as int;
    return getInvoiceById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetInvoiceByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getInvoiceByIdHash() => r'79459c48aaad5cbcdfee47156830a2c875bad759';

final class GetInvoiceByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<InvoiceEntity>, int> {
  const GetInvoiceByIdFamily._()
    : super(
        retry: null,
        name: r'getInvoiceByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetInvoiceByIdProvider call(int id) =>
      GetInvoiceByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'getInvoiceByIdProvider';
}

@ProviderFor(updateInvoiceStatus)
const updateInvoiceStatusProvider = UpdateInvoiceStatusFamily._();

final class UpdateInvoiceStatusProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateInvoiceStatusProvider._({
    required UpdateInvoiceStatusFamily super.from,
    required ({int id, String status, DateTime? dispatchDate}) super.argument,
  }) : super(
         retry: null,
         name: r'updateInvoiceStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateInvoiceStatusHash();

  @override
  String toString() {
    return r'updateInvoiceStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument as ({int id, String status, DateTime? dispatchDate});
    return updateInvoiceStatus(
      ref,
      id: argument.id,
      status: argument.status,
      dispatchDate: argument.dispatchDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateInvoiceStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateInvoiceStatusHash() =>
    r'b338e4596cbd34d862c2245aee6d568b042312c2';

final class UpdateInvoiceStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({int id, String status, DateTime? dispatchDate})
        > {
  const UpdateInvoiceStatusFamily._()
    : super(
        retry: null,
        name: r'updateInvoiceStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateInvoiceStatusProvider call({
    required int id,
    required String status,
    DateTime? dispatchDate,
  }) => UpdateInvoiceStatusProvider._(
    argument: (id: id, status: status, dispatchDate: dispatchDate),
    from: this,
  );

  @override
  String toString() => r'updateInvoiceStatusProvider';
}

/// Always queries the DB fresh — never uses the cached invoices list.
/// Prevents duplicate invoice number collisions.

@ProviderFor(nextInvoiceNumber)
const nextInvoiceNumberProvider = NextInvoiceNumberProvider._();

/// Always queries the DB fresh — never uses the cached invoices list.
/// Prevents duplicate invoice number collisions.

final class NextInvoiceNumberProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Always queries the DB fresh — never uses the cached invoices list.
  /// Prevents duplicate invoice number collisions.
  const NextInvoiceNumberProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextInvoiceNumberProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextInvoiceNumberHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return nextInvoiceNumber(ref);
  }
}

String _$nextInvoiceNumberHash() => r'86623d353847914a1931f1bff97ba8dfa59e901e';
