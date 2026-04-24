import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:ledgerly/features/client/presentation/providers/client_providers.dart';
import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';

class OrderDetailsPage extends ConsumerWidget {
  const OrderDetailsPage({required this.order, this.client, super.key});

  final OrderEntity order;
  final ClientEntity? client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallbackClientAsync = ref.watch(getAllClientsProvider);
    final productsAsync = ref.watch(getAllProductsProvider);

    final resolvedClient =
        client ??
        fallbackClientAsync.asData?.value.firstWhere(
          (c) => c.id == order.customerId,
          orElse: () => ClientEntity(
            id: order.customerId,
            clientName: 'Client #${order.customerId}',
            contactNumber: '-',
            clientAddress: '-',
            department: '-',
            createdAt: DateTime.now(),
            isActive: true,
          ),
        );

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.textWhite,
        foregroundColor: AppColors.textBlack,
        title: Text('Order #AL-${order.id ?? '---'}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 980;
          final details = _OrderTotals.from(order);

          if (!isWide) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderHeader(order: order),
                  const SizedBox(height: 14),
                  _OrderItemsCard(order: order, productsAsync: productsAsync),
                  const SizedBox(height: 14),
                  _CustomerCard(client: resolvedClient),
                  const SizedBox(height: 14),
                  _TotalsCard(totals: details),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OrderHeader(order: order),
                      const SizedBox(height: 14),
                      Expanded(
                        child: _OrderItemsCard(
                          order: order,
                          productsAsync: productsAsync,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _CustomerCard(client: resolvedClient),
                      const SizedBox(height: 14),
                      _TotalsCard(totals: details),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #AL-${order.id ?? '---'}',
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _OrderStatusChip(status: order.status ?? 'pending'),
            const SizedBox(width: 8),
            Text(
              order.createdAt == null
                  ? 'Date unavailable'
                  : 'Placed on ${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}',
              style: const TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),
      ],
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  const _OrderItemsCard({required this.order, required this.productsAsync});

  final OrderEntity order;
  final AsyncValue<List<ProductEntity>> productsAsync;

  @override
  Widget build(BuildContext context) {
    final productNameById = <int, String>{};
    final products = productsAsync.asData?.value ?? const <ProductEntity>[];
    for (final p in products) {
      productNameById[p.id] = p.name;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text(
                '${order.items.length} items total',
                style: const TextStyle(color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: order.items.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: AppColors.dividerColor.withValues(alpha: 0.6),
              ),
              itemBuilder: (context, index) {
                final item = order.items[index];
                final productLabel =
                    productNameById[item.productId] ??
                    'Product #${item.productId}';
                final lineTotal = item.price * item.quantity;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Qty: ${item.quantity} · Unit: \$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${lineTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.client});

  final ClientEntity? client;

  @override
  Widget build(BuildContext context) {
    final label = client?.clientName ?? 'Unknown client';
    final initials = label.isNotEmpty ? label[0].toUpperCase() : '?';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Details',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      client?.department ?? '-',
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoRow(label: 'Phone', value: client?.contactNumber ?? '-'),
          _InfoRow(label: 'Address', value: client?.clientAddress ?? '-'),
          _InfoRow(
            label: 'Status',
            value: (client?.isActive ?? false) ? 'Active' : 'Inactive',
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.totals});

  final _OrderTotals totals;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            label: 'Subtotal',
            value: '\$${totals.subtotal.toStringAsFixed(2)}',
          ),
          _InfoRow(
            label: 'Tax (5%)',
            value: '\$${totals.tax.toStringAsFixed(2)}',
          ),
          Divider(
            color: AppColors.dividerColor.withValues(alpha: 0.6),
            height: 18,
          ),
          _InfoRow(
            label: 'Total Amount',
            value: '\$${totals.total.toStringAsFixed(2)}',
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: emphasized ? 18 : 14,
      fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
      color: emphasized ? AppColors.textBlack : AppColors.textBlack87,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: emphasized ? AppColors.textBlack : AppColors.textGrey,
                fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _OrderStatusChip extends StatelessWidget {
  const _OrderStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    Color bg = Colors.orange.shade50;
    Color fg = Colors.orange.shade700;

    if (normalized == 'delivered') {
      bg = Colors.green.shade50;
      fg = Colors.green.shade700;
    } else if (normalized == 'confirmed') {
      bg = Colors.blue.shade50;
      fg = Colors.blue.shade700;
    } else if (normalized == 'cancelled') {
      bg = Colors.red.shade50;
      fg = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _OrderTotals {
  const _OrderTotals({
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  final double subtotal;
  final double tax;
  final double total;

  factory _OrderTotals.from(OrderEntity order) {
    final subtotal = order.items.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
    final tax = subtotal * 0.05;
    return _OrderTotals(subtotal: subtotal, tax: tax, total: subtotal + tax);
  }
}
