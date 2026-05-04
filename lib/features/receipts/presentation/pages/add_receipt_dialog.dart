import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
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

  @override
  void dispose() {
    _paymentAmountController.dispose();
    _accountNoController.dispose();
    _remarksController.dispose();
    super.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a client.')));
      return;
    }

    final paymentAmount = _parseAmount(_paymentAmountController.text);
    if (paymentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid payment amount.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Receipts are now fully decoupled from invoices.
      // Passing empty allocations — the RPC will create a credit ledger entry
      // for the full amount under transaction_source = 'receipt_advance'.
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
        allocations: const [],
      );

      await ref.read(createReceiptProvider(receipt).future);

      ref.invalidate(getAllReceiptsProvider);
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

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 560,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: clientsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
            data: (clients) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Receipt',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Record a payment received from a client.',
                                style: TextStyle(color: Colors.grey.shade600),
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
                    const SizedBox(height: 24),

                    // Client dropdown
                    DropdownButtonFormField<int?>(
                      initialValue: _selectedClientId,
                      decoration: const InputDecoration(
                        labelText: 'Client *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Select client'),
                        ),
                        ...clients.map(
                          (client) => DropdownMenuItem<int?>(
                            value: client.id,
                            child: Text(client.clientName),
                          ),
                        ),
                      ],
                      onChanged: _isSubmitting
                          ? null
                          : (value) => setState(() => _selectedClientId = value),
                      validator: (value) =>
                          value == null ? 'Please select a client' : null,
                    ),
                    const SizedBox(height: 16),

                    // Amount + Payment Method row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _paymentAmountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Amount *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.payments_outlined),
                              prefixText: 'PKR ',
                            ),
                            validator: (value) {
                              final amount = _parseAmount(value ?? '');
                              if (amount <= 0) return 'Enter a valid amount';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _paymentMethod,
                            decoration: const InputDecoration(
                              labelText: 'Payment Method',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.credit_card_outlined),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'cash',
                                child: Text('Cash'),
                              ),
                              DropdownMenuItem(
                                value: 'bank',
                                child: Text('Bank Transfer'),
                              ),
                              DropdownMenuItem(
                                value: 'cheque',
                                child: Text('Cheque'),
                              ),
                            ],
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    if (value != null) {
                                      setState(() => _paymentMethod = value);
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Account No + Date row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _accountNoController,
                            decoration: const InputDecoration(
                              labelText: 'Account No',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.account_balance_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _isSubmitting ? null : _pickDate,
                            borderRadius: BorderRadius.circular(4),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Received Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today_outlined),
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

                    // Remarks
                    TextFormField(
                      controller: _remarksController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Remarks',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.notes_outlined),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
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
                        FilledButton.icon(
                          onPressed: _isSubmitting ? null : _submit,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: const Text('Save Receipt'),
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
    );
  }
}
