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
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OperatorEntityToJson(_OperatorEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'cnic': instance.cnic,
      'joiningDate': instance.joiningDate.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
