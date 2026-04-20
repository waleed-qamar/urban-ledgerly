// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientEntity _$ClientEntityFromJson(Map<String, dynamic> json) =>
    _ClientEntity(
      id: (json['id'] as num).toInt(),
      clientName: json['clientName'] as String,
      contactNumber: json['contactNumber'] as String,
      clientAddress: json['clientAddress'] as String,
      department: json['department'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ClientEntityToJson(_ClientEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientName': instance.clientName,
      'contactNumber': instance.contactNumber,
      'clientAddress': instance.clientAddress,
      'department': instance.department,
      'createdAt': instance.createdAt.toIso8601String(),
      'is_active': instance.isActive,
    };
