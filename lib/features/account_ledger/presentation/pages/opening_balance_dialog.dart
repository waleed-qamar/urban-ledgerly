import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../domain/entities/account_entity.dart';
import '../provider/account_ledger_providers.dart';

class OpeningBalanceDialog extends ConsumerStatefulWidget {
  final int? initialAccountId;

  const OpeningBalanceDialog({super.key, this.initialAccountId});

  static Future<void> show(BuildContext context, {int? initialAccountId}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OpeningBalanceDialog(initialAccountId: initialAccountId),
    );
  }

  @override
  ConsumerState<OpeningBalanceDialog> createState() =>
      _OpeningBalanceDialogState();
}

class _OpeningBalanceDialogState extends ConsumerState<OpeningBalanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController =
      TextEditingController(text: 'Initial / Starting balance');
  late DateTime _transactionDate;
  int? _selectedAccountId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.initialAccountId;
    _transactionDate = DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatAccount(AccountEntity a) {
    final parts = <String>[];
    if (a.bankName != null && a.bankName!.isNotEmpty) parts.add(a.bankName!);
    parts.add(a.accountTitle);
    if (a.accountNumber != null && a.accountNumber!.isNotEmpty) {
      parts.add('(${a.accountNumber})');
    }
    return parts.join(' - ');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an account')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount greater than 0')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

      final desc = _descriptionController.text.trim().isEmpty
          ? 'Initial / Starting balance'
          : _descriptionController.text.trim();

      await ref.read(
        setOpeningBalanceProvider(
          accountId: _selectedAccountId!,
          amount: amount,
          description: desc,
          date: _transactionDate,
        ).future,
      );

      ref.invalidate(getAllAccountsProvider);
      ref.invalidate(getAccountByIdProvider(_selectedAccountId!));
      ref.invalidate(getAccountTransactionsProvider(_selectedAccountId!));

      if (!mounted) return;
      navigator.pop();
      scaffoldMessenger?.showSnackBar(
        const SnackBar(
          content: Text('Initial / Opening balance updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set initial balance: $e'),
            backgroundColor: AppColors.errorText,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAccountsAsync = ref.watch(getAllAccountsProvider);

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: Row(
        children: const [
          Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
          SizedBox(width: 10),
          Text(
            'Account Initial / Opening Balance',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Sets or updates the starting equity balance for this account in the ledger. If an opening balance already exists, it will be updated cleanly.',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Account Selection
                allAccountsAsync.when(
                  loading: () => const LinearProgressIndicator(minHeight: 2),
                  error: (err, _) => Text('Error loading accounts: $err'),
                  data: (accounts) {
                    final selectedAccount = accounts
                        .where((a) => a.id == _selectedAccountId)
                        .firstOrNull;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.initialAccountId == null)
                          SearchableDropdown<AccountEntity>(
                            initialText: selectedAccount != null
                                ? _formatAccount(selectedAccount)
                                : null,
                            labelText: 'Select Account *',
                            prefixIcon: const Icon(
                              Icons.account_balance_outlined,
                            ),
                            items: accounts,
                            displayStringForOption: _formatAccount,
                            onSelected: (account) {
                              setState(() {
                                _selectedAccountId = account.id;
                              });
                            },
                            errorText: _selectedAccountId == null
                                ? 'Please select an account'
                                : null,
                          ),
                        if (selectedAccount != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedAccount.accountTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (selectedAccount.bankName != null)
                                      Text(
                                        selectedAccount.bankName!,
                                        style: const TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Current Balance',
                                      style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      '${selectedAccount.currency} ${selectedAccount.currentBalance.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: selectedAccount.currentBalance >= 0
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Starting Balance Amount *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.payments_outlined),
                    prefixText: 'PKR ',
                  ),
                  validator: (value) {
                    final amount = double.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _transactionDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => _transactionDate = picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Opening Balance Date *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(_transactionDate),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description / Remarks (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: _isSubmitting ? null : _submit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Icon(Icons.check),
          label: Text(
            _isSubmitting ? 'Saving...' : 'Save Initial Balance',
          ),
        ),
      ],
    );
  }
}
