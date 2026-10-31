import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/providers/order_providers.dart';
import '../../../orders/presentation/providers/supplier_providers.dart';
import '../../../products/domain/entities/product_set_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../providers/invoice_providers.dart';

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
  final _orderDateController = TextEditingController();

  final _supplierAddressController = TextEditingController();
  final _supplierStrnController = TextEditingController();
  final _supplierNtnController = TextEditingController();

  final _clientAddressController = TextEditingController();
  final _clientStrnController = TextEditingController();
  final _clientNtnController = TextEditingController();

  final _advanceController = TextEditingController(text: '0');

  String _invoiceType = 'sales_tax'; // 'sales_tax' or 'commercial'
  bool _isSubmitting = false;
  bool _applyGst = true;

  late List<_InvoiceLine> _lines;
  DateTime _orderDate = DateUtils.dateOnly(DateTime.now());

  final _currencyFormat = NumberFormat('#,##0.00');

  String _fmt(double v) => _currencyFormat.format(v);

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
    _supplierAddressController.dispose();
    _supplierStrnController.dispose();
    _supplierNtnController.dispose();
    _clientAddressController.dispose();
    _clientStrnController.dispose();
    _clientNtnController.dispose();
    _advanceController.dispose();
    for (final line in _lines) {
      line.dispose();
    }
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
    final clients =
        ref.watch(getAllClientsProvider).asData?.value ?? const <dynamic>[];
    final clientById = {for (var c in clients) c.id: c};
    final client = clientById[widget.order.clientId];
    final clientName = client?.clientName ?? '';
    final initials = _getClientInitials(clientName);

    final nextNumberAsync = ref.watch(
      nextInvoiceNumberProvider(widget.order.clientId, initials),
    );

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 960,
          maxHeight: MediaQuery.of(context).size.height * 0.94,
        ),
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

                // Seed product descriptions if empty
                for (final line in _lines) {
                  if (line.descriptionController.text.isEmpty) {
                    final defaultDesc = line.isSet
                        ? (setById[line.setId]?.description?.isNotEmpty == true
                            ? setById[line.setId]!.description!
                            : (setById[line.setId]?.name ?? ''))
                        : (productById[line.productId]?.description?.isNotEmpty ==
                                true
                            ? productById[line.productId]!.description!
                            : (productById[line.productId]?.name ?? ''));
                    line.descriptionController.text = defaultDesc;
                  }
                }

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

    // Seed supplier details once if empty
    if (supplier != null) {
      if (_supplierAddressController.text.isEmpty &&
          supplier.address != null &&
          supplier.address.isNotEmpty) {
        _supplierAddressController.text = supplier.address;
      }
      if (_supplierStrnController.text.isEmpty && supplier.strnNo != null) {
        _supplierStrnController.text = supplier.strnNo!;
      }
      if (_supplierNtnController.text.isEmpty && supplier.ntn != null) {
        _supplierNtnController.text = supplier.ntn!;
      }
    }

    // Seed client address once if empty
    if (client != null &&
        _clientAddressController.text.isEmpty &&
        client.clientAddress != null &&
        client.clientAddress.isNotEmpty) {
      _clientAddressController.text = client.clientAddress;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 680;

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header (Fixed & Responsive) ───────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Generate Invoice',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          Text(
                            'Invoice Number: $invoiceNo',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // ── Scrollable Body (Adaptive for Zoom & Screen Size) ────
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 14 : 20,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Order & Invoice Meta Strip (Adaptive)
                      _buildMetaStrip(isNarrow),
                      const SizedBox(height: 16),

                      // 2. Supplier & Buyer Cards (Side by Side or Stacked)
                      if (isNarrow)
                        Column(
                          children: [
                            _buildPartyCard(
                              title: 'Supplier Details',
                              name: supplier != null
                                  ? supplier.name
                                  : 'Unknown Supplier',
                              icon: Icons.storefront_outlined,
                              badgeColor: Colors.blue.shade700,
                              addressController: _supplierAddressController,
                              strnController: _supplierStrnController,
                              ntnController: _supplierNtnController,
                              strnLabel: 'Supplier STRN',
                              ntnLabel: 'Supplier NTN',
                            ),
                            const SizedBox(height: 12),
                            _buildPartyCard(
                              title: 'Buyer / Client Details',
                              name: client != null
                                  ? (client.clientName ?? 'Unknown Client')
                                  : 'Unknown Client',
                              icon: Icons.person_outline,
                              badgeColor: Colors.teal.shade700,
                              addressController: _clientAddressController,
                              strnController: _clientStrnController,
                              ntnController: _clientNtnController,
                              strnLabel: 'Buyer STRN',
                              ntnLabel: 'Buyer NTN',
                            ),
                          ],
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildPartyCard(
                                title: 'Supplier Details',
                                name: supplier != null
                                    ? supplier.name
                                    : 'Unknown Supplier',
                                icon: Icons.storefront_outlined,
                                badgeColor: Colors.blue.shade700,
                                addressController: _supplierAddressController,
                                strnController: _supplierStrnController,
                                ntnController: _supplierNtnController,
                                strnLabel: 'Supplier STRN',
                                ntnLabel: 'Supplier NTN',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildPartyCard(
                                title: 'Buyer / Client Details',
                                name: client != null
                                    ? (client.clientName ?? 'Unknown Client')
                                    : 'Unknown Client',
                                icon: Icons.person_outline,
                                badgeColor: Colors.teal.shade700,
                                addressController: _clientAddressController,
                                strnController: _clientStrnController,
                                ntnController: _clientNtnController,
                                strnLabel: 'Buyer STRN',
                                ntnLabel: 'Buyer NTN',
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 18),

                      // 3. Line Items Section (With Multiline Wrapping Description)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Line Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_lines.length} items',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (!isNarrow)
                            const Text(
                              'Product descriptions wrap automatically',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textGrey,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Items List Container
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.dividerColor.withValues(alpha: 0.7),
                          ),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _lines.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            color: AppColors.dividerColor.withValues(alpha: 0.6),
                          ),
                          itemBuilder: (context, index) {
                            final line = _lines[index];
                            final product = line.isSet
                                ? null
                                : productById[line.productId];
                            final displayName = line.isSet
                                ? (setById[line.setId]?.name ??
                                    'Set #${line.setId}')
                                : (product?.name ?? 'Unknown Product');

                            final lineTotal = line.quantity * line.unitPrice;

                            return Container(
                              padding: const EdgeInsets.all(12),
                              color: index.isEven
                                  ? Colors.white
                                  : const Color(0xFFFAFAFA),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Line Header: Title, Badges, Rates, and Subtotal
                                  Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${index + 1}. ',
                                            style: const TextStyle(
                                              color: AppColors.textGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              displayName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.textBlack,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: line.isSet
                                                  ? Colors.purple.shade50
                                                  : Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              line.isSet ? 'SET' : 'PRODUCT',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: line.isSet
                                                    ? Colors.purple.shade700
                                                    : Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.amber.shade300,
                                              ),
                                            ),
                                            child: Text(
                                              'Order Rem: ${line.remainingQty}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber.shade900,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Rate: PKR ${_fmt(line.unitPrice)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'PKR ${_fmt(lineTotal)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Color(0xFF2E7D32),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Line Inputs: Multiline Product Description & Quantity
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Description (Multiline & Fully Visible!)
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              line.descriptionController,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            height: 1.35,
                                          ),
                                          maxLines: null,
                                          minLines: 2,
                                          keyboardType:
                                              TextInputType.multiline,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Product Description',
                                            hintText:
                                                'Enter or edit item description...',
                                            hintStyle: const TextStyle(
                                              color: Colors.black38,
                                              fontSize: 12,
                                            ),
                                            isDense: true,
                                            border:
                                                const OutlineInputBorder(),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.edit_note,
                                              size: 20,
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Invoice Quantity
                                      SizedBox(
                                        width: 125,
                                        child: TextFormField(
                                          initialValue:
                                              line.quantity.toString(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.right,
                                          decoration: const InputDecoration(
                                            labelText: 'Invoice Qty',
                                            isDense: true,
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          validator: (value) {
                                            final parsed =
                                                int.tryParse(value ?? '');
                                            if (parsed == null || parsed < 0) {
                                              return 'Invalid';
                                            }
                                            if (parsed > line.remainingQty) {
                                              return 'Exceeds Rem.';
                                            }
                                            return null;
                                          },
                                          onChanged: (val) => setState(() {
                                            line.quantity =
                                                int.tryParse(val) ?? 0;
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 4. Financial & Representative Section (Adaptive)
                      if (isNarrow)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildRepresentativeAndAdvance(),
                            const SizedBox(height: 14),
                            _buildFinancialSummaryCard(),
                          ],
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildRepresentativeAndAdvance()),
                            const SizedBox(width: 18),
                            Expanded(child: _buildFinancialSummaryCard()),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // ── Footer Actions (Fixed & Responsive) ──────────────────
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed:
                          _isSubmitting ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 11,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () => _submit(
                                invoiceNo,
                                _orderDate,
                                productById,
                                setById,
                                client,
                                supplier,
                              ),
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check, size: 18),
                      label: Text(
                        _isSubmitting
                            ? 'Creating Invoice...'
                            : 'Save & Issue Invoice',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetaStrip(bool isNarrow) {
    if (isNarrow) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.dividerColor.withValues(alpha: 0.7),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildMetaChip(
                    icon: Icons.tag,
                    label: 'Order Reference',
                    value: 'Order #${widget.order.id}',
                  ),
                ),
                Expanded(
                  child: _buildMetaChip(
                    icon: Icons.description_outlined,
                    label: 'PO Number',
                    value: widget.order.po?.isNotEmpty == true
                        ? widget.order.po!
                        : 'None',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildDateField()),
                const SizedBox(width: 10),
                Expanded(child: _buildInvoiceTypeDropdown()),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetaChip(
              icon: Icons.tag,
              label: 'Order Reference',
              value: 'Order #${widget.order.id}',
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: AppColors.dividerColor.withValues(alpha: 0.6),
          ),
          Expanded(
            child: _buildMetaChip(
              icon: Icons.description_outlined,
              label: 'Purchase Order (PO)',
              value: widget.order.po?.isNotEmpty == true
                  ? widget.order.po!
                  : 'None',
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: AppColors.dividerColor.withValues(alpha: 0.6),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildDateField(),
            ),
          ),
          Expanded(child: _buildInvoiceTypeDropdown()),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _orderDateController,
      readOnly: true,
      enabled: !_isSubmitting,
      style: const TextStyle(fontSize: 13),
      decoration: const InputDecoration(
        labelText: 'Invoice Date',
        isDense: true,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        suffixIcon: Icon(Icons.calendar_today_outlined, size: 16),
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
              if (selectedDate == null) return;
              setState(() {
                _orderDate = DateUtils.dateOnly(selectedDate);
                _orderDateController.text = _formatDate(_orderDate);
              });
            },
    );
  }

  Widget _buildInvoiceTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _invoiceType,
      style: const TextStyle(fontSize: 13, color: AppColors.textBlack),
      decoration: const InputDecoration(
        labelText: 'Invoice Type',
        isDense: true,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      items: const [
        DropdownMenuItem(
          value: 'sales_tax',
          child: Text('Sales Tax Invoice'),
        ),
        DropdownMenuItem(
          value: 'commercial',
          child: Text('Commercial Invoice'),
        ),
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
    );
  }

  Widget _buildRepresentativeAndAdvance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _representativeController,
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            labelText: 'Company Representative',
            hintText: 'Name of representative',
            isDense: true,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _advanceController,
          style: const TextStyle(fontSize: 13),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: const InputDecoration(
            labelText: 'Advance Payment',
            prefixText: 'PKR ',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (_invoiceType == 'sales_tax') ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.dividerColor.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.calculate_outlined,
                      size: 18,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Apply GST (18%)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _applyGst,
                  onChanged: (v) => setState(() => _applyGst = v),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryRow('Sub Total', 'PKR ${_fmt(_subTotal)}'),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                'Shipping Cost:',
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
              const Spacer(),
              SizedBox(
                width: 105,
                height: 32,
                child: TextFormField(
                  controller: _shippingController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 13),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          if (_invoiceType == 'sales_tax') ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'GST (${_applyGst ? "18%" : "0%"})',
              'PKR ${_fmt(_taxAmount)}',
              color: Colors.blue.shade700,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          _buildSummaryRow(
            'Grand Total',
            'PKR ${_fmt(_grandTotal)}',
            isBold: true,
            fontSize: 15,
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(height: 4),
          _buildSummaryRow(
            'Balance Due',
            'PKR ${_fmt(_grandTotal - _advanceAmount)}',
            isBold: true,
            color: AppColors.textBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyCard({
    required String title,
    required String name,
    required IconData icon,
    required Color badgeColor,
    required TextEditingController addressController,
    required TextEditingController strnController,
    required TextEditingController ntnController,
    required String strnLabel,
    required String ntnLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: badgeColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 10),

          // Editable Address
          TextFormField(
            controller: addressController,
            maxLines: 2,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: 'Enter address...',
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),

          // STRN & NTN Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: strnController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: strnLabel,
                    isDense: true,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: ntnController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: ntnLabel,
                    isDense: true,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 13,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? (isBold ? AppColors.textBlack : AppColors.textGrey),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? AppColors.textBlack,
          ),
        ),
      ],
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
      final invoiceItems = activeLines.map((l) {
        final product = l.isSet ? null : productById[l.productId];
        final fallbackDescription = l.isSet
            ? (setById[l.setId]?.description ?? setById[l.setId]?.name ?? '')
            : (product?.description ?? product?.name ?? '');

        final chosenDescription = l.descriptionController.text.trim().isNotEmpty
            ? l.descriptionController.text.trim()
            : fallbackDescription;

        return InvoiceItemEntity(
          orderItemId: l.orderItemId,
          productId: l.productId,
          setId: l.setId,
          isSet: l.isSet,
          quantity: l.quantity,
          unitPrice: l.unitPrice,
          totalPrice: l.quantity * l.unitPrice,
          description: chosenDescription,
          unitType: 'Each',
        );
      }).toList();

      final invoice = InvoiceEntity(
        orderId: widget.order.id!,
        clientId: widget.order.clientId,
        supplierId: widget.order.supplierId,
        invoiceNumber: invoiceNo,
        status: 'undispatched',
        representative: _representativeController.text.trim(),
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
        supplierAddress: _supplierAddressController.text.trim(),
        supplierStrn: _supplierStrnController.text.trim(),
        supplierNtn: _supplierNtnController.text.trim(),
        clientName: client?.clientName ?? 'Unknown Client',
        clientAddress: _clientAddressController.text.trim(),
        clientStrn: _clientStrnController.text.trim(),
        clientNtn: _clientNtnController.text.trim(),
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
  final TextEditingController descriptionController;

  _InvoiceLine({
    required this.orderItemId,
    this.productId,
    this.setId,
    this.isSet = false,
    required this.quantity,
    required this.remainingQty,
    required this.unitPrice,
    String initialDescription = '',
  }) : descriptionController =
            TextEditingController(text: initialDescription);

  void dispose() {
    descriptionController.dispose();
  }
}
