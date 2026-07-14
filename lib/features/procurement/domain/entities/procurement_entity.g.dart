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
      brokerId: (json['broker_id'] as num?)?.toInt(),
      brokeragePrice:
          (_readDouble(json, 'brokerage_price') as num?)?.toDouble() ?? 0.0,
      loadingCharges:
          (_readDouble(json, 'loading_charges') as num?)?.toDouble() ?? 0.0,
      unloadingCharges:
          (_readDouble(json, 'unloading_charges') as num?)?.toDouble() ?? 0.0,
      itemsTotal: (_readDouble(json, 'items_total') as num?)?.toDouble() ?? 0.0,
      total: (_readDouble(json, 'grand_total') as num).toDouble(),
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
      'broker_id': instance.brokerId,
      'brokerage_price': instance.brokeragePrice,
      'loading_charges': instance.loadingCharges,
      'unloading_charges': instance.unloadingCharges,
      'items_total': instance.itemsTotal,
      'grand_total': instance.total,
      'notes': instance.notes,
      'items': instance.items,
    };
