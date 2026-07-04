// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcurementEntity _$ProcurementEntityFromJson(Map<String, dynamic> json) =>
    _ProcurementEntity(
      id: (json['id'] as num?)?.toInt(),
      vendorId: (json['vendorId'] as num).toInt(),
      procurementDate: json['procurementDate'] as String,
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => ProcurementItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProcurementEntityToJson(_ProcurementEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'procurementDate': instance.procurementDate,
      'total': instance.total,
      'notes': instance.notes,
      'items': instance.items,
    };
