// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: (json['id'] as num).toInt(),
  expenseHeadId: (json['expenseHeadId'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  remarks: json['remarks'] as String,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'expenseHeadId': instance.expenseHeadId,
  'amount': instance.amount,
  'remarks': instance.remarks,
  'date': instance.date.toIso8601String(),
};
