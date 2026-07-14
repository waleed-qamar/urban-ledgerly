import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../products/domain/entities/product_set_entity.dart';
import '../providers/invoice_providers.dart';
import '../../../orders/presentation/providers/supplier_providers.dart';
import '../../../orders/presentation/providers/order_providers.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';

class AddInvoiceDialog extends ConsumerStatefulWidget {
  final OrderEntity order;
  const AddInvoiceDialog({super.key, required this.order});

  @override
  ConsumerState<AddInvoiceDialog> createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends ConsumerState<AddInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _shippingController = TextEditingController(text: '0');
  final _representativeController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();

  final _clientStrnController = TextEditingController();
  final _clientNtnController = TextEditingController();
  final _supplierStrnController = TextEditingController();
  final _supplierNtnController = TextEditingController();
  final _advanceController = TextEditingController(text: '0');
  
  String _invoiceType = 'sales_tax'; // 'sales_tax' or 'commercial'
  bool _isSubmitting = false;
  bool _applyGst = true;

  late List<_InvoiceLine> _lines;
  DateTime _orderDate = DateUtils.dateOnly(DateTime.now());

  @override
  void initState() {
    super.initState();
    _orderDateController.text = _formatDate(_orderDate);
    // Initialize lines derived from order items
    _lines = widget.order.items.map((item) {
      final invoicedQty = item.invoicedQuantity ?? 0;
      final remaining = (item.quantity - invoicedQty);
      final effectiveRemaining = remaining < 0 ? 0 : remaining;

      return _InvoiceLine(
        orderItemId: item.id ?? 0,
        productId: item.productId,
        setId: item.setId,
        isSet: item.isSet,
        quantity: effectiveRemaining.toInt(),
        remainingQty: effectiveRemaining.toInt(),
        unitPrice: item.price,
      );
    }).toList();
  }

  @override
  void dispose() {
    _shippingController.dispose();
    _representativeController.dispose();
    _orderDateController.dispose();
    _clientStrnController.dispose();
    _clientNtnController.dispose();
    _supplierStrnController.dispose();
    _supplierNtnController.dispose();
    _advanceController.dispose();
    super.dispose();
  }

  String _getClientInitials(String? clientName) {
    if (clientName == null || clientName.trim().isEmpty) return 'XX';
    final RegExp wordRegex = RegExp(r'\b[a-zA-Z0-9]');
    final matches = wordRegex.allMatches(clientName);
    final initials = matches.map((m) => m.group(0)!.toUpperCase()).join('');
    return initials.isEmpty ? 'XX' : initials;
  }

  String detectSupplierStyle(String supplierName) {
    final lower = supplierName.toLowerCase();
    if (lower.contains('composites')) return 'urban_composites';
    if (lower.contains('constructions')) return 'urban_constructions';
    if (lower.contains('encore')) return 'encore_enterprises';
    return 'encore_enterprises';
  }

  double get _subTotal {
    return _lines.fold(
      0,
      (sum, line) => sum + (line.quantity * line.unitPrice),
    );
  }

  double get _shippingCost => double.tryParse(_shippingController.text) ?? 0.0;

  double get _taxAmount => (_invoiceType == 'sales_tax' && _applyGst)
      ? (_subTotal + _shippingCost) * 0.18
      : 0.0;

  double get _grandTotal => _subTotal + _shippingCost + _taxAmount;

  double get _advanceAmount => double.tryParse(_advanceController.text) ?? 0.0;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(getAllProductsProvider);
    final clients = ref.watch(getAllClientsProvider).asData?.value ?? const <dynamic>[];
    final clientById = {for (var c in clients) c.id: c};
    final client = clientById[widget.order.clientId];
    final clientName = client?.clientName ?? '';
    final initials = _getClientInitials(clientName);

    final nextNumberAsync = ref.watch(nextInvoiceNumberProvider(widget.order.clientId, initials));

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 850,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: productsAsync.when(
            loading: () => const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                SizedBox(height: 240, child: Center(child: Text('Error: $e'))),
            data: (products) {
              return nextNumberAsync.when(
                loading: () => const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SizedBox(
                  height: 240,
                  child: Center(
                    child: Text('Error generating invoice number: $e'),
                  ),
                ),
                data: (nextInvoiceNo) {
                  final productById = {for (var p in products) p.id: p};
                  final sets =
                      ref.watch(getAllProductSetsProvider).asData?.value ??
                      const <ProductSetEntity>[];
                  final setById = {for (var s in sets) s.setId: s};
                  return _buildContent(
                    context,
                    nextInvoiceNo,
                    productById,
                    widget.order,
                    setById,
                    client,
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
    String invoiceNo,
    Map<int, dynamic> productById,
    OrderEntity order,
    Map<int?, ProductSetEntity> setById,
    dynamic client,
  ) {
    final suppliers =
        ref.watch(getAllSuppliersProvider).asData?.value ?? const <dynamic>[];
    final supplierById = {for (var s in suppliers) s.id: s};
    final supplier = supplierById[widget.order.supplierId];

    if (supplier != null && _supplierStrnController.text.isEmpty && _supplierNtnController.text.isEmpty) {
      _supplierStrnController.text = supplier.strnNo ?? '';
      _supplierNtnController.text = supplier.ntn ?? '';
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Generate Invoice: $invoiceNo',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #: ${widget.order.id}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'PO: ${widget.order.po ?? "N/A"}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _orderDateController,
                    readOnly: true,
                    enabled: !_isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Invoice Date',
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _invoiceType,
                    decoration: const InputDecoration(
                      labelText: 'Invoice Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sales_tax', child: Text('Sales Tax Invoice')),
                      DropdownMenuItem(value: 'commercial', child: Text('Commercial Invoice')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _invoiceType = val;
                          if (_invoiceType == 'commercial') {
                            _applyGst = false;
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Supplier Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(supplier != null ? supplier.name : 'Unknown Supplier'),
                      Text(supplier != null ? supplier.address : ''),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _supplierStrnController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier STRN',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _supplierNtnController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier NTN',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buyer Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(client != null ? client.clientName ?? 'Unknown Client' : 'Unknown Client'),
                      Text(client != null ? (client.clientAddress ?? '') : ''),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _clientStrnController,
                        decoration: const InputDecoration(
                          labelText: 'Buyer STRN',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _clientNtnController,
                        decoration: const InputDecoration(
                          labelText: 'Buyer NTN',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Invoice Lines',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _lines.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final line = _lines[index];
                final product = line.isSet ? null : productById[line.productId];

                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        line.isSet
                            ? (setById[line.setId]?.name ?? 'Set #${line.setId}')
                            : (product?.name ?? 'Unknown Product'),
                      ),
                    ),
                    Expanded(child: Text('Remain: ${line.remainingQty}')),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: line.quantity.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Invoice Qty',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final parsed = int.tryParse(value ?? '');
                          if (parsed == null || parsed < 0) return 'Invalid';
                          if (parsed > line.remainingQty) return 'Exceeds Rem.';
                          return null;
                        },
                        onChanged: (val) => setState(
                          () => line.quantity = int.tryParse(val) ?? 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'PKR ${(line.quantity * line.unitPrice).toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _representativeController,
              decoration: const InputDecoration(
                labelText: 'Representative',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _SummaryCard(
              subTotal: _subTotal,
              invoiceType: _invoiceType,
              shippingWidget: TextFormField(
                controller: _shippingController,
                decoration: const InputDecoration(
                  labelText: 'Shipping Cost',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              taxAmount: _taxAmount,
              grandTotal: _grandTotal,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _advanceController,
                    decoration: const InputDecoration(
                      labelText: 'Advance Payment',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'Balance: PKR ${(_grandTotal - _advanceAmount).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_invoiceType == 'sales_tax')
              Row(
                children: [
                  const Text('Apply GST (18%)'),
                  const SizedBox(width: 12),
                  Switch(
                    value: _applyGst,
                    onChanged: (v) => setState(() => _applyGst = v),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () => _submit(invoiceNo, _orderDate, productById, setById, client, supplier),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Invoice'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(
    String invoiceNo,
    DateTime selectedDate,
    Map<int, dynamic> productById,
    Map<int?, ProductSetEntity> setById,
    dynamic client,
    dynamic supplier,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final activeLines = _lines.where((l) => l.quantity > 0).toList();
    if (activeLines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice must contain at least 1 item.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final invoiceItems = activeLines
          .map(
            (l) {
              final product = l.isSet ? null : productById[l.productId];
              final description = l.isSet
                  ? (setById[l.setId]?.description ?? setById[l.setId]?.name ?? '')
                  : (product?.description ?? product?.name ?? '');

              return InvoiceItemEntity(
                orderItemId: l.orderItemId,
                productId: l.productId,
                setId: l.setId,
                isSet: l.isSet,
                quantity: l.quantity,
                unitPrice: l.unitPrice,
                totalPrice: l.quantity * l.unitPrice,
                description: description,
                unitType: 'Each',
              );
            },
          )
          .toList();

      final invoice = InvoiceEntity(
        orderId: widget.order.id!,
        clientId: widget.order.clientId,
        supplierId: widget.order.supplierId,
        invoiceNumber: invoiceNo,
        status: 'undispatched',
        representative: _representativeController.text,
        po: widget.order.po,
        issueDate: selectedDate,
        subTotal: _subTotal,
        shippingCost: _shippingCost,
        taxPercent: (_invoiceType == 'sales_tax' && _applyGst) ? 18.0 : 0.0,
        taxAmount: _taxAmount,
        grandTotal: _grandTotal,
        items: invoiceItems,
        dispatchedAt: DateTime(1996, 01, 01),
        supplierName: supplier?.name ?? 'Unknown Supplier',
        supplierAddress: supplier?.address ?? '',
        supplierStrn: _supplierStrnController.text,
        supplierNtn: _supplierNtnController.text,
        clientName: client?.clientName ?? 'Unknown Client',
        clientAddress: client?.clientAddress ?? '',
        clientStrn: _clientStrnController.text,
        clientNtn: _clientNtnController.text,
        advanceAmount: _advanceAmount,
        balanceAmount: _grandTotal - _advanceAmount,
        invoiceType: _invoiceType,
        supplierStyle: detectSupplierStyle(supplier?.name ?? ''),
      );

      await ref.read(createInvoiceProvider(invoice).future);

      bool fullyInvoiced = true;
      for (final line in _lines) {
        if (line.remainingQty - line.quantity > 0) {
          fullyInvoiced = false;
          break;
        }
      }

      if (fullyInvoiced) {
        await ref
            .read(orderRepositoryProvider)
            .updateOrder(widget.order.copyWith(status: 'completed'));
      }

      ref.invalidate(getAllInvoicesProvider);
      ref.invalidate(getAllOrdersProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _InvoiceLine {
  final int orderItemId;
  final int? productId;
  final int? setId;
  final bool isSet;
  int quantity;
  final int remainingQty;
  final double unitPrice;

  _InvoiceLine({
    required this.orderItemId,
    this.productId,
    this.setId,
    this.isSet = false,
    required this.quantity,
    required this.remainingQty,
    required this.unitPrice,
  });
}

class _SummaryCard extends StatelessWidget {
  final double subTotal;
  final String invoiceType;
  final Widget shippingWidget;
  final double taxAmount;
  final double grandTotal;

  const _SummaryCard({
    required this.subTotal,
    required this.invoiceType,
    required this.shippingWidget,
    required this.taxAmount,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sub Total: PKR ${subTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                shippingWidget,
              ],
            ),
          ),
          const SizedBox(width: 30),
          if (invoiceType == 'sales_tax')
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'GST (18%): PKR ${taxAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Grand Total: PKR ${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Grand Total: PKR ${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
