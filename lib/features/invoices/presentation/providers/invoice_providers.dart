import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/app_providers.dart';
import '../../data/datasource/invoice_remote_datasource.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';

part 'invoice_providers.g.dart';

@riverpod
InvoiceRemoteDatasource invoiceRemoteDatasource(Ref ref) {
  return InvoiceRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
InvoiceRepository invoiceRepository(Ref ref) {
  return InvoiceRepositoryImpl(ref.watch(invoiceRemoteDatasourceProvider));
}

@riverpod
Future<List<InvoiceEntity>> getAllInvoices(Ref ref) {
  return ref.watch(invoiceRepositoryProvider).getInvoices();
}

@riverpod
Future<void> createInvoice(Ref ref, InvoiceEntity invoice) {
  return ref.watch(invoiceRepositoryProvider).createInvoice(invoice);
}

@riverpod
Future<InvoiceEntity> getInvoiceById(Ref ref, int id) {
  return ref.watch(invoiceRepositoryProvider).getInvoiceById(id);
}
