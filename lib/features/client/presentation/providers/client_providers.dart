
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/client_remote_datasource.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/entities/client_entity.dart';
import '../../domain/repositories/client_repository.dart';

part 'client_providers.g.dart';

enum ClientFilter { all, active, inactive }

@riverpod
class ClientFilterNotifier extends _$ClientFilterNotifier {
  @override
  ClientFilter build() => ClientFilter.all;

  void setFilter(ClientFilter filter) => state = filter;
}

@riverpod
ClientRemoteDatasource clientRemoteDatasource(Ref ref) {
  return ClientRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ClientRepository clientRepository(Ref ref) {
  return ClientRepositoryImpl(ref.watch(clientRemoteDatasourceProvider));
}

@riverpod
Future<List<ClientEntity>> getAllClients(Ref ref) async {
  return ref.watch(clientRepositoryProvider).getAllClients();
}

@riverpod
Future<void> addClient(Ref ref, ClientEntity client) async {
  await ref.watch(clientRepositoryProvider).addClient(client);
}

@riverpod
Future<void> updateClient(Ref ref, ClientEntity client) async {
  await ref.watch(clientRepositoryProvider).updateClient(client);
}

@riverpod
Future<void> deleteClient(Ref ref, int clientId) async {
  await ref.watch(clientRepositoryProvider).deleteClient(clientId);
}
