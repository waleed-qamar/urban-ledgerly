import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/products/domain/entities/inventory_transaction_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';

class ProductDetailPage extends ConsumerWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(
      inventoryTransactionsByProductProvider(product.id),
    );

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        backgroundColor: AppColors.textWhite,
        foregroundColor: AppColors.textBlack,
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductHeaderCard(product: product),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    label: 'Add Stock',
                    icon: Icons.add_circle_outline,
                    onPressed: () =>
                        _recordTransaction(context, ref, transactionType: 'IN'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionCard(
                    label: 'Remove Stock',
                    icon: Icons.remove_circle_outline,
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
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  return _TransactionTile(
                                    transaction: transaction,
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

  Future<void> _recordTransaction(
    BuildContext context,
    WidgetRef ref, {
    required String transactionType,
  }) async {
    var quantityText = '';

    final quantity = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text(transactionType == 'IN' ? 'Add Stock' : 'Remove Stock'),
          content: Form(
            key: formKey,
            child: TextFormField(
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

    final repository = ref.read(productInventoryRepositoryProvider);
    try {
      if (transactionType == 'IN') {
        await repository.addTransaction(product.id, quantity);
      } else {
        await repository.removeTransaction(product.id, quantity);
      }

      ref.invalidate(inventoryTransactionsByProductProvider(product.id));

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

class _ProductHeaderCard extends StatelessWidget {
  final ProductEntity product;

  const _ProductHeaderCard({required this.product});

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
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          if (product.description != null && product.description!.isNotEmpty)
            Text(
              product.description!,
              style: const TextStyle(color: AppColors.textGrey),
            ),
          const SizedBox(height: 12),
          Text(
            'Weight: ${product.weight.toStringAsFixed(2)} kg',
            style: const TextStyle(color: AppColors.textBlack),
          ),
          const SizedBox(height: 4),
          Text(
            'Created: ${formatter.format(product.createdAt)}',
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
  final VoidCallback onPressed;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
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

  const _TransactionTile({required this.transaction});

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
          Text(
            '${isIn ? '+' : '-'}${transaction.quantity}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIn ? Colors.green : Colors.red,
            ),
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
