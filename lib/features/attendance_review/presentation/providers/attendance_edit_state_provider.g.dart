// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_edit_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AttendanceEditDrafts)
const attendanceEditDraftsProvider = AttendanceEditDraftsFamily._();

final class AttendanceEditDraftsProvider
    extends
        $NotifierProvider<
          AttendanceEditDrafts,
          Map<DateTime, AttendanceAdjustmentDraft>
        > {
  const AttendanceEditDraftsProvider._({
    required AttendanceEditDraftsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'attendanceEditDraftsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$attendanceEditDraftsHash();

  @override
  String toString() {
    return r'attendanceEditDraftsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AttendanceEditDrafts create() => AttendanceEditDrafts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<DateTime, AttendanceAdjustmentDraft> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<DateTime, AttendanceAdjustmentDraft>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceEditDraftsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attendanceEditDraftsHash() =>
    r'8bce7eff0f9595bdd2f39b2e6a275436c798cc32';

final class AttendanceEditDraftsFamily extends $Family
    with
        $ClassFamilyOverride<
          AttendanceEditDrafts,
          Map<DateTime, AttendanceAdjustmentDraft>,
          Map<DateTime, AttendanceAdjustmentDraft>,
          Map<DateTime, AttendanceAdjustmentDraft>,
          int
        > {
  const AttendanceEditDraftsFamily._()
    : super(
        retry: null,
        name: r'attendanceEditDraftsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AttendanceEditDraftsProvider call(int operatorId) =>
      AttendanceEditDraftsProvider._(argument: operatorId, from: this);

  @override
  String toString() => r'attendanceEditDraftsProvider';
}

abstract class _$AttendanceEditDrafts
    extends $Notifier<Map<DateTime, AttendanceAdjustmentDraft>> {
  late final _$args = ref.$arg as int;
  int get operatorId => _$args;

  Map<DateTime, AttendanceAdjustmentDraft> build(int operatorId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              Map<DateTime, AttendanceAdjustmentDraft>,
              Map<DateTime, AttendanceAdjustmentDraft>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<DateTime, AttendanceAdjustmentDraft>,
                Map<DateTime, AttendanceAdjustmentDraft>
              >,
              Map<DateTime, AttendanceAdjustmentDraft>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(isOtRoleCellEnabled)
const isOtRoleCellEnabledProvider = IsOtRoleCellEnabledFamily._();

final class IsOtRoleCellEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsOtRoleCellEnabledProvider._({
    required IsOtRoleCellEnabledFamily super.from,
    required ({int operatorId, DateTime date, int loadedOtMinutes})
    super.argument,
  }) : super(
         retry: null,
         name: r'isOtRoleCellEnabledProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isOtRoleCellEnabledHash();

  @override
  String toString() {
    return r'isOtRoleCellEnabledProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument =
        this.argument as ({int operatorId, DateTime date, int loadedOtMinutes});
    return isOtRoleCellEnabled(
      ref,
      operatorId: argument.operatorId,
      date: argument.date,
      loadedOtMinutes: argument.loadedOtMinutes,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsOtRoleCellEnabledProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isOtRoleCellEnabledHash() =>
    r'4a987a53dbc78f9a9bbb51e99d8e086b5a665951';

final class IsOtRoleCellEnabledFamily extends $Family
    with
        $FunctionalFamilyOverride<
          bool,
          ({int operatorId, DateTime date, int loadedOtMinutes})
        > {
  const IsOtRoleCellEnabledFamily._()
    : super(
        retry: null,
        name: r'isOtRoleCellEnabledProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsOtRoleCellEnabledProvider call({
    required int operatorId,
    required DateTime date,
    required int loadedOtMinutes,
  }) => IsOtRoleCellEnabledProvider._(
    argument: (
      operatorId: operatorId,
      date: date,
      loadedOtMinutes: loadedOtMinutes,
    ),
    from: this,
  );

  @override
  String toString() => r'isOtRoleCellEnabledProvider';
}

@ProviderFor(SaveAttendanceAdjustments)
const saveAttendanceAdjustmentsProvider = SaveAttendanceAdjustmentsProvider._();

final class SaveAttendanceAdjustmentsProvider
    extends $AsyncNotifierProvider<SaveAttendanceAdjustments, void> {
  const SaveAttendanceAdjustmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveAttendanceAdjustmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveAttendanceAdjustmentsHash();

  @$internal
  @override
  SaveAttendanceAdjustments create() => SaveAttendanceAdjustments();
}

String _$saveAttendanceAdjustmentsHash() =>
    r'abb62e36b792e8d4fa68fc283c81f0efe08549bf';

abstract class _$SaveAttendanceAdjustments extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
