import '../../../auth/presentation/provider/current_employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../account_ledger/domain/entities/account_entity.dart';
import '../../../account_ledger/presentation/provider/account_ledger_providers.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../ledger/domain/entities/ledger_entity.dart';
import '../../../ledger/presentation/providers/ledger_providers.dart';
import '../../domain/entities/receipt_entity.dart';
import '../providers/receipt_providers.dart';

class AddReceiptDialog extends ConsumerStatefulWidget {
  final ReceiptEntity? receipt;

  const AddReceiptDialog({super.key, this.receipt});

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
  String _bankTransferMode = 'online'; // 'online' or 'cheque'
  int? _selectedClientId;
  int? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      final r = widget.receipt!;
      _selectedClientId = r.clientId;
      _paymentAmountController.text = r.totalAmount.toString();
      _paymentMethod = r.paymentMethod == 'cheque' ? 'bank' : r.paymentMethod;
      _bankTransferMode = r.paymentMethod == 'cheque' ? 'cheque' : 'online';
      _accountNoController.text = r.accountNo ?? '';
      _remarksController.text = r.remarks ?? '';
      _receivedDate = r.receivedDate;
      _selectedAccountId = r.accountId;

      if (_selectedAccountId == null && r.id != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final accId = await ref
              .read(accountLedgerRepositoryProvider)
              .getAccountIdByReference('receipt', r.id!);
          if (mounted && accId != null) {
            setState(() => _selectedAccountId = accId);
          }
        });
      }
    }
  }

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

    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an account.')),
      );
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
      final finalPaymentMethod =
          _paymentMethod == 'bank' && _bankTransferMode == 'cheque'
          ? 'cheque'
          : _paymentMethod;

      if (widget.receipt != null) {
        await ref.read(receiptRepositoryProvider).updateReceipt(
          id: widget.receipt!.id!,
          clientId: _selectedClientId,
          accountId: _selectedAccountId,
          paymentMethod: finalPaymentMethod,
          accountNo: _accountNoController.text.trim().isEmpty
              ? null
              : _accountNoController.text.trim(),
          remarks: _remarksController.text.trim().isEmpty
              ? null
              : _remarksController.text.trim(),
          receivedDate: _receivedDate,
          totalAmount: paymentAmount,
        );
      } else {
        final receipt = ReceiptEntity(
          clientId: _selectedClientId!,
          totalAmount: paymentAmount,
          paymentMethod: finalPaymentMethod,
          accountId: _selectedAccountId,
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
      }

      ref.invalidate(getAllReceiptsProvider);
      ref.invalidate(getAllAccountsProvider);
      ref.invalidate(getAllEntriesProvider);
      ref.invalidate(getBalanceProvider);
      ref.invalidate(getEntriesByPartyProvider);
      ref.invalidate(getEntriesByTypeProvider);
      if (context.mounted) {
        Navigator.pop(context.mounted ? context : context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context.mounted ? context : context,
        ).showSnackBar(SnackBar(content: Text('Failed to save receipt: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.receipt != null;
    final hasUpdatePermission = ref.watch(hasPermissionProvider('receipts.update'));
    final hasCreatePermission = ref.watch(hasPermissionProvider('receipts.create'));
    final hasPermission = isEdit ? hasUpdatePermission : hasCreatePermission;

    final clientsAsync = ref.watch(getAllClientsProvider);
    final accountsAsync = ref.watch(getAllAccountsProvider);

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
                child: SingleChildScrollView(
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
                                  widget.receipt != null
                                      ? 'Edit Receipt'
                                      : 'New Receipt',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.receipt != null
                                      ? 'Update payment details and remarks.'
                                      : 'Record a payment received from a client.',
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
                      const SizedBox(height: 16),
                      if (!hasPermission)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 16, color: AppColors.errorText),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  isEdit
                                      ? 'You do not have permission to update receipts.'
                                      : 'You do not have permission to create receipts.',
                                  style: const TextStyle(
                                    color: AppColors.errorText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Client dropdown (searchable)
                      FormField<int>(
                        initialValue: _selectedClientId,
                        validator: (value) =>
                            value == null ? 'Please select a client' : null,
                        builder: (fieldState) {
                          final selectedClient = clients
                              .where((c) => c.id == _selectedClientId)
                              .firstOrNull;

                          return SearchableDropdown<ClientEntity>(
                            items: clients,
                            displayStringForOption: (c) => c.clientName,
                            labelText: 'Client *',
                            prefixIcon: const Icon(Icons.person_outline),
                            errorText: fieldState.errorText,
                            enabled: !_isSubmitting,
                            initialText: selectedClient?.clientName,
                            onSelected: (selected) {
                              setState(() => _selectedClientId = selected.id);
                              fieldState.didChange(selected.id);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      if (_selectedClientId != null)
                        _ClientBalanceDisplay(clientId: _selectedClientId!)
                      else
                        Text(
                          'Select a client to view current receivable balance.',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Amount + Payment Method row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _paymentAmountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
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
                                labelText: 'Payment Mode',
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
                              ],
                              onChanged: _isSubmitting
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        setState(() {
                                          _paymentMethod = value;
                                          _selectedAccountId =
                                              null; // reset account
                                        });
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),

                      if (_paymentMethod == 'bank') ...[
                        const SizedBox(height: 12),
                        RadioGroup<String>(
                          groupValue: _bankTransferMode,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _bankTransferMode = value;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              const Text(
                                'Transfer Type:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 16),
                              Radio<String>(value: 'online'),
                              const Text('Online Transfer'),
                              const SizedBox(width: 16),
                              Radio<String>(value: 'cheque'),
                              const Text('Cheque'),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Select Account based on Payment Method
                      accountsAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text('Error loading accounts: $err'),
                        data: (accounts) {
                          final filteredAccounts = accounts
                              .where((acc) => acc.accountType == _paymentMethod)
                              .toList();

                          if (filteredAccounts.isEmpty) {
                            return Text(
                              'No $_paymentMethod accounts found in the database.',
                              style: const TextStyle(color: Colors.red),
                            );
                          }

                          // If there's only 1 account and it's not selected yet, auto-select it
                          if (filteredAccounts.length == 1 &&
                              _selectedAccountId == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _selectedAccountId = filteredAccounts.first.id;
                              });
                            });
                          }

                          final selectedAcc = _selectedAccountId != null
                              ? filteredAccounts
                                    .where(
                                      (acc) => acc.id == _selectedAccountId,
                                    )
                                    .firstOrNull
                              : null;

                          return SearchableDropdown<AccountEntity>(
                            items: filteredAccounts,
                            displayStringForOption: (acc) =>
                                '${acc.accountTitle} ${acc.bankName != null ? "(${acc.bankName})" : ""}',
                            onSelected: (acc) {
                              if (!_isSubmitting) {
                                setState(() => _selectedAccountId = acc.id);
                              }
                            },
                            initialText: selectedAcc != null
                                ? '${selectedAcc.accountTitle} ${selectedAcc.bankName != null ? "(${selectedAcc.bankName})" : ""}'
                                : null,
                            labelText: 'Select $_paymentMethod Account *',
                            prefixIcon: const Icon(
                              Icons.account_balance_outlined,
                            ),
                            errorText: _selectedAccountId == null
                                ? 'Please select an account'
                                : null,
                            enabled: !_isSubmitting,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Account No + Date row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _accountNoController,
                              decoration: InputDecoration(
                                labelText:
                                    _bankTransferMode == 'cheque' &&
                                        _paymentMethod == 'bank'
                                    ? 'Cheque No'
                                    : 'Account/Ref No (Optional)',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.numbers_outlined),
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
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                  ),
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
                            onPressed: (_isSubmitting || !hasPermission) ? null : _submit,
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
                            label: Text(
                              widget.receipt != null
                                  ? 'Update Receipt'
                                  : 'Save Receipt',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Widget to display client receivable balance
class _ClientBalanceDisplay extends ConsumerWidget {
  final int clientId;

  const _ClientBalanceDisplay({required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(
      getBalanceProvider(partyType: PartyType.client, partyId: clientId),
    );

    return balanceAsync.when(
      loading: () => const Text(
        'Calculating client receivable balance...',
        style: TextStyle(color: AppColors.textGrey),
      ),
      error: (_, _) => const Text(
        'Could not fetch live receivable balance from ledger.',
        style: TextStyle(color: AppColors.errorText),
      ),
      data: (balance) => Text(
        'Current receivable balance: PKR ${balance.toStringAsFixed(2)}',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textBlack,
        ),
      ),
    );
  }
}
