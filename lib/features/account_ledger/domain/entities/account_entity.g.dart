// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountEntity _$AccountEntityFromJson(Map<String, dynamic> json) =>
    _AccountEntity(
      id: (json['id'] as num).toInt(),
      accountTitle: json['accountTitle'] as String,
      accountType: json['accountType'] as String,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      currency: json['currency'] as String? ?? 'PKR',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$AccountEntityToJson(_AccountEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountTitle': instance.accountTitle,
      'accountType': instance.accountType,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'currency': instance.currency,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'currentBalance': instance.currentBalance,
    };
