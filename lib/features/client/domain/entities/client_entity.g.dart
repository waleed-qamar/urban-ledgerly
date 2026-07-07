// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientEntity _$ClientEntityFromJson(Map<String, dynamic> json) =>
    _ClientEntity(
      id: (json['id'] as num).toInt(),
      clientName: json['client_name'] as String,
      contactNumber: json['contact_number'] as String,
      clientAddress: json['client_address'] as String,
      department: json['department'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ClientEntityToJson(_ClientEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_name': instance.clientName,
      'contact_number': instance.contactNumber,
      'client_address': instance.clientAddress,
      'department': instance.department,
      'created_at': instance.createdAt.toIso8601String(),
      'is_active': instance.isActive,
    };
