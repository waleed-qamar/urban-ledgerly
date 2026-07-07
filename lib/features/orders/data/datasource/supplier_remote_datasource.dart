import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:ledgerly/features/orders/domain/entities/supplier_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupplierRemoteDatasource {
  final SupabaseClient _client;
  SupplierRemoteDatasource(this._client);

  Future<List<SupplierEntity>> getSuppliers() async {
    final response = await _client.from('suppliers').select();

    return (response as List)
        .map((e) => SupplierEntity.fromJson(_normalizeSupplierRow(e)))
        .toList();
  }

  Future<SupplierEntity> getSupplierById(int id) async {
    final response = await _client
        .from('suppliers')
        .select()
        .eq('id', id)
        .single();

    return SupplierEntity.fromJson(_normalizeSupplierRow(response));
  }

  Future<void> addSupplier(SupplierEntity supplier) async {
    await supabaseSafeCall(() async {
      await _client.from('suppliers').insert(supplier.toJson());
    });
  }

  Future<void> updateSupplier(SupplierEntity supplier) async {
    await supabaseSafeCall(() async {
      await _client
          .from('suppliers')
          .update(supplier.toJson())
          .eq('id', supplier.id!);
    });
  }

  Future<void> deleteSupplier(int id) async {
    await supabaseSafeCall(() async {
      await _client.from('suppliers').delete().eq('id', id);
    });
  }

  Map<String, dynamic> _normalizeSupplierRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);

    normalized['name'] = (normalized['name'] ?? '').toString();
    normalized['address'] = (normalized['address'] ?? '').toString();
    normalized['strnNo'] = (normalized['strnNo'] ?? normalized['strn_no'] ?? '')
        .toString();
    normalized['ntn'] = (normalized['ntn'] ?? '').toString();
    // `delivery_terms` is currently transitional and may be null in old rows.
    normalized['deliveryTerms'] =
        (normalized['deliveryTerms'] ?? normalized['delivery_terms'] ?? '')
            .toString();
    normalized['contactInfo'] =
        (normalized['contactInfo'] ?? normalized['contact_info'] ?? '')
            .toString();

    return normalized;
  }
}
