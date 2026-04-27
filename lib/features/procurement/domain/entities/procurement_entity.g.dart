// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcurementEntity _$ProcurementEntityFromJson(Map<String, dynamic> json) =>
    _ProcurementEntity(
      id: (json['id'] as num?)?.toInt(),
      rawMaterialId: (json['rawMaterialId'] as num).toInt(),
      vendorId: (json['vendorId'] as num).toInt(),
      procurementDate: json['procurementDate'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ProcurementEntityToJson(_ProcurementEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rawMaterialId': instance.rawMaterialId,
      'vendorId': instance.vendorId,
      'procurementDate': instance.procurementDate,
      'quantity': instance.quantity,
      'price': instance.price,
      'total': instance.total,
      'notes': instance.notes,
    };
