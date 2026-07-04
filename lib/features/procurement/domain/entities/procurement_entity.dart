import 'package:freezed_annotation/freezed_annotation.dart';
import 'procurement_item_entity.dart';

part 'procurement_entity.freezed.dart';
part 'procurement_entity.g.dart';

@freezed
abstract class ProcurementEntity with _$ProcurementEntity {
  const factory ProcurementEntity({
    int? id,
    required int vendorId,
    required String procurementDate,
    required double total,
    String? notes,
    required List<ProcurementItemEntity> items,
  }) = _ProcurementEntity;

  factory ProcurementEntity.fromJson(Map<String, dynamic> json) =>
      _$ProcurementEntityFromJson(json);
}
