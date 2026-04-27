import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/client/domain/entities/client_entity.dart';
import 'package:ledgerly/features/client/presentation/providers/client_providers.dart';
import 'package:ledgerly/features/orders/domain/entities/order_entity.dart';
import 'package:ledgerly/features/orders/domain/entities/order_item_entity.dart';
import 'package:ledgerly/features/orders/domain/entities/supplier_entity.dart';
import 'package:ledgerly/features/orders/presentation/providers/order_providers.dart';
import 'package:ledgerly/features/orders/presentation/providers/supplier_providers.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';

class AddOrderDialog extends ConsumerStatefulWidget {
  const AddOrderDialog({super.key});

  @override
  ConsumerState<AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends ConsumerState<AddOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _discountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _poController = TextEditingController();
  final TextEditingController _deliveryTermsController =
      TextEditingController();

  int? _selectedSupplierId;
  int? _selectedClientId;
  DateTime _orderDate = DateUtils.dateOnly(DateTime.now());
  final String _status = 'pending';
  bool _isSubmitting = false;
  final List<_DraftOrderLine> _lines = [
    _DraftOrderLine(quantity: 1, unitPrice: 0),
  ];

  @override
  void initState() {
    super.initState();
    _orderDateController.text = _formatDate(_orderDate);
  }

  @override
  void dispose() {
    _discountController.dispose();
    _orderDateController.dispose();
    _departmentController.dispose();
    _poController.dispose();
    _deliveryTermsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(getAllClientsProvider);
    final suppliersAsync = ref.watch(getAllSuppliersProvider);
    final productsAsync = ref.watch(getAllProductsProvider);
    final ordersAsync = ref.watch(getAllOrdersProvider);

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 740,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: clientsAsync.when(
            loading: () => const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SizedBox(
              height: 240,
              child: Center(
                child: Text(
                  'Unable to load clients: $error',
                  style: const TextStyle(color: AppColors.errorText),
                ),
              ),
            ),
            data: (clients) {
              return suppliersAsync.when(
                loading: () => const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SizedBox(
                  height: 240,
                  child: Center(
                    child: Text(
                      'Unable to load suppliers: $error',
                      style: const TextStyle(color: AppColors.errorText),
                    ),
                  ),
                ),
                data: (suppliers) {
                  return productsAsync.when(
                    loading: () => const SizedBox(
                      height: 240,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => SizedBox(
                      height: 240,
                      child: Center(
                        child: Text(
                          'Unable to load products: $error',
                          style: const TextStyle(color: AppColors.errorText),
                        ),
                      ),
                    ),
                    data: (products) {
                      return _buildContent(
                        context,
                        clients,
                        suppliers,
                        products,
                        ordersAsync,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<ClientEntity> clients,
    List<SupplierEntity> suppliers,
    List<ProductEntity> products,
    AsyncValue<List<OrderEntity>> ordersAsync,
  ) {
    final subtotal = _calculateSubtotal();
    final discountPercent = _discountPercent;
    final total = subtotal * (1 - discountPercent / 100);
    final selectedSupplier = _supplierForId(suppliers, _selectedSupplierId);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'New Order',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ordersAsync.when(
                        loading: () => const Text(
                          'Order# ...',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        error: (_, _) => const Text(
                          'Order# N/A',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        data: (orders) {
                          final maxId = orders
                              .map((order) => order.id ?? 0)
                              .fold<int>(0, (max, id) => id > max ? id : max);
                          final nextId = maxId + 1;

                          return Text(
                            'Order# $nextId',
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _isSubmitting
                    ? null
                    : () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _selectedSupplierId,
                  decoration: const InputDecoration(
                    labelText: 'Supplier',
                    border: OutlineInputBorder(),
                  ),
                  items: suppliers
                      .map(
                        (supplier) => DropdownMenuItem<int>(
                          value: supplier.id,
                          child: Text(
                            supplier.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Select a Supplier' : null,
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          setState(() {
                            _selectedSupplierId = value;
                          });
                        },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _selectedClientId,
                  decoration: const InputDecoration(
                    labelText: 'Client',
                    border: OutlineInputBorder(),
                  ),
                  items: clients
                      .map(
                        (c) => DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.clientName),
                        ),
                      )
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Select a Client' : null,
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          setState(() {
                            _selectedClientId = value;
                          });
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selectedSupplier != null)
            _SupplierDetailsCard(supplier: selectedSupplier),
          if (selectedSupplier != null) const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _poController,
                  enabled: !_isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'PO',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                // width: 240,
                child: TextFormField(
                  controller: _orderDateController,
                  readOnly: true,
                  enabled: !_isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'Order Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  onTap: _isSubmitting
                      ? null
                      : () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _orderDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (selectedDate == null) {
                            return;
                          }

                          setState(() {
                            _orderDate = DateUtils.dateOnly(selectedDate);
                            _orderDateController.text = _formatDate(_orderDate);
                          });
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _departmentController,
                  enabled: !_isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a Department'
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _deliveryTermsController,
                  enabled: !_isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'Delivery Terms',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a Delivery Term'
                      : null,
                ),
              ),
              // Expanded(
              //   child: DropdownButtonFormField<String>(
              //     initialValue: _status,
              //     decoration: const InputDecoration(
              //       labelText: 'Status',
              //       border: OutlineInputBorder(),
              //     ),
              //     items: const [
              //       DropdownMenuItem(value: 'pending', child: Text('Pending')),
              //       DropdownMenuItem(
              //         value: 'completed',
              //         child: Text('Completed'),
              //       ),
              //     ],
              //     onChanged: _isSubmitting
              //         ? null
              //         : (value) {
              //             if (value != null) {
              //               setState(() {
              //                 _status = value;
              //               });
              //             }
              //           },
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product Details',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              TextButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        setState(() {
                          _lines.add(
                            _DraftOrderLine(quantity: 1, unitPrice: 0),
                          );
                        });
                      },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Row'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _lines.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _OrderLineEditor(
                    line: _lines[index],
                    products: products,
                    enabled: !_isSubmitting,
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
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: 190,
            child: TextFormField(
              controller: _discountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Discount %',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
              validator: (value) {
                final parsed = double.tryParse((value ?? '').trim());
                if (parsed == null || parsed < 0 || parsed > 100) {
                  return '0 - 100';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Total (after discount)',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'PKR ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _isSubmitting
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
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSubmitting
                    ? null
                    : () => _submit(context, products),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create Order'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateSubtotal() {
    return _lines.fold<double>(0, (sum, line) {
      return sum + (line.quantity * line.unitPrice);
    });
  }

  double get _discountPercent {
    final parsed = double.tryParse(_discountController.text.trim());
    if (parsed == null) {
      return 0;
    }
    if (parsed < 0) {
      return 0;
    }
    if (parsed > 100) {
      return 100;
    }
    return parsed;
  }

  Future<void> _submit(
    BuildContext context,
    List<ProductEntity> products,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final productById = {for (final p in products) p.id: p};
    final items = <OrderItemEntity>[];
    final department = _departmentController.text.trim();
    final _po = _poController.text.trim();
    final deliveryTerms = _deliveryTermsController.text.trim();

    for (final line in _lines) {
      final productId = line.productId;
      if (productId == null) {
        _showError('Each row must have a selected product.');
        return;
      }

      final product = productById[productId];
      if (product == null) {
        _showError('One selected product no longer exists. Refresh and retry.');
        return;
      }

      if (line.quantity <= 0) {
        _showError('Quantity should be at least 1 in every row.');
        return;
      }

      if (line.unitPrice <= 0) {
        _showError('Price should be greater than 0 in every row.');
        return;
      }

      final discountedUnitPrice = line.unitPrice * (1 - _discountPercent / 100);

      items.add(
        OrderItemEntity(
          productId: productId,
          quantity: line.quantity,
          price: discountedUnitPrice,
        ),
      );
    }

    if (_selectedClientId == null) {
      _showError('Please select a Client.');
      return;
    }

    if (_selectedSupplierId == null) {
      _showError('Please select a Supplier.');
      return;
    }

    if (department.isEmpty) {
      _showError('Please enter a Department.');
      return;
    }

    if (deliveryTerms.isEmpty) {
      _showError('Please enter Delivery Terms.');
      return;
    }

    final order = OrderEntity(
      supplierId: _selectedSupplierId!,
      clientId: _selectedClientId!,
      items: items,
      status: _status,
      department: department,
      deliveryTerm: deliveryTerms,
      po: _po.isEmpty ? null : _po,
      createdAt: _orderDate,
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(addOrderProvider(order).future);
      ref.invalidate(getAllOrdersProvider);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showError('Failed to create order: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.errorText),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  SupplierEntity? _supplierForId(List<SupplierEntity> suppliers, int? id) {
    if (id == null) {
      return null;
    }
    for (final supplier in suppliers) {
      if (supplier.id == id) {
        return supplier;
      }
    }
    return null;
  }
}

class _SupplierDetailsCard extends StatelessWidget {
  const _SupplierDetailsCard({required this.supplier});

  final SupplierEntity supplier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            supplier.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          _DetailRow(label: 'Address', value: supplier.address),
          _DetailRow(label: 'Contact', value: supplier.contactInfo ?? '-'),
          _DetailRow(label: 'STRN', value: supplier.strnNo ?? '-'),
          _DetailRow(label: 'NTN', value: supplier.ntn ?? '-'),
          // _DetailRow(label: 'Delivery Terms', value: supplier.deliveryTerms),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderLineEditor extends StatelessWidget {
  const _OrderLineEditor({
    required this.line,
    required this.products,
    required this.enabled,
    required this.onChanged,
    required this.onDelete,
  });

  final _DraftOrderLine line;
  final List<ProductEntity> products;
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
            child: DropdownButtonFormField<int>(
              initialValue: line.productId,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Product',
              ),
              items: products
                  .map(
                    (p) => DropdownMenuItem<int>(
                      value: p.id,
                      child: Text(p.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              validator: (value) => value == null ? 'Select product' : null,
              onChanged: enabled
                  ? (value) {
                      line.productId = value;
                      onChanged();
                    }
                  : null,
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
              // initialValue: line.unitPrice.toStringAsFixed(2),
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

class _DraftOrderLine {
  _DraftOrderLine({required this.quantity, required this.unitPrice});

  int? productId;
  int quantity;
  double unitPrice;
}
