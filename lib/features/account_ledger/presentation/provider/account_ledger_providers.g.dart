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
