import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_item_entity.freezed.dart';
part 'invoice_item_entity.g.dart';

@freezed
abstract class InvoiceItemEntity with _$InvoiceItemEntity {
  const factory InvoiceItemEntity({
    int? id,
    int? invoiceId,
    int? orderItemId,
    int? productId,
    int? setId,
    @Default(false) bool isSet,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    String? description,
    @Default('Each') String unitType,
  }) = _InvoiceItemEntity;

  factory InvoiceItemEntity.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemEntityFromJson(json);
}
