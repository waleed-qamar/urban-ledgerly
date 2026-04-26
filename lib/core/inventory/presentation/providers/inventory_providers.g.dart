// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The shared Supabase-backed datasource for inventory_transactions.

@ProviderFor(inventoryRemoteDatasource)
const inventoryRemoteDatasourceProvider = InventoryRemoteDatasourceProvider._();

/// The shared Supabase-backed datasource for inventory_transactions.

final class InventoryRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          InventoryRemoteDatasource,
          InventoryRemoteDatasource,
          InventoryRemoteDatasource
        >
    with $Provider<InventoryRemoteDatasource> {
  /// The shared Supabase-backed datasource for inventory_transactions.
  const InventoryRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<InventoryRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRemoteDatasource create(Ref ref) {
    return inventoryRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRemoteDatasource>(value),
    );
  }
}

String _$inventoryRemoteDatasourceHash() =>
    r'ac4496a3d46b466a1b7e9ea0618ca1bf5bb56406';

/// The shared repository — inject this wherever you need inventory ops.

@ProviderFor(inventoryRepository)
const inventoryRepositoryProvider = InventoryRepositoryProvider._();

/// The shared repository — inject this wherever you need inventory ops.

final class InventoryRepositoryProvider
    extends
        $FunctionalProvider<
          InventoryRepository,
          InventoryRepository,
          InventoryRepository
        >
    with $Provider<InventoryRepository> {
  /// The shared repository — inject this wherever you need inventory ops.
  const InventoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRepository create(Ref ref) {
    return inventoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRepository>(value),
    );
  }
}

String _$inventoryRepositoryHash() =>
    r'dc3e0bbd4a99e1c6f2d69e5114a7b2b28e15d4d8';

/// Fetch all transactions for a specific item (product or raw material).
///
/// Usage:
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'PRODUCT'))
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'RAW_MATERIAL'))

@ProviderFor(inventoryTransactionsForItem)
const inventoryTransactionsForItemProvider =
    InventoryTransactionsForItemFamily._();

/// Fetch all transactions for a specific item (product or raw material).
///
/// Usage:
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'PRODUCT'))
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'RAW_MATERIAL'))

final class InventoryTransactionsForItemProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryTransactionEntity>>,
          List<InventoryTransactionEntity>,
          FutureOr<List<InventoryTransactionEntity>>
        >
    with
        $FutureModifier<List<InventoryTransactionEntity>>,
        $FutureProvider<List<InventoryTransactionEntity>> {
  /// Fetch all transactions for a specific item (product or raw material).
  ///
  /// Usage:
  ///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'PRODUCT'))
  ///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'RAW_MATERIAL'))
  const InventoryTransactionsForItemProvider._({
    required InventoryTransactionsForItemFamily super.from,
    required (int, String) super.argument,
  }) : super(
         retry: null,
         name: r'inventoryTransactionsForItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inventoryTransactionsForItemHash();

  @override
  String toString() {
    return r'inventoryTransactionsForItemProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<InventoryTransactionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryTransactionEntity>> create(Ref ref) {
    final argument = this.argument as (int, String);
    return inventoryTransactionsForItem(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryTransactionsForItemProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inventoryTransactionsForItemHash() =>
    r'5ef8fc583b5a93aafb070a5221814e62239ca5d1';

/// Fetch all transactions for a specific item (product or raw material).
///
/// Usage:
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'PRODUCT'))
///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'RAW_MATERIAL'))

final class InventoryTransactionsForItemFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<InventoryTransactionEntity>>,
          (int, String)
        > {
  const InventoryTransactionsForItemFamily._()
    : super(
        retry: null,
        name: r'inventoryTransactionsForItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch all transactions for a specific item (product or raw material).
  ///
  /// Usage:
  ///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'PRODUCT'))
  ///   ref.watch(inventoryTransactionsForItemProvider(itemId, 'RAW_MATERIAL'))

  InventoryTransactionsForItemProvider call(int itemId, String itemType) =>
      InventoryTransactionsForItemProvider._(
        argument: (itemId, itemType),
        from: this,
      );

  @override
  String toString() => r'inventoryTransactionsForItemProvider';
}

/// Delete a single transaction by id.

@ProviderFor(deleteInventoryTransaction)
const deleteInventoryTransactionProvider = DeleteInventoryTransactionFamily._();

/// Delete a single transaction by id.

final class DeleteInventoryTransactionProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Delete a single transaction by id.
  const DeleteInventoryTransactionProvider._({
    required DeleteInventoryTransactionFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteInventoryTransactionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteInventoryTransactionHash();

  @override
  String toString() {
    return r'deleteInventoryTransactionProvider'
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
    return deleteInventoryTransaction(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteInventoryTransactionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteInventoryTransactionHash() =>
    r'4ecd2ca45bde8644b145b33713bd0571180b0a15';

/// Delete a single transaction by id.

final class DeleteInventoryTransactionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteInventoryTransactionFamily._()
    : super(
        retry: null,
        name: r'deleteInventoryTransactionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Delete a single transaction by id.

  DeleteInventoryTransactionProvider call(int transactionId) =>
      DeleteInventoryTransactionProvider._(argument: transactionId, from: this);

  @override
  String toString() => r'deleteInventoryTransactionProvider';
}

/// Update a transaction's quantity, type, and notes.

@ProviderFor(updateInventoryTransaction)
const updateInventoryTransactionProvider = UpdateInventoryTransactionFamily._();

/// Update a transaction's quantity, type, and notes.

final class UpdateInventoryTransactionProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Update a transaction's quantity, type, and notes.
  const UpdateInventoryTransactionProvider._({
    required UpdateInventoryTransactionFamily super.from,
    required (
      int,
      int,
      String, {
      String? notes,
      String? referenceType,
      int? referenceId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'updateInventoryTransactionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateInventoryTransactionHash();

  @override
  String toString() {
    return r'updateInventoryTransactionProvider'
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
        this.argument
            as (
              int,
              int,
              String, {
              String? notes,
              String? referenceType,
              int? referenceId,
            });
    return updateInventoryTransaction(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      notes: argument.notes,
      referenceType: argument.referenceType,
      referenceId: argument.referenceId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateInventoryTransactionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateInventoryTransactionHash() =>
    r'9938e51c9c0746210dab3d7c6ec5a2b529a9ef59';

/// Update a transaction's quantity, type, and notes.

final class UpdateInventoryTransactionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          (
            int,
            int,
            String, {
            String? notes,
            String? referenceType,
            int? referenceId,
          })
        > {
  const UpdateInventoryTransactionFamily._()
    : super(
        retry: null,
        name: r'updateInventoryTransactionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Update a transaction's quantity, type, and notes.

  UpdateInventoryTransactionProvider call(
    int transactionId,
    int quantity,
    String transactionType, {
    String? notes,
    String? referenceType,
    int? referenceId,
  }) => UpdateInventoryTransactionProvider._(
    argument: (
      transactionId,
      quantity,
      transactionType,
      notes: notes,
      referenceType: referenceType,
      referenceId: referenceId,
    ),
    from: this,
  );

  @override
  String toString() => r'updateInventoryTransactionProvider';
}
