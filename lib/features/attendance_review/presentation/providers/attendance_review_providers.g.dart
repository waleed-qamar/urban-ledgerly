// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseClient)
const supabaseClientProvider = SupabaseClientProvider._();

final class SupabaseClientProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  const SupabaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseClientHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return supabaseClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$supabaseClientHash() => r'834a58d6ae4b94e36f4e04a10d8a7684b929310e';

@ProviderFor(attendanceReviewDatasource)
const attendanceReviewDatasourceProvider =
    AttendanceReviewDatasourceProvider._();

final class AttendanceReviewDatasourceProvider
    extends
        $FunctionalProvider<
          AttendanceReviewSupabaseDatasource,
          AttendanceReviewSupabaseDatasource,
          AttendanceReviewSupabaseDatasource
        >
    with $Provider<AttendanceReviewSupabaseDatasource> {
  const AttendanceReviewDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceReviewDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceReviewDatasourceHash();

  @$internal
  @override
  $ProviderElement<AttendanceReviewSupabaseDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceReviewSupabaseDatasource create(Ref ref) {
    return attendanceReviewDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceReviewSupabaseDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceReviewSupabaseDatasource>(
        value,
      ),
    );
  }
}

String _$attendanceReviewDatasourceHash() =>
    r'3b9e6db4b71bd0fd02007478caee2dc11a6b87c6';

@ProviderFor(attendanceReviewRepository)
const attendanceReviewRepositoryProvider =
    AttendanceReviewRepositoryProvider._();

final class AttendanceReviewRepositoryProvider
    extends
        $FunctionalProvider<
          AttendanceReviewRepository,
          AttendanceReviewRepository,
          AttendanceReviewRepository
        >
    with $Provider<AttendanceReviewRepository> {
  const AttendanceReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceReviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceReviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<AttendanceReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceReviewRepository create(Ref ref) {
    return attendanceReviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceReviewRepository>(value),
    );
  }
}

String _$attendanceReviewRepositoryHash() =>
    r'9899a742c0afe5a09b3f16b3ef71522efa55375a';

@ProviderFor(AttendanceReviewFilter)
const attendanceReviewFilterProvider = AttendanceReviewFilterProvider._();

final class AttendanceReviewFilterProvider
    extends
        $NotifierProvider<AttendanceReviewFilter, AttendanceReviewFilterState> {
  const AttendanceReviewFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceReviewFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceReviewFilterHash();

  @$internal
  @override
  AttendanceReviewFilter create() => AttendanceReviewFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceReviewFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceReviewFilterState>(value),
    );
  }
}

String _$attendanceReviewFilterHash() =>
    r'3bf5ac7ee8bc6e6372f512f96948bb2ca342857b';

abstract class _$AttendanceReviewFilter
    extends $Notifier<AttendanceReviewFilterState> {
  AttendanceReviewFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AttendanceReviewFilterState, AttendanceReviewFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AttendanceReviewFilterState,
                AttendanceReviewFilterState
              >,
              AttendanceReviewFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(attendanceDayRows)
const attendanceDayRowsProvider = AttendanceDayRowsFamily._();

final class AttendanceDayRowsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AttendanceDayRow>>,
          List<AttendanceDayRow>,
          FutureOr<List<AttendanceDayRow>>
        >
    with
        $FutureModifier<List<AttendanceDayRow>>,
        $FutureProvider<List<AttendanceDayRow>> {
  const AttendanceDayRowsProvider._({
    required AttendanceDayRowsFamily super.from,
    required ({int operatorId, DateTime from, DateTime to}) super.argument,
  }) : super(
         retry: null,
         name: r'attendanceDayRowsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$attendanceDayRowsHash();

  @override
  String toString() {
    return r'attendanceDayRowsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AttendanceDayRow>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AttendanceDayRow>> create(Ref ref) {
    final argument =
        this.argument as ({int operatorId, DateTime from, DateTime to});
    return attendanceDayRows(
      ref,
      operatorId: argument.operatorId,
      from: argument.from,
      to: argument.to,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceDayRowsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attendanceDayRowsHash() => r'a84c9b90cdc0148d860d65a7b050008236febcdd';

final class AttendanceDayRowsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AttendanceDayRow>>,
          ({int operatorId, DateTime from, DateTime to})
        > {
  const AttendanceDayRowsFamily._()
    : super(
        retry: null,
        name: r'attendanceDayRowsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AttendanceDayRowsProvider call({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  }) => AttendanceDayRowsProvider._(
    argument: (operatorId: operatorId, from: from, to: to),
    from: this,
  );

  @override
  String toString() => r'attendanceDayRowsProvider';
}

@ProviderFor(wageRolesForWorkGroup)
const wageRolesForWorkGroupProvider = WageRolesForWorkGroupFamily._();

final class WageRolesForWorkGroupProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WageRole>>,
          List<WageRole>,
          FutureOr<List<WageRole>>
        >
    with $FutureModifier<List<WageRole>>, $FutureProvider<List<WageRole>> {
  const WageRolesForWorkGroupProvider._({
    required WageRolesForWorkGroupFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'wageRolesForWorkGroupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wageRolesForWorkGroupHash();

  @override
  String toString() {
    return r'wageRolesForWorkGroupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WageRole>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WageRole>> create(Ref ref) {
    final argument = this.argument as int;
    return wageRolesForWorkGroup(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WageRolesForWorkGroupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wageRolesForWorkGroupHash() =>
    r'c676941baf127d630d9fbdf3128f664c18a89d76';

final class WageRolesForWorkGroupFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WageRole>>, int> {
  const WageRolesForWorkGroupFamily._()
    : super(
        retry: null,
        name: r'wageRolesForWorkGroupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WageRolesForWorkGroupProvider call(int workGroupId) =>
      WageRolesForWorkGroupProvider._(argument: workGroupId, from: this);

  @override
  String toString() => r'wageRolesForWorkGroupProvider';
}

@ProviderFor(hasWageRateForRole)
const hasWageRateForRoleProvider = HasWageRateForRoleFamily._();

final class HasWageRateForRoleProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const HasWageRateForRoleProvider._({
    required HasWageRateForRoleFamily super.from,
    required ({int operatorId, int wageRoleId, DateTime asOfDate})
    super.argument,
  }) : super(
         retry: null,
         name: r'hasWageRateForRoleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasWageRateForRoleHash();

  @override
  String toString() {
    return r'hasWageRateForRoleProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument =
        this.argument as ({int operatorId, int wageRoleId, DateTime asOfDate});
    return hasWageRateForRole(
      ref,
      operatorId: argument.operatorId,
      wageRoleId: argument.wageRoleId,
      asOfDate: argument.asOfDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HasWageRateForRoleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasWageRateForRoleHash() =>
    r'8cfcf365d19e7aef42a245966159d078816c2b46';

final class HasWageRateForRoleFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({int operatorId, int wageRoleId, DateTime asOfDate})
        > {
  const HasWageRateForRoleFamily._()
    : super(
        retry: null,
        name: r'hasWageRateForRoleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HasWageRateForRoleProvider call({
    required int operatorId,
    required int wageRoleId,
    required DateTime asOfDate,
  }) => HasWageRateForRoleProvider._(
    argument: (
      operatorId: operatorId,
      wageRoleId: wageRoleId,
      asOfDate: asOfDate,
    ),
    from: this,
  );

  @override
  String toString() => r'hasWageRateForRoleProvider';
}

@ProviderFor(payrollPeriodSummary)
const payrollPeriodSummaryProvider = PayrollPeriodSummaryFamily._();

final class PayrollPeriodSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<PayrollPeriodSummary>,
          PayrollPeriodSummary,
          FutureOr<PayrollPeriodSummary>
        >
    with
        $FutureModifier<PayrollPeriodSummary>,
        $FutureProvider<PayrollPeriodSummary> {
  const PayrollPeriodSummaryProvider._({
    required PayrollPeriodSummaryFamily super.from,
    required ({int operatorId, DateTime from, DateTime to}) super.argument,
  }) : super(
         retry: null,
         name: r'payrollPeriodSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$payrollPeriodSummaryHash();

  @override
  String toString() {
    return r'payrollPeriodSummaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PayrollPeriodSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PayrollPeriodSummary> create(Ref ref) {
    final argument =
        this.argument as ({int operatorId, DateTime from, DateTime to});
    return payrollPeriodSummary(
      ref,
      operatorId: argument.operatorId,
      from: argument.from,
      to: argument.to,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PayrollPeriodSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$payrollPeriodSummaryHash() =>
    r'd5d3c72b0b47ef42e3e7547aeaf463175c9a47db';

final class PayrollPeriodSummaryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PayrollPeriodSummary>,
          ({int operatorId, DateTime from, DateTime to})
        > {
  const PayrollPeriodSummaryFamily._()
    : super(
        retry: null,
        name: r'payrollPeriodSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PayrollPeriodSummaryProvider call({
    required int operatorId,
    required DateTime from,
    required DateTime to,
  }) => PayrollPeriodSummaryProvider._(
    argument: (operatorId: operatorId, from: from, to: to),
    from: this,
  );

  @override
  String toString() => r'payrollPeriodSummaryProvider';
}
