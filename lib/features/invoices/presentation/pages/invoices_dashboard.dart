import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/features/invoices/utils/pdf_generator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../orders/presentation/providers/supplier_providers.dart';
import '../../domain/entities/invoice_entity.dart';
import '../providers/invoice_providers.dart';

class InvoicesDashboard extends ConsumerWidget {
  const InvoicesDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: invoicesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (invoices) {
            if (invoices.isEmpty) {
              return const Center(child: Text('No invoices found.'));
            }

            final clients = clientsAsync.asData?.value ?? [];
            final suppliers = suppliersAsync.asData?.value ?? [];
            final products = productsAsync.asData?.value ?? [];

            final clientById = {for (var c in clients) c.id: c};
            final supplierById = {for (var s in suppliers) s.id: s};
            final productById = {for (var p in products) p.id: p};

            return ListView.separated(
              itemCount: invoices.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                final client = clientById[invoice.clientId];
                final supplier = supplierById[invoice.supplierId];

                return _InvoiceCard(
                  invoice: invoice,
                  clientName: client?.clientName ?? 'Unknown Client',
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
                          content: Text('Client or Supplier data missing.'),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;
  final String clientName;
  final VoidCallback onPrint;

  const _InvoiceCard({
    required this.invoice,
    required this.clientName,
    required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.status == 'paid';
    final isPartial = invoice.paidAmount > 0 && invoice.remainingAmount > 0;
    final badgeLabel = isPaid
        ? 'PAID'
        : isPartial
        ? 'PARTIAL'
        : 'UNPAID';
    final badgeColor = isPaid
        ? Colors.green.shade50
        : isPartial
        ? Colors.orange.shade50
        : Colors.red.shade50;
    final badgeTextColor = isPaid
        ? Colors.green.shade700
        : isPartial
        ? Colors.orange.shade700
        : Colors.red.shade700;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              invoice.invoiceNumber,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(clientName, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PKR ${invoice.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Remaining: PKR ${invoice.remainingAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isPaid ? Colors.grey.shade500 : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.print, color: Colors.blue),
            onPressed: onPrint,
            tooltip: 'Print / Download',
          ),
          IconButton(
            icon: Icon(
              Icons.receipt_long,
              color: isPaid ? Colors.grey : Colors.blue,
            ),
            onPressed: null,
            tooltip: 'Receipt-driven payments',
          ),
        ],
      ),
    );
  }
}
