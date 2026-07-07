import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRemoteDatasource {
  final SupabaseClient _client;

  ClientRemoteDatasource(this._client);

  Future<List<ClientEntity>> fetchAllClients() async {
    final response = await _client.from('clients').select();

    return response
        .map((json) => ClientEntity.fromJson(_normalizeClientRow(json)))
        .toList();
  }

  Future<void> addClient(ClientEntity client) async {
    await supabaseSafeCall(() async {
      final payload = client.toJson()..remove('id');
      await _client.from('clients').insert(payload);
    });
  }

  Future<void> updateClient(ClientEntity client) async {
    await supabaseSafeCall(() async {
      await _client.from('clients').update(client.toJson()).eq('id', client.id);
    });
  }

  Future<void> deleteClient(int clientId) async {
    await supabaseSafeCall(() async {
      await _client.from('clients').delete().eq('id', clientId);
    });
  }

  Map<String, dynamic> _normalizeClientRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);

    normalized['clientName'] = (normalized['clientName'] ?? '').toString();
    normalized['contactNumber'] = (normalized['contactNumber'] ?? '')
        .toString();
    normalized['clientAddress'] = (normalized['clientAddress'] ?? '')
        .toString();
    normalized['department'] = (normalized['department'] ?? '').toString();
    normalized['createdAt'] =
        (normalized['createdAt'] ?? DateTime.now().toIso8601String())
            .toString();
    normalized['is_active'] = normalized['is_active'] ?? true;

    return normalized;
  }
}
