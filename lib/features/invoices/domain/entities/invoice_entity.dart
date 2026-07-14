import 'package:freezed_annotation/freezed_annotation.dart';
import 'invoice_item_entity.dart';

part 'invoice_entity.freezed.dart';
part 'invoice_entity.g.dart';

@freezed
abstract class InvoiceEntity with _$InvoiceEntity {
  const factory InvoiceEntity({
    int? id,
    int? orderId,
    int? clientId,
    int? supplierId,
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
    String? supplierName,
    String? supplierAddress,
    String? supplierStrn,
    String? supplierNtn,
    String? clientName,
    String? clientAddress,
    String? clientStrn,
    String? clientNtn,
    @Default(0.0) double advanceAmount,
    @Default(0.0) double balanceAmount,
    @Default('sales_tax') String invoiceType,
    @Default('style_1') String supplierStyle,
    DateTime? createdAt,
    @Default([]) List<InvoiceItemEntity> items,
  }) = _InvoiceEntity;

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) =>
      _$InvoiceEntityFromJson(json);
}
