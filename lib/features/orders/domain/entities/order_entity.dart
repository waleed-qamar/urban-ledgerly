import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_item_entity.dart';

part 'order_entity.freezed.dart';
part 'order_entity.g.dart';

@freezed
abstract class OrderEntity with _$OrderEntity {
  const factory OrderEntity({
    int? id,
    required int customerId,
    required List<OrderItemEntity> items,
    String? status,
    DateTime? createdAt,
  }) = _OrderEntity;

  factory OrderEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderEntityFromJson(json);
}
