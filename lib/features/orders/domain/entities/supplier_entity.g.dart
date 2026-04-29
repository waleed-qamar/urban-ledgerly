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
      strnNo: json['strnNo'] as String?,
      ntn: json['ntn'] as String?,
      deliveryTerms: json['deliveryTerms'] as String,
      contactInfo: json['contactInfo'] as String?,
    );

Map<String, dynamic> _$SupplierEntityToJson(_SupplierEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'strnNo': instance.strnNo,
      'ntn': instance.ntn,
      'deliveryTerms': instance.deliveryTerms,
      'contactInfo': instance.contactInfo,
    };
