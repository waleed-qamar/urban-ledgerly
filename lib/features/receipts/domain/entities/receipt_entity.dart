import 'package:freezed_annotation/freezed_annotation.dart';

import 'receipt_allocation_entity.dart';

part 'receipt_entity.freezed.dart';
part 'receipt_entity.g.dart';

@freezed
abstract class ReceiptEntity with _$ReceiptEntity {
  const factory ReceiptEntity({
    int? id,
    required int clientId,
    String? receiptNumber,
    required double totalAmount,
    required String paymentMethod,
    String? accountNo,
    int? accountId,
    String? remarks,
    required DateTime receivedDate,
    DateTime? createdAt,
    @Default([]) List<ReceiptAllocationEntity> allocations,
  }) = _ReceiptEntity;

  factory ReceiptEntity.fromJson(Map<String, dynamic> json) =>
      _$ReceiptEntityFromJson(json);
}
