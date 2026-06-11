import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_entity.freezed.dart';
part 'order_item_entity.g.dart';

@freezed
abstract class OrderItemEntity with _$OrderItemEntity {
  const factory OrderItemEntity({
    int? id,
    int? productId,
    int? setId,
    @Default(false) bool isSet,
    required int quantity,
    required double price,
    int? invoicedQuantity,
  }) = _OrderItemEntity;

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderItemEntityFromJson(json);
}
