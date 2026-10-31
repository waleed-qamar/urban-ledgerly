import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/core/widgets/build_search_box.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_entity.dart';
import 'package:ledgerly/features/products/presentation/pages/add_productset_dialog.dart';
import 'package:ledgerly/features/products/presentation/pages/product_detail_page.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';
import 'package:ledgerly/core/inventory/presentation/providers/inventory_providers.dart';
import 'package:ledgerly/core/inventory/presentation/widgets/inventory_transaction_dialog.dart';

import 'add_product_dialog.dart';

class ProductDashboard extends ConsumerStatefulWidget {
  const ProductDashboard({super.key});

  @override
  ConsumerState<ProductDashboard> createState() => _ProductDashboardState();
}

class _ProductDashboardState extends ConsumerState<ProductDashboard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(getAllProductsProvider);
    final setAsyncValue = ref.watch(getAllProductSetsProvider);
    final searchQuery = ref.watch(productSearchQueryProvider);

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
                    const SizedBox(width: 16),
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
                          builder: (context) => const AddProductsetDialog(),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Set'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            BuildSearchBox(
              searchController: _searchController,
              searchQueryProvider: productSearchQueryProvider,
              onQueryChanged: (value) => ref
                  .read(productSearchQueryProvider.notifier)
                  .setSearchQuery(value),
              hintText: 'Search product by name, company, contact, or notes...',
            ),

            const SizedBox(height: 32),

            // // Summary Cards
            // productsAsyncValue.when(
            //   data: (products) {
            //     if (products.isEmpty) {
            //       return SizedBox(
            //         height: 120,
            //         child: Center(
            //           child: Text(
            //             'No products yet. Click "Add Product" to get started.',
            //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //               color: AppColors.textGrey,
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //     return Row(
            //       children: [
            //         Expanded(
            //           child: _buildSummaryCard(
            //             title: 'Total Products',
            //             value: products.length.toString(),
            //             subtitleLabel: 'PRODUCTS',
            //             icon: Icons.shopping_cart,
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            //   error: (err, _) => Container(
            //     padding: const EdgeInsets.all(24),
            //     decoration: BoxDecoration(
            //       color: AppColors.textWhite,
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(
            //         color: AppColors.dividerColor.withValues(alpha: 0.5),
            //       ),
            //     ),
            //     child: Center(
            //       child: Text(
            //         'Error loading products: $err',
            //         style: TextStyle(color: AppColors.errorText),
            //       ),
            //     ),
            //   ),
            //   loading: () => Container(
            //     padding: const EdgeInsets.all(24),
            //     decoration: BoxDecoration(
            //       color: AppColors.textWhite,
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(
            //         color: AppColors.dividerColor.withValues(alpha: 0.5),
            //       ),
            //     ),
            //     child: const Center(child: CircularProgressIndicator()),
            //   ),
            // ),
            // const SizedBox(height: 48),

            // Products List
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Products'),
                        Tab(text: 'Sets'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Products Page
                          productsAsyncValue.when(
                            data: (products) {
                              // Apply search filter
                              var filteredProducts = products;
                              if (searchQuery.trim().isNotEmpty) {
                                final query = searchQuery.trim().toLowerCase();
                                filteredProducts = products.where((p) {
                                  final name = p.name.toLowerCase();
                                  final description = (p.description ?? '')
                                      .toLowerCase();
                                  return name.contains(query) ||
                                      description.contains(query);
                                }).toList();
                              }

                              if (filteredProducts.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No products found.',
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                );
                              }
                              if (products.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No products found.',
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                );
                              }

                              return ListView.separated(
                                itemCount: filteredProducts.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final prod =
                                      filteredProducts[index]; // use filtered list here

                                  return _ProductListItem(
                                    product: prod,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ProductDetailPage(product: prod),
                                        ),
                                      );
                                    },
                                    onAddStock: () {
                                      _recordTransaction(
                                        context,
                                        ref,
                                        prod.id,
                                        transactionType: 'IN',
                                      );
                                    },
                                    onRemoveStock: () {
                                      _recordTransaction(
                                        context,
                                        ref,
                                        prod.id,
                                        transactionType: 'OUT',
                                      );
                                    },
                                    onEdit: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AddProductDialog(
                                          productToEdit: prod,
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      _showDeleteConfirmation(
                                        context,
                                        ref,
                                        prod,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (err, _) => Center(
                              child: Text(
                                'Error loading products: $err',
                                style: const TextStyle(
                                  color: AppColors.errorText,
                                ),
                              ),
                            ),
                          ),

                          // Sets Page
                          setAsyncValue.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (err, _) => Center(
                              child: Text(
                                'Error loading products: $err',
                                style: const TextStyle(
                                  color: AppColors.errorText,
                                ),
                              ),
                            ),
                            data: (sets) {
                              var filteredSets = sets;
                              if (searchQuery.trim().isNotEmpty) {
                                final query = searchQuery.trim().toLowerCase();
                                filteredSets = sets
                                    .where(
                                      (s) =>
                                          s.name.toLowerCase().contains(query),
                                    )
                                    .toList();
                              }

                              if (filteredSets.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No product sets found.',
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                );
                              }
                              return ListView.separated(
                                itemCount: filteredSets.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final set = filteredSets[index];
                                  return _ProductSetListItem(
                                    set: set,
                                    onTap: () {
                                      // navigate to set detail page if you have one
                                    },
                                    onEdit: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            AddProductsetDialog(setToEdit: set),
                                      );
                                    },
                                    onDelete: () {
                                      _showDeleteSetConfirmation(
                                        context,
                                        ref,
                                        set,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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

  void _showDeleteSetConfirmation(
    BuildContext context,
    WidgetRef ref,
    ProductSetEntity set,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product Set'),
        content: Text(
          'Are you sure you want to delete "${set.name}"? This action cannot be undone.',
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
                if (set.setId == null) return;
                await ref
                    .read(productRepositoryProvider)
                    .deleteProductSet(set.setId!);
                ref.invalidate(getAllProductSetsProvider);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product set deleted successfully'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting product set: $e')),
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
    final result = await showInventoryTransactionDialog(
      context: context,
      transactionType: transactionType,
    );

    if (result == null) return;

    final repository = ref.read(inventoryRepositoryProvider);
    try {
      if (transactionType == 'IN') {
        await repository.recordIn(
          productId,
          'PRODUCT',
          result.quantity,
          notes: result.notes,
          transactionDate: result.transactionDate,
        );
      } else {
        await repository.recordOut(
          productId,
          'PRODUCT',
          result.quantity,
          notes: result.notes,
          transactionDate: result.transactionDate,
        );
      }

      ref.invalidate(
        inventoryTransactionsForItemProvider(productId, 'PRODUCT'),
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

class _ProductSetListItem extends StatelessWidget {
  final dynamic set;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductSetListItem({
    required this.set,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                    set.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${set.products.length} products',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
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

class _ProductListItem extends ConsumerWidget {
  final dynamic product;
  final VoidCallback onTap;
  final VoidCallback onAddStock;
  final VoidCallback onRemoveStock;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductListItem({
    required this.product,
    required this.onTap,
    required this.onAddStock,
    required this.onRemoveStock,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(
      inventoryTransactionsForItemProvider(product.id, 'PRODUCT'),
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
                child: Icon(Icons.shopping_bag, color: AppColors.textGrey),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (product.description != null &&
                      product.description!.isNotEmpty)
                    Text(
                      product.description ?? '',
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
                      children: [Icon(Icons.delete), Text('Remove')],
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
                    error: (_, _) => const Text(
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
