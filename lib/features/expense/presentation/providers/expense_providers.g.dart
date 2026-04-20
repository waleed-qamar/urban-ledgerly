// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedLedgerHead)
const selectedLedgerHeadProvider = SelectedLedgerHeadProvider._();

final class SelectedLedgerHeadProvider
    extends $NotifierProvider<SelectedLedgerHead, int?> {
  const SelectedLedgerHeadProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLedgerHeadProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLedgerHeadHash();

  @$internal
  @override
  SelectedLedgerHead create() => SelectedLedgerHead();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedLedgerHeadHash() =>
    r'00ecd9e6cbd361a0e65ef3bc561f92c023bc04dc';

abstract class _$SelectedLedgerHead extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LedgerDateRange)
const ledgerDateRangeProvider = LedgerDateRangeProvider._();

final class LedgerDateRangeProvider
    extends $NotifierProvider<LedgerDateRange, DateTimeRange<DateTime>?> {
  const LedgerDateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerDateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerDateRangeHash();

  @$internal
  @override
  LedgerDateRange create() => LedgerDateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>?>(value),
    );
  }
}

String _$ledgerDateRangeHash() => r'14915347dabca274e869cd19d0e28dba09cc01c4';

abstract class _$LedgerDateRange extends $Notifier<DateTimeRange<DateTime>?> {
  DateTimeRange<DateTime>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<DateTimeRange<DateTime>?, DateTimeRange<DateTime>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTimeRange<DateTime>?, DateTimeRange<DateTime>?>,
              DateTimeRange<DateTime>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ExpenseHeads)
const expenseHeadsProvider = ExpenseHeadsProvider._();

final class ExpenseHeadsProvider
    extends $AsyncNotifierProvider<ExpenseHeads, List<ExpenseHead>> {
  const ExpenseHeadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseHeadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseHeadsHash();

  @$internal
  @override
  ExpenseHeads create() => ExpenseHeads();
}

String _$expenseHeadsHash() => r'3072e559dc33aa2bfdab13e231351d83f4659c18';

abstract class _$ExpenseHeads extends $AsyncNotifier<List<ExpenseHead>> {
  FutureOr<List<ExpenseHead>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<ExpenseHead>>, List<ExpenseHead>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExpenseHead>>, List<ExpenseHead>>,
              AsyncValue<List<ExpenseHead>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(expenseRemoteDatasource)
const expenseRemoteDatasourceProvider = ExpenseRemoteDatasourceProvider._();

final class ExpenseRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          ExpenseRemoteDatasource,
          ExpenseRemoteDatasource,
          ExpenseRemoteDatasource
        >
    with $Provider<ExpenseRemoteDatasource> {
  const ExpenseRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ExpenseRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseRemoteDatasource create(Ref ref) {
    return expenseRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRemoteDatasource>(value),
    );
  }
}

String _$expenseRemoteDatasourceHash() =>
    r'662770ffde619b3f13b12984ca9ef79be92f1ca6';

@ProviderFor(expenseRepository)
const expenseRepositoryProvider = ExpenseRepositoryProvider._();

final class ExpenseRepositoryProvider
    extends
        $FunctionalProvider<
          ExpenseRepository,
          ExpenseRepository,
          ExpenseRepository
        >
    with $Provider<ExpenseRepository> {
  const ExpenseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpenseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseRepository create(Ref ref) {
    return expenseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRepository>(value),
    );
  }
}

String _$expenseRepositoryHash() => r'591a31d3386e8f36a6dabe36f9ee7bc2d186c590';

@ProviderFor(recentExpenses)
const recentExpensesProvider = RecentExpensesProvider._();

final class RecentExpensesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
  const RecentExpensesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentExpensesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentExpensesHash();

  @$internal
  @override
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
    return recentExpenses(ref);
  }
}

String _$recentExpensesHash() => r'08ace2a58f57da6c4e3e42942e5cfccf55f3b565';

@ProviderFor(monthlyInsights)
const monthlyInsightsProvider = MonthlyInsightsProvider._();

final class MonthlyInsightsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  const MonthlyInsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyInsightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyInsightsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return monthlyInsights(ref);
  }
}

String _$monthlyInsightsHash() => r'39a2bbeab916ddaee67285b986bbf3e2421ec0ed';

@ProviderFor(expensesByHead)
const expensesByHeadProvider = ExpensesByHeadFamily._();

final class ExpensesByHeadProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
  const ExpensesByHeadProvider._({
    required ExpensesByHeadFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'expensesByHeadProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expensesByHeadHash();

  @override
  String toString() {
    return r'expensesByHeadProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
    final argument = this.argument as int;
    return expensesByHead(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByHeadProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesByHeadHash() => r'9705b51e859f6e570f7a9760569779e42d9b5069';

final class ExpensesByHeadFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Expense>>, int> {
  const ExpensesByHeadFamily._()
    : super(
        retry: null,
        name: r'expensesByHeadProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExpensesByHeadProvider call(int headId) =>
      ExpensesByHeadProvider._(argument: headId, from: this);

  @override
  String toString() => r'expensesByHeadProvider';
}

@ProviderFor(filteredLedger)
const filteredLedgerProvider = FilteredLedgerProvider._();

final class FilteredLedgerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
  const FilteredLedgerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredLedgerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredLedgerHash();

  @$internal
  @override
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
    return filteredLedger(ref);
  }
}

String _$filteredLedgerHash() => r'7f32f5b37ea670f883a3af1145a5431df0c4982a';
