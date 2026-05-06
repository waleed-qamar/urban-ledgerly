import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/core/inventory/presentation/providers/inventory_providers.dart';

import '../providers/raw_material_providers.dart';
import 'add_raw_material_dialog.dart';
import 'raw_material_detail_page.dart';

class RawMaterialDashboard extends ConsumerWidget {
  const RawMaterialDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialsAsyncValue = ref.watch(getAllRawMaterialsProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raw Materials',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddRawMaterialDialog(),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Raw Material'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Summary Cards
            materialsAsyncValue.when(
              data: (materials) {
                if (materials.isEmpty) {
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'No materials yet. Click "Add Raw Material" to get started.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Total Materials',
                        value: materials.length.toString(),
                        subtitleLabel: 'ITEMS',
                        icon: Icons.category,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Total Value (Avg)',
                        value: materials
                            .fold<double>(0, (sum, mat) => sum + (mat.price))
                            .toStringAsFixed(2),
                        subtitleLabel: 'USD', // Or relevant currency
                        icon: Icons.attach_money,
                      ),
                    ),
                  ],
                );
              },
              error: (err, _) => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.textWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Error loading materials: $err',
                    style: TextStyle(color: AppColors.errorText),
                  ),
                ),
              ),
              loading: () => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.textWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 48),

            // Materials List
            Expanded(
              child: materialsAsyncValue.when(
                data: (materials) {
                  if (materials.isEmpty) {
                    return const Center(
                      child: Text(
                        'No raw materials found.',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: materials.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final mat = materials[index];
                      return _RawMaterialListItem(
                        material: mat,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  RawMaterialDetailPage(material: mat),
                            ),
                          );
                        },
                        onAddStock: () {
                          _recordTransaction(
                            context,
                            ref,
                            mat.id,
                            transactionType: 'IN',
                          );
                        },
                        onRemoveStock: () {
                          _recordTransaction(
                            context,
                            ref,
                            mat.id,
                            transactionType: 'OUT',
                          );
                        },
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AddRawMaterialDialog(materialToEdit: mat),
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmation(context, ref, mat);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    'Error loading materials: $err',
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

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    dynamic material,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Raw Material'),
        content: const Text(
          'Are you sure you want to delete this material? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorText,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                await ref
                    .read(rawMaterialRepositoryProvider)
                    .deleteRawMaterial(material.id);
                ref.invalidate(getAllRawMaterialsProvider);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Material deleted successfully'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting material: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _recordTransaction(
    BuildContext context,
    WidgetRef ref,
    int materialId, {
    required String transactionType,
  }) async {
    var quantityText = '';
    var notesText = '';

    final quantity = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          backgroundColor: AppColors.textWhite,
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
          materialId,
          'RAW_MATERIAL',
          quantity.toDouble(),
          notes: notes,
        );
      } else {
        await repository.recordOut(
          materialId,
          'RAW_MATERIAL',
          quantity.toDouble(),
          notes: notes,
        );
      }

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

class _RawMaterialListItem extends ConsumerWidget {
  final dynamic material;
  final VoidCallback onTap;
  final VoidCallback onAddStock;
  final VoidCallback onRemoveStock;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RawMaterialListItem({
    required this.material,
    required this.onTap,
    required this.onAddStock,
    required this.onRemoveStock,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(
      inventoryTransactionsForItemProvider(material.id, 'RAW_MATERIAL'),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.dividerColor.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textGrey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Icon(Icons.inventory_2, color: AppColors.textGrey),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (material.description != null &&
                      material.description!.isNotEmpty)
                    Text(
                      material.description ?? '',
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  TextButton(
                    onPressed: onAddStock,
                    child: const Row(children: [Icon(Icons.add), Text('Add')]),
                  ),
                  TextButton(
                    onPressed: onRemoveStock,
                    child: const Row(
                      children: [Icon(Icons.remove), Text('Remove')],
                    ),
                  ),
                  const Spacer(),
                  transactionsAsync.when(
                    data: (transactions) {
                      double totalIn = 0;
                      double totalOut = 0;
                      for (final t in transactions) {
                        if (t.isIn) {
                          totalIn += t.quantity;
                        } else {
                          totalOut += t.quantity;
                        }
                      }
                      final available = totalIn - totalOut;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'In Stock',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            available.toStringAsFixed(0),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(
                      width: 40,
                      child: Center(
                        child: SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (_, __) => const Text(
                      '-',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            PopupMenuButton<String>(
              color: AppColors.textWhite,
              onSelected: (val) {
                if (val == 'edit') {
                  onEdit();
                } else if (val == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              icon: const Icon(Icons.more_vert, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSummaryCard({
  required String title,
  required String value,
  required String subtitleLabel,
  required IconData icon,
  String? trailingText,
}) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.textWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.5)),
      boxShadow: [
        BoxShadow(
          color: AppColors.textGrey.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              radius: 20,
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              subtitleLabel,
              style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
            if (trailingText != null) ...[
              const SizedBox(width: 8),
              Text(
                trailingText,
                style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
