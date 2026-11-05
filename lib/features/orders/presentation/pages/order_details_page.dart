import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/core/widgets/audit_log_list_widget.dart';
import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:ledgerly/features/client/presentation/providers/client_providers.dart';
import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/orders/domain/entities/order_item_entity.dart';
import 'package:ledgerly/features/orders/domain/entities/supplier_entity.dart';
import 'package:ledgerly/features/orders/presentation/providers/order_providers.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_entity.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';
import 'package:ledgerly/features/auth/presentation/provider/current_employee_provider.dart';
import 'add_order_dialog.dart';

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
  const OrderDetailsPage({
    required this.order,
    this.client,
    super.key,
    required this.supplier,
  });

  final OrderEntity order;
  final ClientEntity? client;
  final SupplierEntity supplier;

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  late OrderEntity _order;
  late SupplierEntity _supplier;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _supplier = widget.supplier;
  }

  void _onStatusChanged(String newStatus) {
    setState(() {
      _order = _order.copyWith(status: newStatus);
    });
  }

  Future<void> _openEditOrderDialog() async {
    final updated = await showDialog<OrderEntity>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddOrderDialog(order: _order),
    );

    if (updated != null && mounted) {
      setState(() {
        _order = updated;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order updated successfully.')),
      );
    }
  }

  Future<void> _handleDeleteOrder() async {
    final canDelete = ref.read(hasPermissionProvider('orders.delete')) ||
        ref.read(isMasterProvider);
    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have permission to delete orders.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Order'),
        content: Text(
          'Delete Order #ORD-${_order.id}?\n\n'
          'This will also permanently delete all linked invoices and invoice items. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(deleteOrderProvider(_order.id!).future);
      ref.invalidate(getAllOrdersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order and linked invoices deleted.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackClientAsync = ref.watch(getAllClientsProvider);
    final productsAsync = ref.watch(getAllProductsProvider);
    final setsAsync = ref.watch(getAllProductSetsProvider);

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
              ),
              onPressed: _openEditOrderDialog,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Order'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              onPressed: _handleDeleteOrder,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 980;
          final details = _OrderTotals.from(_order);
          final historyCard = Card(
            elevation: 5,
            child: Container(
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
                    'Order Activity History',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuditLogListWidget(
                    tableName: 'orders',
                    recordId: _order.id.toString(),
                  ),
                ],
              ),
            ),
          );

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
                  _OrderItemsCard(
                    order: _order,
                    productsAsync: productsAsync,
                    setsAsync: setsAsync,
                  ),
                  const SizedBox(height: 14),
                  _ClientCard(client: resolvedClient),
                  const SizedBox(height: 14),
                  _SupplierCard(supplier: _supplier),
                  const SizedBox(height: 14),
                  _TotalsCard(totals: details),
                  const SizedBox(height: 14),
                  historyCard,
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
                          setsAsync: setsAsync,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _ClientCard(client: resolvedClient),
                        const SizedBox(height: 14),
                        _SupplierCard(supplier: _supplier),
                        const SizedBox(height: 14),
                        _TotalsCard(totals: details),
                        const SizedBox(height: 14),
                        historyCard,
                      ],
                    ),
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

class _EditOrderDialog extends ConsumerStatefulWidget {
  const _EditOrderDialog({required this.order});

  final OrderEntity order;

  @override
  ConsumerState<_EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends ConsumerState<_EditOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _departmentController;
  late final TextEditingController _poController;
  late String _status;
  bool _isSaving = false;

  late final List<_EditableOrderLine> _lines;

  @override
  void initState() {
    super.initState();
    _departmentController = TextEditingController(
      text: widget.order.department ?? '',
    );
    _poController = TextEditingController(text: widget.order.po ?? '');
    _status = widget.order.status ?? 'pending';
    _lines = widget.order.items
        .map(
          (item) => _EditableOrderLine(
            id: item.id,
            productId: item.productId,
            setId: item.setId,
            isSet: item.isSet,
            quantity: item.quantity,
            unitPrice: item.price,
            invoicedQuantity: item.invoicedQuantity,
          ),
        )
        .toList();

    if (_lines.isEmpty) {
      _lines.add(_EditableOrderLine(quantity: 1, unitPrice: 0));
    }
  }

  @override
  void dispose() {
    _departmentController.dispose();
    _poController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final items = <OrderItemEntity>[];
    for (final line in _lines) {
      if (line.isSet) {
        if (line.setId == null) {
          _showError('Each row must have a selected set.');
          return;
        }
      } else {
        if (line.productId == null) {
          _showError('Each row must have a selected product.');
          return;
        }
      }

      if (line.quantity <= 0) {
        _showError('Quantity should be at least 1 in every row.');
        return;
      }
      if (line.unitPrice <= 0) {
        _showError('Price should be greater than 0 in every row.');
        return;
      }

      items.add(
        OrderItemEntity(
          id: line.id,
          productId: line.productId,
          setId: line.setId,
          isSet: line.isSet,
          quantity: line.quantity,
          price: line.unitPrice,
          invoicedQuantity: line.invoicedQuantity,
        ),
      );
    }

    final updatedOrder = widget.order.copyWith(
      items: items,
      department: _departmentController.text.trim().isEmpty
          ? null
          : _departmentController.text.trim(),
      po: _poController.text.trim().isEmpty ? null : _poController.text.trim(),
      status: _status,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(orderRepositoryProvider).updateOrder(updatedOrder);
      ref.invalidate(getAllOrdersProvider);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(updatedOrder);
    } catch (e) {
      _showError('Failed to update order: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.errorText),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(getAllProductsProvider);
    final setsAsync = ref.watch(getAllProductSetsProvider);

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 740,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: productsAsync.when(
            loading: () => const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SizedBox(
              height: 220,
              child: Center(
                child: Text(
                  'Unable to load products: $error',
                  style: const TextStyle(color: AppColors.errorText),
                ),
              ),
            ),
            data: (products) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Edit Order #ORD-${widget.order.id ?? '---'}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _departmentController,
                            enabled: !_isSaving,
                            decoration: const InputDecoration(
                              labelText: 'Department',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Enter a Department'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _poController,
                            enabled: !_isSaving,
                            decoration: const InputDecoration(
                              labelText: 'PO',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 170,
                          child: DropdownButtonFormField<String>(
                            initialValue: _status,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'pending',
                                child: Text('Pending'),
                              ),
                              DropdownMenuItem(
                                value: 'completed',
                                child: Text('Completed'),
                              ),
                            ],
                            onChanged: _isSaving
                                ? null
                                : (value) {
                                    if (value != null) {
                                      setState(() {
                                        _status = value;
                                      });
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Items',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: _isSaving
                                  ? null
                                  : () {
                                      setState(() {
                                        _lines.add(
                                          _EditableOrderLine(
                                            quantity: 1,
                                            unitPrice: 0,
                                            isSet: false,
                                          ),
                                        );
                                      });
                                    },
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Add Product'),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: _isSaving
                                  ? null
                                  : () {
                                      setState(() {
                                        _lines.add(
                                          _EditableOrderLine(
                                            quantity: 1,
                                            unitPrice: 0,
                                            isSet: true,
                                          ),
                                        );
                                      });
                                    },
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Add Set'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 320),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _lines.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final line = _lines[index];
                          return _EditableOrderLineRow(
                            line: line,
                            products: products,
                            setsAsync: setsAsync,
                            enabled: !_isSaving,
                            onChanged: () => setState(() {}),
                            onDelete: _lines.length == 1
                                ? null
                                : () {
                                    setState(() {
                                      _lines.removeAt(index);
                                    });
                                  },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total: PKR ${_lines.fold<double>(0, (sum, line) => sum + (line.quantity * line.unitPrice)).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: AppColors.textWhite,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          onPressed: _isSaving ? null : _submit,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.textWhite,
                                  ),
                                )
                              : const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EditableOrderLine {
  _EditableOrderLine({
    this.id,
    this.productId,
    this.setId,
    this.isSet = false,
    required this.quantity,
    required this.unitPrice,
    this.invoicedQuantity,
  });

  int? id;
  int? productId;
  int? setId;
  bool isSet;
  int quantity;
  double unitPrice;
  int? invoicedQuantity;
}

class _EditableOrderLineRow extends StatelessWidget {
  const _EditableOrderLineRow({
    required this.line,
    required this.products,
    required this.setsAsync,
    required this.enabled,
    required this.onChanged,
    required this.onDelete,
  });

  final _EditableOrderLine line;
  final List<ProductEntity> products;
  final AsyncValue<List<ProductSetEntity>> setsAsync;
  final bool enabled;
  final VoidCallback onChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: line.isSet ? 'set' : 'product',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'product', child: Text('Product')),
                    DropdownMenuItem(value: 'set', child: Text('Set')),
                  ],
                  onChanged: enabled
                      ? (val) {
                          if (val == null) return;
                          line.isSet = val == 'set';
                          line.productId = null;
                          line.setId = null;
                          onChanged();
                        }
                      : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: line.isSet ? line.setId : line.productId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Product / Set',
                  ),
                  items: line.isSet
                      ? setsAsync.when(
                          data: (sets) => sets
                              .map(
                                (s) => DropdownMenuItem<int>(
                                  value: s.setId,
                                  child: Text(
                                    s.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          loading: () => [
                            const DropdownMenuItem<int>(
                              value: -1,
                              child: Text('Loading'),
                            ),
                          ],
                          error: (_, _) => [
                            const DropdownMenuItem<int>(
                              value: -1,
                              child: Text('Error'),
                            ),
                          ],
                        )
                      : products
                            .map(
                              (p) => DropdownMenuItem<int>(
                                value: p.id,
                                child: Text(
                                  p.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                  validator: (value) =>
                      value == null || value == -1 ? 'Select item' : null,
                  onChanged: enabled
                      ? (value) {
                          if (value == null) return;
                          if (line.isSet) {
                            line.setId = value;
                            line.productId = null;
                          } else {
                            line.productId = value;
                            line.setId = null;
                          }
                          onChanged();
                        }
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: TextFormField(
              initialValue: line.quantity.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Qty',
              ),
              enabled: enabled,
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Invalid';
                }
                return null;
              },
              onChanged: (value) {
                line.quantity = int.tryParse(value) ?? 0;
                onChanged();
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 118,
            child: TextFormField(
              initialValue: line.unitPrice.toStringAsFixed(2),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Price',
                prefixText: 'PKR ',
              ),
              enabled: enabled,
              validator: (value) {
                final parsed = double.tryParse((value ?? '').trim());
                if (parsed == null || parsed <= 0) {
                  return 'Invalid';
                }
                return null;
              },
              onChanged: (value) {
                line.unitPrice = double.tryParse(value) ?? 0;
                onChanged();
              },
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: enabled ? onDelete : null,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
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
              'Placed on ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
              style: const TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),
      ],
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  const _OrderItemsCard({
    required this.order,
    required this.productsAsync,
    required this.setsAsync,
  });

  final OrderEntity order;
  final AsyncValue<List<ProductEntity>> productsAsync;
  final AsyncValue<List<ProductSetEntity>> setsAsync;

  @override
  Widget build(BuildContext context) {
    final productNameById = <int, String>{};
    final products = productsAsync.asData?.value ?? const <ProductEntity>[];
    for (final p in products) {
      productNameById[p.id] = p.name;
    }
    final setNameById = <int, String>{};
    final sets = setsAsync.asData?.value ?? const <ProductSetEntity>[];
    for (final s in sets) {
      if (s.setId != null) setNameById[s.setId!] = s.name;
    }

    return Card(
      elevation: 5,
      child: Container(
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
                  final productLabel = item.isSet
                      ? (setNameById[item.setId] ?? 'Set #${item.setId}')
                      : (productNameById[item.productId] ??
                            'Product #${item.productId}');
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
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            size: 18,
                          ),
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
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                ),
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
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({required this.client});

  final ClientEntity? client;

  @override
  Widget build(BuildContext context) {
    final label = client?.clientName ?? 'Unknown client';
    final initials = label.isNotEmpty ? label[0].toUpperCase() : '?';

    return Card(
      elevation: 5,
      child: Container(
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
              'Client Details',
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
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  final SupplierEntity supplier;
  const _SupplierCard({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
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
              'Supplier Details',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    supplier.name.isNotEmpty
                        ? supplier.name[0].toUpperCase()
                        : '?',
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
                        supplier.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      // Text(
                      //   client?.department ?? '-',
                      //   style: const TextStyle(color: AppColors.textGrey),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _InfoRow(label: 'Phone', value: supplier.contactInfo ?? '-'),
            _InfoRow(
              label: 'Address',
              value: supplier.address.isNotEmpty ? supplier.address : '-',
            ),
            _InfoRow(label: 'STRN Number', value: supplier.strnNo ?? '-'),
            _InfoRow(label: 'NTN Number', value: supplier.ntn ?? '-'),
          ],
        ),
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.totals});

  final _OrderTotals totals;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
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
              label: 'Total Amount',
              value: 'PKR ${totals.total.toStringAsFixed(2)}',
              emphasized: true,
            ),
          ],
        ),
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
  const _OrderTotals({required this.subtotal, required this.total});

  final double subtotal;
  final double total;

  factory _OrderTotals.from(OrderEntity order) {
    final subtotal = order.items.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
    return _OrderTotals(subtotal: subtotal, total: subtotal);
  }
}
