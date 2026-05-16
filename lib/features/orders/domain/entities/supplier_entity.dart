import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_entity.freezed.dart';
part 'supplier_entity.g.dart';

@freezed
abstract class SupplierEntity with _$SupplierEntity {
  const factory SupplierEntity({
    int? id,
    required String name,
    required String address,
    String? strnNo,
    String? ntn,
    String? contactInfo,
  }) = _SupplierEntity;

  factory SupplierEntity.fromJson(Map<String, dynamic> json) =>
      _$SupplierEntityFromJson(json);
}
