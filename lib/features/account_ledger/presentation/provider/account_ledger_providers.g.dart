// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_ledger_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountLedgerRemoteDatasource)
const accountLedgerRemoteDatasourceProvider =
    AccountLedgerRemoteDatasourceProvider._();

final class AccountLedgerRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          AccountLedgerRemoteDatasource,
          AccountLedgerRemoteDatasource,
          AccountLedgerRemoteDatasource
        >
    with $Provider<AccountLedgerRemoteDatasource> {
  const AccountLedgerRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountLedgerRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountLedgerRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<AccountLedgerRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountLedgerRemoteDatasource create(Ref ref) {
    return accountLedgerRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountLedgerRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountLedgerRemoteDatasource>(
        value,
      ),
    );
  }
}

String _$accountLedgerRemoteDatasourceHash() =>
    r'5807a9cd77b330eccbd598f3afaaf8df78f09ba6';

@ProviderFor(accountLedgerRepository)
const accountLedgerRepositoryProvider = AccountLedgerRepositoryProvider._();

final class AccountLedgerRepositoryProvider
    extends
        $FunctionalProvider<
          AccountLedgerRepository,
          AccountLedgerRepository,
          AccountLedgerRepository
        >
    with $Provider<AccountLedgerRepository> {
  const AccountLedgerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountLedgerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountLedgerRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountLedgerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountLedgerRepository create(Ref ref) {
    return accountLedgerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountLedgerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountLedgerRepository>(value),
    );
  }
}

String _$accountLedgerRepositoryHash() =>
    r'18c8524543605a6a21de9886a3312f2304788f66';

@ProviderFor(getAllAccounts)
const getAllAccountsProvider = GetAllAccountsProvider._();

final class GetAllAccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccountEntity>>,
          List<AccountEntity>,
          FutureOr<List<AccountEntity>>
        >
    with
        $FutureModifier<List<AccountEntity>>,
        $FutureProvider<List<AccountEntity>> {
  const GetAllAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllAccountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllAccountsHash();

  @$internal
  @override
  $FutureProviderElement<List<AccountEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AccountEntity>> create(Ref ref) {
    return getAllAccounts(ref);
  }
}

String _$getAllAccountsHash() => r'580cb33f1ffd3d592f5e46f071fe1b7523522aff';

@ProviderFor(getAccountById)
const getAccountByIdProvider = GetAccountByIdFamily._();

final class GetAccountByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccountEntity>,
          AccountEntity,
          FutureOr<AccountEntity>
        >
    with $FutureModifier<AccountEntity>, $FutureProvider<AccountEntity> {
  const GetAccountByIdProvider._({
    required GetAccountByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getAccountByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAccountByIdHash();

  @override
  String toString() {
    return r'getAccountByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AccountEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccountEntity> create(Ref ref) {
    final argument = this.argument as int;
    return getAccountById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAccountByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAccountByIdHash() => r'b119eaea51833e88aa957f7d4159b0ed19e1c4bc';

final class GetAccountByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AccountEntity>, int> {
  const GetAccountByIdFamily._()
    : super(
        retry: null,
        name: r'getAccountByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAccountByIdProvider call(int accountId) =>
      GetAccountByIdProvider._(argument: accountId, from: this);

  @override
  String toString() => r'getAccountByIdProvider';
}

@ProviderFor(getAccountTransactions)
const getAccountTransactionsProvider = GetAccountTransactionsFamily._();

final class GetAccountTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccountTransactionEntity>>,
          List<AccountTransactionEntity>,
          FutureOr<List<AccountTransactionEntity>>
        >
    with
        $FutureModifier<List<AccountTransactionEntity>>,
        $FutureProvider<List<AccountTransactionEntity>> {
  const GetAccountTransactionsProvider._({
    required GetAccountTransactionsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getAccountTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAccountTransactionsHash();

  @override
  String toString() {
    return r'getAccountTransactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AccountTransactionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AccountTransactionEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return getAccountTransactions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAccountTransactionsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAccountTransactionsHash() =>
    r'44e0cbae324051464458d66d9b9164b114067aea';

final class GetAccountTransactionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AccountTransactionEntity>>,
          int
        > {
  const GetAccountTransactionsFamily._()
    : super(
        retry: null,
        name: r'getAccountTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAccountTransactionsProvider call(int accountId) =>
      GetAccountTransactionsProvider._(argument: accountId, from: this);

  @override
  String toString() => r'getAccountTransactionsProvider';
}

@ProviderFor(getAccountIdByReference)
const getAccountIdByReferenceProvider = GetAccountIdByReferenceFamily._();

final class GetAccountIdByReferenceProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  const GetAccountIdByReferenceProvider._({
    required GetAccountIdByReferenceFamily super.from,
    required ({String referenceType, int referenceId}) super.argument,
  }) : super(
         retry: null,
         name: r'getAccountIdByReferenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAccountIdByReferenceHash();

  @override
  String toString() {
    return r'getAccountIdByReferenceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as ({String referenceType, int referenceId});
    return getAccountIdByReference(
      ref,
      referenceType: argument.referenceType,
      referenceId: argument.referenceId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetAccountIdByReferenceProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAccountIdByReferenceHash() =>
    r'afbbaed29ff2a4e82ea6d67f27853edc28e3b69d';

final class GetAccountIdByReferenceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<int?>,
          ({String referenceType, int referenceId})
        > {
  const GetAccountIdByReferenceFamily._()
    : super(
        retry: null,
        name: r'getAccountIdByReferenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAccountIdByReferenceProvider call({
    required String referenceType,
    required int referenceId,
  }) => GetAccountIdByReferenceProvider._(
    argument: (referenceType: referenceType, referenceId: referenceId),
    from: this,
  );

  @override
  String toString() => r'getAccountIdByReferenceProvider';
}

@ProviderFor(transferBetweenAccounts)
const transferBetweenAccountsProvider = TransferBetweenAccountsFamily._();

final class TransferBetweenAccountsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const TransferBetweenAccountsProvider._({
    required TransferBetweenAccountsFamily super.from,
    required ({
      int fromAccountId,
      int toAccountId,
      double amount,
      String description,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'transferBetweenAccountsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transferBetweenAccountsHash();

  @override
  String toString() {
    return r'transferBetweenAccountsProvider'
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
            as ({
              int fromAccountId,
              int toAccountId,
              double amount,
              String description,
            });
    return transferBetweenAccounts(
      ref,
      fromAccountId: argument.fromAccountId,
      toAccountId: argument.toAccountId,
      amount: argument.amount,
      description: argument.description,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransferBetweenAccountsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transferBetweenAccountsHash() =>
    r'99bd291e674a86955267ec1e8384f9d19557a6af';

final class TransferBetweenAccountsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({
            int fromAccountId,
            int toAccountId,
            double amount,
            String description,
          })
        > {
  const TransferBetweenAccountsFamily._()
    : super(
        retry: null,
        name: r'transferBetweenAccountsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransferBetweenAccountsProvider call({
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String description,
  }) => TransferBetweenAccountsProvider._(
    argument: (
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
      description: description,
    ),
    from: this,
  );

  @override
  String toString() => r'transferBetweenAccountsProvider';
}
