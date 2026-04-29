// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(receiptRemoteDatasource)
const receiptRemoteDatasourceProvider = ReceiptRemoteDatasourceProvider._();

final class ReceiptRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          ReceiptRemoteDatasource,
          ReceiptRemoteDatasource,
          ReceiptRemoteDatasource
        >
    with $Provider<ReceiptRemoteDatasource> {
  const ReceiptRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ReceiptRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReceiptRemoteDatasource create(Ref ref) {
    return receiptRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptRemoteDatasource>(value),
    );
  }
}

String _$receiptRemoteDatasourceHash() =>
    r'60390df4ae8d57debf041a7a45ec5cc63ee358ed';

@ProviderFor(receiptRepository)
const receiptRepositoryProvider = ReceiptRepositoryProvider._();

final class ReceiptRepositoryProvider
    extends
        $FunctionalProvider<
          ReceiptRepository,
          ReceiptRepository,
          ReceiptRepository
        >
    with $Provider<ReceiptRepository> {
  const ReceiptRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReceiptRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReceiptRepository create(Ref ref) {
    return receiptRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptRepository>(value),
    );
  }
}

String _$receiptRepositoryHash() => r'4a72dadcf75532bfbeb29a6b9ca6ba3614da54d2';

@ProviderFor(getAllReceipts)
const getAllReceiptsProvider = GetAllReceiptsProvider._();

final class GetAllReceiptsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReceiptEntity>>,
          List<ReceiptEntity>,
          FutureOr<List<ReceiptEntity>>
        >
    with
        $FutureModifier<List<ReceiptEntity>>,
        $FutureProvider<List<ReceiptEntity>> {
  const GetAllReceiptsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllReceiptsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllReceiptsHash();

  @$internal
  @override
  $FutureProviderElement<List<ReceiptEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReceiptEntity>> create(Ref ref) {
    return getAllReceipts(ref);
  }
}

String _$getAllReceiptsHash() => r'28150054af804abf91fc024f0057c3db5d5f8568';

@ProviderFor(getReceiptById)
const getReceiptByIdProvider = GetReceiptByIdFamily._();

final class GetReceiptByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReceiptEntity>,
          ReceiptEntity,
          FutureOr<ReceiptEntity>
        >
    with $FutureModifier<ReceiptEntity>, $FutureProvider<ReceiptEntity> {
  const GetReceiptByIdProvider._({
    required GetReceiptByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getReceiptByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getReceiptByIdHash();

  @override
  String toString() {
    return r'getReceiptByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReceiptEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReceiptEntity> create(Ref ref) {
    final argument = this.argument as int;
    return getReceiptById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetReceiptByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getReceiptByIdHash() => r'5ba6745ad2f2afdfed3c04635871941bcc4884e1';

final class GetReceiptByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReceiptEntity>, int> {
  const GetReceiptByIdFamily._()
    : super(
        retry: null,
        name: r'getReceiptByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetReceiptByIdProvider call(int id) =>
      GetReceiptByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'getReceiptByIdProvider';
}

@ProviderFor(createReceipt)
const createReceiptProvider = CreateReceiptFamily._();

final class CreateReceiptProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReceiptEntity>,
          ReceiptEntity,
          FutureOr<ReceiptEntity>
        >
    with $FutureModifier<ReceiptEntity>, $FutureProvider<ReceiptEntity> {
  const CreateReceiptProvider._({
    required CreateReceiptFamily super.from,
    required ReceiptEntity super.argument,
  }) : super(
         retry: null,
         name: r'createReceiptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createReceiptHash();

  @override
  String toString() {
    return r'createReceiptProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReceiptEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReceiptEntity> create(Ref ref) {
    final argument = this.argument as ReceiptEntity;
    return createReceipt(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateReceiptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createReceiptHash() => r'd96f5863db8506a8453719e3d1eeb65550374215';

final class CreateReceiptFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReceiptEntity>, ReceiptEntity> {
  const CreateReceiptFamily._()
    : super(
        retry: null,
        name: r'createReceiptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateReceiptProvider call(ReceiptEntity receipt) =>
      CreateReceiptProvider._(argument: receipt, from: this);

  @override
  String toString() => r'createReceiptProvider';
}

@ProviderFor(deleteReceipt)
const deleteReceiptProvider = DeleteReceiptFamily._();

final class DeleteReceiptProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteReceiptProvider._({
    required DeleteReceiptFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteReceiptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteReceiptHash();

  @override
  String toString() {
    return r'deleteReceiptProvider'
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
    return deleteReceipt(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteReceiptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteReceiptHash() => r'e8b8fba855efb385090a2f5c1fed3504be01eb23';

final class DeleteReceiptFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteReceiptFamily._()
    : super(
        retry: null,
        name: r'deleteReceiptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteReceiptProvider call(int id) =>
      DeleteReceiptProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteReceiptProvider';
}
