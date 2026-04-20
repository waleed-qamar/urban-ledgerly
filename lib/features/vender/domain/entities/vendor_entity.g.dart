// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorEntity _$VendorEntityFromJson(Map<String, dynamic> json) =>
    _VendorEntity(
      id: (json['id'] as num).toInt(),
      vendorName: json['vendorName'] as String,
      vendorAddress: json['vendorAddress'] as String,
      vendorNotes: json['vendorNotes'] as String,
      companyName: json['companyName'] as String,
      contactNumber: json['contactNumber'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$VendorEntityToJson(_VendorEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorName': instance.vendorName,
      'vendorAddress': instance.vendorAddress,
      'vendorNotes': instance.vendorNotes,
      'companyName': instance.companyName,
      'contactNumber': instance.contactNumber,
      'createdAt': instance.createdAt.toIso8601String(),
      'is_active': instance.isActive,
    };
