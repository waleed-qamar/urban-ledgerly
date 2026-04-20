import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/app_providers.dart';

import '../../data/datasources/expense_remote_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_head.dart';
import '../../domain/repositories/expense_repository.dart';

part 'expense_providers.g.dart';

@riverpod
class SelectedLedgerHead extends _$SelectedLedgerHead {
  @override
  int? build() => null; // null means all heads

  void setHead(int? headId) => state = headId;
}

@riverpod
class LedgerDateRange extends _$LedgerDateRange {
  @override
  DateTimeRange? build() => null;

  void setRange(DateTimeRange? range) => state = range;
}

@riverpod
class ExpenseHeads extends _$ExpenseHeads {
  @override
  FutureOr<List<ExpenseHead>> build() async {
    return ref.watch(expenseRepositoryProvider).getExpenseHeads();
  }

  Future<void> add(ExpenseHead head) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.watch(expenseRepositoryProvider).addExpenseHead(head);
      return ref.watch(expenseRepositoryProvider).getExpenseHeads();
    });
  }
}

@riverpod
ExpenseRemoteDatasource expenseRemoteDatasource(Ref ref) {
  return ExpenseRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepositoryImpl(ref.watch(expenseRemoteDatasourceProvider));
}

@riverpod
Future<List<Expense>> recentExpenses(Ref ref) async {
  final allExpenses = await ref
      .watch(expenseRepositoryProvider)
      .getAllExpenses();
  final cutofTime = DateTime.now().subtract(const Duration(hours: 36));

  final recent = allExpenses
      .where((expense) => expense.date.isAfter(cutofTime))
      .toList();

  recent.sort((a, b) => b.date.compareTo(a.date));

  return recent;
}

@riverpod
Future<Map<String, dynamic>> monthlyInsights(Ref ref) async {
  final allExpenses = await ref
      .watch(expenseRepositoryProvider)
      .getAllExpenses();

  final now = DateTime.now();
  double currentMonthTotal = 0;
  double lastMonthTotal = 0;

  for (var exp in allExpenses) {
    if (exp.date.year == now.year && exp.date.month == now.month) {
      currentMonthTotal += exp.amount;
    } else if (exp.date.year == now.year && exp.date.month == now.month - 1) {
      lastMonthTotal += exp.amount;
    }
  }

  double percentageChange = 0;
  if (lastMonthTotal > 0) {
    percentageChange =
        ((currentMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
  }

  return {'total': currentMonthTotal, 'change': percentageChange};
}

@riverpod
Future<List<Expense>> expensesByHead(Ref ref, int headId) {
  return ref.watch(expenseRepositoryProvider).getExpensesByHead(headId);
}

@riverpod
Future<List<Expense>> filteredLedger(Ref ref) async {
  final range = ref.watch(ledgerDateRangeProvider);
  final headId = ref.watch(selectedLedgerHeadProvider);

  return ref
      .watch(expenseRepositoryProvider)
      .getFilteredExpenses(headId: headId, from: range?.start, to: range?.end);
}
