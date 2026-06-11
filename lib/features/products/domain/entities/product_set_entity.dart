import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_item_entity.dart';

part 'product_set_entity.freezed.dart';
part 'product_set_entity.g.dart';

@freezed
abstract class ProductSetEntity with _$ProductSetEntity {
  const factory ProductSetEntity({
    int? setId,
    required String name,
    String? description,
    required List<ProductSetItemEntity> products,
    DateTime? createdAt,
  }) = _ProductSetEntity;

  factory ProductSetEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductSetEntityFromJson(json);
}
