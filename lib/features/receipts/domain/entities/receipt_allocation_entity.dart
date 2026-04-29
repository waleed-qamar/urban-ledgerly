import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_allocation_entity.freezed.dart';
part 'receipt_allocation_entity.g.dart';

@freezed
abstract class ReceiptAllocationEntity with _$ReceiptAllocationEntity {
  const factory ReceiptAllocationEntity({
    int? id,
    int? receiptId,
    required int invoiceId,
    required double amount,
    DateTime? createdAt,
  }) = _ReceiptAllocationEntity;

  factory ReceiptAllocationEntity.fromJson(Map<String, dynamic> json) =>
      _$ReceiptAllocationEntityFromJson(json);
}
