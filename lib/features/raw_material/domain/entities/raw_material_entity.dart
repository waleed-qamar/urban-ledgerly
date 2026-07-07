import 'package:freezed_annotation/freezed_annotation.dart';

part 'raw_material_entity.freezed.dart';
part 'raw_material_entity.g.dart';

/// Represents a row in the `raw_material` table.
///
/// [price] is the estimated/average cost per unit.
/// Actual purchase prices will be tracked in the future Procurement module.
@freezed
abstract class RawMaterialEntity with _$RawMaterialEntity {
  const factory RawMaterialEntity({
    required int id,
    required String name,
    required double price,
    String? description,
    @Default('kg') String unit,
    required DateTime createdAt,
  }) = _RawMaterialEntity;

  factory RawMaterialEntity.fromJson(Map<String, dynamic> json) =>
      _$RawMaterialEntityFromJson(json);
}
