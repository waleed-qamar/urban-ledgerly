import 'package:freezed_annotation/freezed_annotation.dart';

part 'procurement_item_entity.freezed.dart';
part 'procurement_item_entity.g.dart';

double _readDouble(Map map, String key) {
  final val = map[key];
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

@freezed
abstract class ProcurementItemEntity with _$ProcurementItemEntity {
  const factory ProcurementItemEntity({
    int? id,
    @JsonKey(name: 'procurement_id') int? procurementId,
    @JsonKey(name: 'raw_material_id') required int rawMaterialId,
    required int quantity,
    @JsonKey(readValue: _readDouble) required double price,
    @JsonKey(readValue: _readDouble) required double total,
  }) = _ProcurementItemEntity;

  factory ProcurementItemEntity.fromJson(Map<String, dynamic> json) =>
      _$ProcurementItemEntityFromJson(json);
}

