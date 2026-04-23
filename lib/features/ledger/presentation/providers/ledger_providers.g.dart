// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ledgerRemoteDatasource)
const ledgerRemoteDatasourceProvider = LedgerRemoteDatasourceProvider._();

final class LedgerRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          LedgerRemoteDatasource,
          LedgerRemoteDatasource,
          LedgerRemoteDatasource
        >
    with $Provider<LedgerRemoteDatasource> {
  const LedgerRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<LedgerRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LedgerRemoteDatasource create(Ref ref) {
    return ledgerRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerRemoteDatasource>(value),
    );
  }
}

String _$ledgerRemoteDatasourceHash() =>
    r'20f9d613cc54cbb1465eb5e5c06706d195ea6bc7';

@ProviderFor(ledgerRepository)
const ledgerRepositoryProvider = LedgerRepositoryProvider._();

final class LedgerRepositoryProvider
    extends
        $FunctionalProvider<
          LedgerRepository,
          LedgerRepository,
          LedgerRepository
        >
    with $Provider<LedgerRepository> {
  const LedgerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerRepositoryHash();

  @$internal
  @override
  $ProviderElement<LedgerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LedgerRepository create(Ref ref) {
    return ledgerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerRepository>(value),
    );
  }
}

String _$ledgerRepositoryHash() => r'6b3545f5d113db462a8982233ff2c32c881e63eb';

@ProviderFor(getAllEntries)
const getAllEntriesProvider = GetAllEntriesProvider._();

final class GetAllEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LedgerEntity>>,
          List<LedgerEntity>,
          FutureOr<List<LedgerEntity>>
        >
    with
        $FutureModifier<List<LedgerEntity>>,
        $FutureProvider<List<LedgerEntity>> {
  const GetAllEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllEntriesHash();

  @$internal
  @override
  $FutureProviderElement<List<LedgerEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LedgerEntity>> create(Ref ref) {
    return getAllEntries(ref);
  }
}

String _$getAllEntriesHash() => r'0793a96bd5e25ec166d3550268971c20e3000569';

@ProviderFor(addEntry)
const addEntryProvider = AddEntryFamily._();

final class AddEntryProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddEntryProvider._({
    required AddEntryFamily super.from,
    required LedgerEntity super.argument,
  }) : super(
         retry: null,
         name: r'addEntryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addEntryHash();

  @override
  String toString() {
    return r'addEntryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as LedgerEntity;
    return addEntry(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddEntryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addEntryHash() => r'3141cfe8d87df6edb21704d796c86fb777521663';

final class AddEntryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, LedgerEntity> {
  const AddEntryFamily._()
    : super(
        retry: null,
        name: r'addEntryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddEntryProvider call(LedgerEntity entry) =>
      AddEntryProvider._(argument: entry, from: this);

  @override
  String toString() => r'addEntryProvider';
}

@ProviderFor(getEntriesByDateRange)
const getEntriesByDateRangeProvider = GetEntriesByDateRangeFamily._();

final class GetEntriesByDateRangeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LedgerEntity>>,
          List<LedgerEntity>,
          FutureOr<List<LedgerEntity>>
        >
    with
        $FutureModifier<List<LedgerEntity>>,
        $FutureProvider<List<LedgerEntity>> {
  const GetEntriesByDateRangeProvider._({
    required GetEntriesByDateRangeFamily super.from,
    required (DateTime, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'getEntriesByDateRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getEntriesByDateRangeHash();

  @override
  String toString() {
    return r'getEntriesByDateRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<LedgerEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LedgerEntity>> create(Ref ref) {
    final argument = this.argument as (DateTime, DateTime);
    return getEntriesByDateRange(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is GetEntriesByDateRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getEntriesByDateRangeHash() =>
    r'7ad3a1995cfadabf31b486c8434cbe86ffa44a89';

final class GetEntriesByDateRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LedgerEntity>>,
          (DateTime, DateTime)
        > {
  const GetEntriesByDateRangeFamily._()
    : super(
        retry: null,
        name: r'getEntriesByDateRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetEntriesByDateRangeProvider call(DateTime start, DateTime end) =>
      GetEntriesByDateRangeProvider._(argument: (start, end), from: this);

  @override
  String toString() => r'getEntriesByDateRangeProvider';
}

@ProviderFor(getEntriesByType)
const getEntriesByTypeProvider = GetEntriesByTypeFamily._();

final class GetEntriesByTypeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LedgerEntity>>,
          List<LedgerEntity>,
          FutureOr<List<LedgerEntity>>
        >
    with
        $FutureModifier<List<LedgerEntity>>,
        $FutureProvider<List<LedgerEntity>> {
  const GetEntriesByTypeProvider._({
    required GetEntriesByTypeFamily super.from,
    required PartyType super.argument,
  }) : super(
         retry: null,
         name: r'getEntriesByTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getEntriesByTypeHash();

  @override
  String toString() {
    return r'getEntriesByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LedgerEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LedgerEntity>> create(Ref ref) {
    final argument = this.argument as PartyType;
    return getEntriesByType(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetEntriesByTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getEntriesByTypeHash() => r'dfbffec4ef167ff63f416cf8aeec4c825e385820';

final class GetEntriesByTypeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LedgerEntity>>, PartyType> {
  const GetEntriesByTypeFamily._()
    : super(
        retry: null,
        name: r'getEntriesByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetEntriesByTypeProvider call(PartyType partyType) =>
      GetEntriesByTypeProvider._(argument: partyType, from: this);

  @override
  String toString() => r'getEntriesByTypeProvider';
}

@ProviderFor(getEntriesByParty)
const getEntriesByPartyProvider = GetEntriesByPartyFamily._();

final class GetEntriesByPartyProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LedgerEntity>>,
          List<LedgerEntity>,
          FutureOr<List<LedgerEntity>>
        >
    with
        $FutureModifier<List<LedgerEntity>>,
        $FutureProvider<List<LedgerEntity>> {
  const GetEntriesByPartyProvider._({
    required GetEntriesByPartyFamily super.from,
    required ({PartyType partyType, int partyId}) super.argument,
  }) : super(
         retry: null,
         name: r'getEntriesByPartyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getEntriesByPartyHash();

  @override
  String toString() {
    return r'getEntriesByPartyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<LedgerEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LedgerEntity>> create(Ref ref) {
    final argument = this.argument as ({PartyType partyType, int partyId});
    return getEntriesByParty(
      ref,
      partyType: argument.partyType,
      partyId: argument.partyId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetEntriesByPartyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getEntriesByPartyHash() => r'95815eea4348f1e5034eca97e36d87a35208525f';

final class GetEntriesByPartyFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LedgerEntity>>,
          ({PartyType partyType, int partyId})
        > {
  const GetEntriesByPartyFamily._()
    : super(
        retry: null,
        name: r'getEntriesByPartyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetEntriesByPartyProvider call({
    required PartyType partyType,
    required int partyId,
  }) => GetEntriesByPartyProvider._(
    argument: (partyType: partyType, partyId: partyId),
    from: this,
  );

  @override
  String toString() => r'getEntriesByPartyProvider';
}

@ProviderFor(getBalance)
const getBalanceProvider = GetBalanceFamily._();

final class GetBalanceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  const GetBalanceProvider._({
    required GetBalanceFamily super.from,
    required ({PartyType partyType, int partyId}) super.argument,
  }) : super(
         retry: null,
         name: r'getBalanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getBalanceHash();

  @override
  String toString() {
    return r'getBalanceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as ({PartyType partyType, int partyId});
    return getBalance(
      ref,
      partyType: argument.partyType,
      partyId: argument.partyId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetBalanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getBalanceHash() => r'79da68c32ea4a6207168c43f389b16326e248039';

final class GetBalanceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<double>,
          ({PartyType partyType, int partyId})
        > {
  const GetBalanceFamily._()
    : super(
        retry: null,
        name: r'getBalanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetBalanceProvider call({
    required PartyType partyType,
    required int partyId,
  }) => GetBalanceProvider._(
    argument: (partyType: partyType, partyId: partyId),
    from: this,
  );

  @override
  String toString() => r'getBalanceProvider';
}
