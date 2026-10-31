import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../domain/entities/account_entity.dart';
import '../provider/account_ledger_providers.dart';

class WithdrawDialog extends ConsumerStatefulWidget {
  final int? initialAccountId;

  const WithdrawDialog({super.key, this.initialAccountId});

  static Future<void> show(BuildContext context, {int? initialAccountId}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WithdrawDialog(initialAccountId: initialAccountId),
    );
  }

  @override
  ConsumerState<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends ConsumerState<WithdrawDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _transactionDate;
  int? _selectedAccountId;
  String _selectedReason = 'Personal Use / Drawings';
  bool _isSubmitting = false;

  final List<String> _commonReasons = const [
    'Personal Use / Drawings',
    'Owner Salary / Allowance',
    'Household / Family Expense',
    'Personal Investment',
    'Other Personal Expense',
  ];

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
        const SnackBar(content: Text('Please select an account to withdraw from')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

      final userDesc = _descriptionController.text.trim();
      final finalDesc = userDesc.isEmpty
          ? _selectedReason
          : '$_selectedReason - $userDesc';

      await ref.read(
        recordWithdrawalProvider(
          accountId: _selectedAccountId!,
          amount: amount,
          description: finalDesc,
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
          content: Text('Personal withdrawal recorded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Withdrawal failed: $e'),
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
          Icon(Icons.money_off, color: Colors.orange),
          SizedBox(width: 10),
          Text(
            'Record Personal Withdrawal',
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
                const Text(
                  'Record money withdrawn from the business for personal use or owner drawings.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13),
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
                            labelText: 'From Account *',
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
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
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
                    labelText: 'Withdrawal Amount *',
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
                      labelText: 'Withdrawal Date *',
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

                // Reason / Purpose Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedReason,
                  decoration: const InputDecoration(
                    labelText: 'Withdrawal Purpose / Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: _commonReasons.map((reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedReason = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Remarks / Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Remarks / Specific Note (Optional)',
                    hintText: 'e.g. For personal shopping, medical, etc.',
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
            backgroundColor: Colors.orange.shade800,
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
              : const Icon(Icons.money_off),
          label: Text(_isSubmitting ? 'Recording...' : 'Withdraw'),
        ),
      ],
    );
  }
}
