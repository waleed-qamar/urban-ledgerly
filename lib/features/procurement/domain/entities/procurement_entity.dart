import 'package:freezed_annotation/freezed_annotation.dart';

part 'procurement_entity.freezed.dart';
part 'procurement_entity.g.dart';

@freezed
abstract class ProcurementEntity with _$ProcurementEntity {
  const factory ProcurementEntity({
    int? id,
    required int rawMaterialId,
    required int vendorId,
    required String procurementDate,
    required int quantity,
    required double price,
    required double total,
    String? notes,
  }) = _ProcurementEntity;

  factory ProcurementEntity.fromJson(Map<String, dynamic> json) =>
      _$ProcurementEntityFromJson(json);
}
