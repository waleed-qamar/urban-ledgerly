// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClientFilterNotifier)
const clientFilterProvider = ClientFilterNotifierProvider._();

final class ClientFilterNotifierProvider
    extends $NotifierProvider<ClientFilterNotifier, ClientFilter> {
  const ClientFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientFilterNotifierHash();

  @$internal
  @override
  ClientFilterNotifier create() => ClientFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientFilter>(value),
    );
  }
}

String _$clientFilterNotifierHash() =>
    r'0c6a982f366d920394ea6f0663b0bb62ba2799f9';

abstract class _$ClientFilterNotifier extends $Notifier<ClientFilter> {
  ClientFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ClientFilter, ClientFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClientFilter, ClientFilter>,
              ClientFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(clientRemoteDatasource)
const clientRemoteDatasourceProvider = ClientRemoteDatasourceProvider._();

final class ClientRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          ClientRemoteDatasource,
          ClientRemoteDatasource,
          ClientRemoteDatasource
        >
    with $Provider<ClientRemoteDatasource> {
  const ClientRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ClientRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClientRemoteDatasource create(Ref ref) {
    return clientRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientRemoteDatasource>(value),
    );
  }
}

String _$clientRemoteDatasourceHash() =>
    r'43bac28ccfbdb84daf11ea5998a9020c4fe47d45';

@ProviderFor(clientRepository)
const clientRepositoryProvider = ClientRepositoryProvider._();

final class ClientRepositoryProvider
    extends
        $FunctionalProvider<
          ClientRepository,
          ClientRepository,
          ClientRepository
        >
    with $Provider<ClientRepository> {
  const ClientRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClientRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClientRepository create(Ref ref) {
    return clientRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientRepository>(value),
    );
  }
}

String _$clientRepositoryHash() => r'c120c198abd4037225bfa89cd27613de029be202';

@ProviderFor(getAllClients)
const getAllClientsProvider = GetAllClientsProvider._();

final class GetAllClientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClientEntity>>,
          List<ClientEntity>,
          FutureOr<List<ClientEntity>>
        >
    with
        $FutureModifier<List<ClientEntity>>,
        $FutureProvider<List<ClientEntity>> {
  const GetAllClientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllClientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllClientsHash();

  @$internal
  @override
  $FutureProviderElement<List<ClientEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientEntity>> create(Ref ref) {
    return getAllClients(ref);
  }
}

String _$getAllClientsHash() => r'666a01c5cecd6bc8c3b8ba18cdfe466d141faa38';

@ProviderFor(addClient)
const addClientProvider = AddClientFamily._();

final class AddClientProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AddClientProvider._({
    required AddClientFamily super.from,
    required ClientEntity super.argument,
  }) : super(
         retry: null,
         name: r'addClientProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addClientHash();

  @override
  String toString() {
    return r'addClientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ClientEntity;
    return addClient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addClientHash() => r'ce7f967fcd58781caf8188a6bbc2b8fbe435cba6';

final class AddClientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, ClientEntity> {
  const AddClientFamily._()
    : super(
        retry: null,
        name: r'addClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddClientProvider call(ClientEntity client) =>
      AddClientProvider._(argument: client, from: this);

  @override
  String toString() => r'addClientProvider';
}

@ProviderFor(updateClient)
const updateClientProvider = UpdateClientFamily._();

final class UpdateClientProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateClientProvider._({
    required UpdateClientFamily super.from,
    required ClientEntity super.argument,
  }) : super(
         retry: null,
         name: r'updateClientProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateClientHash();

  @override
  String toString() {
    return r'updateClientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ClientEntity;
    return updateClient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateClientHash() => r'7be5cd9f712da3b8ff7df1682dcccbbe1e713ff2';

final class UpdateClientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, ClientEntity> {
  const UpdateClientFamily._()
    : super(
        retry: null,
        name: r'updateClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateClientProvider call(ClientEntity client) =>
      UpdateClientProvider._(argument: client, from: this);

  @override
  String toString() => r'updateClientProvider';
}

@ProviderFor(deleteClient)
const deleteClientProvider = DeleteClientFamily._();

final class DeleteClientProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteClientProvider._({
    required DeleteClientFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deleteClientProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteClientHash();

  @override
  String toString() {
    return r'deleteClientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as int;
    return deleteClient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteClientHash() => r'68f4ec5554c209e3ef2629b62db62ddcfd0c0a6d';

final class DeleteClientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, int> {
  const DeleteClientFamily._()
    : super(
        retry: null,
        name: r'deleteClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteClientProvider call(int clientId) =>
      DeleteClientProvider._(argument: clientId, from: this);

  @override
  String toString() => r'deleteClientProvider';
}
