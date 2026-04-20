import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRemoteDatasource {
  final SupabaseClient _client;

  ClientRemoteDatasource(this._client);

  Future<List<ClientEntity>> fetchAllClients() async {
    final response = await _client.from('clients').select();

    return response.map((json) => ClientEntity.fromJson(json)).toList();
  }

  Future<void> addClient(ClientEntity client) async {
    await _client.from('clients').insert(client.toJson());
  }

  Future<void> updateClient(ClientEntity client) async {
    await _client.from('clients').update(client.toJson()).eq('id', client.id);
  }

  Future<void> deleteClient(int clientId) async {
    await _client.from('clients').delete().eq('id', clientId);
  }
}
