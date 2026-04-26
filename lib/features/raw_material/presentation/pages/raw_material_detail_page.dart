import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/core/inventory/domain/entities/inventory_transaction_entity.dart';
import 'package:ledgerly/core/inventory/presentation/providers/inventory_providers.dart';
import 'package:ledgerly/features/raw_material/domain/entities/raw_material_entity.dart';

class RawMaterialDetailPage extends ConsumerWidget {
  final RawMaterialEntity material;

  const RawMaterialDetailPage({super.key, required this.material});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(
      inventoryTransactionsForItemProvider(material.id, 'RAW_MATERIAL'),
    );

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        backgroundColor: AppColors.textWhite,
        foregroundColor: AppColors.textBlack,
        title: const Text('Material Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MaterialHeaderCard(material: material),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    label: 'Add Stock',
                    icon: Icons.add_circle_outline,
                    color: AppColors.primary,
                    onPressed: () =>
                        _recordTransaction(context, ref, transactionType: 'IN'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionCard(
                    label: 'Remove Stock',
                    icon: Icons.remove_circle_outline,
                    color: AppColors.negativeAccent,
                    onPressed: () => _recordTransaction(
                      context,
                      ref,
                      transactionType: 'OUT',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) {
                  final totals = _TransactionTotals.from(transactions);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryTile(
                              label: 'Total IN',
                              value: totals.totalIn.toString(),
                              icon: Icons.call_received,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryTile(
                              label: 'Total OUT',
                              value: totals.totalOut.toString(),
                              icon: Icons.call_made,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryTile(
                              label: 'Net',
                              value: totals.net.toString(),
                              icon: Icons.inventory_2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Inventory Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: transactions.isEmpty
                            ? const Center(
                                child: Text(
                                  'No inventory transactions yet.',
                                  style: TextStyle(color: AppColors.textGrey),
                                ),
                              )
                            : ListView.separated(
                                itemCount: transactions.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  return _TransactionTile(
                                    transaction: transaction,
                                    onEdit: () => _showEditTransactionDialog(
                                      context,
                                      ref,
                                      transaction,
                                    ),
                                    onDelete: () =>
                                        _showDeleteTransactionConfirmation(
                                          context,
                                          ref,
                                          transaction,
                                        ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Error loading transactions: $error',
                    style: TextStyle(color: AppColors.errorText),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditTransactionDialog(
    BuildContext context,
    WidgetRef ref,
    InventoryTransactionEntity transaction,
  ) async {
    final quantityController = TextEditingController(
      text: transaction.quantity.toString(),
    );
    final notesController = TextEditingController(
      text: transaction.notes ?? '',
    );
    var transactionType = transaction.transactionType.toUpperCase();

    try {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          final formKey = GlobalKey<FormState>();

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Edit Transaction'),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: transactionType,
                        decoration: const InputDecoration(
                          labelText: 'Transaction Type',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'IN',
                            child: Text('Stock In'),
                          ),
                          DropdownMenuItem(
                            value: 'OUT',
                            child: Text('Stock Out'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => transactionType = value);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select a transaction type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: quantityController,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        validator: (value) {
                          final parsed = int.tryParse(value ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid positive quantity';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(dialogContext).pop(true);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (shouldSave != true) return;

      final quantity = int.parse(quantityController.text.trim());
      final notes = notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim();

      await ref.read(
        updateInventoryTransactionProvider(
          transaction.id,
          quantity,
          transactionType,
          notes: notes,
        ).future,
      );

      ref.invalidate(
        inventoryTransactionsForItemProvider(material.id, 'RAW_MATERIAL'),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction updated successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update transaction: $e')),
        );
      }
    } finally {
      quantityController.dispose();
      notesController.dispose();
    }
  }

  Future<void> _showDeleteTransactionConfirmation(
    BuildContext context,
    WidgetRef ref,
    InventoryTransactionEntity transaction,
  ) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorText,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete != true) return;

    try {
      await ref.read(deleteInventoryTransactionProvider(transaction.id).future);

      ref.invalidate(
        inventoryTransactionsForItemProvider(material.id, 'RAW_MATERIAL'),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete transaction: $e')),
        );
      }
    }
  }

  Future<void> _recordTransaction(
    BuildContext context,
    WidgetRef ref, {
    required String transactionType,
  }) async {
    var quantityText = '';
    var notesText = '';

    final quantity = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text(transactionType == 'IN' ? 'Add Stock' : 'Remove Stock'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  onChanged: (value) => quantityText = value,
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid positive quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 2,
                  onChanged: (value) => notesText = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(int.parse(quantityText));
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (quantity == null) return;
    final notes = notesText.trim().isEmpty ? null : notesText.trim();

    final repository = ref.read(inventoryRepositoryProvider);
    try {
      if (transactionType == 'IN') {
        await repository.recordIn(
          material.id,
          'RAW_MATERIAL',
          quantity,
          notes: notes,
        );
      } else {
        await repository.recordOut(
          material.id,
          'RAW_MATERIAL',
          quantity,
          notes: notes,
        );
      }

      ref.invalidate(
        inventoryTransactionsForItemProvider(material.id, 'RAW_MATERIAL'),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inventory updated successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update inventory: $e')),
        );
      }
    }
  }
}

class _MaterialHeaderCard extends StatelessWidget {
  final RawMaterialEntity material;

  const _MaterialHeaderCard({required this.material});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd().add_jm();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textGrey.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            material.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          if (material.description != null && material.description!.isNotEmpty)
            Text(
              material.description!,
              style: const TextStyle(color: AppColors.textGrey),
            ),
          const SizedBox(height: 12),
          Text(
            'Avg Price: ${material.price.toStringAsFixed(2)}',
            style: const TextStyle(color: AppColors.textBlack),
          ),
          const SizedBox(height: 4),
          Text(
            'Created: ${formatter.format(material.createdAt)}',
            style: const TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(icon, size: 18, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final InventoryTransactionEntity transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TransactionTile({
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd().add_jm();
    final isIn = transaction.isIn;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (isIn ? Colors.green : Colors.red).withValues(
              alpha: 0.12,
            ),
            child: Icon(
              isIn ? Icons.add : Icons.remove,
              color: isIn ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isIn ? 'Stock In' : 'Stock Out',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatter.format(transaction.createdAt),
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (transaction.notes?.isNotEmpty ?? false)
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.comment, size: 14, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      transaction.notes!,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Text(
            '${isIn ? '+' : '-'}${transaction.quantity}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIn ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit, color: AppColors.iconColor),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete, color: AppColors.errorText),
          ),
        ],
      ),
    );
  }
}

class _TransactionTotals {
  final int totalIn;
  final int totalOut;

  const _TransactionTotals({required this.totalIn, required this.totalOut});

  int get net => totalIn - totalOut;

  factory _TransactionTotals.from(
    List<InventoryTransactionEntity> transactions,
  ) {
    var totalIn = 0;
    var totalOut = 0;

    for (final transaction in transactions) {
      if (transaction.isIn) {
        totalIn += transaction.quantity;
      } else {
        totalOut += transaction.quantity;
      }
    }

    return _TransactionTotals(totalIn: totalIn, totalOut: totalOut);
  }
}
