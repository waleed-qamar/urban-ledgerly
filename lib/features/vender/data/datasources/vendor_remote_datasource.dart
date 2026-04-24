import 'package:ledgerly/features/vender/domain/entities/vendor_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorRemoteDatasource {
  final SupabaseClient _client;

  VendorRemoteDatasource(this._client);

  Future<List<VendorEntity>> fetchAllVenders() async {
    final response = await _client.from('vendors').select();

    return response.map((json) => VendorEntity.fromJson(json)).toList();
  }

  Future<void> addVender(VendorEntity vendor) async {
    final payload = vendor.toJson()..remove('id');
    await _client.from('vendors').insert(payload);
  }

  Future<void> updateVender(VendorEntity vendor) async {
    await _client.from('vendors').update(vendor.toJson()).eq('id', vendor.id);
  }

  Future<void> deleteVender(int vendorId) async {
    await _client.from('vendors').delete().eq('id', vendorId);
  }
}
