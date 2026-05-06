// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeEntity _$EmployeeEntityFromJson(Map<String, dynamic> json) =>
    _EmployeeEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      cnic: json['cnic'] as String?,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      isActive: json['isActive'] as bool,
      role: json['role'] as String?,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$EmployeeEntityToJson(_EmployeeEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'cnic': instance.cnic,
      'joiningDate': instance.joiningDate.toIso8601String(),
      'isActive': instance.isActive,
      'role': instance.role,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
