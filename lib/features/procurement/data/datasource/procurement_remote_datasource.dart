import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/procurement_entity.dart';

class ProcurementRemoteDatasource {
  final SupabaseClient _client;
  static const String _procurementSelect = '*, items:procurement_items(*)';

  ProcurementRemoteDatasource(this._client);

  Future<List<ProcurementEntity>> getAllProcurements() async {
    final response = await _client
        .from('procurements')
        .select(_procurementSelect);

    return (response as List)
        .map((row) => ProcurementEntity.fromJson(_normalizeRow(row)))
        .toList();
  }

  Future<ProcurementEntity> getProcurementById(int id) async {
    final response = await _client
        .from('procurements')
        .select(_procurementSelect)
        .eq('id', id)
        .single();

    return ProcurementEntity.fromJson(_normalizeRow(response));
  }

  Future<void> createProcurement(ProcurementEntity procurement) async {
    await supabaseSafeCall(() async {
      final inserted = await _client
          .from('procurements')
          .insert({
            'vendor_id': procurement.vendorId,
            'procurement_date': procurement.procurementDate,
            'total': procurement.total,
            'notes': procurement.notes,
          })
          .select()
          .single();

      final createdId = inserted['id'] as int;

      try {
        // 1) Insert procurement items
        final itemsToInsert = procurement.items.map((item) {
          return {
            'procurement_id': createdId,
            'raw_material_id': item.rawMaterialId,
            'quantity': item.quantity,
            'price': item.price,
            'total': item.total,
          };
        }).toList();

        await _client.from('procurement_items').insert(itemsToInsert);

        // 2) Auto stock-in transaction for raw material inventory.
        for (final item in procurement.items) {
          await _client.from('inventory_transactions').insert({
            'item_id': item.rawMaterialId,
            'item_type': 'RAW_MATERIAL',
            'transaction_type': 'IN',
            'quantity': item.quantity,
            'reference_type': 'PROCUREMENT',
            'reference_id': createdId,
            'notes':
                'Auto added from procurement #$createdId (vendor ${procurement.vendorId})',
            'transaction_date': _parseDate(
              procurement.procurementDate,
            ).toIso8601String(),
            'created_at': DateTime.now().toIso8601String(),
          });
        }

        // 3) Auto vendor ledger entry: credit increases payable.
        await _client.from('ledger').insert({
          'party_type': 'vendor',
          'party_id': procurement.vendorId,
          'invoice_number': 'PRC-$createdId',
          'entry_type': 'credit',
          'amount': procurement.total,
          'entry_date': _parseDate(
            procurement.procurementDate,
          ).toIso8601String(),
          'transaction_source': 'procurement',
          'reference_id': createdId.toString(),
          'remarks': 'Auto credit from procurement #$createdId',
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {
        // Keep data consistent: if side-effects fail, remove procurement row.
        await _client.from('procurements').delete().eq('id', createdId);
        rethrow;
      }
    });
  }

  Future<void> updateProcurement(ProcurementEntity procurement) async {
    await supabaseSafeCall(() async {
      final procurementId = procurement.id!;

      // 1) Update procurements table
      await _client
          .from('procurements')
          .update({
            'vendor_id': procurement.vendorId,
            'procurement_date': procurement.procurementDate,
            'total': procurement.total,
            'notes': procurement.notes,
          })
          .eq('id', procurementId);

      // 2) Delete old items (which cascades/cleans up but let's delete them explicitly)
      await _client
          .from('procurement_items')
          .delete()
          .eq('procurement_id', procurementId);

      // 3) Insert updated items
      final itemsToInsert = procurement.items.map((item) {
        return {
          'procurement_id': procurementId,
          'raw_material_id': item.rawMaterialId,
          'quantity': item.quantity,
          'price': item.price,
          'total': item.total,
        };
      }).toList();

      await _client.from('procurement_items').insert(itemsToInsert);

      // 4) Update inventory transactions: delete old ones and insert updated ones
      await _client
          .from('inventory_transactions')
          .delete()
          .eq('reference_type', 'PROCUREMENT')
          .eq('reference_id', procurementId);

      for (final item in procurement.items) {
        await _client.from('inventory_transactions').insert({
          'item_id': item.rawMaterialId,
          'item_type': 'RAW_MATERIAL',
          'transaction_type': 'IN',
          'quantity': item.quantity,
          'reference_type': 'PROCUREMENT',
          'reference_id': procurementId,
          'notes':
              'Auto added from procurement #$procurementId (vendor ${procurement.vendorId})',
          'transaction_date': _parseDate(
            procurement.procurementDate,
          ).toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // 5) Update vendor ledger entry: delete old one and insert updated one
      await _client
          .from('ledger')
          .delete()
          .eq('transaction_source', 'procurement')
          .eq('reference_id', procurementId.toString());

      await _client.from('ledger').insert({
        'party_type': 'vendor',
        'party_id': procurement.vendorId,
        'invoice_number': 'PRC-$procurementId',
        'entry_type': 'credit',
        'amount': procurement.total,
        'entry_date': _parseDate(procurement.procurementDate).toIso8601String(),
        'transaction_source': 'procurement',
        'reference_id': procurementId.toString(),
        'remarks': 'Auto credit from procurement #$procurementId',
        'created_at': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<void> deleteProcurement(int id) async {
    await supabaseSafeCall(() async {
      // 1) Delete inventory transactions
      await _client
          .from('inventory_transactions')
          .delete()
          .eq('reference_type', 'PROCUREMENT')
          .eq('reference_id', id);

      // 2) Delete ledger entry
      await _client
          .from('ledger')
          .delete()
          .eq('transaction_source', 'procurement')
          .eq('reference_id', id.toString());

      // 3) Delete procurement itself (cascades to procurement_items)
      await _client.from('procurements').delete().eq('id', id);
    });
  }

  DateTime _parseDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    return parsed ?? DateTime.now();
  }

  Map<String, dynamic> _normalizeRow(dynamic row) {
    final json = Map<String, dynamic>.from(row as Map);

    final vendorId = json['vendorId'] ?? json['vendor_id'];
    final itemsRaw = json['items'] as List? ?? [];

    final items = itemsRaw.map((itemRaw) {
      final item = Map<String, dynamic>.from(itemRaw as Map);
      final rawMaterialId = item['rawMaterialId'] ?? item['raw_material_id'];
      final procurementId = item['procurementId'] ?? item['procurement_id'];
      return {
        'id': (item['id'] as num?)?.toInt(),
        'procurement_id': (procurementId as num?)?.toInt(),
        'rawMaterial_id': (rawMaterialId as num?)?.toInt() ?? 0,
        'quantity': (item['quantity'] as num?)?.toInt() ?? 0,
        'price': (item['price'] as num?)?.toDouble() ?? 0.0,
        'total': (item['total'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();

    return {
      'id': (json['id'] as num?)?.toInt(),
      'vendor_id': (vendorId as num?)?.toInt() ?? 0,
      'procurement_date':
          (json['procurementDate'] ?? json['procurement_date'] ?? '')
              .toString(),
      'total': (json['total'] as num?)?.toDouble() ?? 0.0,
      'notes': json['notes']?.toString(),
      'items': items,
    };
  }
}
