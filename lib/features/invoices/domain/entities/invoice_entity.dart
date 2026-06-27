import 'package:freezed_annotation/freezed_annotation.dart';
import 'invoice_item_entity.dart';

part 'invoice_entity.freezed.dart';
part 'invoice_entity.g.dart';

@freezed
abstract class InvoiceEntity with _$InvoiceEntity {
  const factory InvoiceEntity({
    int? id,
    required int orderId,
    required int clientId,
    required int supplierId,
    required String invoiceNumber,
    required String status,
    String? po,
    required DateTime issueDate,
    required double subTotal,
    required double shippingCost,
    @Default(18.00) double taxPercent,
    required double taxAmount,
    required double grandTotal,
    required String representative,
    @Default(0) double paidAmount,
    @Default(0) double remainingAmount,
    required DateTime dispatchedAt,
    DateTime? createdAt,
    @Default([]) List<InvoiceItemEntity> items,
  }) = _InvoiceEntity;

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) =>
      _$InvoiceEntityFromJson(json);
}
