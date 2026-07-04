import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/features/invoices/utils/pdf_generator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/inventory/presentation/providers/inventory_providers.dart';
import '../../../../core/widgets/build_search_box.dart';
import '../../../ledger/domain/entities/ledger_entity.dart';
import '../../../ledger/presentation/providers/ledger_providers.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../products/domain/entities/product_set_entity.dart';
import '../../../orders/presentation/providers/supplier_providers.dart';
import '../../domain/entities/invoice_entity.dart';
import '../providers/invoice_providers.dart';
import '../widgets/invoice_view_dialog.dart';

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
  late final TextEditingController _searchController;
  bool _sortAscending = false;
  int? _filterClientId;

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

  int _compareInvoiceNumbers(String a, String b) {
    int parseSuffix(String value) {
      final match = RegExp(r'^(.*?)(\d+)$').firstMatch(value);
      if (match == null) return -1;
      return int.tryParse(match.group(2) ?? '') ?? -1;
    }

    final aSuffix = parseSuffix(a);
    final bSuffix = parseSuffix(b);

    if (aSuffix != -1 && bSuffix != -1) {
      final cmp = aSuffix.compareTo(bSuffix);
      if (cmp != 0) return cmp;
    }

    return a.compareTo(b);
  }

  List<InvoiceEntity> _sorted(
    List<InvoiceEntity> invoices,
    Map<int, ClientEntity> clientById,
    String searchQuery, // new param
  ) {
    List<InvoiceEntity> list = _filterClientId == null
        ? List.of(invoices)
        : invoices.where((i) => i.clientId == _filterClientId).toList();

    // Apply search filter (new)
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      list = list.where((invoice) {
        final invoiceNumber = invoice.invoiceNumber.toLowerCase();
        final clientName =
            clientById[invoice.clientId]?.clientName.toLowerCase() ?? '';
        final orderNumber = invoice.orderId.toString();

        return invoiceNumber.contains(query) ||
            clientName.contains(query) ||
            orderNumber.contains(query);
      }).toList();
    }

    list.sort((a, b) {
      int cmp;
      switch (_sortField) {
        case _SortField.invoiceNumber:
          cmp = _compareInvoiceNumbers(a.invoiceNumber, b.invoiceNumber);
          break;
        case _SortField.orderNumber:
          cmp = a.orderId.compareTo(b.orderId);
          break;
        case _SortField.client:
          final nameA = clientById[a.clientId]?.clientName ?? '';
          final nameB = clientById[b.clientId]?.clientName ?? '';
          cmp = nameA.compareTo(nameB);
          break;
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
    final setsAsync = ref.watch(getAllProductSetsProvider);
    final searchQuery = ref.watch(invoiceSearchQueryProvider);

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

          final sorted = _sorted(invoices, clientById, searchQuery);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Toolbar ──────────────────────────────────────────────
                _InvoiceToolbar(
                  clients: clients,
                  filterClientId: _filterClientId,
                  onFilterClient: (id) => setState(() => _filterClientId = id),
                  sortField: _sortField,
                  sortAscending: _sortAscending,
                  onToggleSort: _toggleSort,
                ),
                const SizedBox(height: 16),
                BuildSearchBox(
                  searchController: _searchController,
                  searchQueryProvider: invoiceSearchQueryProvider,
                  onQueryChanged: (value) => ref
                      .read(invoiceSearchQueryProvider.notifier)
                      .setSearchQuery(value),
                  hintText:
                      'Search by invoice number, client, or order number...',
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
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final invoice = sorted[index];
                        final client = clientById[invoice.clientId];
                        final supplier = supplierById[invoice.supplierId];
                        final setNames = <int, String>{
                          for (final set
                              in setsAsync.asData?.value ??
                                  const <ProductSetEntity>[])
                            if (set.setId != null) set.setId!: set.name,
                        };

                        return _InvoiceCard(
                          invoice: invoice,
                          clientName: client?.clientName ?? 'Unknown Client',
                          onPrint: () {
                            if (client != null && supplier != null) {
                              PdfGenerator.generateAndPrintInvoice(
                                invoice: invoice,
                                products: productById,
                                sets: {
                                  for (final set
                                      in setsAsync.asData?.value ??
                                          const <ProductSetEntity>[])
                                    if (set.setId != null) set.setId!: set,
                                },
                                client: client,
                                supplier: supplier,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Client or Supplier data missing.',
                                  ),
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
                              builder: (_) => InvoiceViewDialog(
                                invoice: invoice,
                                clientName:
                                    client?.clientName ?? 'Unknown Client',
                                supplierName:
                                    supplier?.name ?? 'Unknown Supplier',
                                productNames: {
                                  for (var p in products) p.id: p.name,
                                },
                                setNames: setNames,
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
    final icon = isDispatched
        ? Icons.undo_outlined
        : Icons.local_shipping_outlined;
    final color = isDispatched ? Colors.orange : Colors.green;

    DateTime selectedDate = DateTime.now();

    final result = await showDialog<dynamic>(
      context: context,
      builder: (ctx) {
        if (newStatus == 'dispatched') {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change invoice ${invoice.invoiceNumber} status to '
                      '"${newStatus.toUpperCase()}"?',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select Dispatch Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.dividerColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, null),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx, selectedDate),
                    child: Text(label),
                  ),
                ],
              );
            },
          );
        } else {
          return AlertDialog(
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
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(label),
              ),
            ],
          );
        }
      },
    );

    if (result == null || !context.mounted) return;

    final dispatchDate = (result is DateTime) ? result : DateTime.now();

    try {
      await ref.read(
        updateInvoiceStatusProvider(
          id: invoice.id ?? 0,
          status: newStatus,
          dispatchDate: newStatus == 'dispatched' ? dispatchDate : null,
        ).future,
      );

      // If marking as dispatched, create stock OUT transactions
      if (newStatus == 'dispatched' && invoice.id != null) {
        final inventoryRepository = ref.read(inventoryRepositoryProvider);
        // Load product sets once to expand set-lines into individual products.
        final productRepository = ref.read(productRepositoryProvider);
        final sets = await productRepository.getProductSets();
        final setById = {for (var s in sets) s.setId: s};

        for (final item in invoice.items) {
          if (item.isSet) {
            final set = setById[item.setId];
            if (set == null) continue;
            for (final setItem in set.products) {
              await inventoryRepository.recordOut(
                setItem.productId,
                'PRODUCT',
                item.quantity.toDouble(),
                notes:
                    'Invoice ${invoice.invoiceNumber} dispatched (set ${set.name})',
                referenceType: 'INVOICE',
                referenceId: invoice.id,
                transactionDate: dispatchDate,
              );
            }
          } else {
            await inventoryRepository.recordOut(
              item.productId!,
              'PRODUCT',
              item.quantity.toDouble(),
              notes: 'Invoice ${invoice.invoiceNumber} dispatched',
              referenceType: 'INVOICE',
              referenceId: invoice.id,
              transactionDate: dispatchDate,
            );
          }
        }

        // Book the client receivable when the invoice is actually dispatched.
        // This keeps the ledger aligned with the invoice lifecycle and avoids
        // charging the customer before dispatch.
        final existingClientLedgerEntries = await ref.read(
          getEntriesByPartyProvider(
            partyType: PartyType.client,
            partyId: invoice.clientId,
          ).future,
        );

        final alreadyBooked = existingClientLedgerEntries.any((entry) {
          return entry.transactionSource == 'invoice' &&
              entry.referenceId == 'invoice:${invoice.id}';
        });

        if (!alreadyBooked) {
          await ref.read(
            addEntryProvider(
              LedgerEntity(
                id: 0,
                partyType: PartyType.client,
                partyId: invoice.clientId,
                invoiceNumber: invoice.invoiceNumber,
                entryType: EntryType.debit,
                amount: invoice.grandTotal,
                paymentMethod: null,
                entryDate: dispatchDate,
                transactionSource: 'invoice',
                referenceId: 'invoice:${invoice.id}',
                remarks:
                    'auto entry against dispatched invoice ${invoice.invoiceNumber}',
                createdAt: DateTime.now(),
              ),
            ).future,
          );
        }
      }

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
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
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
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
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
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
                    child: Text(
                      c.clientName,
                      style: const TextStyle(fontSize: 13),
                    ),
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
          border: Border.all(color: selected ? primary : Colors.grey.shade300),
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
    final badgeColor = isDispatched
        ? Colors.green.shade50
        : Colors.orange.shade50;
    final badgeTextColor = isDispatched
        ? Colors.green.shade700
        : Colors.orange.shade700;

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
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
              color: isDispatched
                  ? Colors.orange.shade700
                  : Colors.green.shade700,
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
