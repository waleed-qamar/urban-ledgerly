// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wage_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WageRoleModel _$WageRoleModelFromJson(Map<String, dynamic> json) =>
    _WageRoleModel(
      id: (json['id'] as num).toInt(),
      workGroupId: (json['work_group_id'] as num).toInt(),
      roleName: json['role_name'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$WageRoleModelToJson(_WageRoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'work_group_id': instance.workGroupId,
      'role_name': instance.roleName,
      'is_active': instance.isActive,
    };
