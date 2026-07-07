// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogEntity _$AuditLogEntityFromJson(Map<String, dynamic> json) =>
    _AuditLogEntity(
      id: (json['id'] as num).toInt(),
      tableName: json['table_name'] as String,
      recordId: json['record_id'] as String,
      action: json['action'] as String,
      oldData: json['old_data'] as Map<String, dynamic>?,
      newData: json['new_data'] as Map<String, dynamic>?,
      changedFields: json['changed_fields'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      changedBy: json['changed_by'] as String?,
      changedByName: json['changed_by_name'] as String?,
      changedAt: DateTime.parse(json['changed_at'] as String),
    );

Map<String, dynamic> _$AuditLogEntityToJson(_AuditLogEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'table_name': instance.tableName,
      'record_id': instance.recordId,
      'action': instance.action,
      'old_data': instance.oldData,
      'new_data': instance.newData,
      'changed_fields': instance.changedFields,
      'description': instance.description,
      'changed_by': instance.changedBy,
      'changed_by_name': instance.changedByName,
      'changed_at': instance.changedAt.toIso8601String(),
    };
