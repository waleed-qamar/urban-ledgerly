import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:ledgerly/features/client/presentation/providers/client_providers.dart';
import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/orders/presentation/providers/order_providers.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';

// Available order statuses
const _kOrderStatuses = [('pending', 'Pending'), ('completed', 'Completed')];

/// Resolves status → color pair.
(Color bg, Color fg) _statusColors(String status) {
  final normalized = status.toLowerCase();
  if (normalized == 'completed') {
    return (Colors.green.shade50, Colors.green.shade700);
  } else if (normalized == 'pending') {
    return (Colors.blue.shade50, Colors.orange.shade800);
  }
  return (Colors.orange.shade50, Colors.orange.shade800);
}

class OrderDetailsPage extends ConsumerStatefulWidget {
  const OrderDetailsPage({required this.order, this.client, super.key});

  final OrderEntity order;
  final ClientEntity? client;

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  late OrderEntity _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  void _onStatusChanged(String newStatus) {
    setState(() {
      _order = _order.copyWith(status: newStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fallbackClientAsync = ref.watch(getAllClientsProvider);
    final productsAsync = ref.watch(getAllProductsProvider);

    final resolvedClient =
        widget.client ??
        fallbackClientAsync.asData?.value.firstWhere(
          (c) => c.id == _order.clientId,
          orElse: () => ClientEntity(
            id: _order.clientId,
            clientName: 'Client #${_order.clientId}',
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
        title: Text('Order #ORD-${_order.id ?? '---'}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 980;
          final details = _OrderTotals.from(_order);

          if (!isWide) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderHeader(
                    order: _order,
                    onStatusChanged: _onStatusChanged,
                  ),
                  const SizedBox(height: 14),
                  _OrderItemsCard(order: _order, productsAsync: productsAsync),
                  const SizedBox(height: 14),
                  _clientCard(client: resolvedClient),
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
                      _OrderHeader(
                        order: _order,
                        onStatusChanged: _onStatusChanged,
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: _OrderItemsCard(
                          order: _order,
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
                      _clientCard(client: resolvedClient),
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
  const _OrderHeader({required this.order, required this.onStatusChanged});

  final OrderEntity order;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #ORD-${order.id ?? '---'}',
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _StatusChipButton(order: order, onStatusChanged: onStatusChanged),
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
                              'Qty: ${item.quantity} · Unit: PKR ${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'PKR ${lineTotal.toStringAsFixed(2)}',
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

class _clientCard extends StatelessWidget {
  const _clientCard({required this.client});

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
            'client Details',
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
            value: 'PKR ${totals.subtotal.toStringAsFixed(2)}',
          ),
          _InfoRow(
            label: 'Tax (5%)',
            value: 'PKR ${totals.tax.toStringAsFixed(2)}',
          ),
          Divider(
            color: AppColors.dividerColor.withValues(alpha: 0.6),
            height: 18,
          ),
          _InfoRow(
            label: 'Total Amount',
            value: 'PKR ${totals.total.toStringAsFixed(2)}',
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

/// Interactive status chip shown in the order details header.
/// Tapping it presents a popup to change the order status.
class _StatusChipButton extends ConsumerWidget {
  const _StatusChipButton({required this.order, required this.onStatusChanged});

  final OrderEntity order;
  final ValueChanged<String> onStatusChanged;

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    String newStatus,
  ) async {
    if (newStatus == (order.status ?? 'pending')) return;
    // Read the repo BEFORE any await so we hold a stable reference.
    final repo = ref.read(orderRepositoryProvider);
    try {
      final existing = await repo.getOrderById(order.id!);
      await repo.updateOrder(existing.copyWith(status: newStatus));
      ref.invalidate(getAllOrdersProvider);
      onStatusChanged(newStatus);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: AppColors.errorText,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = order.status ?? 'pending';
    final (bg, fg) = _statusColors(status);

    return PopupMenuButton<String>(
      tooltip: 'Change status',
      onSelected: (value) => _changeStatus(context, ref, value),
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => _kOrderStatuses
          .map(
            (s) => PopupMenuItem<String>(
              value: s.$1,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _statusColors(s.$1).$2,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.$2,
                    style: TextStyle(
                      fontWeight: s.$1 == status
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: s.$1 == status
                          ? _statusColors(s.$1).$2
                          : AppColors.textBlack87,
                    ),
                  ),
                  if (s.$1 == status) ...[
                    const Spacer(),
                    Icon(Icons.check, size: 14, color: _statusColors(s.$1).$2),
                  ],
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status.toUpperCase(),
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: fg),
          ],
        ),
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
