import 'package:ledgerly/features/client/domain/entities/client_entity.dart';

abstract class ClientRepository {
  Future<List<ClientEntity>> getAllClients();
  Future<void> addClient(ClientEntity client);
  Future<void> updateClient(ClientEntity client);
  Future<void> deleteClient(int clientId);
}
