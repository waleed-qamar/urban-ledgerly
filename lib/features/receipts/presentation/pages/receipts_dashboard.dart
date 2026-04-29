import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../ledger/presentation/providers/ledger_providers.dart';
import '../../domain/entities/receipt_entity.dart';
import '../providers/receipt_providers.dart';
import 'add_receipt_dialog.dart';
import 'receipt_details_page.dart';

class ReceiptsDashboard extends ConsumerStatefulWidget {
  const ReceiptsDashboard({super.key});

  @override
  ConsumerState<ReceiptsDashboard> createState() => _ReceiptsDashboardState();
}

class _ReceiptsDashboardState extends ConsumerState<ReceiptsDashboard> {
  final TextEditingController _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(getAllReceiptsProvider);
    final clientsAsync = ref.watch(getAllClientsProvider);

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
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: receiptsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load receipts: $error',
                    style: const TextStyle(color: AppColors.errorText),
                  ),
                ),
                data: (receipts) {
                  final clients = clientsAsync.asData?.value ?? const [];
                  final clientsById = {
                    for (final client in clients) client.id: client,
                  };
                  final query = _searchController.text.trim().toLowerCase();
                  final filtered = receipts.where((receipt) {
                    if (query.isEmpty) return true;
                    final receiptNumber =
                        receipt.receiptNumber?.toLowerCase() ?? '';
                    final clientName =
                        clientsById[receipt.clientId]?.clientName
                            .toLowerCase() ??
                        '';
                    return receiptNumber.contains(query) ||
                        clientName.contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No receipts found.'));
                  }

                  return Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
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
                      Expanded(
                        child: ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final receipt = filtered[index];
                            final client = clientsById[receipt.clientId];
                            return _ReceiptCard(
                              receipt: receipt,
                              clientName:
                                  client?.clientName ?? 'Unknown Client',
                              onOpen: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReceiptDetailsPage(
                                      receipt: receipt,
                                      clientName:
                                          client?.clientName ??
                                          'Unknown Client',
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
                                      const SnackBar(
                                        content: Text('Receipt deleted.'),
                                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptSummaryHeader extends StatelessWidget {
  final int receiptCount;
  final double totalReceived;
  final VoidCallback onCreate;

  const _ReceiptSummaryHeader({
    required this.receiptCount,
    required this.totalReceived,
    required this.onCreate,
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
