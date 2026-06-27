import 'package:ledgerly/features/procurement/domain/entities/procurement_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProcurementRemoteDatasource {
  final SupabaseClient _client;
  ProcurementRemoteDatasource(this._client);

  Future<List<ProcurementEntity>> getAllProcurements() async {
    final response = await _client.from('procurements').select();

    return (response as List)
        .map((row) => ProcurementEntity.fromJson(_normalizeRow(row)))
        .toList();
  }

  Future<ProcurementEntity> getProcurementById(int id) async {
    final response = await _client
        .from('procurements')
        .select()
        .eq('id', id)
        .single();

    return ProcurementEntity.fromJson(_normalizeRow(response));
  }

  Future<void> createProcurement(ProcurementEntity procurement) async {
    final payload = _toDbRow(procurement.toJson())..remove('id');

    final inserted = await _client
        .from('procurements')
        .insert(payload)
        .select()
        .single();

    final created = ProcurementEntity.fromJson(_normalizeRow(inserted));
    final createdId = created.id;

    if (createdId == null) {
      throw Exception('Unable to resolve created procurement id.');
    }

    try {
      // 1) Auto stock-in transaction for raw material inventory.
      await _client.from('inventory_transactions').insert({
        'item_id': created.rawMaterialId,
        'item_type': 'RAW_MATERIAL',
        'transaction_type': 'IN',
        'quantity': created.quantity,
        'reference_type': 'PROCUREMENT',
        'reference_id': createdId,
        'notes':
            'Auto added from procurement #$createdId (vendor ${created.vendorId})',
        'transaction_date': _parseDate(procurement.procurementDate).toIso8601String(),
        'created_at': _parseDate(procurement.procurementDate).toIso8601String(),
      });

      // 2) Auto vendor ledger entry: credit increases payable.
      await _client.from('ledger').insert({
        'party_type': 'vendor',
        'party_id': created.vendorId,
        'invoice_number': 'PRC-$createdId',
        'entry_type': 'credit',
        'amount': created.total,
        'entry_date': _parseDate(created.procurementDate).toIso8601String(),
        'transaction_source': 'procurement',
        'reference_id': createdId.toString(),
        'remarks':
            'Auto credit from procurement #$createdId for raw material ${created.rawMaterialId}',
        'transaction_date': _parseDate(
          procurement.procurementDate,
        ).toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Keep data consistent: if side-effects fail, remove procurement row.
      await _client.from('procurements').delete().eq('id', createdId);
      rethrow;
    }
  }

  Future<void> updateProcurement(ProcurementEntity procurement) async {
    await _client
        .from('procurements')
        .update(_toDbRow(procurement.toJson()))
        .eq('id', procurement.id!);
  }

  Future<void> deleteProcurement(int id) async {
    await _client.from('procurements').delete().eq('id', id);
  }

  DateTime _parseDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    return parsed ?? DateTime.now();
  }

  Map<String, dynamic> _normalizeRow(dynamic row) {
    final json = Map<String, dynamic>.from(row as Map);

    final rawMaterialId = json['rawMaterialId'] ?? json['raw_material_id'];
    final vendorId = json['vendorId'] ?? json['vendor_id'];

    return {
      'id': (json['id'] as num?)?.toInt(),
      'rawMaterialId': (rawMaterialId as num?)?.toInt() ?? 0,
      'vendorId': (vendorId as num?)?.toInt() ?? 0,
      'procurementDate':
          (json['procurementDate'] ?? json['procurement_date'] ?? '')
              .toString(),
      'quantity': (json['quantity'] as num?)?.toInt() ?? 0,
      'price': (json['price'] as num?)?.toDouble() ?? 0.0,
      'total': (json['total'] as num?)?.toDouble() ?? 0.0,
      'notes': json['notes']?.toString(),
    };
  }

  Map<String, dynamic> _toDbRow(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'rawMaterialId': json['rawMaterialId'],
      'vendorId': json['vendorId'],
      'procurementDate': json['procurementDate'],
      'quantity': json['quantity'],
      'price': json['price'],
      'total': json['total'],
      'notes': json['notes'],
    };
  }
}
