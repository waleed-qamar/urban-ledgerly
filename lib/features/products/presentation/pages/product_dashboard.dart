import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/products/presentation/pages/product_detail_page.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';

import 'add_product_dialog.dart';

class ProductDashboard extends ConsumerWidget {
  const ProductDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(getAllProductsProvider);

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
                  'Products',
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
                          builder: (context) => const AddProductDialog(),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Product'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Summary Cards
            productsAsyncValue.when(
              data: (products) {
                if (products.isEmpty) {
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'No products yet. Click "Add Product" to get started.',
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
                        title: 'Total Products',
                        value: products.length.toString(),
                        subtitleLabel: 'PRODUCTS',
                        icon: Icons.shopping_cart,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Total Weight',
                        value: products
                            .fold<double>(0, (sum, prod) => sum + (prod.weight))
                            .toStringAsFixed(2),
                        subtitleLabel: 'KG',
                        icon: Icons.scale,
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
                    'Error loading products: $err',
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

            // Products List
            Expanded(
              child: productsAsyncValue.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products found.',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final prod = products[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(product: prod),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.dividerColor.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textGrey.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.shopping_bag,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Name & Description
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prod.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.textBlack,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (prod.description != null &&
                                        prod.description!.isNotEmpty)
                                      Text(
                                        prod.description ?? '',
                                        style: const TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),

                              // Weight
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _recordTransaction(
                                          context,
                                          ref,
                                          prod.id,
                                          transactionType: 'IN',
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.add),
                                          Text('Add'),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _recordTransaction(
                                          context,
                                          ref,
                                          prod.id,
                                          transactionType: 'OUT',
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          Text('Remove'),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Weight',
                                          style: TextStyle(
                                            color: AppColors.textGrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${prod.weight.toStringAsFixed(2)} kg',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.textBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),
                              PopupMenuButton<String>(
                                color: AppColors.textWhite,
                                onSelected: (val) async {
                                  if (val == 'edit') {
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AddProductDialog(
                                          productToEdit: prod,
                                        ),
                                      );
                                    }
                                  } else if (val == 'delete') {
                                    _showDeleteConfirmation(context, ref, prod);
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    'Error loading products: $err',
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
    dynamic product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
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
                // Delete product
                await ref
                    .read(productRepositoryProvider)
                    .deleteProduct(product.id);
                ref.invalidate(getAllProductsProvider);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting product: $e')),
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
    int productId, {
    required String transactionType,
  }) async {
    var quantityText = '';
    var remarksText = '';

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
                    labelText: 'Remarks (optional)',
                  ),
                  maxLines: 2,
                  onChanged: (value) => remarksText = value,
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
    final remarks = remarksText.trim().isEmpty ? null : remarksText.trim();

    final repository = ref.read(productInventoryRepositoryProvider);
    try {
      if (transactionType == 'IN') {
        await repository.addTransaction(productId, quantity, remarks);
      } else {
        await repository.removeTransaction(productId, quantity, remarks);
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
