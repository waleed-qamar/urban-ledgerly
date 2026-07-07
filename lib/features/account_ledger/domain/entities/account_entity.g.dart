// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountEntity _$AccountEntityFromJson(Map<String, dynamic> json) =>
    _AccountEntity(
      id: (json['id'] as num).toInt(),
      accountTitle: json['account_title'] as String,
      accountType: json['account_type'] as String,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      currency: json['currency'] as String? ?? 'PKR',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$AccountEntityToJson(_AccountEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_title': instance.accountTitle,
      'account_type': instance.accountType,
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
      'currency': instance.currency,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'currentBalance': instance.currentBalance,
    };
