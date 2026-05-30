import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  factory Expense({
    required int id,
    required int expenseHeadId,
    required double amount,
    required String remarks,
    required DateTime date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
