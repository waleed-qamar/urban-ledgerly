import '../entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<void> createInvoice(InvoiceEntity invoice);
  Future<void> updateInvoiceStatus(int id, String status);
  Future<InvoiceEntity> getInvoiceById(int id);
  Future<List<InvoiceEntity>> getInvoices();
}
