import 'package:freezed_annotation/freezed_annotation.dart';

part 'procurement_item_entity.freezed.dart';
part 'procurement_item_entity.g.dart';

@freezed
abstract class ProcurementItemEntity with _$ProcurementItemEntity {
  const factory ProcurementItemEntity({
    int? id,
    int? procurementId,
    required int rawMaterialId,
    required int quantity,
    required double price,
    required double total,
  }) = _ProcurementItemEntity;

  factory ProcurementItemEntity.fromJson(Map<String, dynamic> json) =>
      _$ProcurementItemEntityFromJson(json);
}
