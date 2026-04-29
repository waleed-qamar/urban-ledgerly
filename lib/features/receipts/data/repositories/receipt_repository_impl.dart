import '../../domain/entities/receipt_entity.dart';
import '../../domain/repositories/receipt_repository.dart';
import '../datasources/receipt_remote_datasource.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDatasource _datasource;

  ReceiptRepositoryImpl(this._datasource);

  @override
  Future<ReceiptEntity> createReceipt(ReceiptEntity receipt) {
    return _datasource.createReceipt(receipt);
  }

  @override
  Future<void> deleteReceipt(int id) {
    return _datasource.deleteReceipt(id);
  }

  @override
  Future<ReceiptEntity> getReceiptById(int id) {
    return _datasource.getReceiptById(id);
  }

  @override
  Future<List<ReceiptEntity>> getReceipts() {
    return _datasource.getReceipts();
  }
}
