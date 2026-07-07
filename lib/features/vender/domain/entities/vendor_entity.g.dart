// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorEntity _$VendorEntityFromJson(Map<String, dynamic> json) =>
    _VendorEntity(
      id: (json['id'] as num).toInt(),
      vendorName: json['vendor_name'] as String,
      vendorAddress: json['vendor_address'] as String,
      vendorNotes: json['vendor_notes'] as String,
      companyName: json['company_name'] as String,
      contactNumber: json['contact_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$VendorEntityToJson(_VendorEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_name': instance.vendorName,
      'vendor_address': instance.vendorAddress,
      'vendor_notes': instance.vendorNotes,
      'company_name': instance.companyName,
      'contact_number': instance.contactNumber,
      'created_at': instance.createdAt.toIso8601String(),
      'is_active': instance.isActive,
    };
