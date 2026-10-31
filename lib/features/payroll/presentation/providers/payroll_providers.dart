import 'dart:async';
import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/payroll_remote_datasource.dart';
import '../../data/repositories/payroll_repository_impl.dart';
import '../../domain/entities/payroll_sheet_entity.dart';
import '../../domain/entities/payroll_row_entity.dart';
import '../../domain/payroll_calc.dart';
import '../../domain/repositories/payroll_repository.dart';
import 'package:ledgerly/features/employee/presentation/provider/operator_providers.dart';

part 'payroll_providers.g.dart';

enum RowSaveStatus { idle, saving, saved, error }

class PayrollSheetState {
  final PayrollSheetEntity? sheet;
  final List<PayrollRowEntity> rows;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, RowSaveStatus> rowStatuses;

  const PayrollSheetState({
    this.sheet,
    this.rows = const [],
    this.isLoading = false,
    this.errorMessage,
    this.rowStatuses = const {},
  });

  double get totalDays => rows.fold(0.0, (sum, r) => sum + r.days);
  double get totalHours => rows.fold(0.0, (sum, r) => sum + r.hours);
  double get totalSalary => rows.fold(0.0, (sum, r) => sum + r.salary);
  double get totalDayAmount => rows.fold(0.0, (sum, r) => sum + r.dayAmount);
  double get totalHourAmount => rows.fold(0.0, (sum, r) => sum + r.hourAmount);
  double get totalAdvance => rows.fold(0.0, (sum, r) => sum + r.advance);
  double get totalCurrent => rows.fold(0.0, (sum, r) => sum + r.currentAmt);
  double get totalDemand => rows.fold(0.0, (sum, r) => sum + r.demand);
  double get totalPayable => rows.fold(0.0, (sum, r) => sum + r.payable);
  double get totalOvertime => rows.fold(0.0, (sum, r) => sum + r.overtime);
  double get totalPaidAmount => rows.fold(0.0, (sum, r) => sum + r.paidAmount);
  double get grandTotal => rows.fold(0.0, (sum, r) => sum + r.total);
  double get balance => (sheet?.amountGiven ?? 0.0) - grandTotal;

  PayrollSheetState copyWith({
    PayrollSheetEntity? sheet,
    List<PayrollRowEntity>? rows,
    bool? isLoading,
    String? errorMessage,
    Map<String, RowSaveStatus>? rowStatuses,
  }) {
    return PayrollSheetState(
      sheet: sheet ?? this.sheet,
      rows: rows ?? this.rows,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      rowStatuses: rowStatuses ?? this.rowStatuses,
    );
  }
}

@riverpod
PayrollRemoteDatasource payrollRemoteDatasource(Ref ref) {
  return PayrollRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
PayrollRepository payrollRepository(Ref ref) {
  return PayrollRepositoryImpl(ref.watch(payrollRemoteDatasourceProvider));
}

@riverpod
Future<List<PayrollSheetEntity>> payrollSheets(Ref ref) {
  return ref.watch(payrollRepositoryProvider).getSheets();
}

@riverpod
class PayrollSheetDetail extends _$PayrollSheetDetail {
  final Map<String, Timer> _debounceTimers = {};

  @override
  PayrollSheetState build(String sheetId) {
    ref.onDispose(() {
      for (final timer in _debounceTimers.values) {
        timer.cancel();
      }
    });

    Future.microtask(() => loadSheet());
    return const PayrollSheetState(isLoading: true);
  }

  Future<void> loadSheet() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(payrollRepositoryProvider);
      final sheet = await repo.getSheetById(sheetId);
      var rows = await repo.getSheetRows(sheetId);

      // Auto-load Salary/Day from Operator table if row perDay is 0
      try {
        final operators = await ref.read(getAllOperatorsProvider.future);
        final opWageMap = {for (final o in operators) o.id: o.defaultPerDay};

        bool anyRowUpdated = false;
        final filledRows = rows.map((r) {
          if (r.perDay == 0.0 && opWageMap.containsKey(r.employeeId)) {
            final opWage = opWageMap[r.employeeId] ?? 0.0;
            if (opWage > 0.0) {
              anyRowUpdated = true;
              final mod = r.copyWith(perDay: opWage);
              return sheet.isOvertime
                  ? PayrollCalc.recomputeOvertime(mod)
                  : PayrollCalc.recompute(mod);
            }
          }
          return r;
        }).toList();

        if (anyRowUpdated) {
          rows = filledRows;
          for (final r in filledRows) {
            if (r.perDay > 0) {
              _scheduleRowSave(r.id, r);
            }
          }
        }
      } catch (_) {}

      state = state.copyWith(
        sheet: sheet,
        rows: rows,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update input cell values for a row with immediate optimistic calculation & debounced patch
  void updateRowInputs(
    String rowId, {
    double? days,
    double? hours,
    double? perDay,
    double? advance,
    double? demand,
    double? overtime,
  }) {
    if (state.sheet?.isFinalized ?? false) return;

    final index = state.rows.indexWhere((r) => r.id == rowId);
    if (index == -1) return;

    final currentRow = state.rows[index];
    final modifiedRow = currentRow.copyWith(
      days: days ?? currentRow.days,
      hours: hours ?? currentRow.hours,
      perDay: perDay ?? currentRow.perDay,
      advance: advance ?? currentRow.advance,
      demand: demand ?? currentRow.demand,
      overtime: overtime ?? currentRow.overtime,
    );

    // Instant local recomputation
    final recomputedRow = (state.sheet?.isOvertime ?? false)
        ? PayrollCalc.recomputeOvertime(modifiedRow)
        : PayrollCalc.recompute(modifiedRow);

    final updatedRows = List<PayrollRowEntity>.from(state.rows);
    updatedRows[index] = recomputedRow;

    final updatedStatuses = Map<String, RowSaveStatus>.from(state.rowStatuses);
    updatedStatuses[rowId] = RowSaveStatus.saving;

    state = state.copyWith(
      rows: updatedRows,
      rowStatuses: updatedStatuses,
    );

    // If perDay was updated, also update the operator default wage in the Operator table
    if (perDay != null && perDay > 0 && currentRow.employeeId > 0) {
      ref.read(operatorRepositoryProvider).updateOperatorWageRate(currentRow.employeeId, perDay);
    }

    _scheduleRowSave(rowId, recomputedRow);
  }

  /// Set or remove a manual override on a cell (e.g. key: 'payable', value: 25000)
  void setRowOverride(String rowId, String fieldKey, double? overrideValue) {
    if (state.sheet?.isFinalized ?? false) return;

    final index = state.rows.indexWhere((r) => r.id == rowId);
    if (index == -1) return;

    final currentRow = state.rows[index];
    final overrides = Map<String, dynamic>.from(currentRow.overrides);

    if (overrideValue == null) {
      overrides.remove(fieldKey);
    } else {
      overrides[fieldKey] = overrideValue;
    }

    final modifiedRow = currentRow.copyWith(overrides: overrides);
    final recomputedRow = (state.sheet?.isOvertime ?? false)
        ? PayrollCalc.recomputeOvertime(modifiedRow)
        : PayrollCalc.recompute(modifiedRow);

    final updatedRows = List<PayrollRowEntity>.from(state.rows);
    updatedRows[index] = recomputedRow;

    final updatedStatuses = Map<String, RowSaveStatus>.from(state.rowStatuses);
    updatedStatuses[rowId] = RowSaveStatus.saving;

    state = state.copyWith(
      rows: updatedRows,
      rowStatuses: updatedStatuses,
    );

    _scheduleRowSave(rowId, recomputedRow);
  }

  void _scheduleRowSave(String rowId, PayrollRowEntity rowToSave) {
    _debounceTimers[rowId]?.cancel();
    _debounceTimers[rowId] = Timer(const Duration(milliseconds: 400), () async {
      try {
        final serverRow = await ref.read(payrollRepositoryProvider).patchRow(rowToSave);

        final currentIndex = state.rows.indexWhere((r) => r.id == rowId);
        if (currentIndex != -1) {
          final updatedRows = List<PayrollRowEntity>.from(state.rows);
          updatedRows[currentIndex] = serverRow;

          final updatedStatuses = Map<String, RowSaveStatus>.from(state.rowStatuses);
          updatedStatuses[rowId] = RowSaveStatus.saved;

          state = state.copyWith(
            rows: updatedRows,
            rowStatuses: updatedStatuses,
          );

          // Clear 'saved' indicator after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            try {
              if (state.rowStatuses[rowId] == RowSaveStatus.saved) {
                final s = Map<String, RowSaveStatus>.from(state.rowStatuses);
                s[rowId] = RowSaveStatus.idle;
                state = state.copyWith(rowStatuses: s);
              }
            } catch (_) {}
          });
        }
      } catch (e) {
        final updatedStatuses = Map<String, RowSaveStatus>.from(state.rowStatuses);
        updatedStatuses[rowId] = RowSaveStatus.error;
        state = state.copyWith(rowStatuses: updatedStatuses);
      }
    });
  }

  Future<void> updateSheetMetadata({
    String? title,
    String? category,
    String? operatorName,
    double? amountGiven,
  }) async {
    if (state.sheet == null) return;
    final updated = state.sheet!.copyWith(
      title: title,
      category: category,
      operatorName: operatorName,
      amountGiven: amountGiven,
    );
    state = state.copyWith(sheet: updated);
    await ref.read(payrollRepositoryProvider).updateSheet(updated);
  }

  Future<void> finalize() async {
    await ref.read(payrollRepositoryProvider).finalizeSheet(sheetId);
    await loadSheet();
  }
}
