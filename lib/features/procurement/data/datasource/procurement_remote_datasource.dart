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
        .map((row) => ProcurementEntity.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<ProcurementEntity> getProcurementById(int id) async {
    final response = await _client
        .from('procurements')
        .select(_procurementSelect)
        .eq('id', id)
        .single();

    return ProcurementEntity.fromJson(response as Map<String, dynamic>);
  }

  Future<void> createProcurement(ProcurementEntity procurement) async {
    await supabaseSafeCall(() async {
      final inserted = await _client
          .from('procurements')
          .insert({
            'vendor_id': procurement.vendorId,
            'procurement_date': procurement.procurementDate,
            'broker_id': procurement.brokerId,
            'brokerage_price': procurement.brokeragePrice,
            'loading_charges': procurement.loadingCharges,
            'unloading_charges': procurement.unloadingCharges,
            'rent_amount': procurement.rentAmount,
            'rent_expense_head_id': procurement.rentExpenseHeadId,
            'items_total': procurement.itemsTotal,
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

        // 3) Auto vendor ledger entry: credit increases payable (only for itemsTotal)
        await _client.from('ledger').insert({
          'party_type': 'vendor',
          'party_id': procurement.vendorId,
          'invoice_number': 'PRC-$createdId',
          'entry_type': 'credit',
          'amount': procurement.itemsTotal,
          'entry_date': _parseDate(
            procurement.procurementDate,
          ).toIso8601String(),
          'transaction_source': 'procurement',
          'reference_id': createdId.toString(),
          'remarks': 'Auto credit from procurement #$createdId',
          'created_at': DateTime.now().toIso8601String(),
        });

        // 4) Auto broker ledger entry if a broker is selected
        if (procurement.brokerId != null && procurement.brokeragePrice > 0) {
          await _client.from('ledger').insert({
            'party_type': 'vendor',
            'party_id': procurement.brokerId,
            'invoice_number': 'PRC-BRK-$createdId',
            'entry_type': 'credit',
            'amount': procurement.brokeragePrice,
            'entry_date': _parseDate(
              procurement.procurementDate,
            ).toIso8601String(),
            'transaction_source': 'procurement_brokerage',
            'reference_id': createdId.toString(),
            'remarks': 'Auto brokerage credit from procurement #$createdId',
            'created_at': DateTime.now().toIso8601String(),
          });
        }

        // 5) Auto rent expense and account transaction
        if (procurement.rentAmount > 0 && procurement.rentExpenseHeadId != null) {
          final expenseInserted = await _client.from('expenses').insert({
            'expense_head_id': procurement.rentExpenseHeadId,
            'amount': procurement.rentAmount,
            'date': _parseDate(procurement.procurementDate).toIso8601String(),
            'remarks': 'Auto rent from procurement #$createdId',
          }).select().single();

          final expenseId = expenseInserted['id'] as int;

          await _client.from('procurements').update({
            'rent_expense_id': expenseId,
          }).eq('id', createdId);

          await _client.from('account_transactions').insert({
            'account_id': 1,
            'transaction_type': 'DEBIT',
            'amount': procurement.rentAmount,
            'reference_type': 'procurement_rent',
            'reference_id': createdId,
            'transaction_date': _parseDate(procurement.procurementDate).toIso8601String(),
            'notes': 'Auto rent from procurement #$createdId',
          });
        }
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
            'broker_id': procurement.brokerId,
            'brokerage_price': procurement.brokeragePrice,
            'loading_charges': procurement.loadingCharges,
            'unloading_charges': procurement.unloadingCharges,
            'rent_amount': procurement.rentAmount,
            'rent_expense_head_id': procurement.rentExpenseHeadId,
            'items_total': procurement.itemsTotal,
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
        'amount': procurement.itemsTotal,
        'entry_date': _parseDate(procurement.procurementDate).toIso8601String(),
        'transaction_source': 'procurement',
        'reference_id': procurementId.toString(),
        'remarks': 'Auto credit from procurement #$procurementId',
        'created_at': DateTime.now().toIso8601String(),
      });

      // 6) Update broker ledger entry
      await _client
          .from('ledger')
          .delete()
          .eq('transaction_source', 'procurement_brokerage')
          .eq('reference_id', procurementId.toString());

      if (procurement.brokerId != null && procurement.brokeragePrice > 0) {
        await _client.from('ledger').insert({
          'party_type': 'vendor',
          'party_id': procurement.brokerId,
          'invoice_number': 'PRC-BRK-$procurementId',
          'entry_type': 'credit',
          'amount': procurement.brokeragePrice,
          'entry_date': _parseDate(procurement.procurementDate).toIso8601String(),
          'transaction_source': 'procurement_brokerage',
          'reference_id': procurementId.toString(),
          'remarks': 'Auto brokerage credit from procurement #$procurementId',
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // 7) Handle Rent Expense Updates
      // First delete existing rent transactions
      await _client
          .from('account_transactions')
          .delete()
          .eq('reference_type', 'procurement_rent')
          .eq('reference_id', procurementId);

      if (procurement.rentExpenseId != null) {
        await _client
            .from('expenses')
            .delete()
            .eq('id', procurement.rentExpenseId!);
      }

      // Then insert new if applicable
      if (procurement.rentAmount > 0 && procurement.rentExpenseHeadId != null) {
        final expenseInserted = await _client.from('expenses').insert({
          'expense_head_id': procurement.rentExpenseHeadId,
          'amount': procurement.rentAmount,
          'date': _parseDate(procurement.procurementDate).toIso8601String(),
          'remarks': 'Auto rent from procurement #$procurementId',
        }).select().single();

        final expenseId = expenseInserted['id'] as int;

        await _client.from('procurements').update({
          'rent_expense_id': expenseId,
        }).eq('id', procurementId);

        await _client.from('account_transactions').insert({
          'account_id': 1,
          'transaction_type': 'DEBIT',
          'amount': procurement.rentAmount,
          'reference_type': 'procurement_rent',
          'reference_id': procurementId,
          'transaction_date': _parseDate(procurement.procurementDate).toIso8601String(),
          'notes': 'Auto rent from procurement #$procurementId',
        });
      } else {
        // if no rent, ensure we clear the rent_expense_id from the DB
        await _client.from('procurements').update({
          'rent_expense_id': null,
        }).eq('id', procurementId);
      }
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

      // 2) Delete ledger entries (vendor and broker)
      await _client
          .from('ledger')
          .delete()
          .inFilter('transaction_source', ['procurement', 'procurement_brokerage'])
          .eq('reference_id', id.toString());

      // 3) Delete procurement itself (cascades to procurement_items)
      // Note: First fetch it to see if there is an expense to delete
      final procResponse = await _client.from('procurements').select('rent_expense_id').eq('id', id).maybeSingle();
      
      await _client.from('procurements').delete().eq('id', id);

      // 4) Delete rent account transaction and expense
      await _client
          .from('account_transactions')
          .delete()
          .eq('reference_type', 'procurement_rent')
          .eq('reference_id', id);
          
      if (procResponse != null && procResponse['rent_expense_id'] != null) {
        await _client.from('expenses').delete().eq('id', procResponse['rent_expense_id'] as int);
      }
    });
  }

  DateTime _parseDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    return parsed ?? DateTime.now();
  }
}
