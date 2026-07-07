// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_head.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseHead _$ExpenseHeadFromJson(Map<String, dynamic> json) => _ExpenseHead(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  headType: $enumDecode(_$HeadTypeEnumMap, json['head_type']),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ExpenseHeadToJson(_ExpenseHead instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'head_type': _$HeadTypeEnumMap[instance.headType]!,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$HeadTypeEnumMap = {
  HeadType.developmental: 'developmental',
  HeadType.nondevelopmental: 'nondevelopmental',
  HeadType.domestic: 'domestic',
};
