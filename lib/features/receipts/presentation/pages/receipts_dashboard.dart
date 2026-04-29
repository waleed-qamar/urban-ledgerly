import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../ledger/presentation/providers/ledger_providers.dart';
import '../../../vender/domain/entities/vendor_entity.dart';
import '../../../vender/presentation/providers/vendor_providers.dart';
import '../../domain/entities/disbursement_record.dart';
import '../../domain/entities/receipt_entity.dart';
import '../providers/receipt_providers.dart';
import 'add_disbursement_dialog.dart';
import 'add_receipt_dialog.dart';
import 'receipt_details_page.dart';

enum _DashboardSection { receipts, disbursements }

class ReceiptsDashboard extends ConsumerStatefulWidget {
  const ReceiptsDashboard({super.key});

  @override
  ConsumerState<ReceiptsDashboard> createState() => _ReceiptsDashboardState();
}

class _ReceiptsDashboardState extends ConsumerState<ReceiptsDashboard> {
  final TextEditingController _searchController = TextEditingController();
  _DashboardSection _selectedSection = _DashboardSection.receipts;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCreateReceiptDialog() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddReceiptDialog(),
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt created successfully.')),
      );
      ref.invalidate(getAllReceiptsProvider);
      ref.invalidate(getAllInvoicesProvider);
      ref.invalidate(getAllEntriesProvider);
    }
  }

  Future<void> _openCreateDisbursementDialog() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddDisbursementDialog(),
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disbursement added successfully.')),
      );
      ref.invalidate(getAllEntriesProvider);
      ref.invalidate(getEntriesByTypeProvider);
      ref.invalidate(getBalanceProvider);
      ref.invalidate(getAllDisbursementsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(getAllReceiptsProvider);
    final disbursementsAsync = ref.watch(getAllDisbursementsProvider);
    final clientsAsync = ref.watch(getAllClientsProvider);
    final vendorsAsync = ref.watch(getAllvendorsProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        title: const Text(
          'Receipts',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.textWhite,
        elevation: 0,
        foregroundColor: AppColors.textBlack,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: OutlinedButton.icon(
              onPressed: _openCreateDisbursementDialog,
              icon: const Icon(Icons.payments_outlined),
              label: const Text('Add Disbursement'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: _openCreateReceiptDialog,
              icon: const Icon(Icons.add),
              label: const Text('New Receipt'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            receiptsAsync.when(
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (_, _) => const SizedBox.shrink(),
              data: (receipts) {
                final totalReceived = receipts.fold<double>(
                  0,
                  (sum, receipt) => sum + receipt.totalAmount,
                );
                return _ReceiptSummaryHeader(
                  receiptCount: receipts.length,
                  totalReceived: totalReceived,
                  onCreate: _openCreateReceiptDialog,
                  onCreateDisbursement: _openCreateDisbursementDialog,
                );
              },
            ),
            const SizedBox(height: 20),
            _DashboardModeSelector(
              selectedSection: _selectedSection,
              onChanged: (section) {
                if (section == _selectedSection) {
                  return;
                }
                setState(() {
                  _selectedSection = section;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedSection == _DashboardSection.receipts
                  ? _ReceiptsSection(
                      ref: ref,
                      receiptsAsync: receiptsAsync,
                      clientsAsync: clientsAsync,
                      searchController: _searchController,
                      onSearchChanged: () => setState(() {}),
                    )
                  : _DisbursementSection(
                      disbursementsAsync: disbursementsAsync,
                      vendorsAsync: vendorsAsync,
                      searchController: _searchController,
                      onSearchChanged: () => setState(() {}),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardModeSelector extends StatelessWidget {
  final _DashboardSection selectedSection;
  final ValueChanged<_DashboardSection> onChanged;

  const _DashboardModeSelector({
    required this.selectedSection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModeChoiceTile(
            section: _DashboardSection.receipts,
            label: 'Receipts',
            selectedSection: selectedSection,
            onTap: () => onChanged(_DashboardSection.receipts),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ModeChoiceTile(
            section: _DashboardSection.disbursements,
            label: 'Disbursements',
            selectedSection: selectedSection,
            onTap: () => onChanged(_DashboardSection.disbursements),
          ),
        ),
      ],
    );
  }
}

class _ModeChoiceTile extends StatelessWidget {
  final _DashboardSection section;
  final String label;
  final _DashboardSection selectedSection;
  final VoidCallback onTap;

  const _ModeChoiceTile({
    required this.section,
    required this.label,
    required this.selectedSection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = section == selectedSection;
    final borderColor = selected
        ? colorScheme.primary
        : AppColors.dividerColor.withValues(alpha: 0.35);
    final fillColor = selected
        ? colorScheme.primary.withValues(alpha: 0.08)
        : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Radio<_DashboardSection>(
              value: section,
              groupValue: selectedSection,
              onChanged: (_) => onTap(),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? colorScheme.primary : AppColors.textBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptsSection extends StatelessWidget {
  final WidgetRef ref;
  final AsyncValue<List<ReceiptEntity>> receiptsAsync;
  final AsyncValue<List<ClientEntity>> clientsAsync;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  const _ReceiptsSection({
    required this.ref,
    required this.receiptsAsync,
    required this.clientsAsync,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return receiptsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Failed to load receipts: $error',
          style: const TextStyle(color: AppColors.errorText),
        ),
      ),
      data: (receipts) {
        final clients = clientsAsync.asData?.value ?? const [];
        final clientsById = {for (final client in clients) client.id: client};
        final query = searchController.text.trim().toLowerCase();
        final filtered = receipts.where((receipt) {
          if (query.isEmpty) return true;
          final receiptNumber = receipt.receiptNumber?.toLowerCase() ?? '';
          final clientName =
              clientsById[receipt.clientId]?.clientName.toLowerCase() ?? '';
          return receiptNumber.contains(query) || clientName.contains(query);
        }).toList();

        return Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Search by receipt number or client',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (filtered.isEmpty)
              const Expanded(child: Center(child: Text('No receipts found.')))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final receipt = filtered[index];
                    final client = clientsById[receipt.clientId];
                    return _ReceiptCard(
                      receipt: receipt,
                      clientName: client?.clientName ?? 'Unknown Client',
                      onOpen: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReceiptDetailsPage(
                              receipt: receipt,
                              clientName:
                                  client?.clientName ?? 'Unknown Client',
                            ),
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Delete receipt?'),
                            content: const Text(
                              'This will reverse the ledger entry and remove allocations.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed != true || receipt.id == null) {
                          return;
                        }

                        try {
                          await ref.read(
                            deleteReceiptProvider(receipt.id!).future,
                          );
                          ref.invalidate(getAllReceiptsProvider);
                          ref.invalidate(getAllInvoicesProvider);
                          ref.invalidate(getAllEntriesProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Receipt deleted.')),
                            );
                          }
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to delete receipt: $error',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ReceiptSummaryHeader extends StatelessWidget {
  final int receiptCount;
  final double totalReceived;
  final VoidCallback onCreate;
  final VoidCallback onCreateDisbursement;

  const _ReceiptSummaryHeader({
    required this.receiptCount,
    required this.totalReceived,
    required this.onCreate,
    required this.onCreateDisbursement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash Receipts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Receipts are the only source of credit entries for clients.',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          _StatPill(label: 'Receipts', value: '$receiptCount'),
          const SizedBox(width: 12),
          _StatPill(
            label: 'Received',
            value: 'PKR ${totalReceived.toStringAsFixed(2)}',
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('New Receipt'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onCreateDisbursement,
            icon: const Icon(Icons.payments_outlined),
            label: const Text('Disbursement'),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final String clientName;
  final VoidCallback onOpen;
  final VoidCallback onDelete;
  final ReceiptEntity receipt;

  const _ReceiptCard({
    required this.receipt,
    required this.clientName,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.receiptNumber ?? 'Receipt',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(clientName, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            child: Text(
              receipt.paymentMethod.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(
              'PKR ${receipt.totalAmount.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: Text(
              receipt.allocations.isEmpty
                  ? 'Advance'
                  : '${receipt.allocations.length} invoice(s)',
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: onOpen,
            icon: const Icon(Icons.visibility_outlined),
            tooltip: 'View details',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Delete receipt',
          ),
        ],
      ),
    );
  }
}

class _DisbursementSection extends StatelessWidget {
  final AsyncValue<List<DisbursementRecord>> disbursementsAsync;
  final AsyncValue<List<VendorEntity>> vendorsAsync;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  const _DisbursementSection({
    required this.disbursementsAsync,
    required this.vendorsAsync,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final vendors = vendorsAsync.asData?.value ?? const [];
    final vendorsById = {for (final vendor in vendors) vendor.id: vendor};
    final query = searchController.text.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchController,
          onChanged: (_) => onSearchChanged(),
          decoration: InputDecoration(
            hintText: 'Search by vendor or disbursement number',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Disbursements',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'All vendor payments recorded in the ledger.',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: disbursementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                'Failed to load disbursements: $error',
                style: const TextStyle(color: AppColors.errorText),
              ),
            ),
            data: (disbursements) {
              final filtered = disbursements.where((disbursement) {
                if (query.isEmpty) return true;
                final number = disbursement.disbursementNumber.toLowerCase();
                final vendorName = vendorsById[disbursement.supplierId]?.vendorName.toLowerCase() ?? '';
                return number.contains(query) || vendorName.contains(query);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text('No disbursements found.'));
              }

              final totalPaid = filtered.fold<double>(
                0,
                (sum, record) => sum + record.totalAmount,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatPill(
                        label: 'Disbursements',
                        value: '${filtered.length}',
                      ),
                      const SizedBox(width: 12),
                      _StatPill(
                        label: 'Paid',
                        value: 'PKR ${totalPaid.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final disbursement = filtered[index];
                        final vendor = vendorsById[disbursement.supplierId];
                        return _DisbursementCard(
                          disbursement: disbursement,
                          vendorName: vendor?.vendorName ?? 'Unknown Vendor',
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DisbursementCard extends StatelessWidget {
  final DisbursementRecord disbursement;
  final String vendorName;

  const _DisbursementCard({
    required this.disbursement,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disbursement.disbursementNumber,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(vendorName, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            child: Text(
              disbursement.paymentMethod.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(
              'PKR ${disbursement.totalAmount.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: Text(
              disbursement.category?.isNotEmpty == true
                  ? disbursement.category!
                  : (disbursement.remarks?.isNotEmpty == true
                        ? disbursement.remarks!
                        : 'Disbursement'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
