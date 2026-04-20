import 'package:ledgerly/features/client/data/datasources/client_remote_datasource.dart';
import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:ledgerly/features/client/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDatasource _datasource;

  ClientRepositoryImpl(this._datasource);

  @override
  Future<void> addClient(ClientEntity client) => _datasource.addClient(client);

  @override
  Future<void> deleteClient(int clientId) => _datasource.deleteClient(clientId);

  @override
  Future<List<ClientEntity>> getAllClients() => _datasource.fetchAllClients();

  @override
  Future<void> updateClient(ClientEntity client) =>
      _datasource.updateClient(client);
}
