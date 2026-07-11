import 'package:freezed_annotation/freezed_annotation.dart';
import 'procurement_item_entity.dart';

part 'procurement_entity.freezed.dart';
part 'procurement_entity.g.dart';

double _readDouble(Map map, String key) {
  final val = map[key];
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

@freezed
abstract class ProcurementEntity with _$ProcurementEntity {
  const factory ProcurementEntity({
    int? id,
    @JsonKey(name: 'vendor_id') required int vendorId,
    @JsonKey(name: 'procurement_date') required String procurementDate,
    @JsonKey(readValue: _readDouble) required double total,
    String? notes,
    required List<ProcurementItemEntity> items,
  }) = _ProcurementEntity;

  factory ProcurementEntity.fromJson(Map<String, dynamic> json) =>
      _$ProcurementEntityFromJson(json);
}

