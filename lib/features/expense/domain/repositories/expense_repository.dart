import 'package:ledgerly/features/expense/domain/entities/expense.dart';
import 'package:ledgerly/features/expense/domain/entities/expense_head.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseHead>> getExpenseHeads();
  Future<void> addExpenseHead(ExpenseHead expenseHead);
  Future<void> updateExpenseHead(ExpenseHead expenseHead);
  Future<void> deleteExpenseHead(int headId);

  Future<List<Expense>> getAllExpenses();
  Future<List<Expense>> getExpensesByHead(int headId);
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<void> addExpense(Expense expense);

  Future<List<Expense>> getFilteredExpenses({
    int? headId,
    DateTime? from,
    DateTime? to,
  });
}
