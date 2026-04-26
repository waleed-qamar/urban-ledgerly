// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupplierEntity _$SupplierEntityFromJson(Map<String, dynamic> json) =>
    _SupplierEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      strnNo: json['strn_no'] as String?,
      ntn: json['ntn'] as String?,
      deliveryTerms: json['delivery_terms'] as String,
      contactInfo: json['contact_info'] as String?,
    );

Map<String, dynamic> _$SupplierEntityToJson(_SupplierEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'strn_no': instance.strnNo,
      'ntn': instance.ntn,
      'delivery_terms': instance.deliveryTerms,
      'contact_info': instance.contactInfo,
    };
