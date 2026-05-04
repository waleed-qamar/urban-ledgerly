import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/features/invoices/utils/pdf_generator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../orders/presentation/providers/supplier_providers.dart';
import '../../domain/entities/invoice_entity.dart';
import '../providers/invoice_providers.dart';

// ---------------------------------------------------------------------------
// Sorting / filtering enums
// ---------------------------------------------------------------------------
enum _SortField { invoiceNumber, orderNumber, client }

// ---------------------------------------------------------------------------
// Dashboard
// ---------------------------------------------------------------------------
class InvoicesDashboard extends ConsumerStatefulWidget {
  const InvoicesDashboard({super.key});

  @override
  ConsumerState<InvoicesDashboard> createState() => _InvoicesDashboardState();
}

class _InvoicesDashboardState extends ConsumerState<InvoicesDashboard> {
  _SortField _sortField = _SortField.invoiceNumber;
  bool _sortAscending = false;
  int? _filterClientId;

  List<InvoiceEntity> _sorted(
    List<InvoiceEntity> invoices,
    Map<int, ClientEntity> clientById,
  ) {
    List<InvoiceEntity> list = _filterClientId == null
        ? List.of(invoices)
        : invoices.where((i) => i.clientId == _filterClientId).toList();

    list.sort((a, b) {
      int cmp;
      switch (_sortField) {
        case _SortField.invoiceNumber:
          cmp = a.invoiceNumber.compareTo(b.invoiceNumber);
        case _SortField.orderNumber:
          cmp = a.orderId.compareTo(b.orderId);
        case _SortField.client:
          final nameA = clientById[a.clientId]?.clientName ?? '';
          final nameB = clientById[b.clientId]?.clientName ?? '';
          cmp = nameA.compareTo(nameB);
      }
      return _sortAscending ? cmp : -cmp;
    });

    return list;
  }

  void _toggleSort(_SortField field) {
    setState(() {
      if (_sortField == field) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(getAllInvoicesProvider);
    final clientsAsync = ref.watch(getAllClientsProvider);
    final suppliersAsync = ref.watch(getAllSuppliersProvider);
    final productsAsync = ref.watch(getAllProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        title: const Text(
          'Invoices',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.textWhite,
        elevation: 0,
        foregroundColor: AppColors.textBlack,
      ),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (invoices) {
          final clients = clientsAsync.asData?.value ?? [];
          final suppliers = suppliersAsync.asData?.value ?? [];
          final products = productsAsync.asData?.value ?? [];

          final clientById = {for (var c in clients) c.id: c};
          final supplierById = {for (var s in suppliers) s.id: s};
          final productById = {for (var p in products) p.id: p};

          final sorted = _sorted(invoices, clientById);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Toolbar ──────────────────────────────────────────────
                _InvoiceToolbar(
                  clients: clients,
                  filterClientId: _filterClientId,
                  onFilterClient: (id) =>
                      setState(() => _filterClientId = id),
                  sortField: _sortField,
                  sortAscending: _sortAscending,
                  onToggleSort: _toggleSort,
                ),
                const SizedBox(height: 16),

                // ── List ─────────────────────────────────────────────────
                if (sorted.isEmpty)
                  const Expanded(
                    child: Center(child: Text('No invoices found.')),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: sorted.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final invoice = sorted[index];
                        final client = clientById[invoice.clientId];
                        final supplier = supplierById[invoice.supplierId];

                        return _InvoiceCard(
                          invoice: invoice,
                          clientName:
                              client?.clientName ?? 'Unknown Client',
                          onPrint: () {
                            if (client != null && supplier != null) {
                              PdfGenerator.generateAndPrintInvoice(
                                invoice: invoice,
                                products: productById,
                                client: client,
                                supplier: supplier,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Client or Supplier data missing.'),
                                ),
                              );
                            }
                          },
                          onUpdateStatus: () async {
                            await _showUpdateStatusDialog(context, invoice);
                          },
                          onView: () {
                            showDialog(
                              context: context,
                              builder: (_) => _InvoiceViewDialog(
                                invoice: invoice,
                                clientName:
                                    client?.clientName ?? 'Unknown Client',
                                supplierName:
                                    supplier?.name ?? 'Unknown Supplier',
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showUpdateStatusDialog(
    BuildContext context,
    InvoiceEntity invoice,
  ) async {
    final isDispatched = invoice.status == 'dispatched';
    final newStatus = isDispatched ? 'undispatched' : 'dispatched';
    final label = isDispatched ? 'Mark as Undispatched' : 'Mark as Dispatched';
    final icon = isDispatched ? Icons.undo_outlined : Icons.local_shipping_outlined;
    final color = isDispatched ? Colors.orange : Colors.green;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            const Text('Update Status'),
          ],
        ),
        content: Text(
          'Change invoice ${invoice.invoiceNumber} status to '
          '"${newStatus.toUpperCase()}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: color),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(label),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(
        updateInvoiceStatusProvider(
          id: invoice.id ?? 0,
          status: newStatus,
        ).future,
      );
      ref.invalidate(getAllInvoicesProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invoice ${invoice.invoiceNumber} marked as $newStatus.',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Toolbar: Sort + Filter
// ---------------------------------------------------------------------------
class _InvoiceToolbar extends StatelessWidget {
  final List<ClientEntity> clients;
  final int? filterClientId;
  final ValueChanged<int?> onFilterClient;
  final _SortField sortField;
  final bool sortAscending;
  final ValueChanged<_SortField> onToggleSort;

  const _InvoiceToolbar({
    required this.clients,
    required this.filterClientId,
    required this.onFilterClient,
    required this.sortField,
    required this.sortAscending,
    required this.onToggleSort,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Sort buttons
        const Text(
          'Sort:',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textGrey),
        ),
        _SortChip(
          label: 'Invoice No',
          selected: sortField == _SortField.invoiceNumber,
          ascending: sortAscending,
          onTap: () => onToggleSort(_SortField.invoiceNumber),
        ),
        _SortChip(
          label: 'Order No',
          selected: sortField == _SortField.orderNumber,
          ascending: sortAscending,
          onTap: () => onToggleSort(_SortField.orderNumber),
        ),
        _SortChip(
          label: 'Client',
          selected: sortField == _SortField.client,
          ascending: sortAscending,
          onTap: () => onToggleSort(_SortField.client),
        ),
        const SizedBox(width: 8),
        const Text(
          'Filter:',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textGrey),
        ),
        // Client filter dropdown
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: filterClientId != null
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.dividerColor,
            ),
            borderRadius: BorderRadius.circular(20),
            color: filterClientId != null
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                : Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int?>(
              value: filterClientId,
              isDense: true,
              hint: const Text('All Clients', style: TextStyle(fontSize: 13)),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('All Clients', style: TextStyle(fontSize: 13)),
                ),
                ...clients.map(
                  (c) => DropdownMenuItem<int?>(
                    value: c.id,
                    child: Text(c.clientName, style: const TextStyle(fontSize: 13)),
                  ),
                ),
              ],
              onChanged: onFilterClient,
            ),
          ),
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool ascending;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.selected,
    required this.ascending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.10)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? primary : AppColors.textBlack87,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 4),
              Icon(
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Invoice Card
// ---------------------------------------------------------------------------
class _InvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;
  final String clientName;
  final VoidCallback onPrint;
  final VoidCallback onUpdateStatus;
  final VoidCallback onView;

  const _InvoiceCard({
    required this.invoice,
    required this.clientName,
    required this.onPrint,
    required this.onUpdateStatus,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final isDispatched = invoice.status == 'dispatched';
    final badgeLabel = isDispatched ? 'DISPATCHED' : 'UNDISPATCHED';
    final badgeColor =
        isDispatched ? Colors.green.shade50 : Colors.orange.shade50;
    final badgeTextColor =
        isDispatched ? Colors.green.shade700 : Colors.orange.shade700;

    return Container(
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
          // Invoice number + client
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  clientName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Grand total
          Expanded(
            flex: 2,
            child: Text(
              'PKR ${NumberFormat.decimalPattern('en_IN').format(invoice.grandTotal)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // View invoice detail
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.indigo),
            onPressed: onView,
            tooltip: 'View invoice',
          ),
          // Update status
          IconButton(
            icon: Icon(
              isDispatched
                  ? Icons.undo_outlined
                  : Icons.local_shipping_outlined,
              color: isDispatched ? Colors.orange.shade700 : Colors.green.shade700,
            ),
            onPressed: onUpdateStatus,
            tooltip: isDispatched
                ? 'Mark as Undispatched'
                : 'Mark as Dispatched',
          ),
          // Print / download
          IconButton(
            icon: const Icon(Icons.print, color: Colors.blue),
            onPressed: onPrint,
            tooltip: 'Print / Download',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Invoice View Dialog
// ---------------------------------------------------------------------------
class _InvoiceViewDialog extends StatelessWidget {
  final InvoiceEntity invoice;
  final String clientName;
  final String supplierName;

  const _InvoiceViewDialog({
    required this.invoice,
    required this.clientName,
    required this.supplierName,
  });

  static String _fmt(double v) =>
      NumberFormat.decimalPattern('en_IN').format(v);

  @override
  Widget build(BuildContext context) {
    final isDispatched = invoice.status == 'dispatched';

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 700,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.invoiceNumber,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Issued: ${DateFormat('dd MMM yyyy').format(invoice.issueDate)}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDispatched
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDispatched
                            ? Colors.green.shade300
                            : Colors.orange.shade300,
                      ),
                    ),
                    child: Text(
                      isDispatched ? 'DISPATCHED' : 'UNDISPATCHED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDispatched
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 28),

              // ── Info grid ──────────────────────────────────────────────
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _InfoChip(
                    label: 'Client',
                    value: clientName,
                    icon: Icons.person_outline,
                  ),
                  _InfoChip(
                    label: 'Supplier',
                    value: supplierName,
                    icon: Icons.business_outlined,
                  ),
                  _InfoChip(
                    label: 'Order ID',
                    value: '#${invoice.orderId}',
                    icon: Icons.receipt_long_outlined,
                  ),
                  if (invoice.po?.isNotEmpty == true)
                    _InfoChip(
                      label: 'PO',
                      value: invoice.po!,
                      icon: Icons.tag_outlined,
                    ),
                  _InfoChip(
                    label: 'Representative',
                    value: invoice.representative,
                    icon: Icons.badge_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Items table ────────────────────────────────────────────
              if (invoice.items.isNotEmpty) ...[
                const Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: AppColors.dividerColor.withValues(alpha: 0.6),
                      ),
                    ),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F1F1),
                        ),
                        children: [
                          _TableHeader('Product'),
                          _TableHeader('Qty'),
                          _TableHeader('Unit Price'),
                          _TableHeader('Total'),
                        ],
                      ),
                      ...invoice.items.map(
                        (item) => TableRow(
                          children: [
                            _TableCell('Product #${item.productId}'),
                            _TableCell(item.quantity.toStringAsFixed(0)),
                            _TableCell('PKR ${_fmt(item.unitPrice)}'),
                            _TableCell('PKR ${_fmt(item.totalPrice)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Totals ─────────────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F1FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _TotalRow('Sub Total', 'PKR ${_fmt(invoice.subTotal)}'),
                      const SizedBox(height: 6),
                      _TotalRow(
                        'Shipping',
                        'PKR ${_fmt(invoice.shippingCost)}',
                      ),
                      const SizedBox(height: 6),
                      _TotalRow(
                        'Tax (${invoice.taxPercent.toStringAsFixed(0)}%)',
                        'PKR ${_fmt(invoice.taxAmount)}',
                      ),
                      const Divider(height: 16),
                      _TotalRow(
                        'Grand Total',
                        'PKR ${_fmt(invoice.grandTotal)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String label;
  const _TableHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textBlack87,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String value;
  const _TableCell(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        value,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _TotalRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              fontSize: bold ? 14 : 13,
              color: bold ? AppColors.textBlack : AppColors.textGrey,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            fontSize: bold ? 14 : 13,
          ),
        ),
      ],
    );
  }
}
