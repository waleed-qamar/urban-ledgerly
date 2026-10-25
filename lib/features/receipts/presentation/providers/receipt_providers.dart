import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/receipt_remote_datasource.dart';
import '../../data/repositories/receipt_repository_impl.dart';
import '../../domain/entities/disbursement_record.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/repositories/receipt_repository.dart';

part 'receipt_providers.g.dart';

@riverpod
ReceiptRemoteDatasource receiptRemoteDatasource(Ref ref) {
  return ReceiptRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ReceiptRepository receiptRepository(Ref ref) {
  return ReceiptRepositoryImpl(ref.watch(receiptRemoteDatasourceProvider));
}

@riverpod
Future<List<ReceiptEntity>> getAllReceipts(Ref ref) {
  return ref.watch(receiptRepositoryProvider).getReceipts();
}

@riverpod
Future<ReceiptEntity> getReceiptById(Ref ref, int id) {
  return ref.watch(receiptRepositoryProvider).getReceiptById(id);
}

@riverpod
Future<ReceiptEntity> createReceipt(Ref ref, ReceiptEntity receipt) {
  return ref.watch(receiptRepositoryProvider).createReceipt(receipt);
}

@riverpod
Future<void> deleteReceipt(Ref ref, int id) {
  return ref.watch(receiptRepositoryProvider).deleteReceipt(id);
}

final getAllDisbursementsProvider = FutureProvider<List<DisbursementRecord>>(
  (ref) => ref.watch(receiptRepositoryProvider).getDisbursements(),
);

// ── Update providers ──────────────────────────────────────────────────────────

@riverpod
Future<void> updateReceipt(
  Ref ref, {
  required int id,
  int? clientId,
  int? accountId,
  required String paymentMethod,
  String? accountNo,
  String? remarks,
  required DateTime receivedDate,
  double? totalAmount,
}) {
  return ref.watch(receiptRepositoryProvider).updateReceipt(
    id: id,
    clientId: clientId,
    accountId: accountId,
    paymentMethod: paymentMethod,
    accountNo: accountNo,
    remarks: remarks,
    receivedDate: receivedDate,
    totalAmount: totalAmount,
  );
}

@riverpod
Future<void> updateDisbursement(
  Ref ref, {
  required int id,
  int? supplierId,
  int? accountId,
  required String paymentMethod,
  String? accountNo,
  String? category,
  String? remarks,
  required DateTime paidDate,
  double? totalAmount,
}) {
  return ref.watch(receiptRepositoryProvider).updateDisbursement(
    id: id,
    supplierId: supplierId,
    accountId: accountId,
    paymentMethod: paymentMethod,
    accountNo: accountNo,
    category: category,
    remarks: remarks,
    paidDate: paidDate,
    totalAmount: totalAmount,
  );
}
