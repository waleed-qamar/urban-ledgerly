import 'package:freezed_annotation/freezed_annotation.dart';

part 'dps_models.freezed.dart';
part 'dps_models.g.dart';

@freezed
abstract class Machine with _$Machine {
  const factory Machine({
    required int id,
    required String name,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Machine;

  factory Machine.fromJson(Map<String, dynamic> json) => _$MachineFromJson(json);
}

@freezed
abstract class DpsReport with _$DpsReport {
  const factory DpsReport({
    int? id,
    @JsonKey(name: 'report_date') required DateTime reportDate,
    @Default('draft') String status,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DpsReport;

  factory DpsReport.fromJson(Map<String, dynamic> json) => _$DpsReportFromJson(json);
}

@freezed
abstract class DpsEnergyLog with _$DpsEnergyLog {
  const factory DpsEnergyLog({
    int? id,
    @JsonKey(name: 'report_id') int? reportId,
    @JsonKey(name: 'machine_id') required int machineId,
    @JsonKey(name: 'operator_name') String? operatorName,
    @JsonKey(name: 'gas_weight') @Default(0.0) double gasWeight,
    @JsonKey(name: 'wood_weight') @Default(0.0) double woodWeight,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DpsEnergyLog;

  factory DpsEnergyLog.fromJson(Map<String, dynamic> json) => _$DpsEnergyLogFromJson(json);
}

@freezed
abstract class DpsProductionLog with _$DpsProductionLog {
  const factory DpsProductionLog({
    int? id,
    @JsonKey(name: 'report_id') int? reportId,
    @JsonKey(name: 'machine_id') required int machineId,
    @JsonKey(name: 'product_id') required int productId,
    required double quantity,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DpsProductionLog;

  factory DpsProductionLog.fromJson(Map<String, dynamic> json) => _$DpsProductionLogFromJson(json);
}

@freezed
abstract class DpsConsumptionLog with _$DpsConsumptionLog {
  const factory DpsConsumptionLog({
    int? id,
    @JsonKey(name: 'report_id') int? reportId,
    @JsonKey(name: 'machine_id') required int machineId,
    @JsonKey(name: 'raw_material_id') required int rawMaterialId,
    required double quantity,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DpsConsumptionLog;

  factory DpsConsumptionLog.fromJson(Map<String, dynamic> json) => _$DpsConsumptionLogFromJson(json);
}

@freezed
abstract class DpsDamageLog with _$DpsDamageLog {
  const factory DpsDamageLog({
    int? id,
    @JsonKey(name: 'report_id') int? reportId,
    @JsonKey(name: 'machine_id') required int machineId,
    @JsonKey(name: 'item_type') required String itemType, // 'product' or 'raw_material'
    @JsonKey(name: 'item_id') required int itemId,
    required double quantity,
    String? reason,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DpsDamageLog;

  factory DpsDamageLog.fromJson(Map<String, dynamic> json) => _$DpsDamageLogFromJson(json);
}
