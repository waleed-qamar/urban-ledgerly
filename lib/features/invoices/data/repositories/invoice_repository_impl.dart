import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasource/invoice_remote_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDatasource _datasource;

  InvoiceRepositoryImpl(this._datasource);

  @override
  Future<void> createInvoice(InvoiceEntity invoice) {
    return _datasource.createInvoice(invoice);
  }

  @override
  Future<InvoiceEntity> getInvoiceById(int id) {
    return _datasource.getInvoiceById(id);
  }

  @override
  Future<List<InvoiceEntity>> getInvoices() {
    return _datasource.getInvoices();
  }

  @override
  Future<void> updateInvoiceStatus(int id, String status, {DateTime? dispatchDate}) {
    return _datasource.updateInvoiceStatus(id, status, dispatchDate: dispatchDate);
  }

  @override
  Future<String> getNextInvoiceNumber() {
    return _datasource.getNextInvoiceNumber();
  }
}
