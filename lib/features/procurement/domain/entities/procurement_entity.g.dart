// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcurementEntity _$ProcurementEntityFromJson(Map<String, dynamic> json) =>
    _ProcurementEntity(
      id: (json['id'] as num?)?.toInt(),
      vendorId: (json['vendor_id'] as num).toInt(),
      procurementDate: json['procurement_date'] as String,
      total: (_readDouble(json, 'total') as num).toDouble(),
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => ProcurementItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProcurementEntityToJson(_ProcurementEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'procurement_date': instance.procurementDate,
      'total': instance.total,
      'notes': instance.notes,
      'items': instance.items,
    };
