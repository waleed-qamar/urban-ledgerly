import '../entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<void> createInvoice(InvoiceEntity invoice);
  Future<void> updateInvoiceStatus(int id, String status, {DateTime? dispatchDate});
  Future<InvoiceEntity> getInvoiceById(int id);
  Future<List<InvoiceEntity>> getInvoices();
  Future<String> getNextInvoiceNumber({int? clientId, String? clientInitials});
}
