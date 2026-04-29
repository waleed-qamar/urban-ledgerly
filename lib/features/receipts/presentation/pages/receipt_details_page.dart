import 'package:flutter/material.dart';
import 'package:ledgerly/core/theme/app_colors.dart';

import '../../domain/entities/receipt_entity.dart';

class ReceiptDetailsPage extends StatelessWidget {
  final ReceiptEntity receipt;
  final String clientName;

  const ReceiptDetailsPage({
    super.key,
    required this.receipt,
    required this.clientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        title: Text(receipt.receiptNumber ?? 'Receipt Details'),
        backgroundColor: AppColors.textWhite,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(receipt: receipt, clientName: clientName),
            const SizedBox(height: 20),
            Text(
              'Allocations',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (receipt.allocations.isEmpty)
              const _EmptyAllocationsCard()
            else
              ...receipt.allocations.map(
                (allocation) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.dividerColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Invoice #${allocation.invoiceId}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'PKR ${allocation.amount.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ReceiptEntity receipt;
  final String clientName;

  const _HeaderCard({required this.receipt, required this.clientName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.25),
        ),
      ),
      child: Wrap(
        runSpacing: 12,
        spacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          _InfoBlock(label: 'Receipt No', value: receipt.receiptNumber ?? '-'),
          _InfoBlock(label: 'Client', value: clientName),
          _InfoBlock(label: 'Payment Method', value: receipt.paymentMethod),
          _InfoBlock(
            label: 'Total Amount',
            value: 'PKR ${receipt.totalAmount.toStringAsFixed(2)}',
          ),
          _InfoBlock(
            label: 'Received Date',
            value: receipt.receivedDate.toIso8601String().split('T').first,
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _EmptyAllocationsCard extends StatelessWidget {
  const _EmptyAllocationsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: const Text('This receipt is treated as an advance payment.'),
    );
  }
}
