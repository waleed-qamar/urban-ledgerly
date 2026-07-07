import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_set_item_entity.freezed.dart';
part 'product_set_item_entity.g.dart';

@freezed
abstract class ProductSetItemEntity with _$ProductSetItemEntity {
  const factory ProductSetItemEntity({
    @JsonKey(name: 'set_id') int? setid,
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ProductSetItemEntity;

  factory ProductSetItemEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductSetItemEntityFromJson(json);
}
