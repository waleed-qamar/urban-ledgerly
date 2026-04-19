import 'package:ledgerly/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:ledgerly/features/expense/domain/entities/expense.dart';
import 'package:ledgerly/features/expense/domain/entities/expense_head.dart';

import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDatasource _datasource;

  ExpenseRepositoryImpl(this._datasource);

  @override
  Future<List<ExpenseHead>> getExpenseHeads() =>
      _datasource.fectchExpenseHead();

  @override
  Future<List<Expense>> getAllExpenses() => _datasource.fectchExpenses();

  @override
  Future<List<Expense>> getExpensesByHead(int headId) =>
      _datasource.fectchExpensesByHead(headId);

  @override
  Future<void> addExpenseHead(ExpenseHead expenseHead) =>
      _datasource.addExpenseHead(expenseHead);

  @override
  Future<void> updateExpenseHead(ExpenseHead expenseHead) =>
      _datasource.updateExpenseHead(expenseHead);

  @override
  Future<void> deleteExpenseHead(int headId) =>
      _datasource.deleteExpenseHead(headId);

  @override
  Future<void> addExpense(Expense expense) => _datasource.addExpense(expense);

  @override
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) =>
      _datasource.fetchExpensesByDateRange(start, end);

  @override
  Future<List<Expense>> getFilteredExpenses({
    int? headId,
    DateTime? from,
    DateTime? to,
  }) => _datasource.fetchFilteredExpenses(headId: headId, from: from, to: to);
}
