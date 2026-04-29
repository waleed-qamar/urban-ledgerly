import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../invoices/domain/entities/invoice_entity.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../domain/entities/receipt_allocation_entity.dart';
import '../../domain/entities/receipt_entity.dart';
import '../providers/receipt_providers.dart';

class AddReceiptDialog extends ConsumerStatefulWidget {
  const AddReceiptDialog({super.key});

  @override
  ConsumerState<AddReceiptDialog> createState() => _AddReceiptDialogState();
}

class _AddReceiptDialogState extends ConsumerState<AddReceiptDialog> {
  final _formKey = GlobalKey<FormState>();
  final _paymentAmountController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _remarksController = TextEditingController();

  bool _isSubmitting = false;
  DateTime _receivedDate = DateTime.now();
  String _paymentMethod = 'cash';
  int? _selectedClientId;
  int? _selectedInvoiceId;

  @override
  void dispose() {
    _paymentAmountController.dispose();
    _accountNoController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _setSelectedClient(int? clientId) {
    if (_selectedClientId == clientId) return;

    setState(() {
      _selectedClientId = clientId;
      _selectedInvoiceId = null;
      _paymentAmountController.clear();
    });
  }

  void _setSelectedInvoice(InvoiceEntity? invoice) {
    setState(() {
      _selectedInvoiceId = invoice?.id;

      if (invoice == null) {
        _paymentAmountController.clear();
        return;
      }

      final currentAmount = _parseAmount(_paymentAmountController.text);
      if (_paymentAmountController.text.trim().isEmpty ||
          currentAmount > invoice.remainingAmount) {
        _paymentAmountController.text = invoice.remainingAmount.toStringAsFixed(
          2,
        );
      }
    });
  }

  void _syncSelectedInvoice(List<InvoiceEntity> invoices) {
    if (_selectedClientId == null || _selectedInvoiceId == null) return;

    final openInvoices = invoices
        .where((invoice) => invoice.clientId == _selectedClientId)
        .where((invoice) => invoice.remainingAmount > 0)
        .toList();

    final selectedInvoice = openInvoices.where(
      (invoice) => invoice.id == _selectedInvoiceId,
    );

    if (selectedInvoice.isEmpty) {
      setState(() {
        _selectedInvoiceId = null;
        _paymentAmountController.clear();
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _receivedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _receivedDate = picked);
    }
  }

  double _parseAmount(String value) {
    return double.tryParse(value.trim()) ?? 0.0;
  }

  Future<void> _submit(List<InvoiceEntity> invoices) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a client.')));
      return;
    }

    final selectedInvoice = invoices.where(
      (invoice) =>
          invoice.clientId == _selectedClientId &&
          invoice.id == _selectedInvoiceId &&
          invoice.remainingAmount > 0,
    );

    if (selectedInvoice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an unpaid invoice.')),
      );
      return;
    }

    final invoice = selectedInvoice.first;
    final paymentAmount = _parseAmount(_paymentAmountController.text);

    if (paymentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid payment amount.')),
      );
      return;
    }

    if (paymentAmount > invoice.remainingAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment for ${invoice.invoiceNumber} exceeds the invoice balance.',
          ),
        ),
      );
      return;
    }

    final allocations = <ReceiptAllocationEntity>[
      ReceiptAllocationEntity(
        invoiceId: invoice.id ?? 0,
        amount: paymentAmount,
      ),
    ];

    setState(() => _isSubmitting = true);

    try {
      final receipt = ReceiptEntity(
        clientId: _selectedClientId!,
        totalAmount: paymentAmount,
        paymentMethod: _paymentMethod,
        accountNo: _accountNoController.text.trim().isEmpty
            ? null
            : _accountNoController.text.trim(),
        remarks: _remarksController.text.trim().isEmpty
            ? null
            : _remarksController.text.trim(),
        receivedDate: _receivedDate,
        allocations: allocations,
      );

      await ref.read(createReceiptProvider(receipt).future);

      ref.invalidate(getAllReceiptsProvider);
      ref.invalidate(getAllInvoicesProvider);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create receipt: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(getAllClientsProvider);
    final invoicesAsync = ref.watch(getAllInvoicesProvider);

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 1000,
        height: 760,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: clientsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
            data: (clients) => invoicesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (invoices) {
                _syncSelectedInvoice(invoices);

                final openInvoices = _selectedClientId == null
                    ? const <InvoiceEntity>[]
                    : invoices
                          .where(
                            (invoice) => invoice.clientId == _selectedClientId,
                          )
                          .where((invoice) => invoice.remainingAmount > 0)
                          .toList();

                final selectedInvoice = openInvoices.where(
                  (invoice) => invoice.id == _selectedInvoiceId,
                );

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Receipt',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Choose one unpaid invoice and apply the payment to it.',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _PanelCard(
                                      title: 'Receipt Information',
                                      child: Column(
                                        children: [
                                          DropdownButtonFormField<int?>(
                                            initialValue: _selectedClientId,
                                            decoration: const InputDecoration(
                                              labelText: 'Client',
                                              border: OutlineInputBorder(),
                                            ),
                                            items: [
                                              const DropdownMenuItem<int?>(
                                                value: null,
                                                child: Text('Select client'),
                                              ),
                                              ...clients.map(
                                                (client) =>
                                                    DropdownMenuItem<int?>(
                                                      value: client.id,
                                                      child: Text(
                                                        client.clientName,
                                                      ),
                                                    ),
                                              ),
                                            ],
                                            onChanged: _isSubmitting
                                                ? null
                                                : (value) =>
                                                      _setSelectedClient(value),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      _paymentAmountController,
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                      ),
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText:
                                                            'Payment Amount',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                  validator: (value) {
                                                    final amount = _parseAmount(
                                                      value ?? '',
                                                    );
                                                    if (amount <= 0) {
                                                      return 'Enter a valid amount';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child:
                                                    DropdownButtonFormField<
                                                      String
                                                    >(
                                                      initialValue:
                                                          _paymentMethod,
                                                      decoration:
                                                          const InputDecoration(
                                                            labelText:
                                                                'Payment Method',
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value: 'cash',
                                                          child: Text('Cash'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 'bank',
                                                          child: Text('Bank'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 'cheque',
                                                          child: Text('Cheque'),
                                                        ),
                                                      ],
                                                      onChanged: _isSubmitting
                                                          ? null
                                                          : (value) {
                                                              if (value ==
                                                                  null) {
                                                                return;
                                                              }
                                                              setState(() {
                                                                _paymentMethod =
                                                                    value;
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
                                                  controller:
                                                      _accountNoController,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: 'Account No',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: _isSubmitting
                                                      ? null
                                                      : _pickDate,
                                                  child: InputDecorator(
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText:
                                                              'Received Date',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                    child: Text(
                                                      '${_receivedDate.year}-${_receivedDate.month.toString().padLeft(2, '0')}-${_receivedDate.day.toString().padLeft(2, '0')}',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          if (selectedInvoice.isNotEmpty)
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.lightBackground,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Selected Invoice',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    selectedInvoice
                                                        .first
                                                        .invoiceNumber,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Remaining: PKR ${selectedInvoice.first.remainingAmount.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (selectedInvoice.isNotEmpty)
                                            const SizedBox(height: 16),
                                          TextFormField(
                                            controller: _remarksController,
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                              labelText: 'Remarks',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _PanelCard(
                                      title: 'Payment Summary',
                                      child: Builder(
                                        builder: (context) {
                                          final paymentAmount = _parseAmount(
                                            _paymentAmountController.text,
                                          );

                                          return Row(
                                            children: [
                                              Expanded(
                                                child: _SummaryTile(
                                                  label: 'Selected Invoice',
                                                  value: selectedInvoice.isEmpty
                                                      ? 'None'
                                                      : selectedInvoice
                                                            .first
                                                            .invoiceNumber,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _SummaryTile(
                                                  label: 'Remaining Due',
                                                  value: selectedInvoice.isEmpty
                                                      ? 'PKR 0.00'
                                                      : 'PKR ${selectedInvoice.first.remainingAmount.toStringAsFixed(2)}',
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _SummaryTile(
                                                  label: 'Payment',
                                                  value:
                                                      'PKR ${paymentAmount.toStringAsFixed(2)}',
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
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 6,
                              child: _PanelCard(
                                title: 'Unpaid Invoices',
                                child: _selectedClientId == null
                                    ? const _EmptyAllocationsHint(
                                        text:
                                            'Select a client to show unpaid invoices.',
                                      )
                                    : openInvoices.isEmpty
                                    ? const _EmptyAllocationsHint(
                                        text:
                                            'This client has no unpaid invoices.',
                                      )
                                    : SizedBox(
                                        height: 520,
                                        child: ListView.separated(
                                          itemCount: openInvoices.length,
                                          separatorBuilder: (_, _) =>
                                              const SizedBox(height: 12),
                                          itemBuilder: (context, index) {
                                            final invoice = openInvoices[index];

                                            return _SelectableInvoiceTile(
                                              invoice: invoice,
                                              selected:
                                                  invoice.id ==
                                                  _selectedInvoiceId,
                                              onSelected: () {
                                                _setSelectedInvoice(invoice);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => _submit(invoices),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Save Receipt'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _PanelCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _EmptyAllocationsHint extends StatelessWidget {
  final String text;

  const _EmptyAllocationsHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}

class _SelectableInvoiceTile extends StatelessWidget {
  final InvoiceEntity invoice;
  final bool selected;
  final VoidCallback onSelected;

  const _SelectableInvoiceTile({
    required this.invoice,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final invoice = this.invoice;

    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : AppColors.textWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Colors.blue.shade300
                : AppColors.dividerColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Radio<int?>(
              value: invoice.id,
              groupValue: selected ? invoice.id : null,
              onChanged: (_) => onSelected(),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          invoice.invoiceNumber,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        'Remaining: PKR ${invoice.remainingAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Paid: PKR ${invoice.paidAmount.toStringAsFixed(2)} • Total: PKR ${invoice.grandTotal.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
