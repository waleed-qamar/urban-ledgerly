// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dps_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Machine _$MachineFromJson(Map<String, dynamic> json) => _Machine(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MachineToJson(_Machine instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
};

_DpsReport _$DpsReportFromJson(Map<String, dynamic> json) => _DpsReport(
  id: (json['id'] as num?)?.toInt(),
  reportDate: DateTime.parse(json['report_date'] as String),
  status: json['status'] as String? ?? 'draft',
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$DpsReportToJson(_DpsReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'report_date': instance.reportDate.toIso8601String(),
      'status': instance.status,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_DpsProductionLog _$DpsProductionLogFromJson(Map<String, dynamic> json) =>
    _DpsProductionLog(
      id: (json['id'] as num?)?.toInt(),
      reportId: (json['report_id'] as num?)?.toInt(),
      machineId: (json['machine_id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      unitWeight: (json['unit_weight'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DpsProductionLogToJson(_DpsProductionLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'report_id': instance.reportId,
      'machine_id': instance.machineId,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'unit_weight': instance.unitWeight,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_DpsConsumptionLog _$DpsConsumptionLogFromJson(Map<String, dynamic> json) =>
    _DpsConsumptionLog(
      id: (json['id'] as num?)?.toInt(),
      reportId: (json['report_id'] as num?)?.toInt(),
      rawMaterialId: (json['raw_material_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DpsConsumptionLogToJson(_DpsConsumptionLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'report_id': instance.reportId,
      'raw_material_id': instance.rawMaterialId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_DpsDamageLog _$DpsDamageLogFromJson(Map<String, dynamic> json) =>
    _DpsDamageLog(
      id: (json['id'] as num?)?.toInt(),
      reportId: (json['report_id'] as num?)?.toInt(),
      machineId: (json['machine_id'] as num).toInt(),
      itemType: json['item_type'] as String,
      itemId: (json['item_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      unitWeight: (json['unit_weight'] as num?)?.toDouble(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DpsDamageLogToJson(_DpsDamageLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'report_id': instance.reportId,
      'machine_id': instance.machineId,
      'item_type': instance.itemType,
      'item_id': instance.itemId,
      'quantity': instance.quantity,
      'unit_weight': instance.unitWeight,
      'unit_price': instance.unitPrice,
      'reason': instance.reason,
      'created_at': instance.createdAt?.toIso8601String(),
    };
