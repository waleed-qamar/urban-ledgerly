import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  factory Expense({
    required int id,
    @JsonKey(name: 'expense_head_id') required int expenseHeadId,
    required double amount,
    String? remarks,
    required DateTime date,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
