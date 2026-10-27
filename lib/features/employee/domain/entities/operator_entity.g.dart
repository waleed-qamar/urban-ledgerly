// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OperatorEntity _$OperatorEntityFromJson(Map<String, dynamic> json) =>
    _OperatorEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      cnic: json['cnic'] as String?,
      joiningDate: DateTime.parse(json['joining_date'] as String),
      defaultPerDay: (json['default_per_day'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$OperatorEntityToJson(_OperatorEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'cnic': instance.cnic,
      'joining_date': instance.joiningDate.toIso8601String(),
      'default_per_day': instance.defaultPerDay,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
    };
