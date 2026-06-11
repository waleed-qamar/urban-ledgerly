import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_set_item_entity.freezed.dart';
part 'product_set_item_entity.g.dart';

@freezed
abstract class ProductSetItemEntity with _$ProductSetItemEntity {
  const factory ProductSetItemEntity({
    int? setid,
    required int productId,
    DateTime? createdAt,
  }) = _ProductSetItemEntity;

  factory ProductSetItemEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductSetItemEntityFromJson(json);
}
