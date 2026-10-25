import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/features/vender/domain/entities/vendor_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../account_ledger/domain/entities/account_entity.dart';
import '../../../account_ledger/presentation/provider/account_ledger_providers.dart';
import '../../../ledger/domain/entities/ledger_entity.dart';
import '../../../ledger/presentation/providers/ledger_providers.dart';
import '../../../vender/presentation/providers/vendor_providers.dart';
import '../../domain/entities/disbursement_record.dart';
import '../providers/receipt_providers.dart';

class AddDisbursementDialog extends ConsumerStatefulWidget {
  final DisbursementRecord? disbursement;

  const AddDisbursementDialog({super.key, this.disbursement});

  @override
  ConsumerState<AddDisbursementDialog> createState() =>
      _AddDisbursementDialogState();
}

class _AddDisbursementDialogState extends ConsumerState<AddDisbursementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _categoryController = TextEditingController();
  final _remarksController = TextEditingController();

  int? _selectedVendorId;
  int? _selectedAccountId;
  String _paymentMethod = 'cash';
  String _bankTransferMode = 'online';
  DateTime _paidDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.disbursement != null) {
      final d = widget.disbursement!;
      _selectedVendorId = d.supplierId;
      _amountController.text = d.totalAmount.toString();
      _paymentMethod = d.paymentMethod == 'cheque' ? 'bank' : d.paymentMethod;
      _bankTransferMode = d.paymentMethod == 'cheque' ? 'cheque' : 'online';
      _accountNoController.text = d.accountNo ?? '';
      _categoryController.text = d.category ?? '';
      _remarksController.text = d.remarks ?? '';
      _paidDate = d.paidDate;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final accId = await ref
            .read(accountLedgerRepositoryProvider)
            .getAccountIdByReference('disbursement', d.id);
        if (mounted && accId != null) {
          setState(() => _selectedAccountId = accId);
        }
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountNoController.dispose();
    _categoryController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paidDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _paidDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(getAllvendorsProvider);
    final vendorLedgerAsync = ref.watch(
      getEntriesByTypeProvider(PartyType.vendor),
    );
    final accountsAsync = ref.watch(getAllAccountsProvider);

    final vendorBalances = <int, double>{};
    vendorLedgerAsync.whenData((entries) {
      for (final entry in entries) {
        final current = vendorBalances[entry.partyId] ?? 0.0;
        final next = entry.entryType == EntryType.credit
            ? current + entry.amount
            : current - entry.amount;
        vendorBalances[entry.partyId] = next;
      }
    });

    final selectedDue = _selectedVendorId == null
        ? 0.0
        : (vendorBalances[_selectedVendorId!] ?? 0.0);
    final enteredAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final remainingDue = (selectedDue - enteredAmount).clamp(
      0,
      double.infinity,
    );

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: Text(
        widget.disbursement != null
            ? 'Edit Disbursement'
            : 'Add Disbursement',
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vendorsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text('Failed to load vendors: $error'),
                  data: (vendors) {
                    if (vendors.isEmpty) {
                      return const Text('No vendors found.');
                    }

                    return FormField<int>(
                      initialValue: _selectedVendorId,
                      validator: (value) =>
                          value == null ? 'Please select a Vendor' : null,
                      builder: (fieldState) {
                        final selectedVendor = vendors
                            .where((v) => v.id == _selectedVendorId)
                            .firstOrNull;

                        return SearchableDropdown<VendorEntity>(
                          items: vendors,
                          displayStringForOption: (v) => v.vendorName,
                          labelText: 'Client *',
                          prefixIcon: const Icon(Icons.person_outline),
                          errorText: fieldState.errorText,
                          enabled: !_isSubmitting,
                          initialText: selectedVendor?.vendorName,
                          onSelected: (selected) {
                            setState(() => _selectedVendorId = selected.id);
                            fieldState.didChange(selected.id);
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                vendorLedgerAsync.when(
                  loading: () => const Text(
                    'Calculating vendor due balances...',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  error: (_, _) => const Text(
                    'Could not fetch live due balances from ledger.',
                    style: TextStyle(color: AppColors.errorText),
                  ),
                  data: (_) => Text(
                    _selectedVendorId == null
                        ? 'Select a vendor to view current due balance.'
                        : 'Current due balance: PKR ${selectedDue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _paymentMethod,
                  decoration: const InputDecoration(labelText: 'Payment Mode'),
                  items: const [
                    DropdownMenuItem(value: 'cash', child: Text('Cash')),
                    DropdownMenuItem(
                      value: 'bank',
                      child: Text('Bank Transfer'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _paymentMethod = value;
                        _selectedAccountId = null; // Reset selection
                      });
                    }
                  },
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
                const SizedBox(height: 12),

                // Account Selection
                accountsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error loading accounts: $err'),
                  data: (accounts) {
                    final filteredAccounts = accounts
                        .where((acc) => acc.accountType == _paymentMethod)
                        .toList();

                    if (filteredAccounts.isEmpty) {
                      return Text(
                        'No $_paymentMethod accounts found.',
                        style: const TextStyle(color: Colors.red),
                      );
                    }

                    if (filteredAccounts.length == 1 &&
                        _selectedAccountId == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(
                          () => _selectedAccountId = filteredAccounts.first.id,
                        );
                      });
                    }

                    final selectedAcc = _selectedAccountId != null
                        ? filteredAccounts
                              .where((acc) => acc.id == _selectedAccountId)
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
                      prefixIcon: const Icon(Icons.account_balance_outlined),
                      errorText: _selectedAccountId == null
                          ? 'Please select an account'
                          : null,
                      enabled: !_isSubmitting,
                    );
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Amount *',
                    hintText: 'Enter disbursement amount',
                  ),
                  validator: (value) {
                    final parsed = double.tryParse((value ?? '').trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid amount';
                    }
                    if (_selectedVendorId == null) {
                      return 'Select a vendor first';
                    }
                    if (parsed > selectedDue) {
                      return 'Amount cannot exceed vendor due balance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                if (_selectedVendorId != null)
                  Text(
                    'Remaining due after payment: PKR ${remainingDue.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _accountNoController,
                  decoration: InputDecoration(
                    labelText:
                        _bankTransferMode == 'cheque' &&
                            _paymentMethod == 'bank'
                        ? 'Cheque No'
                        : 'Account/Ref No (Optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category (Optional)',
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Paid Date: ${_paidDate.toIso8601String().split('T').first}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _selectDate,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _remarksController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Remarks (Optional)',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final amount = double.parse(_amountController.text.trim());
                  if (_selectedVendorId == null || _selectedAccountId == null) {
                    return;
                  }

                  setState(() => _isSubmitting = true);
                  try {
                    final finalPaymentMethod =
                        _paymentMethod == 'bank' &&
                            _bankTransferMode == 'cheque'
                        ? 'cheque'
                        : _paymentMethod;

                    if (widget.disbursement != null) {
                      await ref
                          .read(receiptRepositoryProvider)
                          .updateDisbursement(
                            id: widget.disbursement!.id,
                            supplierId: _selectedVendorId!,
                            accountId: _selectedAccountId,
                            totalAmount: amount,
                            paymentMethod: finalPaymentMethod,
                            accountNo: _accountNoController.text.trim().isEmpty
                                ? null
                                : _accountNoController.text.trim(),
                            category: _categoryController.text.trim().isEmpty
                                ? null
                                : _categoryController.text.trim(),
                            remarks: _remarksController.text.trim().isEmpty
                                ? null
                                : _remarksController.text.trim(),
                            paidDate: _paidDate,
                          );
                    } else {
                      await ref
                          .read(receiptRepositoryProvider)
                          .createDisbursement(
                            supplierId: _selectedVendorId!,
                            totalAmount: amount,
                            paymentMethod: finalPaymentMethod,
                            accountId: _selectedAccountId,
                            accountNo: _accountNoController.text.trim().isEmpty
                                ? null
                                : _accountNoController.text.trim(),
                            category: _categoryController.text.trim().isEmpty
                                ? null
                                : _categoryController.text.trim(),
                            remarks: _remarksController.text.trim().isEmpty
                                ? null
                                : _remarksController.text.trim(),
                            paidDate: _paidDate,
                          );
                    }

                    if (!mounted) return;
                    ref.invalidate(getAllEntriesProvider);
                    ref.invalidate(getEntriesByTypeProvider);
                    ref.invalidate(getBalanceProvider);
                    ref.invalidate(getAllDisbursementsProvider);
                    ref.invalidate(getAllAccountsProvider);
                    Navigator.pop(context.mounted ? context : context, true);
                  } catch (error) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context.mounted ? context : context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save disbursement: $error'),
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _isSubmitting = false);
                    }
                  }
                },
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.payments_outlined),
          label: Text(
            _isSubmitting
                ? 'Saving...'
                : (widget.disbursement != null
                    ? 'Update Disbursement'
                    : 'Save Disbursement'),
          ),
        ),
      ],
    );
  }
}
