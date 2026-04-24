import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:ledgerly/features/client/presentation/providers/client_providers.dart';
import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/orders/presentation/pages/add_order_dialog.dart';
import 'package:ledgerly/features/orders/presentation/pages/order_details_page.dart';
import 'package:ledgerly/features/orders/presentation/providers/order_providers.dart';

class OrderDashboard extends ConsumerStatefulWidget {
  const OrderDashboard({super.key});

  @override
  ConsumerState<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends ConsumerState<OrderDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(getAllOrdersProvider);
    final clientsAsync = ref.watch(getAllClientsProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DashboardHeader(
              totalVolumeLabel: ordersAsync.maybeWhen(
                data: (orders) => _currency(_totalVolume(orders)),
                orElse: () => '--',
              ),
              onCreateOrder: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => const AddOrderDialog(),
                );
              },
            ),
            const SizedBox(height: 20),
            _FilterBar(
              searchController: _searchController,
              statusFilter: _statusFilter,
              onStatusChanged: (value) {
                setState(() {
                  _statusFilter = value;
                });
              },
              onSearchChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ordersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load orders: $error',
                    style: const TextStyle(color: AppColors.errorText),
                  ),
                ),
                data: (orders) {
                  final clients =
                      clientsAsync.asData?.value ?? const <ClientEntity>[];
                  final clientsById = {for (final c in clients) c.id: c};
                  final filtered = _applyFilters(orders, clientsById);

                  if (filtered.isEmpty) {
                    return const _EmptyOrdersView();
                  }

                  return _OrdersList(
                    orders: filtered,
                    clientsById: clientsById,
                    onTap: (order) {
                      final selectedClient = clientsById[order.customerId];
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => OrderDetailsPage(
                            order: order,
                            client: selectedClient,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<OrderEntity> _applyFilters(
    List<OrderEntity> orders,
    Map<int, ClientEntity> clientsById,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    return orders.where((order) {
      final status = (order.status ?? 'pending').toLowerCase();
      if (_statusFilter != 'all' && status != _statusFilter) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      final client = clientsById[order.customerId];
      final customerLabel = client?.clientName.toLowerCase() ?? '';
      final orderLabel = order.id?.toString() ?? '';

      return customerLabel.contains(query) || orderLabel.contains(query);
    }).toList();
  }

  static double _totalVolume(List<OrderEntity> orders) {
    return orders.fold<double>(
      0,
      (sum, order) =>
          sum +
          order.items.fold<double>(
            0,
            (inner, item) => inner + item.price * item.quantity,
          ),
    );
  }

  static String _currency(double value) => 'PKR ${value.toStringAsFixed(2)}';
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.totalVolumeLabel,
    required this.onCreateOrder,
  });

  final String totalVolumeLabel;
  final VoidCallback onCreateOrder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textBlack,
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text(
                    'TOTAL ',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    totalVolumeLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            ElevatedButton.icon(
              onPressed: onCreateOrder,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('New Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.searchController,
    required this.statusFilter,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final String statusFilter;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by order id or client name',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.lightBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              initialValue: statusFilter,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
              ],
              onChanged: (value) {
                if (value != null) {
                  onStatusChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.clientsById,
    required this.onTap,
  });

  final List<OrderEntity> orders;
  final Map<int, ClientEntity> clientsById;
  final ValueChanged<OrderEntity> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = orders[index];
        final client = clientsById[order.customerId];
        final total = order.items.fold<double>(
          0,
          (sum, item) => sum + item.price * item.quantity,
        );

        return InkWell(
          onTap: () => onTap(order),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    '#AL-${order.id ?? '---'}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: Text(
                    client?.clientName ?? 'Client #${order.customerId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 145,
                  child: Text(
                    order.createdAt == null
                        ? 'Unknown date'
                        : '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}',
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    'PKR ${total.toStringAsFixed(2)}',
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 16),
                _StatusPill(status: order.status ?? 'pending'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    Color bg = AppColors.lightBackground;
    Color fg = AppColors.textGrey;

    if (normalized == 'delivered') {
      bg = Colors.green.shade50;
      fg = Colors.green.shade700;
    } else if (normalized == 'pending') {
      bg = Colors.orange.shade50;
      fg = Colors.orange.shade800;
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
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long, size: 48, color: AppColors.dividerColor),
          const SizedBox(height: 12),
          const Text(
            'No orders found for this filter.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try changing the search text or status filter.',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
