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
      email: json['email'] as String?,
      joiningDate: DateTime.parse(json['joining_date'] as String),
      isActive: json['is_active'] as bool,
      role: json['role'] as String?,
      roleId: (json['role_id'] as num?)?.toInt(),
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EmployeeEntityToJson(_EmployeeEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'cnic': instance.cnic,
      'email': instance.email,
      'joining_date': instance.joiningDate.toIso8601String(),
      'is_active': instance.isActive,
      'role': instance.role,
      'role_id': instance.roleId,
      'user_id': instance.userId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
