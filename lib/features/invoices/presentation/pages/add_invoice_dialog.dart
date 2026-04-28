import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../providers/invoice_providers.dart';
import '../../../orders/presentation/providers/supplier_providers.dart';
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
  bool _isSubmitting = false;
  bool _applyGst = true;

  late List<_InvoiceLine> _lines;

  @override
  void initState() {
    super.initState();
    // Initialize lines derived from order items
    _lines = widget.order.items.map((item) {
      // Calculate remaining.
      // E.g. total ordered is 12. If already invoiced is 10, then remaining is 2.
      final invoicedQty = item.invoicedQuantity ?? 0;
      final remaining = (item.quantity - invoicedQty);
      
      // Ensure remaining is non negative in edge cases.
      final effectiveRemaining = remaining < 0 ? 0 : remaining;
      
      return _InvoiceLine(
        orderItemId: item.id ?? 0,
        productId: item.productId,
        quantity: effectiveRemaining, // Suggest remaining quantity by default
        remainingQty: effectiveRemaining,
        unitPrice: item.price,
      );
    }).toList();
  }

  @override
  void dispose() {
    _shippingController.dispose();
    super.dispose();
  }

  double get _subTotal {
    return _lines.fold(
      0,
      (sum, line) => sum + (line.quantity * line.unitPrice),
    );
  }

  double get _shippingCost => double.tryParse(_shippingController.text) ?? 0.0;

  double get _taxAmount => _applyGst ? (_subTotal + _shippingCost) * 0.18 : 0.0;

  double get _grandTotal => _subTotal + _shippingCost + _taxAmount;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(getAllProductsProvider);
    final invoicesAsync = ref.watch(getAllInvoicesProvider);

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 800,
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
              return invoicesAsync.when(
                loading: () => const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SizedBox(
                  height: 240,
                  child: Center(child: Text('Error: $e')),
                ),
                data: (invoices) {
                  final productById = {for (var p in products) p.id: p};

                  // Calculate next invoice number
                  final maxId = invoices
                      .map((i) => i.id ?? 0)
                      .fold<int>(0, (max, id) => id > max ? id : max);
                  final nextInvoiceNo = 'INV-${maxId + 1}';

                  return _buildContent(
                    context,
                    nextInvoiceNo,
                    productById,
                    widget.order,
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
  ) {
    // Resolve client & supplier for display
    final clients =
        ref.watch(getAllClientsProvider).asData?.value ?? const <dynamic>[];
    final suppliers =
        ref.watch(getAllSuppliersProvider).asData?.value ?? const <dynamic>[];
    final clientById = {for (var c in clients) c.id: c};
    final supplierById = {for (var s in suppliers) s.id: s};

    final client = clientById[widget.order.clientId];
    final supplier = supplierById[widget.order.supplierId];

    return Form(
      key: _formKey,
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
            ],
          ),
          const SizedBox(height: 20),
          // Supplier & Client details
          const Text(
            'Supplier Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(supplier != null ? supplier.name : 'Unknown Supplier'),
          Text(supplier != null ? supplier.address : ''),
          if (supplier != null && supplier.contactInfo != null)
            Text('Contact: ${supplier.contactInfo}'),
          if (supplier != null && supplier.deliveryTerms.isNotEmpty)
            Text('Delivery Terms: ${order.deliveryTerm}'),
          const SizedBox(height: 12),
          const Text(
            'Buyer Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            client != null
                ? client.clientName ?? 'Unknown Client'
                : 'Unknown Client',
          ),
          Text(client != null ? (client.clientAddress ?? '') : ''),
          const SizedBox(height: 16),

          const Text(
            'Invoice Lines',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _lines.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final line = _lines[index];
                final product = productById[line.productId];

                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(product?.name ?? 'Unknown Product'),
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
          ),
          const SizedBox(height: 16),
          _SummaryCard(
            subTotal: _subTotal,
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
          const SizedBox(height: 8),
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
                onPressed: _isSubmitting ? null : () => _submit(invoiceNo),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Invoice'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit(String invoiceNo) async {
    if (!_formKey.currentState!.validate()) return;

    // Filter out lines with 0 quantity being invoiced
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
            (l) => InvoiceItemEntity(
              orderItemId: l.orderItemId,
              productId: l.productId,
              quantity: l.quantity,
              unitPrice: l.unitPrice,
              totalPrice: l.quantity * l.unitPrice,
            ),
          )
          .toList();

      final invoice = InvoiceEntity(
        orderId: widget.order.id!,
        clientId: widget.order.clientId,
        supplierId: widget.order.supplierId,
        invoiceNumber: invoiceNo,
        status: 'unpaid',
        po: widget.order.po,
        issueDate: DateTime.now(),
        subTotal: _subTotal,
        shippingCost: _shippingCost,
        taxPercent: _applyGst ? 18.0 : 0.0,
        taxAmount: _taxAmount,
        grandTotal: _grandTotal,
        items: invoiceItems,
      );

      await ref.read(createInvoiceProvider(invoice).future);
      ref.invalidate(getAllInvoicesProvider);
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
}

class _InvoiceLine {
  final int orderItemId;
  final int productId;
  int quantity;
  final int remainingQty;
  final double unitPrice;

  _InvoiceLine({
    required this.orderItemId,
    required this.productId,
    required this.quantity,
    required this.remainingQty,
    required this.unitPrice,
  });
}

class _SummaryCard extends StatelessWidget {
  final double subTotal;
  final Widget shippingWidget;
  final double taxAmount;
  final double grandTotal;

  const _SummaryCard({
    required this.subTotal,
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
          ),
        ],
      ),
    );
  }
}
